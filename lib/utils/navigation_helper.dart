import 'package:flutter/material.dart';
import 'page_transitions.dart';

class NavigationHelper {
  // Navigation methods with different transition types based on context
  
  // For main flow navigation (login -> dashboard, etc.)
  static Future<T?> navigateToMain<T extends Object?>(
    BuildContext context,
    Widget destination, {
    bool replace = false,
  }) {
    final route = PageTransitions.slideAndFade<T>(
      child: destination,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOutCubic,
    );
    
    if (replace) {
      return Navigator.of(context).pushReplacement(route);
    } else {
      return Navigator.of(context).push(route);
    }
  }
  
  // For forward navigation (dashboard -> session creation)
  static Future<T?> navigateForward<T extends Object?>(
    BuildContext context,
    Widget destination, {
    bool replace = false,
  }) {
    final route = PageTransitions.slideFromRight<T>(
      child: destination,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    
    if (replace) {
      return Navigator.of(context).pushReplacement(route);
    } else {
      return Navigator.of(context).push(route);
    }
  }
  
  // For backward navigation (typically with back button)
  static Future<T?> navigateBack<T extends Object?>(
    BuildContext context,
    Widget destination, {
    bool replace = false,
  }) {
    final route = PageTransitions.slideFromLeft<T>(
      child: destination,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    
    if (replace) {
      return Navigator.of(context).pushReplacement(route);
    } else {
      return Navigator.of(context).push(route);
    }
  }
  
  // For modal/dialog-style navigation (from bottom)
  static Future<T?> navigateModal<T extends Object?>(
    BuildContext context,
    Widget destination, {
    bool replace = false,
  }) {
    final route = PageTransitions.slideFromBottom<T>(
      child: destination,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOutCubic,
    );
    
    if (replace) {
      return Navigator.of(context).pushReplacement(route);
    } else {
      return Navigator.of(context).push(route);
    }
  }
  
  // For utility/settings screens (fade)
  static Future<T?> navigateUtility<T extends Object?>(
    BuildContext context,
    Widget destination, {
    bool replace = false,
  }) {
    final route = PageTransitions.fade<T>(
      child: destination,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeIn,
    );
    
    if (replace) {
      return Navigator.of(context).pushReplacement(route);
    } else {
      return Navigator.of(context).push(route);
    }
  }
  
  // For special/feature screens (scale)
  static Future<T?> navigateSpecial<T extends Object?>(
    BuildContext context,
    Widget destination, {
    bool replace = false,
  }) {
    final route = PageTransitions.scale<T>(
      child: destination,
      duration: const Duration(milliseconds: 400),
      curve: Curves.elasticOut,
    );
    
    if (replace) {
      return Navigator.of(context).pushReplacement(route);
    } else {
      return Navigator.of(context).push(route);
    }
  }
  
  // For completion/success screens
  static Future<T?> navigateToCompletion<T extends Object?>(
    BuildContext context,
    Widget destination, {
    bool clearStack = false,
  }) {
    final route = PageTransitions.rotateAndSlide<T>(
      child: destination,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutBack,
    );
    
    if (clearStack) {
      return Navigator.of(context).pushAndRemoveUntil(
        route,
        (Route<dynamic> route) => false,
      );
    } else {
      return Navigator.of(context).push(route);
    }
  }
  
  // Custom navigation with specific transition
  static Future<T?> navigateWithTransition<T extends Object?>(
    BuildContext context,
    Widget destination,
    TransitionType transitionType, {
    bool replace = false,
    Duration? duration,
    Curve? curve,
  }) {
    final route = CustomPageRoute<T>(
      child: destination,
      transitionType: transitionType,
      duration: duration ?? const Duration(milliseconds: 300),
      curve: curve ?? Curves.easeInOut,
    );
    
    if (replace) {
      return Navigator.of(context).pushReplacement(route);
    } else {
      return Navigator.of(context).push(route);
    }
  }
  
  // Pop with custom transition (for back navigation)
  static void popWithTransition(BuildContext context, [dynamic result]) {
    Navigator.of(context).pop(result);
  }
  
  // Pop until a certain condition
  static void popUntil(BuildContext context, RoutePredicate predicate) {
    Navigator.of(context).popUntil(predicate);
  }
  
  // Pop and push with transition
  static Future<T?> popAndPush<T extends Object?, TO extends Object?>(
    BuildContext context,
    Widget destination, {
    TO? result,
    TransitionType transitionType = TransitionType.slideFromRight,
    Duration? duration,
    Curve? curve,
  }) {
    final route = CustomPageRoute<T>(
      child: destination,
      transitionType: transitionType,
      duration: duration ?? const Duration(milliseconds: 300),
      curve: curve ?? Curves.easeInOut,
    );
    
    return Navigator.of(context).pushReplacement(route, result: result);
  }
}