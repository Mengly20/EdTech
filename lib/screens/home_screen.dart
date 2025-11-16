import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/language_provider.dart';
import '../providers/app_state.dart';
import '../utils/translations.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    final appState = Provider.of<AppState>(context);
    final lang = languageProvider.currentLanguage;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with language toggle
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    Translations.get('welcome', lang),
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                  IconButton(
                    icon: const Icon(Icons.language),
                    onPressed: () => languageProvider.toggleLanguage(),
                    tooltip: Translations.get('language', lang),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              
              // Welcome message
              Text(
                Translations.get('welcomeMessage', lang),
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 32),

              // Get Started Card
              Card(
                child: InkWell(
                  onTap: () => appState.setTabIndex(1),
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.camera_alt,
                            size: 32,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                Translations.get('getStarted', lang),
                                style: Theme.of(context).textTheme.displaySmall,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                Translations.get('scanEquipment', lang),
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: Theme.of(context).primaryColor,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Features Section
              Text(
                Translations.get('features', lang),
                style: Theme.of(context).textTheme.displaySmall,
              ),
              const SizedBox(height: 16),

              // Feature Cards
              _buildFeatureCard(
                context,
                Icons.camera_alt,
                Translations.get('cameraScanning', lang),
                Translations.get('cameraScanningDesc', lang),
              ),
              const SizedBox(height: 12),
              _buildFeatureCard(
                context,
                Icons.psychology,
                Translations.get('aiRecognition', lang),
                Translations.get('aiRecognitionDesc', lang),
              ),
              const SizedBox(height: 12),
              _buildFeatureCard(
                context,
                Icons.language,
                Translations.get('bilingualSupport', lang),
                Translations.get('bilingualSupportDesc', lang),
              ),
              const SizedBox(height: 12),
              _buildFeatureCard(
                context,
                Icons.history,
                Translations.get('scanHistory', lang),
                Translations.get('scanHistoryDesc', lang),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureCard(
    BuildContext context,
    IconData icon,
    String title,
    String description,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                size: 24,
                color: Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
