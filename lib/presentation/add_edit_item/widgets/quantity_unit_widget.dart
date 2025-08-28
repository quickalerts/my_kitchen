import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class QuantityUnitWidget extends StatefulWidget {
  final double? initialQuantity;
  final String? initialUnit;
  final Function(double?) onQuantityChanged;
  final Function(String) onUnitChanged;

  const QuantityUnitWidget({
    Key? key,
    this.initialQuantity,
    this.initialUnit,
    required this.onQuantityChanged,
    required this.onUnitChanged,
  }) : super(key: key);

  @override
  State<QuantityUnitWidget> createState() => _QuantityUnitWidgetState();
}

class _QuantityUnitWidgetState extends State<QuantityUnitWidget> {
  final TextEditingController _quantityController = TextEditingController();
  String _selectedUnit = 'pieces';

  final List<Map<String, dynamic>> _units = [
    {'value': 'pieces', 'label': 'Pieces', 'icon': 'inventory'},
    {'value': 'lbs', 'label': 'Pounds (lbs)', 'icon': 'scale'},
    {'value': 'oz', 'label': 'Ounces (oz)', 'icon': 'scale'},
    {'value': 'kg', 'label': 'Kilograms (kg)', 'icon': 'scale'},
    {'value': 'g', 'label': 'Grams (g)', 'icon': 'scale'},
    {'value': 'cups', 'label': 'Cups', 'icon': 'local_cafe'},
    {'value': 'ml', 'label': 'Milliliters (ml)', 'icon': 'local_drink'},
    {'value': 'l', 'label': 'Liters (l)', 'icon': 'local_drink'},
    {'value': 'gallons', 'label': 'Gallons', 'icon': 'local_drink'},
    {'value': 'tbsp', 'label': 'Tablespoons', 'icon': 'restaurant'},
    {'value': 'tsp', 'label': 'Teaspoons', 'icon': 'restaurant'},
    {'value': 'boxes', 'label': 'Boxes', 'icon': 'inventory_2'},
    {'value': 'cans', 'label': 'Cans', 'icon': 'sports_bar'},
    {'value': 'bottles', 'label': 'Bottles', 'icon': 'local_drink'},
    {'value': 'bags', 'label': 'Bags', 'icon': 'shopping_bag'},
  ];

  @override
  void initState() {
    super.initState();
    if (widget.initialQuantity != null) {
      _quantityController.text = widget.initialQuantity!.toString();
    }
    if (widget.initialUnit != null) {
      _selectedUnit = widget.initialUnit!;
    }
  }

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

  void _showUnitPicker() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        height: 60.h,
        padding: EdgeInsets.all(4.w),
        child: Column(
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              'Select Unit',
              style: AppTheme.lightTheme.textTheme.titleLarge,
            ),
            SizedBox(height: 3.h),
            Expanded(
              child: ListView.builder(
                itemCount: _units.length,
                itemBuilder: (context, index) {
                  final unit = _units[index];
                  final isSelected = _selectedUnit == unit['value'];

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedUnit = unit['value'] as String;
                      });
                      widget.onUnitChanged(_selectedUnit);
                      Navigator.pop(context);
                    },
                    child: Container(
                      margin: EdgeInsets.only(bottom: 1.h),
                      padding:
                          EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppTheme.lightTheme.primaryColor
                                .withValues(alpha: 0.1)
                            : AppTheme.lightTheme.colorScheme.surface,
                        border: Border.all(
                          color: isSelected
                              ? AppTheme.lightTheme.primaryColor
                              : AppTheme.lightTheme.colorScheme.outline,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          CustomIconWidget(
                            iconName: unit['icon'] as String,
                            color: isSelected
                                ? AppTheme.lightTheme.primaryColor
                                : AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                            size: 6.w,
                          ),
                          SizedBox(width: 3.w),
                          Expanded(
                            child: Text(
                              unit['label'] as String,
                              style: AppTheme.lightTheme.textTheme.bodyLarge
                                  ?.copyWith(
                                color: isSelected
                                    ? AppTheme.lightTheme.primaryColor
                                    : AppTheme.lightTheme.colorScheme.onSurface,
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                              ),
                            ),
                          ),
                          if (isSelected)
                            CustomIconWidget(
                              iconName: 'check',
                              color: AppTheme.lightTheme.primaryColor,
                              size: 6.w,
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getUnitLabel(String value) {
    final unit = _units.firstWhere(
      (unit) => unit['value'] == value,
      orElse: () => {'label': value},
    );
    return unit['label'] as String;
  }

  String _getUnitIcon(String value) {
    final unit = _units.firstWhere(
      (unit) => unit['value'] == value,
      orElse: () => {'icon': 'inventory'},
    );
    return unit['icon'] as String;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quantity *',
          style: AppTheme.lightTheme.textTheme.titleMedium,
        ),
        SizedBox(height: 1.h),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: TextFormField(
                controller: _quantityController,
                decoration: InputDecoration(
                  hintText: '0.0',
                  prefixIcon: Padding(
                    padding: EdgeInsets.all(3.w),
                    child: CustomIconWidget(
                      iconName: 'numbers',
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 6.w,
                    ),
                  ),
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Quantity is required';
                  }
                  final quantity = double.tryParse(value);
                  if (quantity == null || quantity <= 0) {
                    return 'Enter valid quantity';
                  }
                  return null;
                },
                onChanged: (value) {
                  final quantity = double.tryParse(value);
                  widget.onQuantityChanged(quantity);
                },
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              flex: 3,
              child: GestureDetector(
                onTap: _showUnitPicker,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 3.h),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: AppTheme.lightTheme.colorScheme.outline,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      CustomIconWidget(
                        iconName: _getUnitIcon(_selectedUnit),
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        size: 6.w,
                      ),
                      SizedBox(width: 2.w),
                      Expanded(
                        child: Text(
                          _getUnitLabel(_selectedUnit),
                          style: AppTheme.lightTheme.textTheme.bodyLarge,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      CustomIconWidget(
                        iconName: 'keyboard_arrow_down',
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        size: 6.w,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        if (_quantityController.text.isNotEmpty) ...[
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
                Text(
                  'Total: ${_quantityController.text} ${_getUnitLabel(_selectedUnit)}',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.tertiary,
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
