import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class BarcodeSectionWidget extends StatefulWidget {
  final String? initialBarcode;
  final Function(String?) onBarcodeChanged;

  const BarcodeSectionWidget({
    Key? key,
    this.initialBarcode,
    required this.onBarcodeChanged,
  }) : super(key: key);

  @override
  State<BarcodeSectionWidget> createState() => _BarcodeSectionWidgetState();
}

class _BarcodeSectionWidgetState extends State<BarcodeSectionWidget> {
  final TextEditingController _barcodeController = TextEditingController();
  bool _showScanner = false;
  MobileScannerController? _scannerController;

  @override
  void initState() {
    super.initState();
    _barcodeController.text = widget.initialBarcode ?? '';
  }

  @override
  void dispose() {
    _barcodeController.dispose();
    _scannerController?.dispose();
    super.dispose();
  }

  void _startScanning() {
    setState(() {
      _showScanner = true;
      _scannerController = MobileScannerController();
    });
  }

  void _stopScanning() {
    setState(() {
      _showScanner = false;
    });
    _scannerController?.dispose();
    _scannerController = null;
  }

  void _onBarcodeDetected(BarcodeCapture capture) {
    final List<Barcode> barcodes = capture.barcodes;
    if (barcodes.isNotEmpty) {
      final String? code = barcodes.first.rawValue;
      if (code != null && code.isNotEmpty) {
        setState(() {
          _barcodeController.text = code;
          _showScanner = false;
        });
        _scannerController?.dispose();
        _scannerController = null;
        widget.onBarcodeChanged(code);
        _lookupProduct(code);
      }
    }
  }

  Future<void> _lookupProduct(String barcode) async {
    // Mock product lookup - in real app, this would call an API
    await Future.delayed(Duration(milliseconds: 500));

    final Map<String, dynamic> mockProducts = {
      '123456789012': {
        'name': 'Organic Bananas',
        'category': 'Fruits',
        'unit': 'lbs',
      },
      '987654321098': {
        'name': 'Whole Milk',
        'category': 'Dairy',
        'unit': 'gallons',
      },
      '456789123456': {
        'name': 'Bread Loaf',
        'category': 'Bakery',
        'unit': 'pieces',
      },
    };

    if (mockProducts.containsKey(barcode)) {
      final product = mockProducts[barcode] as Map<String, dynamic>;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Product found: ${product['name']}'),
          backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Product not found in database'),
          backgroundColor: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
        ),
      );
    }
  }

  Widget _buildBarcodeScanner() {
    return Container(
      height: 40.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: MobileScanner(
              controller: _scannerController,
              onDetect: _onBarcodeDetected,
            ),
          ),
          Positioned(
            top: 2.h,
            left: 4.w,
            child: GestureDetector(
              onTap: _stopScanning,
              child: Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.5),
                  shape: BoxShape.circle,
                ),
                child: CustomIconWidget(
                  iconName: 'close',
                  color: Colors.white,
                  size: 6.w,
                ),
              ),
            ),
          ),
          Center(
            child: Container(
              width: 60.w,
              height: 30.h,
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppTheme.lightTheme.primaryColor,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          Positioned(
            bottom: 4.h,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Position barcode within the frame',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_showScanner) {
      return _buildBarcodeScanner();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Barcode (Optional)',
          style: AppTheme.lightTheme.textTheme.titleMedium,
        ),
        SizedBox(height: 1.h),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _barcodeController,
                decoration: InputDecoration(
                  hintText: 'Enter or scan barcode',
                  prefixIcon: Padding(
                    padding: EdgeInsets.all(3.w),
                    child: CustomIconWidget(
                      iconName: 'qr_code',
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 6.w,
                    ),
                  ),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  widget.onBarcodeChanged(value.isEmpty ? null : value);
                },
              ),
            ),
            SizedBox(width: 3.w),
            GestureDetector(
              onTap: _startScanning,
              child: Container(
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.primaryColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: CustomIconWidget(
                  iconName: 'qr_code_scanner',
                  color: Colors.white,
                  size: 6.w,
                ),
              ),
            ),
          ],
        ),
        if (_barcodeController.text.isNotEmpty) ...[
          SizedBox(height: 1.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.tertiary
                  .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppTheme.lightTheme.colorScheme.tertiary
                    .withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'check_circle',
                  color: AppTheme.lightTheme.colorScheme.tertiary,
                  size: 5.w,
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: Text(
                    'Barcode: ${_barcodeController.text}',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.tertiary,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _barcodeController.clear();
                    });
                    widget.onBarcodeChanged(null);
                  },
                  child: CustomIconWidget(
                    iconName: 'clear',
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 5.w,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}