import 'dart:convert';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:googleapis_auth/googleapis_auth.dart' as auth;
import 'package:http/http.dart' as http;
import '../models/scan_history_item.dart';
import '../utils/constants.dart';

class DriveService {
  static final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [drive.DriveApi.driveFileScope],
  );

  static Future<bool> backupToGoogleDrive(List<ScanHistoryItem> history) async {
    try {
      // Sign in to Google
      final GoogleSignInAccount? account = await _googleSignIn.signIn();
      if (account == null) return false;

      // Get authentication headers
      final authHeaders = await account.authHeaders;
      final authenticateClient = _GoogleAuthClient(authHeaders);
      final driveApi = drive.DriveApi(authenticateClient);

      // Prepare backup data
      final backupData = {
        'version': '1.0.0',
        'timestamp': DateTime.now().toIso8601String(),
        'history': history.map((item) => item.toJson()).toList(),
      };

      final jsonContent = jsonEncode(backupData);

      // Create file metadata
      final driveFile = drive.File()
        ..name = 'edtech_backup_${DateTime.now().millisecondsSinceEpoch}.json'
        ..mimeType = 'application/json';

      // Upload file
      final media = drive.Media(
        Stream.value(utf8.encode(jsonContent)),
        jsonContent.length,
      );

      await driveApi.files.create(driveFile, uploadMedia: media);

      return true;
    } catch (e) {
      print('Error backing up to Google Drive: $e');
      return false;
    }
  }

  static Future<List<ScanHistoryItem>?> syncFromGoogleDrive() async {
    try {
      // Sign in to Google
      final GoogleSignInAccount? account = await _googleSignIn.signIn();
      if (account == null) return null;

      // Get authentication headers
      final authHeaders = await account.authHeaders;
      final authenticateClient = _GoogleAuthClient(authHeaders);
      final driveApi = drive.DriveApi(authenticateClient);

      // Search for backup files
      final fileList = await driveApi.files.list(
        q: "name contains 'edtech_backup_' and mimeType='application/json'",
        orderBy: 'createdTime desc',
        pageSize: 1,
      );

      if (fileList.files == null || fileList.files!.isEmpty) {
        return null;
      }

      // Download the latest backup
      final fileId = fileList.files!.first.id;
      if (fileId == null) return null;

      final response = await driveApi.files.get(
        fileId,
        downloadOptions: drive.DownloadOptions.fullMedia,
      ) as drive.Media;

      // Read file content
      final List<int> dataStore = [];
      await for (var data in response.stream) {
        dataStore.addAll(data);
      }

      final jsonContent = utf8.decode(dataStore);
      final backupData = jsonDecode(jsonContent);

      // Parse history
      if (backupData['history'] != null) {
        final List<dynamic> historyJson = backupData['history'];
        return historyJson
            .map((item) => ScanHistoryItem.fromJson(item as Map<String, dynamic>))
            .toList();
      }

      return null;
    } catch (e) {
      print('Error syncing from Google Drive: $e');
      return null;
    }
  }

  static Future<void> signOut() async {
    await _googleSignIn.signOut();
  }
}

class _GoogleAuthClient extends http.BaseClient {
  final Map<String, String> _headers;
  final http.Client _client = http.Client();

  _GoogleAuthClient(this._headers);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    return _client.send(request..headers.addAll(_headers));
  }
}
