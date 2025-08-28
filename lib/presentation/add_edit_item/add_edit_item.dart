import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/barcode_section_widget.dart';
import './widgets/category_picker_widget.dart';
import './widgets/photo_section_widget.dart';
import './widgets/quantity_unit_widget.dart';

class AddEditItem extends StatefulWidget {
  final Map<String, dynamic>? existingItem;

  const AddEditItem({Key? key, this.existingItem}) : super(key: key);

  @override
  State<AddEditItem> createState() => _AddEditItemState();
}

class _AddEditItemState extends State<AddEditItem> {
  final _formKey = GlobalKey<FormState>();
  final _itemNameController = TextEditingController();
  final _notesController = TextEditingController();

  String? _selectedCategory;
  double? _quantity;
  String _selectedUnit = 'pieces';
  DateTime? _expirationDate;
  XFile? _selectedImage;
  String? _barcode;
  bool _isLoading = false;

  // Mock data for existing items
  final List<Map<String, dynamic>> _existingItems = [
    {
      'id': 1,
      'name': 'Organic Bananas',
      'category': 'Fruits',
      'quantity': 6.0,
      'unit': 'pieces',
      'expirationDate': DateTime.now().add(Duration(days: 5)),
      'barcode': '123456789012',
      'notes': 'Fresh from local farm',
      'imageUrl':
          'https://images.pexels.com/photos/2872755/pexels-photo-2872755.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
    },
    {
      'id': 2,
      'name': 'Whole Milk',
      'category': 'Dairy',
      'quantity': 1.0,
      'unit': 'gallons',
      'expirationDate': DateTime.now().add(Duration(days: 7)),
      'barcode': '987654321098',
      'notes': 'Organic, grass-fed',
      'imageUrl':
          'https://images.pexels.com/photos/248412/pexels-photo-248412.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
    },
  ];

  @override
  void initState() {
    super.initState();
    _initializeForm();
  }

  @override
  void dispose() {
    _itemNameController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _initializeForm() {
    if (widget.existingItem != null) {
      final item = widget.existingItem!;
      _itemNameController.text = item['name'] ?? '';
      _selectedCategory = item['category'];
      _quantity = item['quantity']?.toDouble();
      _selectedUnit = item['unit'] ?? 'pieces';
      _expirationDate = item['expirationDate'];
      _barcode = item['barcode'];
      _notesController.text = item['notes'] ?? '';

      if (item['imageUrl'] != null) {
        _selectedImage = XFile(item['imageUrl']);
      }
    }
  }

  Future<void> _selectExpirationDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _expirationDate ?? DateTime.now().add(Duration(days: 7)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: AppTheme.lightTheme.colorScheme,
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _expirationDate) {
      setState(() {
        _expirationDate = picked;
      });
    }
  }

  String _formatDate(DateTime date) {
    return '${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}/${date.year}';
  }

  bool _validateForm() {
    if (_itemNameController.text.trim().isEmpty) {
      _showErrorMessage('Item name is required');
      return false;
    }

    if (_selectedCategory == null) {
      _showErrorMessage('Please select a category');
      return false;
    }

    if (_quantity == null || _quantity! <= 0) {
      _showErrorMessage('Please enter a valid quantity');
      return false;
    }

    return true;
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.lightTheme.colorScheme.error,
      ),
    );
  }

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
      ),
    );
  }

  Future<void> _saveItem() async {
    if (!_validateForm()) return;

    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(Duration(milliseconds: 1500));

    final itemData = {
      'id': widget.existingItem?['id'] ?? DateTime.now().millisecondsSinceEpoch,
      'name': _itemNameController.text.trim(),
      'category': _selectedCategory,
      'quantity': _quantity,
      'unit': _selectedUnit,
      'expirationDate': _expirationDate,
      'barcode': _barcode,
      'notes': _notesController.text.trim(),
      'imageUrl': _selectedImage?.path,
      'createdAt': DateTime.now(),
      'updatedAt': DateTime.now(),
    };

    setState(() {
      _isLoading = false;
    });

    final isEditing = widget.existingItem != null;
    _showSuccessMessage(
        isEditing ? 'Item updated successfully!' : 'Item added successfully!');

    // Navigate back with result
    Navigator.pop(context, itemData);
  }

  void _showDiscardDialog() {
    final hasChanges = _itemNameController.text.isNotEmpty ||
        _selectedCategory != null ||
        _quantity != null ||
        _selectedImage != null ||
        _barcode != null ||
        _notesController.text.isNotEmpty;

    if (!hasChanges) {
      Navigator.pop(context);
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Discard Changes?',
          style: AppTheme.lightTheme.textTheme.titleLarge,
        ),
        content: Text(
          'You have unsaved changes. Are you sure you want to discard them?',
          style: AppTheme.lightTheme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Keep Editing'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Close screen
            },
            style: TextButton.styleFrom(
              foregroundColor: AppTheme.lightTheme.colorScheme.error,
            ),
            child: Text('Discard'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.existingItem != null;

    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Item' : 'Add Item'),
        leading: IconButton(
          onPressed: _showDiscardDialog,
          icon: CustomIconWidget(
            iconName: 'close',
            color: AppTheme.lightTheme.colorScheme.onSurface,
            size: 6.w,
          ),
        ),
        actions: [
          if (isEditing)
            IconButton(
              onPressed: () {
                // Show delete confirmation
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Delete Item?'),
                    content: Text('This action cannot be undone.'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context); // Close dialog
                          Navigator.pop(context, {
                            'deleted': true
                          }); // Close screen with delete flag
                        },
                        style: TextButton.styleFrom(
                          foregroundColor:
                              AppTheme.lightTheme.colorScheme.error,
                        ),
                        child: Text('Delete'),
                      ),
                    ],
                  ),
                );
              },
              icon: CustomIconWidget(
                iconName: 'delete',
                color: AppTheme.lightTheme.colorScheme.error,
                size: 6.w,
              ),
            ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(4.w),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Item Name Field
                      Text(
                        'Item Name *',
                        style: AppTheme.lightTheme.textTheme.titleMedium,
                      ),
                      SizedBox(height: 1.h),
                      TextFormField(
                        controller: _itemNameController,
                        decoration: InputDecoration(
                          hintText: 'Enter item name',
                          prefixIcon: Padding(
                            padding: EdgeInsets.all(3.w),
                            child: CustomIconWidget(
                              iconName: 'inventory',
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                              size: 6.w,
                            ),
                          ),
                        ),
                        textCapitalization: TextCapitalization.words,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Item name is required';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 3.h),

                      // Category Picker
                      CategoryPickerWidget(
                        selectedCategory: _selectedCategory,
                        onCategorySelected: (category) {
                          setState(() {
                            _selectedCategory = category;
                          });
                        },
                      ),
                      SizedBox(height: 3.h),

                      // Quantity and Unit
                      QuantityUnitWidget(
                        initialQuantity: _quantity,
                        initialUnit: _selectedUnit,
                        onQuantityChanged: (quantity) {
                          setState(() {
                            _quantity = quantity;
                          });
                        },
                        onUnitChanged: (unit) {
                          setState(() {
                            _selectedUnit = unit;
                          });
                        },
                      ),
                      SizedBox(height: 3.h),

                      // Expiration Date
                      Text(
                        'Expiration Date (Optional)',
                        style: AppTheme.lightTheme.textTheme.titleMedium,
                      ),
                      SizedBox(height: 1.h),
                      GestureDetector(
                        onTap: _selectExpirationDate,
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                              horizontal: 4.w, vertical: 3.h),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: AppTheme.lightTheme.colorScheme.outline,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              CustomIconWidget(
                                iconName: 'calendar_today',
                                color: AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                                size: 6.w,
                              ),
                              SizedBox(width: 3.w),
                              Expanded(
                                child: Text(
                                  _expirationDate != null
                                      ? _formatDate(_expirationDate!)
                                      : 'Select expiration date',
                                  style: AppTheme.lightTheme.textTheme.bodyLarge
                                      ?.copyWith(
                                    color: _expirationDate != null
                                        ? AppTheme
                                            .lightTheme.colorScheme.onSurface
                                        : AppTheme.lightTheme.colorScheme
                                            .onSurfaceVariant,
                                  ),
                                ),
                              ),
                              if (_expirationDate != null)
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _expirationDate = null;
                                    });
                                  },
                                  child: CustomIconWidget(
                                    iconName: 'clear',
                                    color: AppTheme.lightTheme.colorScheme
                                        .onSurfaceVariant,
                                    size: 5.w,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 3.h),

                      // Photo Section
                      Text(
                        'Photo (Optional)',
                        style: AppTheme.lightTheme.textTheme.titleMedium,
                      ),
                      SizedBox(height: 1.h),
                      PhotoSectionWidget(
                        initialImage: _selectedImage,
                        onImageChanged: (image) {
                          setState(() {
                            _selectedImage = image;
                          });
                        },
                      ),
                      SizedBox(height: 3.h),

                      // Barcode Section
                      BarcodeSectionWidget(
                        initialBarcode: _barcode,
                        onBarcodeChanged: (barcode) {
                          setState(() {
                            _barcode = barcode;
                          });
                        },
                      ),
                      SizedBox(height: 3.h),

                      // Notes Field
                      Text(
                        'Notes (Optional)',
                        style: AppTheme.lightTheme.textTheme.titleMedium,
                      ),
                      SizedBox(height: 1.h),
                      TextFormField(
                        controller: _notesController,
                        decoration: InputDecoration(
                          hintText: 'Add any additional notes...',
                          prefixIcon: Padding(
                            padding: EdgeInsets.all(3.w),
                            child: CustomIconWidget(
                              iconName: 'note',
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                              size: 6.w,
                            ),
                          ),
                        ),
                        maxLines: 3,
                        textCapitalization: TextCapitalization.sentences,
                      ),
                      SizedBox(height: 4.h),
                    ],
                  ),
                ),
              ),
            ),

            // Bottom Action Bar
            Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface,
                border: Border(
                  top: BorderSide(
                    color: AppTheme.lightTheme.colorScheme.outline
                        .withValues(alpha: 0.3),
                  ),
                ),
              ),
              child: SafeArea(
                top: false,
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _saveItem,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 3.h),
                    ),
                    child: _isLoading
                        ? SizedBox(
                            height: 6.w,
                            width: 6.w,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                AppTheme.lightTheme.colorScheme.onPrimary,
                              ),
                            ),
                          )
                        : Text(
                            isEditing ? 'Update Item' : 'Save Item',
                            style: AppTheme.lightTheme.textTheme.labelLarge
                                ?.copyWith(
                              color: AppTheme.lightTheme.colorScheme.onPrimary,
                              fontSize: 16.sp,
                            ),
                          ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
