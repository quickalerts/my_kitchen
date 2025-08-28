import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';

class BarcodeScanner extends StatefulWidget {
  const BarcodeScanner({Key? key}) : super(key: key);

  @override
  State<BarcodeScanner> createState() => _BarcodeScannerState();
}

class _BarcodeScannerState extends State<BarcodeScanner>
    with TickerProviderStateMixin {
  MobileScannerController? _scannerController;
  bool _isFlashOn = false;
  bool _isScanning = true;
  bool _isLoading = false;
  String? _scannedCode;
  Map<String, dynamic>? _productData;
  late AnimationController _animationController;
  late Animation<double> _scanAnimation;

  // Mock product database
  final Map<String, Map<String, dynamic>> _productDatabase = {
    "1234567890123": {
      "name": "Organic Bananas",
      "category": "Fruits",
      "image":
          "https://images.unsplash.com/photo-1571771894821-ce9b6c11b08e?w=400&h=400&fit=crop",
      "shelfLife": "5-7 days",
      "description": "Fresh organic bananas, perfect for snacking or smoothies"
    },
    "9876543210987": {
      "name": "Whole Wheat Bread",
      "category": "Bakery",
      "image":
          "https://images.unsplash.com/photo-1509440159596-0249088772ff?w=400&h=400&fit=crop",
      "shelfLife": "3-5 days",
      "description": "Freshly baked whole wheat bread, rich in fiber"
    },
    "5555666677778": {
      "name": "Greek Yogurt",
      "category": "Dairy",
      "image":
          "https://images.unsplash.com/photo-1488477181946-6428a0291777?w=400&h=400&fit=crop",
      "shelfLife": "7-10 days",
      "description": "Creamy Greek yogurt, high in protein"
    },
    "1111222233334": {
      "name": "Red Bell Peppers",
      "category": "Vegetables",
      "image":
          "https://images.unsplash.com/photo-1563565375-f3fdfdbefa83?w=400&h=400&fit=crop",
      "shelfLife": "7-10 days",
      "description": "Fresh red bell peppers, perfect for cooking"
    },
  };

  @override
  void initState() {
    super.initState();
    _initializeScanner();
    _setupAnimation();
  }

  void _setupAnimation() {
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _scanAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _animationController.repeat(reverse: true);
  }

  Future<void> _initializeScanner() async {
    try {
      final hasPermission = await _requestCameraPermission();
      if (!hasPermission) {
        _showPermissionDialog();
        return;
      }

      _scannerController = MobileScannerController(
        detectionSpeed: DetectionSpeed.noDuplicates,
        facing: CameraFacing.back,
        torchEnabled: false,
      );

      await _scannerController!.start();
    } catch (e) {
      _showErrorDialog('Failed to initialize camera. Please try again.');
    }
  }

  Future<bool> _requestCameraPermission() async {
    if (kIsWeb) return true;

    final status = await Permission.camera.request();
    return status.isGranted;
  }

  void _onBarcodeDetected(BarcodeCapture capture) {
    if (!_isScanning || _isLoading) return;

    final List<Barcode> barcodes = capture.barcodes;
    if (barcodes.isEmpty) return;

    final barcode = barcodes.first;
    final code = barcode.rawValue;

    if (code != null && code.isNotEmpty) {
      setState(() {
        _isScanning = false;
        _scannedCode = code;
        _isLoading = true;
      });

      HapticFeedback.mediumImpact();
      _lookupProduct(code);
    }
  }

  Future<void> _lookupProduct(String code) async {
    // Simulate network lookup delay
    await Future.delayed(const Duration(milliseconds: 1500));

    setState(() {
      _isLoading = false;
    });

    if (_productDatabase.containsKey(code)) {
      setState(() {
        _productData = _productDatabase[code];
      });
      _showProductFoundSheet();
    } else {
      _showProductNotFoundDialog();
    }
  }

  void _showProductFoundSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildProductFoundSheet(),
    );
  }

  Widget _buildProductFoundSheet() {
    return Container(
      height: 60.h,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            width: 12.w,
            height: 0.5.h,
            margin: EdgeInsets.symmetric(vertical: 2.h),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.dividerColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Success animation
          Container(
            width: 20.w,
            height: 10.h,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.tertiary
                  .withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: CustomIconWidget(
              iconName: 'check_circle',
              color: AppTheme.lightTheme.colorScheme.tertiary,
              size: 8.w,
            ),
          ),

          SizedBox(height: 2.h),

          Text(
            'Product Found!',
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.tertiary,
              fontWeight: FontWeight.w600,
            ),
          ),

          SizedBox(height: 3.h),

          // Product details
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 6.w),
              child: Column(
                children: [
                  // Product image
                  Container(
                    width: 30.w,
                    height: 15.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: CustomImageWidget(
                        imageUrl: _productData?['image'] ?? '',
                        width: 30.w,
                        height: 15.h,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  SizedBox(height: 3.h),

                  // Product name
                  Text(
                    _productData?['name'] ?? 'Unknown Product',
                    style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: 1.h),

                  // Category
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.primary
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      _productData?['category'] ?? 'General',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),

                  SizedBox(height: 2.h),

                  // Shelf life
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomIconWidget(
                        iconName: 'schedule',
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        size: 4.w,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        'Shelf Life: ${_productData?['shelfLife'] ?? 'N/A'}',
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 1.h),

                  // Description
                  Text(
                    _productData?['description'] ?? '',
                    style: AppTheme.lightTheme.textTheme.bodySmall,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const Spacer(),

                  // Action buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _resetScanner,
                          child: const Text('Scan Another'),
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Expanded(
                        flex: 2,
                        child: ElevatedButton(
                          onPressed: _addToInventory,
                          child: const Text('Add to Inventory'),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 2.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showProductNotFoundDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            CustomIconWidget(
              iconName: 'search_off',
              color: AppTheme.lightTheme.colorScheme.error,
              size: 6.w,
            ),
            SizedBox(width: 3.w),
            const Text('Product Not Found'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'We couldn\'t find this product in our database.',
              style: AppTheme.lightTheme.textTheme.bodyMedium,
            ),
            SizedBox(height: 2.h),
            Text(
              'Scanned Code: $_scannedCode',
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                fontFamily: 'monospace',
                backgroundColor: AppTheme.lightTheme.colorScheme.surface,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: _resetScanner,
            child: const Text('Try Again'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/add-edit-item');
            },
            child: const Text('Enter Manually'),
          ),
        ],
      ),
    );
  }

  void _showPermissionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            CustomIconWidget(
              iconName: 'camera_alt',
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 6.w,
            ),
            SizedBox(width: 3.w),
            const Text('Camera Permission'),
          ],
        ),
        content: const Text(
          'Camera access is required to scan barcodes. Please grant permission in your device settings.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await openAppSettings();
              Navigator.pop(context);
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            CustomIconWidget(
              iconName: 'error',
              color: AppTheme.lightTheme.colorScheme.error,
              size: 6.w,
            ),
            SizedBox(width: 3.w),
            const Text('Error'),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _toggleFlash() {
    if (_scannerController != null) {
      setState(() {
        _isFlashOn = !_isFlashOn;
      });
      _scannerController!.toggleTorch();
      HapticFeedback.lightImpact();
    }
  }

  void _resetScanner() {
    Navigator.pop(context);
    setState(() {
      _isScanning = true;
      _isLoading = false;
      _scannedCode = null;
      _productData = null;
    });
  }

  void _addToInventory() {
    Navigator.pop(context);
    Navigator.pop(context);
    // Navigate to inventory with product data
    Navigator.pushNamed(context, '/inventory-management');
  }

  @override
  void dispose() {
    _scannerController?.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            // Camera preview
            if (_scannerController != null)
              MobileScanner(
                controller: _scannerController!,
                onDetect: _onBarcodeDetected,
              ),

            // Overlay with scanning frame
            _buildScanningOverlay(),

            // Top controls
            _buildTopControls(),

            // Bottom instructions
            _buildBottomInstructions(),

            // Loading overlay
            if (_isLoading) _buildLoadingOverlay(),
          ],
        ),
      ),
    );
  }

  Widget _buildScanningOverlay() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.5),
      ),
      child: Stack(
        children: [
          // Scanning frame cutout
          Center(
            child: Container(
              width: 70.w,
              height: 35.h,
              decoration: BoxDecoration(
                border: Border.all(
                  color: _isScanning
                      ? AppTheme.lightTheme.colorScheme.primary
                      : AppTheme.lightTheme.colorScheme.tertiary,
                  width: 3,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Stack(
                children: [
                  // Corner indicators
                  ..._buildCornerIndicators(),

                  // Scanning line animation
                  if (_isScanning)
                    AnimatedBuilder(
                      animation: _scanAnimation,
                      builder: (context, child) {
                        return Positioned(
                          top: _scanAnimation.value * 30.h,
                          left: 0,
                          right: 0,
                          child: Container(
                            height: 2,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.transparent,
                                  AppTheme.lightTheme.colorScheme.primary,
                                  Colors.transparent,
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildCornerIndicators() {
    const double cornerSize = 20;
    const double cornerThickness = 3;

    return [
      // Top-left corner
      Positioned(
        top: -cornerThickness,
        left: -cornerThickness,
        child: Container(
          width: cornerSize,
          height: cornerSize,
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: AppTheme.lightTheme.colorScheme.primary,
                width: cornerThickness,
              ),
              left: BorderSide(
                color: AppTheme.lightTheme.colorScheme.primary,
                width: cornerThickness,
              ),
            ),
          ),
        ),
      ),

      // Top-right corner
      Positioned(
        top: -cornerThickness,
        right: -cornerThickness,
        child: Container(
          width: cornerSize,
          height: cornerSize,
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: AppTheme.lightTheme.colorScheme.primary,
                width: cornerThickness,
              ),
              right: BorderSide(
                color: AppTheme.lightTheme.colorScheme.primary,
                width: cornerThickness,
              ),
            ),
          ),
        ),
      ),

      // Bottom-left corner
      Positioned(
        bottom: -cornerThickness,
        left: -cornerThickness,
        child: Container(
          width: cornerSize,
          height: cornerSize,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: AppTheme.lightTheme.colorScheme.primary,
                width: cornerThickness,
              ),
              left: BorderSide(
                color: AppTheme.lightTheme.colorScheme.primary,
                width: cornerThickness,
              ),
            ),
          ),
        ),
      ),

      // Bottom-right corner
      Positioned(
        bottom: -cornerThickness,
        right: -cornerThickness,
        child: Container(
          width: cornerSize,
          height: cornerSize,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: AppTheme.lightTheme.colorScheme.primary,
                width: cornerThickness,
              ),
              right: BorderSide(
                color: AppTheme.lightTheme.colorScheme.primary,
                width: cornerThickness,
              ),
            ),
          ),
        ),
      ),
    ];
  }

  Widget _buildTopControls() {
    return Positioned(
      top: 2.h,
      left: 0,
      right: 0,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 6.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Close button
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: 12.w,
                height: 6.h,
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: CustomIconWidget(
                  iconName: 'close',
                  color: Colors.white,
                  size: 6.w,
                ),
              ),
            ),

            // Flash toggle
            if (!kIsWeb)
              GestureDetector(
                onTap: _toggleFlash,
                child: Container(
                  width: 12.w,
                  height: 6.h,
                  decoration: BoxDecoration(
                    color: _isFlashOn
                        ? AppTheme.lightTheme.colorScheme.primary
                            .withValues(alpha: 0.8)
                        : Colors.black.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: CustomIconWidget(
                    iconName: _isFlashOn ? 'flash_on' : 'flash_off',
                    color: Colors.white,
                    size: 6.w,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomInstructions() {
    return Positioned(
      bottom: 8.h,
      left: 0,
      right: 0,
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 6.w),
            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Text(
                  _isScanning ? 'Align barcode within frame' : 'Processing...',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 1.h),
                Text(
                  _isScanning
                      ? 'Hold your device steady and ensure good lighting'
                      : 'Looking up product information',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          SizedBox(height: 2.h),

          // Manual entry option
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/add-edit-item');
            },
            style: TextButton.styleFrom(
              backgroundColor: Colors.black.withValues(alpha: 0.5),
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.5.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomIconWidget(
                  iconName: 'edit',
                  color: Colors.white,
                  size: 4.w,
                ),
                SizedBox(width: 2.w),
                Text(
                  'Enter Manually',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingOverlay() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.black.withValues(alpha: 0.8),
      child: Center(
        child: Container(
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 12.w,
                height: 6.h,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppTheme.lightTheme.colorScheme.primary,
                  ),
                ),
              ),
              SizedBox(height: 3.h),
              Text(
                'Looking up product...',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 1.h),
              Text(
                'Please wait while we find your item',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
