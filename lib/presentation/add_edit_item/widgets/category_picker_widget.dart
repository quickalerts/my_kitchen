import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CategoryPickerWidget extends StatefulWidget {
  final String? selectedCategory;
  final Function(String) onCategorySelected;

  const CategoryPickerWidget({
    Key? key,
    this.selectedCategory,
    required this.onCategorySelected,
  }) : super(key: key);

  @override
  State<CategoryPickerWidget> createState() => _CategoryPickerWidgetState();
}

class _CategoryPickerWidgetState extends State<CategoryPickerWidget> {
  final List<Map<String, dynamic>> _categories = [
    {'name': 'Fruits', 'icon': 'apple', 'color': Colors.red},
    {'name': 'Vegetables', 'icon': 'eco', 'color': Colors.green},
    {'name': 'Dairy', 'icon': 'local_drink', 'color': Colors.blue},
    {'name': 'Meat', 'icon': 'restaurant', 'color': Colors.brown},
    {'name': 'Bakery', 'icon': 'cake', 'color': Colors.orange},
    {'name': 'Pantry', 'icon': 'kitchen', 'color': Colors.purple},
    {'name': 'Frozen', 'icon': 'ac_unit', 'color': Colors.cyan},
    {'name': 'Beverages', 'icon': 'local_cafe', 'color': Colors.amber},
    {'name': 'Snacks', 'icon': 'fastfood', 'color': Colors.deepOrange},
    {'name': 'Condiments', 'icon': 'local_dining', 'color': Colors.teal},
  ];

  List<Map<String, dynamic>> _customCategories = [];
  final TextEditingController _customCategoryController =
      TextEditingController();

  @override
  void dispose() {
    _customCategoryController.dispose();
    super.dispose();
  }

  void _showCategoryPicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          height: 70.h,
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
                'Select Category',
                style: AppTheme.lightTheme.textTheme.titleLarge,
              ),
              SizedBox(height: 3.h),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Default Categories',
                        style: AppTheme.lightTheme.textTheme.titleMedium,
                      ),
                      SizedBox(height: 2.h),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 3,
                          crossAxisSpacing: 3.w,
                          mainAxisSpacing: 2.h,
                        ),
                        itemCount: _categories.length,
                        itemBuilder: (context, index) {
                          final category = _categories[index];
                          final isSelected =
                              widget.selectedCategory == category['name'];

                          return GestureDetector(
                            onTap: () {
                              widget.onCategorySelected(
                                  category['name'] as String);
                              Navigator.pop(context);
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 3.w, vertical: 1.h),
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
                                    iconName: category['icon'] as String,
                                    color: category['color'] as Color,
                                    size: 6.w,
                                  ),
                                  SizedBox(width: 2.w),
                                  Expanded(
                                    child: Text(
                                      category['name'] as String,
                                      style: AppTheme
                                          .lightTheme.textTheme.bodyMedium
                                          ?.copyWith(
                                        color: isSelected
                                            ? AppTheme.lightTheme.primaryColor
                                            : AppTheme.lightTheme.colorScheme
                                                .onSurface,
                                        fontWeight: isSelected
                                            ? FontWeight.w600
                                            : FontWeight.w400,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                      if (_customCategories.isNotEmpty) ...[
                        SizedBox(height: 3.h),
                        Text(
                          'Custom Categories',
                          style: AppTheme.lightTheme.textTheme.titleMedium,
                        ),
                        SizedBox(height: 2.h),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: _customCategories.length,
                          itemBuilder: (context, index) {
                            final category = _customCategories[index];
                            final isSelected =
                                widget.selectedCategory == category['name'];

                            return GestureDetector(
                              onTap: () {
                                widget.onCategorySelected(
                                    category['name'] as String);
                                Navigator.pop(context);
                              },
                              child: Container(
                                margin: EdgeInsets.only(bottom: 1.h),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 3.w, vertical: 2.h),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppTheme.lightTheme.primaryColor
                                          .withValues(alpha: 0.1)
                                      : AppTheme.lightTheme.colorScheme.surface,
                                  border: Border.all(
                                    color: isSelected
                                        ? AppTheme.lightTheme.primaryColor
                                        : AppTheme
                                            .lightTheme.colorScheme.outline,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    CustomIconWidget(
                                      iconName: 'label',
                                      color: AppTheme
                                          .lightTheme.colorScheme.secondary,
                                      size: 6.w,
                                    ),
                                    SizedBox(width: 3.w),
                                    Expanded(
                                      child: Text(
                                        category['name'] as String,
                                        style: AppTheme
                                            .lightTheme.textTheme.bodyMedium
                                            ?.copyWith(
                                          color: isSelected
                                              ? AppTheme.lightTheme.primaryColor
                                              : AppTheme.lightTheme.colorScheme
                                                  .onSurface,
                                          fontWeight: isSelected
                                              ? FontWeight.w600
                                              : FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        setModalState(() {
                                          _customCategories.removeAt(index);
                                        });
                                      },
                                      child: CustomIconWidget(
                                        iconName: 'delete',
                                        color: AppTheme
                                            .lightTheme.colorScheme.error,
                                        size: 5.w,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                      SizedBox(height: 3.h),
                      Text(
                        'Add Custom Category',
                        style: AppTheme.lightTheme.textTheme.titleMedium,
                      ),
                      SizedBox(height: 2.h),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _customCategoryController,
                              decoration: InputDecoration(
                                hintText: 'Enter category name',
                                prefixIcon: Padding(
                                  padding: EdgeInsets.all(3.w),
                                  child: CustomIconWidget(
                                    iconName: 'add',
                                    color: AppTheme.lightTheme.colorScheme
                                        .onSurfaceVariant,
                                    size: 6.w,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 3.w),
                          GestureDetector(
                            onTap: () {
                              final categoryName =
                                  _customCategoryController.text.trim();
                              if (categoryName.isNotEmpty) {
                                final exists = _categories.any(
                                        (cat) => cat['name'] == categoryName) ||
                                    _customCategories.any(
                                        (cat) => cat['name'] == categoryName);

                                if (!exists) {
                                  setModalState(() {
                                    _customCategories.add({
                                      'name': categoryName,
                                      'icon': 'label',
                                      'color': AppTheme
                                          .lightTheme.colorScheme.secondary,
                                    });
                                    _customCategoryController.clear();
                                  });
                                }
                              }
                            },
                            child: Container(
                              padding: EdgeInsets.all(3.w),
                              decoration: BoxDecoration(
                                color: AppTheme.lightTheme.primaryColor,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: CustomIconWidget(
                                iconName: 'add',
                                color: Colors.white,
                                size: 6.w,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Category *',
          style: AppTheme.lightTheme.textTheme.titleMedium,
        ),
        SizedBox(height: 1.h),
        GestureDetector(
          onTap: _showCategoryPicker,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 3.h),
            decoration: BoxDecoration(
              border: Border.all(
                color: AppTheme.lightTheme.colorScheme.outline,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                if (widget.selectedCategory != null) ...[
                  CustomIconWidget(
                    iconName: _categories.firstWhere(
                      (cat) => cat['name'] == widget.selectedCategory,
                      orElse: () => {
                        'icon': 'label',
                        'color': AppTheme.lightTheme.colorScheme.secondary
                      },
                    )['icon'] as String,
                    color: _categories.firstWhere(
                      (cat) => cat['name'] == widget.selectedCategory,
                      orElse: () => {
                        'icon': 'label',
                        'color': AppTheme.lightTheme.colorScheme.secondary
                      },
                    )['color'] as Color,
                    size: 6.w,
                  ),
                  SizedBox(width: 3.w),
                ],
                Expanded(
                  child: Text(
                    widget.selectedCategory ?? 'Select category',
                    style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                      color: widget.selectedCategory != null
                          ? AppTheme.lightTheme.colorScheme.onSurface
                          : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
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
      ],
    );
  }
}
