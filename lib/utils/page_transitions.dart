import 'package:flutter/material.dart';

enum TransitionType {
  slideFromRight,
  slideFromLeft,
  slideFromBottom,
  slideFromTop,
  fade,
  scale,
  slideAndFade,
  rotateAndSlide,
}

class CustomPageRoute<T> extends PageRouteBuilder<T> {
  final Widget child;
  final TransitionType transitionType;
  final Duration duration;
  final Curve curve;

  CustomPageRoute({
    required this.child,
    this.transitionType = TransitionType.slideFromRight,
    this.duration = const Duration(milliseconds: 300),
    this.curve = Curves.easeInOut,
    super.settings,
  }) : super(
          pageBuilder: (context, animation, secondaryAnimation) => child,
          transitionDuration: duration,
          reverseTransitionDuration: duration,
        );

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    switch (transitionType) {
      case TransitionType.slideFromRight:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1.0, 0.0),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: animation, curve: curve)),
          child: child,
        );

      case TransitionType.slideFromLeft:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(-1.0, 0.0),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: animation, curve: curve)),
          child: child,
        );

      case TransitionType.slideFromBottom:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.0, 1.0),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: animation, curve: curve)),
          child: child,
        );

      case TransitionType.slideFromTop:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.0, -1.0),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: animation, curve: curve)),
          child: child,
        );

      case TransitionType.fade:
        return FadeTransition(
          opacity: animation,
          child: child,
        );

      case TransitionType.scale:
        return ScaleTransition(
          scale: Tween<double>(
            begin: 0.0,
            end: 1.0,
          ).animate(CurvedAnimation(parent: animation, curve: curve)),
          child: child,
        );

      case TransitionType.slideAndFade:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1.0, 0.0),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: animation, curve: curve)),
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );

      case TransitionType.rotateAndSlide:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1.0, 0.0),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: animation, curve: curve)),
          child: RotationTransition(
            turns: Tween<double>(
              begin: 0.1,
              end: 0.0,
            ).animate(CurvedAnimation(parent: animation, curve: curve)),
            child: child,
          ),
        );

    }
  }
}

class PageTransitions {
  static Route<T> slideFromRight<T extends Object?>({
    required Widget child,
    RouteSettings? settings,
    Duration? duration,
    Curve? curve,
  }) {
    return CustomPageRoute<T>(
      child: child,
      transitionType: TransitionType.slideFromRight,
      duration: duration ?? const Duration(milliseconds: 300),
      curve: curve ?? Curves.easeInOut,
      settings: settings,
    );
  }

  static Route<T> slideFromLeft<T extends Object?>({
    required Widget child,
    RouteSettings? settings,
    Duration? duration,
    Curve? curve,
  }) {
    return CustomPageRoute<T>(
      child: child,
      transitionType: TransitionType.slideFromLeft,
      duration: duration ?? const Duration(milliseconds: 300),
      curve: curve ?? Curves.easeInOut,
      settings: settings,
    );
  }

  static Route<T> slideFromBottom<T extends Object?>({
    required Widget child,
    RouteSettings? settings,
    Duration? duration,
    Curve? curve,
  }) {
    return CustomPageRoute<T>(
      child: child,
      transitionType: TransitionType.slideFromBottom,
      duration: duration ?? const Duration(milliseconds: 350),
      curve: curve ?? Curves.easeOutCubic,
      settings: settings,
    );
  }

  static Route<T> slideFromTop<T extends Object?>({
    required Widget child,
    RouteSettings? settings,
    Duration? duration,
    Curve? curve,
  }) {
    return CustomPageRoute<T>(
      child: child,
      transitionType: TransitionType.slideFromTop,
      duration: duration ?? const Duration(milliseconds: 350),
      curve: curve ?? Curves.easeOutCubic,
      settings: settings,
    );
  }

  static Route<T> fade<T extends Object?>({
    required Widget child,
    RouteSettings? settings,
    Duration? duration,
    Curve? curve,
  }) {
    return CustomPageRoute<T>(
      child: child,
      transitionType: TransitionType.fade,
      duration: duration ?? const Duration(milliseconds: 250),
      curve: curve ?? Curves.easeIn,
      settings: settings,
    );
  }

  static Route<T> scale<T extends Object?>({
    required Widget child,
    RouteSettings? settings,
    Duration? duration,
    Curve? curve,
  }) {
    return CustomPageRoute<T>(
      child: child,
      transitionType: TransitionType.scale,
      duration: duration ?? const Duration(milliseconds: 300),
      curve: curve ?? Curves.elasticOut,
      settings: settings,
    );
  }

  static Route<T> slideAndFade<T extends Object?>({
    required Widget child,
    RouteSettings? settings,
    Duration? duration,
    Curve? curve,
  }) {
    return CustomPageRoute<T>(
      child: child,
      transitionType: TransitionType.slideAndFade,
      duration: duration ?? const Duration(milliseconds: 400),
      curve: curve ?? Curves.easeOutCubic,
      settings: settings,
    );
  }

  static Route<T> rotateAndSlide<T extends Object?>({
    required Widget child,
    RouteSettings? settings,
    Duration? duration,
    Curve? curve,
  }) {
    return CustomPageRoute<T>(
      child: child,
      transitionType: TransitionType.rotateAndSlide,
      duration: duration ?? const Duration(milliseconds: 500),
      curve: curve ?? Curves.easeOutBack,
      settings: settings,
    );
  }
}