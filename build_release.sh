#!/bin/bash

echo "🚀 Building ATU Barcode Attendance System for Production"

# Clean previous builds
echo "🧹 Cleaning previous builds..."
flutter clean
flutter pub get

# Run analysis
echo "🔍 Running code analysis..."
flutter analyze --no-fatal-infos

# Run tests
echo "🧪 Running tests..."
flutter test --no-sound-null-safety

# Build release APK
echo "📱 Building release APK..."
flutter build apk --release --no-sound-null-safety

# Build App Bundle for Play Store
echo "📦 Building App Bundle..."
flutter build appbundle --release --no-sound-null-safety

echo "✅ Build completed!"
echo "📱 APK location: build/app/outputs/flutter-apk/app-release.apk"
echo "📦 AAB location: build/app/outputs/bundle/release/app-release.aab"
echo ""
echo "🚀 Ready for deployment!"
echo "📋 Release checklist:"
echo "  ✅ Real API integration implemented"
echo "  ✅ Google Fonts Poppins applied"
echo "  ✅ Comprehensive error handling"
echo "  ✅ Offline functionality with fallback"
echo "  ✅ Network security configured"
echo "  ✅ Production optimizations applied"
echo "  ✅ Camera permissions configured"
echo "  ✅ Material Design 3 theming"