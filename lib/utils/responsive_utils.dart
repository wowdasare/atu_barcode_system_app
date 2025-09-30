import 'package:flutter/material.dart';

class ResponsiveUtils {
  static const double _mobileBreakpoint = 600;
  static const double _tabletBreakpoint = 840;

  static bool isMobile(BoxConstraints constraints) {
    return constraints.maxWidth < _mobileBreakpoint;
  }

  static bool isTablet(BoxConstraints constraints) {
    return constraints.maxWidth >= _mobileBreakpoint && 
           constraints.maxWidth < _tabletBreakpoint;
  }

  static bool isDesktop(BoxConstraints constraints) {
    return constraints.maxWidth >= _tabletBreakpoint;
  }

  static double getFontSize(BoxConstraints constraints, {
    double mobile = 14,
    double tablet = 16,
    double desktop = 18,
  }) {
    if (isDesktop(constraints)) return desktop;
    if (isTablet(constraints)) return tablet;
    return mobile;
  }

  static double getIconSize(BoxConstraints constraints, {
    double mobile = 24,
    double tablet = 32,
    double desktop = 40,
  }) {
    if (isDesktop(constraints)) return desktop;
    if (isTablet(constraints)) return tablet;
    return mobile;
  }

  static double getPadding(BoxConstraints constraints, {
    double mobile = 16,
    double tablet = 24,
    double desktop = 32,
  }) {
    if (isDesktop(constraints)) return desktop;
    if (isTablet(constraints)) return tablet;
    return mobile;
  }

  static double getCardElevation(BoxConstraints constraints, {
    double mobile = 2,
    double tablet = 4,
    double desktop = 6,
  }) {
    if (isDesktop(constraints)) return desktop;
    if (isTablet(constraints)) return tablet;
    return mobile;
  }

  static double getButtonHeight(BoxConstraints constraints, {
    double mobile = 48,
    double tablet = 52,
    double desktop = 56,
  }) {
    if (isDesktop(constraints)) return desktop;
    if (isTablet(constraints)) return tablet;
    return mobile;
  }

  static double getLogoSize(BoxConstraints constraints, {
    double mobile = 48,
    double tablet = 64,
    double desktop = 80,
  }) {
    if (isDesktop(constraints)) return desktop;
    if (isTablet(constraints)) return tablet;
    return mobile;
  }

  static EdgeInsets getContentPadding(BoxConstraints constraints, {
    EdgeInsets? mobile,
    EdgeInsets? tablet,
    EdgeInsets? desktop,
  }) {
    final mobilePadding = mobile ?? const EdgeInsets.all(16);
    final tabletPadding = tablet ?? const EdgeInsets.all(24);
    final desktopPadding = desktop ?? const EdgeInsets.all(32);

    if (isDesktop(constraints)) return desktopPadding;
    if (isTablet(constraints)) return tabletPadding;
    return mobilePadding;
  }

  static double getMaxWidth(BoxConstraints constraints, {
    double mobile = double.infinity,
    double tablet = 600,
    double desktop = 800,
  }) {
    if (isDesktop(constraints)) return desktop;
    if (isTablet(constraints)) return tablet;
    return mobile;
  }
}

class ResponsiveText extends StatelessWidget {
  final String text;
  final TextStyle? baseStyle;
  final double? mobileFontSize;
  final double? tabletFontSize;
  final double? desktopFontSize;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  const ResponsiveText(
    this.text, {
    super.key,
    this.baseStyle,
    this.mobileFontSize,
    this.tabletFontSize,
    this.desktopFontSize,
    this.textAlign,
    this.maxLines,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final fontSize = ResponsiveUtils.getFontSize(
          constraints,
          mobile: mobileFontSize ?? 14,
          tablet: tabletFontSize ?? 16,
          desktop: desktopFontSize ?? 18,
        );

        return Text(
          text,
          style: (baseStyle ?? const TextStyle()).copyWith(fontSize: fontSize),
          textAlign: textAlign,
          maxLines: maxLines,
          overflow: overflow,
        );
      },
    );
  }
}

class ResponsiveContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsets? mobilePadding;
  final EdgeInsets? tabletPadding;
  final EdgeInsets? desktopPadding;
  final double? maxWidth;

  const ResponsiveContainer({
    super.key,
    required this.child,
    this.mobilePadding,
    this.tabletPadding,
    this.desktopPadding,
    this.maxWidth,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final padding = ResponsiveUtils.getContentPadding(
          constraints,
          mobile: mobilePadding,
          tablet: tabletPadding,
          desktop: desktopPadding,
        );

        final containerMaxWidth = maxWidth ?? ResponsiveUtils.getMaxWidth(constraints);

        return Container(
          width: double.infinity,
          constraints: BoxConstraints(maxWidth: containerMaxWidth),
          padding: padding,
          child: child,
        );
      },
    );
  }
}

class ResponsiveButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final ButtonStyle? style;

  const ResponsiveButton({
    super.key,
    required this.child,
    this.onPressed,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final buttonHeight = ResponsiveUtils.getButtonHeight(constraints);

        return ElevatedButton(
          onPressed: onPressed,
          style: style?.copyWith(
            minimumSize: WidgetStateProperty.all(Size(double.infinity, buttonHeight)),
          ) ?? ElevatedButton.styleFrom(
            minimumSize: Size(double.infinity, buttonHeight),
          ),
          child: child,
        );
      },
    );
  }
}