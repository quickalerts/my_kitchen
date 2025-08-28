import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/add_item_bottom_sheet.dart';
import './widgets/category_filter_chips.dart';
import './widgets/empty_inventory_state.dart';
import './widgets/inventory_item_card.dart';
import './widgets/inventory_search_bar.dart';
import './widgets/sort_filter_bottom_sheet.dart';

class InventoryManagement extends StatefulWidget {
  const InventoryManagement({Key? key}) : super(key: key);

  @override
  State<InventoryManagement> createState() => _InventoryManagementState();
}

class _InventoryManagementState extends State<InventoryManagement>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  String _selectedCategory = 'All';
  String _searchQuery = '';
  String _sortBy = 'name';
  bool _isAscending = true;
  bool _isMultiSelectMode = false;
  Set<int> _selectedItems = {};

  final List<String> _categories = [
    'All',
    'Vegetables',
    'Proteins',
    'Pantry',
    'Dairy',
  ];

  final List<Map<String, dynamic>> _inventoryItems = [
    {
      "id": 1,
      "name": "Fresh Tomatoes",
      "category": "Vegetables",
      "quantity": 8,
      "unit": "pcs",
      "expirationDate": "2025-09-02",
      "image":
          "https://images.pexels.com/photos/533280/pexels-photo-533280.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "dateAdded": "2025-08-25",
    },
    {
      "id": 2,
      "name": "Chicken Breast",
      "category": "Proteins",
      "quantity": 2,
      "unit": "lbs",
      "expirationDate": "2025-08-30",
      "image":
          "https://images.pexels.com/photos/616354/pexels-photo-616354.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "dateAdded": "2025-08-26",
    },
    {
      "id": 3,
      "name": "Whole Milk",
      "category": "Dairy",
      "quantity": 1,
      "unit": "gallon",
      "expirationDate": "2025-09-05",
      "image":
          "https://images.pexels.com/photos/248412/pexels-photo-248412.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "dateAdded": "2025-08-27",
    },
    {
      "id": 4,
      "name": "Brown Rice",
      "category": "Pantry",
      "quantity": 5,
      "unit": "lbs",
      "expirationDate": "2026-08-28",
      "image":
          "https://images.pexels.com/photos/723198/pexels-photo-723198.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "dateAdded": "2025-08-20",
    },
    {
      "id": 5,
      "name": "Fresh Spinach",
      "category": "Vegetables",
      "quantity": 3,
      "unit": "bunches",
      "expirationDate": "2025-08-29",
      "image":
          "https://images.pexels.com/photos/2325843/pexels-photo-2325843.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "dateAdded": "2025-08-28",
    },
    {
      "id": 6,
      "name": "Cheddar Cheese",
      "category": "Dairy",
      "quantity": 1,
      "unit": "block",
      "expirationDate": "2025-09-15",
      "image":
          "https://images.pexels.com/photos/773253/pexels-photo-773253.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "dateAdded": "2025-08-24",
    },
    {
      "id": 7,
      "name": "Olive Oil",
      "category": "Pantry",
      "quantity": 2,
      "unit": "bottles",
      "expirationDate": "2026-12-31",
      "image":
          "https://images.pexels.com/photos/33783/olive-oil-salad-dressing-cooking-olive.jpg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "dateAdded": "2025-08-15",
    },
    {
      "id": 8,
      "name": "Ground Beef",
      "category": "Proteins",
      "quantity": 1.5,
      "unit": "lbs",
      "expirationDate": "2025-08-29",
      "image":
          "https://images.pexels.com/photos/361184/asparagus-steak-veal-steak-veal-361184.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "dateAdded": "2025-08-27",
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredItems {
    List<Map<String, dynamic>> filtered = _inventoryItems;

    // Filter by category
    if (_selectedCategory != 'All') {
      filtered = filtered
          .where((item) =>
              (item['category'] as String).toLowerCase() ==
              _selectedCategory.toLowerCase())
          .toList();
    }

    // Filter by search query
    if (_searchQuery.isNotEmpty) {
      filtered = filtered
          .where((item) =>
              (item['name'] as String)
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase()) ||
              (item['category'] as String)
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase()))
          .toList();
    }

    // Sort items
    filtered.sort((a, b) {
      int comparison = 0;
      switch (_sortBy) {
        case 'name':
          comparison = (a['name'] as String).compareTo(b['name'] as String);
          break;
        case 'expiration':
          final dateA = DateTime.parse(a['expirationDate'] as String);
          final dateB = DateTime.parse(b['expirationDate'] as String);
          comparison = dateA.compareTo(dateB);
          break;
        case 'category':
          comparison =
              (a['category'] as String).compareTo(b['category'] as String);
          break;
        case 'quantity':
          comparison = (a['quantity'] as num).compareTo(b['quantity'] as num);
          break;
        case 'dateAdded':
          final dateA = DateTime.parse(a['dateAdded'] as String);
          final dateB = DateTime.parse(b['dateAdded'] as String);
          comparison = dateB.compareTo(dateA); // Most recent first by default
          break;
      }
      return _isAscending ? comparison : -comparison;
    });

    return filtered;
  }

  void _showAddItemBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddItemBottomSheet(
        onManualEntry: () => Navigator.pushNamed(context, '/add-edit-item'),
        onBarcodeScanner: () =>
            Navigator.pushNamed(context, '/barcode-scanner'),
        onPhotoCapture: () => _handlePhotoCapture(),
      ),
    );
  }

  void _showSortFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => SortFilterBottomSheet(
        currentSortBy: _sortBy,
        isAscending: _isAscending,
        onSortChanged: (sortBy, ascending) {
          setState(() {
            _sortBy = sortBy;
            _isAscending = ascending;
          });
        },
      ),
    );
  }

  void _handlePhotoCapture() {
    // Navigate to camera/photo capture functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text('Photo capture functionality would open here')),
    );
  }

  void _handleItemEdit(Map<String, dynamic> item) {
    Navigator.pushNamed(context, '/add-edit-item', arguments: item);
  }

  void _handleItemUse(Map<String, dynamic> item) {
    setState(() {
      final index = _inventoryItems.indexWhere((i) => i['id'] == item['id']);
      if (index != -1) {
        final currentQuantity = _inventoryItems[index]['quantity'] as num;
        if (currentQuantity > 1) {
          _inventoryItems[index]['quantity'] = currentQuantity - 1;
        } else {
          _inventoryItems.removeAt(index);
        }
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Used 1 ${item['unit']} of ${item['name']}')),
    );
  }

  void _handleItemDelete(Map<String, dynamic> item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Item'),
        content: Text('Are you sure you want to delete ${item['name']}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _inventoryItems.removeWhere((i) => i['id'] == item['id']);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${item['name']} deleted')),
              );
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _handleItemLongPress(Map<String, dynamic> item) {
    setState(() {
      _isMultiSelectMode = true;
      _selectedItems.add(item['id'] as int);
    });
  }

  void _handleItemTap(Map<String, dynamic> item) {
    if (_isMultiSelectMode) {
      setState(() {
        final itemId = item['id'] as int;
        if (_selectedItems.contains(itemId)) {
          _selectedItems.remove(itemId);
        } else {
          _selectedItems.add(itemId);
        }

        if (_selectedItems.isEmpty) {
          _isMultiSelectMode = false;
        }
      });
    }
  }

  void _exitMultiSelectMode() {
    setState(() {
      _isMultiSelectMode = false;
      _selectedItems.clear();
    });
  }

  void _deleteSelectedItems() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Items'),
        content: Text(
            'Are you sure you want to delete ${_selectedItems.length} selected items?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _inventoryItems
                    .removeWhere((item) => _selectedItems.contains(item['id']));
                _selectedItems.clear();
                _isMultiSelectMode = false;
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Selected items deleted')),
              );
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredItems = _filteredItems;

    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: _isMultiSelectMode
            ? Text('${_selectedItems.length} selected')
            : const Text('My Kitchen Inventory'),
        leading: _isMultiSelectMode
            ? IconButton(
                onPressed: _exitMultiSelectMode,
                icon: CustomIconWidget(
                  iconName: 'close',
                  size: 24,
                  color: AppTheme.textPrimaryLight,
                ),
              )
            : IconButton(
                onPressed: () =>
                    Navigator.pushNamed(context, '/dashboard-home'),
                icon: CustomIconWidget(
                  iconName: 'arrow_back',
                  size: 24,
                  color: AppTheme.textPrimaryLight,
                ),
              ),
        actions: _isMultiSelectMode
            ? [
                IconButton(
                  onPressed: _deleteSelectedItems,
                  icon: CustomIconWidget(
                    iconName: 'delete',
                    size: 24,
                    color: AppTheme.lightTheme.colorScheme.error,
                  ),
                ),
              ]
            : [
                IconButton(
                  onPressed: () =>
                      Navigator.pushNamed(context, '/shopping-list'),
                  icon: CustomIconWidget(
                    iconName: 'shopping_cart',
                    size: 24,
                    color: AppTheme.textPrimaryLight,
                  ),
                ),
              ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Inventory'),
            Tab(text: 'Recipes'),
            Tab(text: 'Meal Plan'),
            Tab(text: 'Analytics'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Inventory Tab
          RefreshIndicator(
            onRefresh: () async {
              await Future.delayed(const Duration(seconds: 1));
              setState(() {});
            },
            child: Column(
              children: [
                // Search Bar
                InventorySearchBar(
                  controller: _searchController,
                  onChanged: (query) {
                    setState(() {
                      _searchQuery = query;
                    });
                  },
                  onFilterTap: _showSortFilterBottomSheet,
                ),

                // Category Filter Chips
                CategoryFilterChips(
                  categories: _categories,
                  selectedCategory: _selectedCategory,
                  onCategorySelected: (category) {
                    setState(() {
                      _selectedCategory = category;
                    });
                  },
                ),

                // Items List
                Expanded(
                  child: filteredItems.isEmpty
                      ? EmptyInventoryState(
                          category: _selectedCategory,
                          onAddItem: _showAddItemBottomSheet,
                        )
                      : ListView.builder(
                          padding: EdgeInsets.only(bottom: 10.h),
                          itemCount: filteredItems.length,
                          itemBuilder: (context, index) {
                            final item = filteredItems[index];
                            final isSelected =
                                _selectedItems.contains(item['id']);

                            return InventoryItemCard(
                              item: item,
                              isSelected: isSelected,
                              onEdit: () => _handleItemEdit(item),
                              onUse: () => _handleItemUse(item),
                              onDelete: () => _handleItemDelete(item),
                              onTap: _isMultiSelectMode
                                  ? () => _handleItemTap(item)
                                  : () => _handleItemLongPress(item),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),

          // Recipes Tab
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomIconWidget(
                  iconName: 'restaurant_menu',
                  size: 80,
                  color: AppTheme.textSecondaryLight,
                ),
                SizedBox(height: 2.h),
                Text(
                  'Recipes Coming Soon',
                  style: AppTheme.lightTheme.textTheme.headlineSmall,
                ),
                SizedBox(height: 1.h),
                Text(
                  'Recipe suggestions based on your inventory',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textSecondaryLight,
                  ),
                ),
              ],
            ),
          ),

          // Meal Plan Tab
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomIconWidget(
                  iconName: 'calendar_month',
                  size: 80,
                  color: AppTheme.textSecondaryLight,
                ),
                SizedBox(height: 2.h),
                Text(
                  'Meal Planning Coming Soon',
                  style: AppTheme.lightTheme.textTheme.headlineSmall,
                ),
                SizedBox(height: 1.h),
                Text(
                  'Plan your meals with calendar integration',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textSecondaryLight,
                  ),
                ),
              ],
            ),
          ),

          // Analytics Tab
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomIconWidget(
                  iconName: 'analytics',
                  size: 80,
                  color: AppTheme.textSecondaryLight,
                ),
                SizedBox(height: 2.h),
                Text(
                  'Analytics Coming Soon',
                  style: AppTheme.lightTheme.textTheme.headlineSmall,
                ),
                SizedBox(height: 1.h),
                Text(
                  'Track your inventory usage and trends',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textSecondaryLight,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: _tabController.index == 0 && !_isMultiSelectMode
          ? FloatingActionButton.extended(
              onPressed: _showAddItemBottomSheet,
              icon: CustomIconWidget(
                iconName: 'add',
                size: 24,
                color: Colors.white,
              ),
              label: const Text('Add Item'),
            )
          : null,
    );
  }
}
