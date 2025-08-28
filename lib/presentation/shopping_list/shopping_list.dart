import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/add_item_dialog.dart';
import './widgets/category_section.dart';
import './widgets/sort_filter_bottom_sheet.dart';

class ShoppingList extends StatefulWidget {
  const ShoppingList({Key? key}) : super(key: key);

  @override
  State<ShoppingList> createState() => _ShoppingListState();
}

class _ShoppingListState extends State<ShoppingList> {
  List<Map<String, dynamic>> _shoppingItems = [];
  List<Map<String, dynamic>> _completedItems = [];
  String _currentSort = 'category';
  bool _isLoading = false;
  final ScrollController _scrollController = ScrollController();

  // Mock data for shopping list items
  final List<Map<String, dynamic>> _mockShoppingItems = [
    {
      'id': '1',
      'name': 'Organic Bananas',
      'quantity': '6 pieces',
      'category': 'Produce',
      'source': 'Banana Bread Recipe',
      'note': '',
      'estimatedPrice': '\$2.99',
      'isCompleted': false,
    },
    {
      'id': '2',
      'name': 'Whole Milk',
      'quantity': '1 gallon',
      'category': 'Dairy',
      'source': 'Low Stock',
      'note': 'Get organic if available',
      'estimatedPrice': '\$3.49',
      'isCompleted': false,
    },
    {
      'id': '3',
      'name': 'Chicken Breast',
      'quantity': '2 lbs',
      'category': 'Meat',
      'source': 'Grilled Chicken Recipe',
      'note': 'Boneless, skinless',
      'estimatedPrice': '\$8.99',
      'isCompleted': false,
    },
    {
      'id': '4',
      'name': 'Brown Rice',
      'quantity': '1 bag',
      'category': 'Pantry',
      'source': 'Low Stock',
      'note': '',
      'estimatedPrice': '\$2.49',
      'isCompleted': false,
    },
    {
      'id': '5',
      'name': 'Greek Yogurt',
      'quantity': '32 oz',
      'category': 'Dairy',
      'source': 'Smoothie Recipe',
      'note': 'Plain, no sugar',
      'estimatedPrice': '\$4.99',
      'isCompleted': false,
    },
    {
      'id': '6',
      'name': 'Fresh Spinach',
      'quantity': '1 bag',
      'category': 'Produce',
      'source': 'Salad Recipe',
      'note': '',
      'estimatedPrice': '\$2.99',
      'isCompleted': false,
    },
    {
      'id': '7',
      'name': 'Sourdough Bread',
      'quantity': '1 loaf',
      'category': 'Bakery',
      'source': 'Manual',
      'note': 'Sliced',
      'estimatedPrice': '\$3.99',
      'isCompleted': false,
    },
    {
      'id': '8',
      'name': 'Frozen Berries',
      'quantity': '1 bag',
      'category': 'Frozen',
      'source': 'Smoothie Recipe',
      'note': 'Mixed berries',
      'estimatedPrice': '\$4.49',
      'isCompleted': false,
    },
  ];

  final List<String> _itemSuggestions = [
    'Apples',
    'Bananas',
    'Oranges',
    'Milk',
    'Eggs',
    'Bread',
    'Chicken',
    'Rice',
    'Pasta',
    'Tomatoes',
    'Onions',
    'Potatoes',
    'Cheese',
    'Yogurt',
    'Butter',
    'Olive Oil',
    'Salt',
    'Pepper',
    'Garlic',
    'Carrots',
    'Broccoli',
    'Spinach',
  ];

  @override
  void initState() {
    super.initState();
    _loadShoppingList();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadShoppingList() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate loading delay
    await Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _shoppingItems = List.from(_mockShoppingItems);
        _isLoading = false;
      });
    });
  }

  Future<void> _refreshList() async {
    HapticFeedback.lightImpact();
    setState(() {
      _isLoading = true;
    });

    // Simulate refresh
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _isLoading = false;
    });

    Fluttertoast.showToast(
      msg: "Shopping list updated",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void _toggleItemComplete(Map<String, dynamic> item) {
    HapticFeedback.selectionClick();

    setState(() {
      if (_shoppingItems.contains(item)) {
        _shoppingItems.remove(item);
        _completedItems.add(item);
      } else if (_completedItems.contains(item)) {
        _completedItems.remove(item);
        _shoppingItems.add(item);
      }
    });
  }

  void _editItem(Map<String, dynamic> item) {
    _showEditItemDialog(item);
  }

  void _addNoteToItem(Map<String, dynamic> item) {
    _showAddNoteDialog(item);
  }

  void _removeItem(Map<String, dynamic> item) {
    HapticFeedback.mediumImpact();

    setState(() {
      _shoppingItems.remove(item);
      _completedItems.remove(item);
    });

    // Show undo snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${item['name']} removed'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              if (item['isCompleted'] == true) {
                _completedItems.add(item);
              } else {
                _shoppingItems.add(item);
              }
            });
          },
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _addNewItem(Map<String, dynamic> newItem) {
    setState(() {
      _shoppingItems.add(newItem);
    });

    Fluttertoast.showToast(
      msg: "${newItem['name']} added to list",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void _clearCompleted() {
    if (_completedItems.isEmpty) return;

    HapticFeedback.mediumImpact();

    final completedCount = _completedItems.length;
    setState(() {
      _completedItems.clear();
    });

    Fluttertoast.showToast(
      msg: "$completedCount completed items cleared",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void _shareShoppingList() {
    final activeItems = _shoppingItems
        .map((item) => '• ${item['name']} (${item['quantity']})')
        .join('\n');
    final completedItems = _completedItems
        .map((item) => '✓ ${item['name']} (${item['quantity']})')
        .join('\n');

    final shareText = '''
My Shopping List

TO BUY:
$activeItems

${completedItems.isNotEmpty ? '\nCOMPLETED:\n$completedItems' : ''}

Generated by My Kitchen App
''';

    // In a real app, you would use the share plugin
    Fluttertoast.showToast(
      msg: "Share functionality would open here",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void _showAddItemDialog() {
    showDialog(
      context: context,
      builder: (context) => AddItemDialog(
        onAddItem: _addNewItem,
        suggestions: _itemSuggestions,
      ),
    );
  }

  void _showEditItemDialog(Map<String, dynamic> item) {
    final nameController = TextEditingController(text: item['name'] as String);
    final quantityController =
        TextEditingController(text: item['quantity'] as String);

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          padding: EdgeInsets.all(6.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Edit Item',
                style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 3.h),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Item Name',
                ),
              ),
              SizedBox(height: 2.h),
              TextField(
                controller: quantityController,
                decoration: const InputDecoration(
                  labelText: 'Quantity',
                ),
              ),
              SizedBox(height: 4.h),
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
                      onPressed: () {
                        setState(() {
                          item['name'] = nameController.text.trim();
                          item['quantity'] = quantityController.text.trim();
                        });
                        Navigator.of(context).pop();
                      },
                      child: const Text('Save'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddNoteDialog(Map<String, dynamic> item) {
    final noteController =
        TextEditingController(text: item['note'] as String? ?? '');

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          padding: EdgeInsets.all(6.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Add Note',
                style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 1.h),
              Text(
                'For: ${item['name']}',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
              SizedBox(height: 3.h),
              TextField(
                controller: noteController,
                decoration: const InputDecoration(
                  labelText: 'Note',
                  hintText: 'Add a note for this item...',
                ),
                maxLines: 3,
              ),
              SizedBox(height: 4.h),
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
                      onPressed: () {
                        setState(() {
                          item['note'] = noteController.text.trim();
                        });
                        Navigator.of(context).pop();
                      },
                      child: const Text('Save'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSortOptions() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => SortFilterBottomSheet(
        currentSortBy: _currentSort,
        onSortChanged: (sortBy) {
          setState(() {
            _currentSort = sortBy;
          });
          _sortItems();
        },
      ),
    );
  }

  void _sortItems() {
    setState(() {
      switch (_currentSort) {
        case 'alphabetical':
          _shoppingItems.sort(
              (a, b) => (a['name'] as String).compareTo(b['name'] as String));
          _completedItems.sort(
              (a, b) => (a['name'] as String).compareTo(b['name'] as String));
          break;
        case 'category':
          _shoppingItems.sort((a, b) =>
              (a['category'] as String).compareTo(b['category'] as String));
          _completedItems.sort((a, b) =>
              (a['category'] as String).compareTo(b['category'] as String));
          break;
        case 'priority':
          // Sort by source priority (recipe items first, then low stock, then manual)
          _shoppingItems.sort((a, b) {
            final sourceA = a['source'] as String;
            final sourceB = b['source'] as String;
            if (sourceA.contains('Recipe') && !sourceB.contains('Recipe'))
              return -1;
            if (!sourceA.contains('Recipe') && sourceB.contains('Recipe'))
              return 1;
            if (sourceA == 'Low Stock' && sourceB != 'Low Stock') return -1;
            if (sourceA != 'Low Stock' && sourceB == 'Low Stock') return 1;
            return 0;
          });
          break;
        case 'store_layout':
          // Sort by typical store layout order
          final storeOrder = [
            'Produce',
            'Dairy',
            'Meat',
            'Frozen',
            'Pantry',
            'Bakery',
            'Other'
          ];
          _shoppingItems.sort((a, b) {
            final indexA = storeOrder.indexOf(a['category'] as String);
            final indexB = storeOrder.indexOf(b['category'] as String);
            return indexA.compareTo(indexB);
          });
          break;
      }
    });
  }

  Map<String, List<Map<String, dynamic>>> _groupItemsByCategory() {
    final Map<String, List<Map<String, dynamic>>> grouped = {};

    for (final item in _shoppingItems) {
      final category = item['category'] as String;
      grouped[category] = grouped[category] ?? [];
      grouped[category]!.add(item);
    }

    return grouped;
  }

  Map<String, List<Map<String, dynamic>>> _groupCompletedItemsByCategory() {
    final Map<String, List<Map<String, dynamic>>> grouped = {};

    for (final item in _completedItems) {
      final category = item['category'] as String;
      grouped[category] = grouped[category] ?? [];
      grouped[category]!.add(item);
    }

    return grouped;
  }

  double _calculateEstimatedTotal() {
    double total = 0.0;
    for (final item in _shoppingItems) {
      final priceStr =
          (item['estimatedPrice'] as String? ?? '\$0.00').replaceAll('\$', '');
      total += double.tryParse(priceStr) ?? 0.0;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    final groupedItems = _groupItemsByCategory();
    final groupedCompletedItems = _groupCompletedItemsByCategory();
    final estimatedTotal = _calculateEstimatedTotal();

    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Shopping List'),
            Text(
              '${_shoppingItems.length} items to buy',
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: _showSortOptions,
            icon: CustomIconWidget(
              iconName: 'sort',
              color: AppTheme.lightTheme.colorScheme.onSurface,
              size: 24,
            ),
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'share':
                  _shareShoppingList();
                  break;
                case 'clear_completed':
                  _clearCompleted();
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'share',
                child: Row(
                  children: [
                    Icon(Icons.share),
                    SizedBox(width: 8),
                    Text('Share List'),
                  ],
                ),
              ),
              if (_completedItems.isNotEmpty)
                const PopupMenuItem(
                  value: 'clear_completed',
                  child: Row(
                    children: [
                      Icon(Icons.clear_all),
                      SizedBox(width: 8),
                      Text('Clear Completed'),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _refreshList,
              child: CustomScrollView(
                controller: _scrollController,
                slivers: [
                  // Estimated total section
                  if (_shoppingItems.isNotEmpty)
                    SliverToBoxAdapter(
                      child: Container(
                        margin: EdgeInsets.all(4.w),
                        padding: EdgeInsets.all(4.w),
                        decoration: BoxDecoration(
                          color: AppTheme.lightTheme.colorScheme.primary
                              .withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppTheme.lightTheme.colorScheme.primary
                                .withValues(alpha: 0.3),
                          ),
                        ),
                        child: Row(
                          children: [
                            CustomIconWidget(
                              iconName: 'account_balance_wallet',
                              color: AppTheme.lightTheme.colorScheme.primary,
                              size: 24,
                            ),
                            SizedBox(width: 3.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Estimated Total',
                                    style: AppTheme
                                        .lightTheme.textTheme.titleSmall
                                        ?.copyWith(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    'Based on average prices',
                                    style: AppTheme
                                        .lightTheme.textTheme.bodySmall
                                        ?.copyWith(
                                      color: AppTheme.lightTheme.colorScheme
                                          .onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              '\$${estimatedTotal.toStringAsFixed(2)}',
                              style: AppTheme.lightTheme.textTheme.headlineSmall
                                  ?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: AppTheme.lightTheme.colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  // Shopping items by category
                  if (_shoppingItems.isNotEmpty || _completedItems.isNotEmpty)
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final categories = groupedItems.keys.toList();
                          categories.addAll(groupedCompletedItems.keys
                              .where((cat) => !categories.contains(cat)));

                          if (index >= categories.length) return null;

                          final category = categories[index];
                          final activeItems = groupedItems[category] ?? [];
                          final completedItems =
                              groupedCompletedItems[category] ?? [];

                          return CategorySection(
                            categoryName: category,
                            items: activeItems,
                            completedItems: completedItems,
                            onToggleComplete: _toggleItemComplete,
                            onEditItem: _editItem,
                            onAddNote: _addNoteToItem,
                            onRemoveItem: _removeItem,
                          );
                        },
                        childCount: groupedItems.keys.length +
                            groupedCompletedItems.keys
                                .where((cat) => !groupedItems.containsKey(cat))
                                .length,
                      ),
                    ),
                  // Empty state
                  if (_shoppingItems.isEmpty && _completedItems.isEmpty)
                    SliverFillRemaining(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomIconWidget(
                              iconName: 'shopping_cart',
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                              size: 64,
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              'Your shopping list is empty',
                              style: AppTheme.lightTheme.textTheme.headlineSmall
                                  ?.copyWith(
                                color: AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                            SizedBox(height: 1.h),
                            Text(
                              'Add items manually or from your recipes',
                              style: AppTheme.lightTheme.textTheme.bodyMedium
                                  ?.copyWith(
                                color: AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 4.h),
                            ElevatedButton.icon(
                              onPressed: _showAddItemDialog,
                              icon: CustomIconWidget(
                                iconName: 'add',
                                color: Colors.white,
                                size: 20,
                              ),
                              label: const Text('Add First Item'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  // Bottom padding for FAB
                  SliverToBoxAdapter(
                    child: SizedBox(height: 10.h),
                  ),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddItemDialog,
        icon: CustomIconWidget(
          iconName: 'add',
          color: Colors.white,
          size: 24,
        ),
        label: const Text('Add Item'),
      ),
    );
  }
}