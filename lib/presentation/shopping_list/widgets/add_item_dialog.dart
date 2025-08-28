import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AddItemDialog extends StatefulWidget {
  final Function(Map<String, dynamic>) onAddItem;
  final List<String> suggestions;

  const AddItemDialog({
    Key? key,
    required this.onAddItem,
    required this.suggestions,
  }) : super(key: key);

  @override
  State<AddItemDialog> createState() => _AddItemDialogState();
}

class _AddItemDialogState extends State<AddItemDialog> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  String _selectedCategory = 'Produce';
  List<String> _filteredSuggestions = [];
  bool _showSuggestions = false;

  final List<String> _categories = [
    'Produce',
    'Dairy',
    'Pantry',
    'Meat',
    'Frozen',
    'Bakery',
    'Other'
  ];

  @override
  void initState() {
    super.initState();
    _quantityController.text = '1';
    _nameController.addListener(_onNameChanged);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _onNameChanged() {
    final query = _nameController.text.toLowerCase();
    if (query.isNotEmpty) {
      setState(() {
        _filteredSuggestions = widget.suggestions
            .where((suggestion) => suggestion.toLowerCase().contains(query))
            .take(5)
            .toList();
        _showSuggestions = _filteredSuggestions.isNotEmpty;
      });
    } else {
      setState(() {
        _showSuggestions = false;
        _filteredSuggestions = [];
      });
    }
  }

  void _selectSuggestion(String suggestion) {
    _nameController.text = suggestion;
    setState(() {
      _showSuggestions = false;
    });
  }

  void _addItem() {
    if (_nameController.text.trim().isEmpty) return;

    final newItem = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'name': _nameController.text.trim(),
      'quantity': _quantityController.text.trim().isEmpty
          ? '1'
          : _quantityController.text.trim(),
      'category': _selectedCategory,
      'source': 'Manual',
      'note': _noteController.text.trim(),
      'estimatedPrice': _getEstimatedPrice(_nameController.text.trim()),
      'isCompleted': false,
    };

    widget.onAddItem(newItem);
    Navigator.of(context).pop();
  }

  String _getEstimatedPrice(String itemName) {
    // Simple price estimation based on item name
    final name = itemName.toLowerCase();
    if (name.contains('milk') || name.contains('cheese')) return '\$3.99';
    if (name.contains('bread') || name.contains('loaf')) return '\$2.49';
    if (name.contains('apple') || name.contains('banana')) return '\$1.99';
    if (name.contains('chicken') || name.contains('beef')) return '\$8.99';
    if (name.contains('rice') || name.contains('pasta')) return '\$1.49';
    return '\$2.99';
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: 80.h,
          maxWidth: 90.w,
        ),
        padding: EdgeInsets.all(6.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'add_shopping_cart',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 24,
                ),
                SizedBox(width: 2.w),
                Text(
                  'Add Item',
                  style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: CustomIconWidget(
                    iconName: 'close',
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                ),
              ],
            ),
            SizedBox(height: 3.h),
            // Item name field with suggestions
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Item Name',
                  style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 1.h),
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    hintText: 'Enter item name',
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(3.w),
                      child: CustomIconWidget(
                        iconName: 'shopping_basket',
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        size: 20,
                      ),
                    ),
                  ),
                  textCapitalization: TextCapitalization.words,
                ),
                // Suggestions dropdown
                if (_showSuggestions)
                  Container(
                    margin: EdgeInsets.only(top: 1.h),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppTheme.lightTheme.colorScheme.outline
                            .withValues(alpha: 0.3),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.lightTheme.colorScheme.shadow,
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: _filteredSuggestions.map((suggestion) {
                        return InkWell(
                          onTap: () => _selectSuggestion(suggestion),
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(
                                horizontal: 4.w, vertical: 2.h),
                            child: Text(
                              suggestion,
                              style: AppTheme.lightTheme.textTheme.bodyMedium,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
              ],
            ),
            SizedBox(height: 2.h),
            // Quantity and Category row
            Row(
              children: [
                // Quantity field
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Quantity',
                        style:
                            AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 1.h),
                      TextField(
                        controller: _quantityController,
                        decoration: const InputDecoration(
                          hintText: '1',
                        ),
                        keyboardType: TextInputType.text,
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 4.w),
                // Category dropdown
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Category',
                        style:
                            AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 1.h),
                      DropdownButtonFormField<String>(
                        value: _selectedCategory,
                        decoration: const InputDecoration(),
                        items: _categories.map((category) {
                          return DropdownMenuItem(
                            value: category,
                            child: Text(category),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _selectedCategory = value;
                            });
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            // Note field
            Text(
              'Note (Optional)',
              style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 1.h),
            TextField(
              controller: _noteController,
              decoration: const InputDecoration(
                hintText: 'Add a note...',
              ),
              maxLines: 2,
            ),
            SizedBox(height: 4.h),
            // Action buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _addItem,
                    child: const Text('Add Item'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
