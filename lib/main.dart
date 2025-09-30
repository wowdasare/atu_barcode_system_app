import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'providers/auth_provider.dart';
import 'providers/course_provider.dart';
import 'providers/attendance_provider.dart';
import 'screens/login_screen.dart';
import 'screens/dashboard_screen.dart';
import 'constants/app_constants.dart';
import 'utils/responsive_utils.dart';
import 'utils/navigation_helper.dart';
import 'utils/page_transitions.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Set preferred orientations to portrait only
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => CourseProvider()),
        ChangeNotifierProvider(create: (_) => AttendanceProvider()),
      ],
      child: MaterialApp(
        title: AppConstants.appName,
        debugShowCheckedModeBanner: false,
        theme: _buildTheme(),
        home: const SplashScreen(),
        onGenerateRoute: _onGenerateRoute,
      ),
    );
  }

  ThemeData _buildTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: AppColors.primary,
        onPrimary: AppColors.onPrimary,
        primaryContainer: AppColors.primaryVariant,
        onPrimaryContainer: AppColors.onPrimary,
        secondary: AppColors.secondary,
        onSecondary: AppColors.onSecondary,
        secondaryContainer: AppColors.secondaryVariant,
        onSecondaryContainer: AppColors.onSecondary,
        tertiary: AppColors.info,
        onTertiary: AppColors.onPrimary,
        tertiaryContainer: AppColors.info,
        onTertiaryContainer: AppColors.onPrimary,
        error: AppColors.error,
        onError: AppColors.onError,
        errorContainer: AppColors.error,
        onErrorContainer: AppColors.onError,
        surface: AppColors.surface,
        onSurface: AppColors.onSurface,
        surfaceContainerHighest: AppColors.background,
        onSurfaceVariant: AppColors.onBackground,
        outline: AppColors.divider,
        outlineVariant: AppColors.divider,
        shadow: Colors.black,
        scrim: Colors.black,
        inverseSurface: AppColors.textPrimary,
        onInverseSurface: AppColors.surface,
        inversePrimary: AppColors.primaryVariant,
        surfaceTint: AppColors.primary,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        elevation: AppConstants.elevationLow,
        centerTitle: false,
      ),
      cardTheme: null,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onPrimary,
          elevation: AppConstants.elevationLow,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          ),
          minimumSize: const Size(88, 48),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          ),
          minimumSize: const Size(88, 48),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          ),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        elevation: AppConstants.elevationMedium,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.textPrimary,
        contentTextStyle: const TextStyle(color: AppColors.surface),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        ),
        behavior: SnackBarBehavior.floating,
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          borderSide: const BorderSide(color: AppColors.divider),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          borderSide: const BorderSide(color: AppColors.primary),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      dialogTheme: null,
      bottomSheetTheme: const BottomSheetThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppConstants.borderRadius),
          ),
        ),
        elevation: AppConstants.elevationMedium,
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.divider,
        thickness: 1,
      ),
      textTheme: GoogleFonts.poppinsTextTheme(
        const TextTheme(
          displayLarge: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w700),
          displayMedium: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600),
          displaySmall: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600),
          headlineLarge: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600),
          headlineMedium: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600),
          headlineSmall: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600),
          titleLarge: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600),
          titleMedium: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w500),
          titleSmall: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w500),
          bodyLarge: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w400),
          bodyMedium: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w400),
          bodySmall: TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.w400),
          labelLarge: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w500),
          labelMedium: TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.w400),
          labelSmall: TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.w400),
        ),
      ),
    );
  }

  static Route<dynamic>? _onGenerateRoute(RouteSettings settings) {
    // Default page transition for all routes
    switch (settings.name) {
      case '/login':
        return PageTransitions.fade<dynamic>(
          child: const LoginScreen(),
          settings: settings,
        );
      case '/dashboard':
        return PageTransitions.slideAndFade<dynamic>(
          child: const DashboardScreen(),
          settings: settings,
        );
      default:
        return PageTransitions.slideFromRight<dynamic>(
          child: const LoginScreen(),
          settings: settings,
        );
    }
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    // Defer app initialization until after the build is complete
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeApp();
    });
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.5, curve: Curves.elasticOut),
    ));

    _animationController.forward();
  }

  void _initializeApp() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    
    try {
      await authProvider.initialize();
      
      // Add a minimum delay to show the splash screen
      await Future.delayed(AppConstants.splashDelay);

      if (mounted) {
        if (authProvider.isAuthenticated) {
          // User is authenticated, load courses and go to dashboard
          final courseProvider = Provider.of<CourseProvider>(context, listen: false);
          courseProvider.loadCourses();
          
          NavigationHelper.navigateToMain(
            context,
            const DashboardScreen(),
            replace: true,
          );
        } else {
          // No valid authentication, go to login
          NavigationHelper.navigateToMain(
            context,
            const LoginScreen(),
            replace: true,
          );
        }
      }
    } catch (e) {
      // Initialization failed, go to login with error
      if (mounted) {
        NavigationHelper.navigateToMain(
          context,
          const LoginScreen(),
          replace: true,
        );
        
        // Show error message after navigation
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Authentication initialization failed: ${authProvider.errorMessage ?? 'Unknown error'}'),
                backgroundColor: AppColors.error,
                behavior: SnackBarBehavior.floating,
                action: SnackBarAction(
                  label: 'Retry',
                  textColor: AppColors.onPrimary,
                  onPressed: () => _initializeApp(),
                ),
              ),
            );
          }
        });
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Center(
            child: AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return FadeTransition(
                  opacity: _fadeAnimation,
                  child: ScaleTransition(
                    scale: _scaleAnimation,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.all(ResponsiveUtils.getPadding(constraints, mobile: 24, tablet: 32, desktop: 40)),
                          decoration: BoxDecoration(
                            color: AppColors.onPrimary,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: ResponsiveUtils.getPadding(constraints, mobile: 20, tablet: 24, desktop: 28),
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.qr_code_scanner,
                            size: ResponsiveUtils.getIconSize(constraints, mobile: 64, tablet: 80, desktop: 96),
                            color: AppColors.primary,
                          ),
                        ),
                        SizedBox(height: ResponsiveUtils.getPadding(constraints, mobile: 24, tablet: 32, desktop: 40)),
                        const ResponsiveText(
                          AppConstants.appName,
                          baseStyle: TextStyle(
                            color: AppColors.onPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                          mobileFontSize: 28,
                          tabletFontSize: 36,
                          desktopFontSize: 44,
                        ),
                        SizedBox(height: ResponsiveUtils.getPadding(constraints, mobile: 8, tablet: 12, desktop: 16)),
                        const ResponsiveText(
                          'Barcode Attendance System',
                          baseStyle: TextStyle(
                            color: AppColors.onPrimary,
                            fontWeight: FontWeight.w300,
                          ),
                          mobileFontSize: 16,
                          tabletFontSize: 20,
                          desktopFontSize: 24,
                        ),
                        SizedBox(height: ResponsiveUtils.getPadding(constraints, mobile: 32, tablet: 40, desktop: 48)),
                        SizedBox(
                          width: ResponsiveUtils.getIconSize(constraints, mobile: 20, tablet: 24, desktop: 28),
                          height: ResponsiveUtils.getIconSize(constraints, mobile: 20, tablet: 24, desktop: 28),
                          child: const CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(AppColors.onPrimary),
                            strokeWidth: 2,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
