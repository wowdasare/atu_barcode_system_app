import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../constants/app_constants.dart';
import '../utils/responsive_utils.dart';
import '../utils/navigation_helper.dart';
import 'dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: ResponsiveUtils.getMaxWidth(
                    constraints,
                    mobile: double.infinity,
                    tablet: 500,
                    desktop: 400,
                  ),
                ),
                child: SingleChildScrollView(
                  padding: ResponsiveUtils.getContentPadding(constraints),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: ResponsiveUtils.getPadding(constraints, mobile: 60, tablet: 80, desktop: 100)),
                      _buildLogo(constraints),
                      SizedBox(height: ResponsiveUtils.getPadding(constraints, mobile: 40, tablet: 48, desktop: 56)),
                      _buildLoginCard(constraints),
                      SizedBox(height: ResponsiveUtils.getPadding(constraints, mobile: 24, tablet: 32, desktop: 40)),
                      _buildFooter(constraints),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildLogo(BoxConstraints constraints) {
    final logoSize = ResponsiveUtils.getLogoSize(constraints);
    final iconPadding = ResponsiveUtils.getPadding(constraints, mobile: 20, tablet: 24, desktop: 28);
    
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(iconPadding),
          decoration: BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.3),
                blurRadius: ResponsiveUtils.getPadding(constraints, mobile: 20, tablet: 24, desktop: 28),
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Icon(
            Icons.qr_code_scanner,
            size: logoSize,
            color: AppColors.onPrimary,
          ),
        ),
        SizedBox(height: ResponsiveUtils.getPadding(constraints, mobile: 16, tablet: 20, desktop: 24)),
        ResponsiveText(
          AppConstants.appName,
          baseStyle: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
          mobileFontSize: 24,
          tabletFontSize: 28,
          desktopFontSize: 32,
        ),
        SizedBox(height: ResponsiveUtils.getPadding(constraints, mobile: 8, tablet: 10, desktop: 12)),
        ResponsiveText(
          'Barcode Attendance System',
          baseStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: AppColors.textSecondary,
          ),
          mobileFontSize: 16,
          tabletFontSize: 18,
          desktopFontSize: 20,
        ),
      ],
    );
  }

  Widget _buildLoginCard(BoxConstraints constraints) {
    final cardElevation = ResponsiveUtils.getCardElevation(constraints);
    final cardPadding = ResponsiveUtils.getContentPadding(constraints);
    
    return Card(
      elevation: cardElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
      ),
      child: Padding(
        padding: cardPadding,
        child: Consumer<AuthProvider>(
          builder: (context, authProvider, child) {
            return Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ResponsiveText(
                    'Welcome Back',
                    baseStyle: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                    mobileFontSize: 20,
                    tabletFontSize: 24,
                    desktopFontSize: 28,
                  ),
                  SizedBox(height: ResponsiveUtils.getPadding(constraints, mobile: 8, tablet: 10, desktop: 12)),
                  ResponsiveText(
                    'Sign in to continue',
                    baseStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                    mobileFontSize: 14,
                    tabletFontSize: 16,
                    desktopFontSize: 18,
                  ),
                  SizedBox(height: ResponsiveUtils.getPadding(constraints, mobile: 32, tablet: 40, desktop: 48)),
                  _buildUsernameField(constraints),
                  SizedBox(height: ResponsiveUtils.getPadding(constraints, mobile: 16, tablet: 20, desktop: 24)),
                  _buildPasswordField(constraints),
                  SizedBox(height: ResponsiveUtils.getPadding(constraints, mobile: 24, tablet: 28, desktop: 32)),
                  if (authProvider.errorMessage != null)
                    _buildErrorMessage(authProvider.errorMessage!, constraints),
                  _buildLoginButton(authProvider, constraints),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildUsernameField(BoxConstraints constraints) {
    return TextFormField(
      controller: _usernameController,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        labelText: 'Username',
        hintText: 'Enter your username',
        prefixIcon: const Icon(Icons.person_outline),
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
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter your username';
        }
        return null;
      },
    );
  }

  Widget _buildPasswordField(BoxConstraints constraints) {
    return TextFormField(
      controller: _passwordController,
      obscureText: _obscurePassword,
      textInputAction: TextInputAction.done,
      onFieldSubmitted: (_) => _handleLogin(),
      decoration: InputDecoration(
        labelText: 'Password',
        hintText: 'Enter your password',
        prefixIcon: const Icon(Icons.lock_outline),
        suffixIcon: IconButton(
          icon: Icon(
            _obscurePassword ? Icons.visibility : Icons.visibility_off,
          ),
          onPressed: () {
            setState(() {
              _obscurePassword = !_obscurePassword;
            });
          },
        ),
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
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your password';
        }
        if (value.length < 4) {
          return 'Password must be at least 4 characters';
        }
        return null;
      },
    );
  }

  Widget _buildErrorMessage(String message, BoxConstraints constraints) {
    final padding = ResponsiveUtils.getPadding(constraints, mobile: 12, tablet: 16, desktop: 20);
    final iconSize = ResponsiveUtils.getIconSize(constraints, mobile: 20, tablet: 22, desktop: 24);
    
    return Container(
      margin: EdgeInsets.only(bottom: ResponsiveUtils.getPadding(constraints, mobile: 16, tablet: 20, desktop: 24)),
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: AppColors.error.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        border: Border.all(color: AppColors.error.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.error_outline,
            color: AppColors.error,
            size: iconSize,
          ),
          SizedBox(width: ResponsiveUtils.getPadding(constraints, mobile: 8, tablet: 10, desktop: 12)),
          Expanded(
            child: ResponsiveText(
              message,
              baseStyle: const TextStyle(color: AppColors.error),
              mobileFontSize: 14,
              tabletFontSize: 15,
              desktopFontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginButton(AuthProvider authProvider, BoxConstraints constraints) {
    final buttonHeight = ResponsiveUtils.getButtonHeight(constraints);
    final fontSize = ResponsiveUtils.getFontSize(constraints, mobile: 16, tablet: 18, desktop: 20);
    
    return ElevatedButton(
      onPressed: authProvider.isLoading ? null : _handleLogin,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        elevation: AppConstants.elevationLow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        ),
        minimumSize: Size(double.infinity, buttonHeight),
      ),
      child: authProvider.isLoading
          ? SizedBox(
              height: ResponsiveUtils.getIconSize(constraints, mobile: 20, tablet: 22, desktop: 24),
              width: ResponsiveUtils.getIconSize(constraints, mobile: 20, tablet: 22, desktop: 24),
              child: const CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.onPrimary),
              ),
            )
          : Text(
              'Sign In',
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.w600,
              ),
            ),
    );
  }

  Widget _buildFooter(BoxConstraints constraints) {
    return ResponsiveText(
      'ATU Barcode Attendance System\nVersion ${AppConstants.appVersion}',
      baseStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
        color: AppColors.textSecondary,
      ),
      textAlign: TextAlign.center,
      mobileFontSize: 12,
      tabletFontSize: 14,
      desktopFontSize: 16,
    );
  }

  void _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    
    final success = await authProvider.login(
      _usernameController.text.trim(),
      _passwordController.text,
    );

    if (success && mounted) {
      NavigationHelper.navigateToMain(
        context,
        const DashboardScreen(),
        replace: true,
      );
    }
  }
}