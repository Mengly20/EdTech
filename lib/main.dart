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
        ChangeNotifierProvider(
            create: (_) => LanguageProvider()..loadLanguage()),
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

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late PageController _pageController;
  int _lastPageIndex = 0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _pageController = PageController();
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _navigateToPage(int index) {
    if (index != _lastPageIndex && _pageController.hasClients) {
      _animationController.reset();
      _animationController.forward();
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOutCubic,
      );
      _lastPageIndex = index;
    }
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final lang = Provider.of<LanguageProvider>(context).currentLanguage;

    // Sync page controller with app state
    if (appState.currentTabIndex != _lastPageIndex) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _navigateToPage(appState.currentTabIndex);
      });
    }

    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: (index) {
          _lastPageIndex = index;
          appState.setTabIndex(index);
        },
        children: const [
          HomeScreen(),
          ScanScreen(),
          HistoryScreen(),
        ],
      ),
      bottomNavigationBar: _buildCustomBottomNav(context, appState, lang),
    );
  }

  Widget _buildCustomBottomNav(
      BuildContext context, AppState appState, String lang) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Container(
          height: 68,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                context,
                icon: Icons.home_rounded,
                label: Translations.get('home', lang),
                index: 0,
                currentIndex: appState.currentTabIndex,
                onTap: () {
                  appState.setTabIndex(0);
                  _navigateToPage(0);
                },
              ),
              _buildNavItem(
                context,
                icon: Icons.qr_code_scanner_rounded,
                label: Translations.get('scan', lang),
                index: 1,
                currentIndex: appState.currentTabIndex,
                onTap: () {
                  appState.setTabIndex(1);
                  _navigateToPage(1);
                },
                isCenter: true,
              ),
              _buildNavItem(
                context,
                icon: Icons.history_rounded,
                label: Translations.get('history', lang),
                index: 2,
                currentIndex: appState.currentTabIndex,
                onTap: () {
                  appState.setTabIndex(2);
                  _navigateToPage(2);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required int index,
    required int currentIndex,
    required VoidCallback onTap,
    bool isCenter = false,
  }) {
    final isSelected = index == currentIndex;
    final color =
        isSelected ? Theme.of(context).primaryColor : Colors.grey[600];

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon Container with Animation
              TweenAnimationBuilder<double>(
                tween: Tween<double>(
                  begin: 0.0,
                  end: isSelected ? 1.0 : 0.0,
                ),
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeInOutCubic,
                builder: (context, value, child) {
                  return Transform.scale(
                    scale: 1.0 + (value * 0.15),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeInOutCubic,
                      height: 36,
                      width: isCenter ? 56 : 52,
                      decoration: BoxDecoration(
                        color: Color.lerp(
                          Colors.transparent,
                          Theme.of(context).primaryColor.withOpacity(0.15),
                          value,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        border: isCenter && isSelected
                            ? Border.all(
                                color: Theme.of(context)
                                    .primaryColor
                                    .withOpacity(0.3 * value),
                                width: 2,
                              )
                            : null,
                      ),
                      child: Icon(
                        icon,
                        color: Color.lerp(
                          Colors.grey[600],
                          Theme.of(context).primaryColor,
                          value,
                        ),
                        size: isCenter ? 26 : 24,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 2),
              // Label
              SizedBox(
                height: 14,
                child: AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOutCubic,
                  style: TextStyle(
                    color: color,
                    fontSize: isSelected ? 11.5 : 11,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    letterSpacing: 0.2,
                    height: 1.0,
                  ),
                  child: Center(
                    child: Text(
                      label,
                      maxLines: 1,
                      overflow: TextOverflow.clip,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              // Active Indicator
              SizedBox(
                height: 4,
                child: isSelected
                    ? TweenAnimationBuilder<double>(
                        tween: Tween<double>(begin: 0.0, end: 1.0),
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeInOutCubic,
                        builder: (context, value, child) {
                          return Center(
                            child: Container(
                              height: 2.5,
                              width: 20 * value,
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          );
                        },
                      )
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
