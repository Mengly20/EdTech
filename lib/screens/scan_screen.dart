import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import '../providers/language_provider.dart';
import '../providers/scan_history_provider.dart';
import '../providers/app_state.dart';
import '../services/roboflow_service.dart';
import '../services/gemini_service.dart';
import '../models/scan_result.dart';
import '../models/scan_history_item.dart';
import '../models/chat_message.dart';
import '../utils/translations.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  final ImagePicker _picker = ImagePicker();
  File? _imageFile;
  ScanResult? _scanResult;
  bool _isAnalyzing = false;
  final List<ChatMessage> _chatMessages = [];
  final TextEditingController _chatController = TextEditingController();
  bool _isSendingMessage = false;

  @override
  void dispose() {
    _chatController.dispose();
    super.dispose();
  }

  Future<void> _takePicture() async {
    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );

      if (photo != null) {
        setState(() {
          _imageFile = File(photo.path);
          _scanResult = null;
          _chatMessages.clear();
        });
        await _analyzeImage();
      }
    } catch (e) {
      _showError('Camera error: $e');
    }
  }

  Future<void> _pickFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (image != null) {
        setState(() {
          _imageFile = File(image.path);
          _scanResult = null;
          _chatMessages.clear();
        });
        await _analyzeImage();
      }
    } catch (e) {
      _showError('Gallery error: $e');
    }
  }

  Future<void> _analyzeImage() async {
    if (_imageFile == null) return;

    setState(() => _isAnalyzing = true);

    final result = await RoboflowService.analyzeImage(_imageFile!);

    setState(() => _isAnalyzing = false);

    if (result != null) {
      setState(() => _scanResult = result);
      await _saveScan(result);
    } else {
      final lang = Provider.of<LanguageProvider>(context, listen: false).currentLanguage;
      _showError(Translations.get('noEquipmentDetected', lang));
    }
  }

  Future<void> _saveScan(ScanResult result) async {
    final historyProvider = Provider.of<ScanHistoryProvider>(context, listen: false);
    final historyItem = ScanHistoryItem(
      id: const Uuid().v4(),
      image: _imageFile!.path,
      result: result,
      timestamp: DateTime.now(),
    );

    await historyProvider.addScan(historyItem);
  }

  Future<void> _sendMessage() async {
    if (_chatController.text.trim().isEmpty || _scanResult == null) return;

    final userMessage = _chatController.text.trim();
    _chatController.clear();

    setState(() {
      _chatMessages.add(ChatMessage(
        id: const Uuid().v4(),
        text: userMessage,
        isUser: true,
        timestamp: DateTime.now(),
      ));
      _isSendingMessage = true;
    });

    final response = await GeminiService.askAboutEquipment(_scanResult!, userMessage);

    setState(() {
      _chatMessages.add(ChatMessage(
        id: const Uuid().v4(),
        text: response,
        isUser: false,
        timestamp: DateTime.now(),
      ));
      _isSendingMessage = false;
    });
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<LanguageProvider>(context).currentLanguage;

    return Scaffold(
      appBar: AppBar(
        title: Text(Translations.get('scanEquipment', lang)),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Image Display or Camera Buttons
                    if (_imageFile == null) ...[
                      _buildCameraButtons(lang),
                    ] else ...[
                      _buildImagePreview(),
                      const SizedBox(height: 20),
                      if (_isAnalyzing) _buildAnalyzingIndicator(lang),
                      if (_scanResult != null) ...[
                        _buildScanResult(lang),
                        const SizedBox(height: 20),
                        _buildChatSection(lang),
                      ],
                    ],
                  ],
                ),
              ),
            ),
            if (_imageFile != null && _scanResult != null) _buildChatInput(lang),
          ],
        ),
      ),
    );
  }

  Widget _buildCameraButtons(String lang) {
    return Column(
      children: [
        Container(
          height: 300,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Icon(
              Icons.camera_alt,
              size: 64,
              color: Colors.grey[400],
            ),
          ),
        ),
        const SizedBox(height: 20),
        ElevatedButton.icon(
          onPressed: _takePicture,
          icon: const Icon(Icons.camera_alt),
          label: Text(Translations.get('takePhoto', lang)),
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
          ),
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: _pickFromGallery,
          icon: const Icon(Icons.photo_library),
          label: Text(Translations.get('chooseFromGallery', lang)),
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
          ),
        ),
      ],
    );
  }

  Widget _buildImagePreview() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.file(
        _imageFile!,
        height: 250,
        width: double.infinity,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildAnalyzingIndicator(String lang) {
    return Column(
      children: [
        const CircularProgressIndicator(),
        const SizedBox(height: 12),
        Text(Translations.get('analyzing', lang)),
      ],
    );
  }

  Widget _buildScanResult(String lang) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              Translations.get('scanResult', lang),
              style: Theme.of(context).textTheme.displaySmall,
            ),
            const SizedBox(height: 16),
            _buildResultRow(
              Icons.label,
              lang == 'en' ? _scanResult!.nameEnglish : _scanResult!.nameKhmer,
            ),
            const SizedBox(height: 8),
            _buildResultRow(
              Icons.category,
              '${Translations.get('category', lang)}: ${lang == 'en' ? _scanResult!.category : _scanResult!.categoryKhmer}',
            ),
            const SizedBox(height: 8),
            _buildResultRow(
              Icons.check_circle,
              '${Translations.get('confidence', lang)}: ${(_scanResult!.confidence * 100).toStringAsFixed(1)}%',
            ),
            const Divider(height: 24),
            Text(
              Translations.get('usage', lang),
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _scanResult!.usage,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Theme.of(context).primaryColor),
        const SizedBox(width: 8),
        Expanded(child: Text(text)),
      ],
    );
  }

  Widget _buildChatSection(String lang) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              Translations.get('chatWithAI', lang),
              style: Theme.of(context).textTheme.displaySmall,
            ),
            const SizedBox(height: 12),
            if (_chatMessages.isNotEmpty)
              ..._chatMessages.map((msg) => _buildChatMessage(msg)),
            if (_isSendingMessage)
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: CircularProgressIndicator(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatMessage(ChatMessage message) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Align(
        alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: message.isUser
                ? Theme.of(context).primaryColor
                : Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            message.text,
            style: TextStyle(
              color: message.isUser ? Colors.white : Colors.black87,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChatInput(String lang) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _chatController,
              decoration: InputDecoration(
                hintText: Translations.get('askQuestion', lang),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton.filled(
            onPressed: _sendMessage,
            icon: const Icon(Icons.send),
          ),
        ],
      ),
    );
  }
}
