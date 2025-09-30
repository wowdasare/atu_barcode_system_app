import 'dart:async';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import '../constants/app_constants.dart';

class ScannerService {
  static final ScannerService _instance = ScannerService._internal();
  factory ScannerService() => _instance;
  ScannerService._internal();

  MobileScannerController? _controller;
  StreamSubscription<BarcodeCapture>? _subscription;
  bool _isScanning = false;
  DateTime? _lastScanTime;

  MobileScannerController? get controller => _controller;
  bool get isScanning => _isScanning;

  Future<bool> requestCameraPermission() async {
    final status = await Permission.camera.status;
    
    if (status.isGranted) {
      return true;
    } else if (status.isDenied) {
      final result = await Permission.camera.request();
      return result.isGranted;
    } else if (status.isPermanentlyDenied) {
      await openAppSettings();
      return false;
    }
    
    return false;
  }

  Future<bool> initializeScanner({
    DetectionSpeed detectionSpeed = DetectionSpeed.noDuplicates,
    CameraFacing facing = CameraFacing.back,
    bool autoStart = true,
  }) async {
    try {
      if (_controller != null) {
        await disposeScanner();
      }

      final hasPermission = await requestCameraPermission();
      if (!hasPermission) {
        return false;
      }

      _controller = MobileScannerController(
        detectionSpeed: detectionSpeed,
        facing: facing,
        formats: _getSupportedFormats(),
        autoStart: autoStart,
      );

      return true;
    } catch (e) {
      return false;
    }
  }

  List<BarcodeFormat> _getSupportedFormats() {
    return [
      BarcodeFormat.code128,
      BarcodeFormat.qrCode,
      BarcodeFormat.ean13,
      BarcodeFormat.ean8,
      BarcodeFormat.code39,
      BarcodeFormat.code93,
      BarcodeFormat.dataMatrix,
      BarcodeFormat.pdf417,
    ];
  }

  void startScanning({
    required Function(String data, BarcodeFormat format) onDetected,
    required Function(String error) onError,
  }) {
    if (_controller == null || _isScanning) return;

    _isScanning = true;
    _subscription = _controller!.barcodes.listen(
      (BarcodeCapture capture) {
        _handleBarcodeDetection(capture, onDetected);
      },
      onError: (error) {
        onError('Scanner error: ${error.toString()}');
        _isScanning = false;
      },
    );
  }

  void _handleBarcodeDetection(
    BarcodeCapture capture, 
    Function(String data, BarcodeFormat format) onDetected,
  ) {
    final now = DateTime.now();
    
    if (_lastScanTime != null && 
        now.difference(_lastScanTime!) < AppConstants.scannerDelay) {
      return;
    }

    if (capture.barcodes.isNotEmpty) {
      final barcode = capture.barcodes.first;
      final data = barcode.rawValue;
      
      if (data != null && data.isNotEmpty) {
        _lastScanTime = now;
        onDetected(data, barcode.format);
      }
    }
  }

  void stopScanning() {
    _isScanning = false;
    _subscription?.cancel();
    _subscription = null;
    _lastScanTime = null;
  }

  Future<void> toggleTorch() async {
    if (_controller == null) return;
    
    try {
      await _controller!.toggleTorch();
    } catch (e) {
      // Handle torch toggle error
    }
  }

  Future<void> switchCamera() async {
    if (_controller == null) return;
    
    try {
      await _controller!.switchCamera();
    } catch (e) {
      // Handle camera switch error
    }
  }

  Future<bool> hasTorch() async {
    if (_controller == null) return false;
    
    try {
      return true;
    } catch (e) {
      return false;
    }
  }

  bool get torchEnabled {
    return _controller?.torchEnabled ?? false;
  }

  CameraFacing get cameraFacing {
    return _controller?.facing ?? CameraFacing.back;
  }

  Future<void> resetScanner() async {
    stopScanning();
    if (_controller != null) {
      try {
        await _controller!.stop();
        await _controller!.start();
      } catch (e) {
        // Handle reset error
      }
    }
  }

  Future<void> disposeScanner() async {
    stopScanning();
    
    if (_controller != null) {
      try {
        _controller!.dispose();
      } catch (e) {
        // Handle dispose error
      } finally {
        _controller = null;
      }
    }
  }

  bool isValidBarcodeFormat(BarcodeFormat format) {
    final supportedFormats = _getSupportedFormats();
    return supportedFormats.contains(format);
  }

  String getBarcodeFormatName(BarcodeFormat format) {
    switch (format) {
      case BarcodeFormat.code128:
        return 'Code 128';
      case BarcodeFormat.qrCode:
        return 'QR Code';
      case BarcodeFormat.ean13:
        return 'EAN-13';
      case BarcodeFormat.ean8:
        return 'EAN-8';
      case BarcodeFormat.code39:
        return 'Code 39';
      case BarcodeFormat.code93:
        return 'Code 93';
      case BarcodeFormat.dataMatrix:
        return 'Data Matrix';
      case BarcodeFormat.pdf417:
        return 'PDF417';
      default:
        return 'Unknown';
    }
  }
}