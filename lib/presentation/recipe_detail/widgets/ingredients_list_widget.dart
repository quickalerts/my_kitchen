import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class IngredientsListWidget extends StatefulWidget {
  final List<Map<String, dynamic>> ingredients;
  final VoidCallback onAddMissingToShoppingList;

  const IngredientsListWidget({
    super.key,
    required this.ingredients,
    required this.onAddMissingToShoppingList,
  });

  @override
  State<IngredientsListWidget> createState() => _IngredientsListWidgetState();
}

class _IngredientsListWidgetState extends State<IngredientsListWidget> {
  final List<bool> _checkedItems = [];

  @override
  void initState() {
    super.initState();
    _checkedItems.addAll(List.filled(widget.ingredients.length, false));
  }

  @override
  Widget build(BuildContext context) {
    final missingItems =
        widget.ingredients.where((item) => !item['owned']).length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Ingredients',
              style: GoogleFonts.inter(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            Text(
              '${widget.ingredients.length} items',
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        SizedBox(height: 2.h),
        ...widget.ingredients.asMap().entries.map((entry) {
          final index = entry.key;
          final ingredient = entry.value;
          return _buildIngredientItem(ingredient, index);
        }).toList(),
        if (missingItems > 0) ...[
          SizedBox(height: 2.h),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: widget.onAddMissingToShoppingList,
              icon: const Icon(Icons.shopping_cart),
              label: Text('Add Missing to Shopping List ($missingItems items)'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 1.5.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildIngredientItem(Map<String, dynamic> ingredient, int index) {
    final isOwned = ingredient['owned'] as bool;
    final stock = ingredient['stock'] as String;

    return Container(
      margin: EdgeInsets.only(bottom: 1.h),
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: _checkedItems[index] ? Colors.grey[100] : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey[300]!,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Checkbox(
            value: _checkedItems[index],
            onChanged: (value) {
              setState(() {
                _checkedItems[index] = value ?? false;
              });
            },
            activeColor: Colors.green,
          ),
          SizedBox(width: 2.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${ingredient['quantity']} ${ingredient['name']}',
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: _checkedItems[index]
                        ? Colors.grey[600]
                        : Colors.black87,
                    decoration: _checkedItems[index]
                        ? TextDecoration.lineThrough
                        : null,
                  ),
                ),
                if (!isOwned)
                  Text(
                    'Not in inventory',
                    style: GoogleFonts.inter(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.red[600],
                    ),
                  ),
              ],
            ),
          ),
          _buildStockIndicator(isOwned, stock),
        ],
      ),
    );
  }

  Widget _buildStockIndicator(bool isOwned, String stock) {
    if (!isOwned) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
        decoration: BoxDecoration(
          color: Colors.red[100],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          Icons.close,
          color: Colors.red[600],
          size: 16.sp,
        ),
      );
    }

    Color color;
    IconData icon;

    switch (stock) {
      case 'high':
        color = Colors.green;
        icon = Icons.check_circle;
        break;
      case 'medium':
        color = Colors.green;
        icon = Icons.check;
        break;
      case 'low':
        color = Colors.orange;
        icon = Icons.warning;
        break;
      default:
        color = Colors.grey;
        icon = Icons.help_outline;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
      decoration: BoxDecoration(
        color: color.withAlpha(26),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        icon,
        color: color,
        size: 16.sp,
      ),
    );
  }
}
