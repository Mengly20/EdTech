import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/language_provider.dart';
import '../providers/scan_history_provider.dart';
import '../utils/translations.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ScanHistoryProvider>(context, listen: false).loadHistory();
    });
  }

  Future<void> _clearAllData() async {
    final lang = Provider.of<LanguageProvider>(context, listen: false).currentLanguage;
    
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(Translations.get('confirmClear', lang)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(Translations.get('cancel', lang)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(Translations.get('clear', lang)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final historyProvider = Provider.of<ScanHistoryProvider>(context, listen: false);
      final success = await historyProvider.clearAllHistory();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              success
                  ? Translations.get('dataCleared', lang)
                  : Translations.get('error', lang),
            ),
          ),
        );
      }
    }
  }

  Future<void> _backupToGoogleDrive() async {
    final lang = Provider.of<LanguageProvider>(context, listen: false).currentLanguage;
    final historyProvider = Provider.of<ScanHistoryProvider>(context, listen: false);

    final success = await historyProvider.backupToGoogleDrive();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            success
                ? Translations.get('backupSuccess', lang)
                : Translations.get('error', lang),
          ),
        ),
      );
    }
  }

  Future<void> _syncFromGoogleDrive() async {
    final lang = Provider.of<LanguageProvider>(context, listen: false).currentLanguage;
    final historyProvider = Provider.of<ScanHistoryProvider>(context, listen: false);

    final success = await historyProvider.syncFromGoogleDrive();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            success
                ? Translations.get('syncSuccess', lang)
                : Translations.get('error', lang),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<LanguageProvider>(context).currentLanguage;
    final historyProvider = Provider.of<ScanHistoryProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(Translations.get('scanHistoryTitle', lang)),
        actions: [
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                onTap: _backupToGoogleDrive,
                child: Row(
                  children: [
                    const Icon(Icons.cloud_upload),
                    const SizedBox(width: 12),
                    Text(Translations.get('backupToDrive', lang)),
                  ],
                ),
              ),
              PopupMenuItem(
                onTap: _syncFromGoogleDrive,
                child: Row(
                  children: [
                    const Icon(Icons.cloud_download),
                    const SizedBox(width: 12),
                    Text(Translations.get('syncFromDrive', lang)),
                  ],
                ),
              ),
              PopupMenuItem(
                onTap: _clearAllData,
                child: Row(
                  children: [
                    const Icon(Icons.delete, color: Colors.red),
                    const SizedBox(width: 12),
                    Text(
                      Translations.get('clearAllData', lang),
                      style: const TextStyle(color: Colors.red),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: historyProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : historyProvider.history.isEmpty
              ? _buildEmptyState(lang)
              : _buildHistoryList(historyProvider, lang),
    );
  }

  Widget _buildEmptyState(String lang) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.history,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            Translations.get('noHistory', lang),
            style: Theme.of(context).textTheme.displaySmall,
          ),
          const SizedBox(height: 8),
          Text(
            Translations.get('noHistoryMessage', lang),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryList(ScanHistoryProvider historyProvider, String lang) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: historyProvider.history.length,
      itemBuilder: (context, index) {
        final item = historyProvider.history[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            contentPadding: const EdgeInsets.all(12),
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.file(
                File(item.image),
                width: 60,
                height: 60,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 60,
                    height: 60,
                    color: Colors.grey[300],
                    child: const Icon(Icons.image),
                  );
                },
              ),
            ),
            title: Text(
              lang == 'en'
                  ? item.result.nameEnglish
                  : item.result.nameKhmer,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(
                  lang == 'en'
                      ? item.result.category
                      : item.result.categoryKhmer,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.check_circle,
                      size: 16,
                      color: Colors.green[600],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${(item.result.confidence * 100).toStringAsFixed(1)}%',
                      style: TextStyle(color: Colors.green[600]),
                    ),
                    const SizedBox(width: 12),
                    Icon(
                      Icons.access_time,
                      size: 16,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      DateFormat('MMM d, y HH:mm').format(item.timestamp),
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ],
            ),
            onTap: () {
              _showItemDetails(context, item, lang);
            },
          ),
        );
      },
    );
  }

  void _showItemDetails(BuildContext context, item, String lang) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.95,
        minChildSize: 0.5,
        expand: false,
        builder: (context, scrollController) {
          return SingleChildScrollView(
            controller: scrollController,
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(
                    File(item.image),
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  lang == 'en'
                      ? item.result.nameEnglish
                      : item.result.nameKhmer,
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                const SizedBox(height: 8),
                Text(
                  '${Translations.get('category', lang)}: ${lang == 'en' ? item.result.category : item.result.categoryKhmer}',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 4),
                Text(
                  '${Translations.get('confidence', lang)}: ${(item.result.confidence * 100).toStringAsFixed(1)}%',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 16),
                Text(
                  Translations.get('usage', lang),
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  item.result.usage,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 16),
                Text(
                  DateFormat('MMMM d, y - HH:mm:ss').format(item.timestamp),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
