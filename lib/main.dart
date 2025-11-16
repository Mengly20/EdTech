import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/app_state.dart';
import 'providers/language_provider.dart';
import 'providers/scan_history_provider.dart';
import 'screens/home_screen.dart';
import 'screens/scan_screen.dart';
import 'screens/history_screen.dart';
import 'services/gemini_service.dart';
import 'utils/theme.dart';
import 'utils/translations.dart';

void main() {
  // Initialize services
  GeminiService.initialize();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppState()),
        ChangeNotifierProvider(create: (_) => LanguageProvider()..loadLanguage()),
        ChangeNotifierProvider(create: (_) => ScanHistoryProvider()),
      ],
      child: const EdTechApp(),
    ),
  );
}

class EdTechApp extends StatelessWidget {
  const EdTechApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EdTech Science Scanner',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const MainNavigationScreen(),
    );
  }
}

class MainNavigationScreen extends StatelessWidget {
  const MainNavigationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final lang = Provider.of<LanguageProvider>(context).currentLanguage;

    final List<Widget> screens = [
      const HomeScreen(),
      const ScanScreen(),
      const HistoryScreen(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: appState.currentTabIndex,
        children: screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: appState.currentTabIndex,
        onDestinationSelected: (index) => appState.setTabIndex(index),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home_outlined),
            selectedIcon: const Icon(Icons.home),
            label: Translations.get('home', lang),
          ),
          NavigationDestination(
            icon: const Icon(Icons.camera_alt_outlined),
            selectedIcon: const Icon(Icons.camera_alt),
            label: Translations.get('scan', lang),
          ),
          NavigationDestination(
            icon: const Icon(Icons.history_outlined),
            selectedIcon: const Icon(Icons.history),
            label: Translations.get('history', lang),
          ),
        ],
      ),
    );
  }
}
