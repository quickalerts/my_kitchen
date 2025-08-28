import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/expiring_soon_card.dart';
import './widgets/inventory_overview_card.dart';
import './widgets/quick_actions_card.dart';
import './widgets/recent_activity_card.dart';
import './widgets/stats_overview_widget.dart';
import './widgets/todays_meals_card.dart';

class DashboardHome extends StatefulWidget {
  const DashboardHome({Key? key}) : super(key: key);

  @override
  State<DashboardHome> createState() => _DashboardHomeState();
}

class _DashboardHomeState extends State<DashboardHome> {
  bool _isRefreshing = false;

  // Mock data for dashboard
  final Map<String, dynamic> _dashboardStats = {
    "totalItems": 142,
    "expiringSoon": 5,
    "todaysMeals": 3,
  };

  final Map<String, dynamic> _inventoryData = {
    "vegetables": 45,
    "proteins": 28,
    "pantry": 67,
  };

  final List<Map<String, dynamic>> _todaysMeals = [
    {
      "id": 1,
      "type": "Breakfast",
      "name": "Avocado Toast with Eggs",
      "image":
          "https://images.unsplash.com/photo-1541519227354-08fa5d50c44d?fm=jpg&q=60&w=400&ixlib=rb-4.0.3",
      "cookTime": "15 min",
      "servings": "2",
    },
    {
      "id": 2,
      "type": "Lunch",
      "name": "Mediterranean Quinoa Bowl",
      "image":
          "https://images.unsplash.com/photo-1512621776951-a57141f2eefd?fm=jpg&q=60&w=400&ixlib=rb-4.0.3",
      "cookTime": "25 min",
      "servings": "4",
    },
    {
      "id": 3,
      "type": "Dinner",
      "name": "Grilled Salmon with Vegetables",
      "image":
          "https://images.unsplash.com/photo-1467003909585-2f8a72700288?fm=jpg&q=60&w=400&ixlib=rb-4.0.3",
      "cookTime": "30 min",
      "servings": "3",
    },
  ];

  final List<Map<String, dynamic>> _expiringItems = [
    {
      "id": 1,
      "name": "Fresh Spinach",
      "image":
          "https://images.unsplash.com/photo-1576045057995-568f588f82fb?fm=jpg&q=60&w=400&ixlib=rb-4.0.3",
      "daysLeft": "2",
    },
    {
      "id": 2,
      "name": "Greek Yogurt",
      "image":
          "https://images.unsplash.com/photo-1571212515416-fdc2d2d87bc5?fm=jpg&q=60&w=400&ixlib=rb-4.0.3",
      "daysLeft": "1",
    },
    {
      "id": 3,
      "name": "Bell Peppers",
      "image":
          "https://images.unsplash.com/photo-1563565375-f3fdfdbefa83?fm=jpg&q=60&w=400&ixlib=rb-4.0.3",
      "daysLeft": "3",
    },
  ];

  final List<Map<String, dynamic>> _recentActivities = [
    {
      "id": 1,
      "type": "add",
      "title": "Added Fresh Tomatoes",
      "description": "2 lbs added to vegetables",
      "time": "2 hours ago",
    },
    {
      "id": 2,
      "type": "cook",
      "title": "Cooked Breakfast",
      "description": "Scrambled eggs with toast",
      "time": "This morning",
    },
    {
      "id": 3,
      "type": "recipe",
      "title": "Saved Recipe",
      "description": "Chicken Stir Fry",
      "time": "Yesterday",
    },
    {
      "id": 4,
      "type": "plan",
      "title": "Planned Meals",
      "description": "Week of Aug 28 - Sep 3",
      "time": "2 days ago",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _handleRefresh,
          color: AppTheme.lightTheme.colorScheme.primary,
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: _buildHeader(context),
              ),
              SliverToBoxAdapter(
                child: StatsOverviewWidget(stats: _dashboardStats),
              ),
              SliverToBoxAdapter(
                child: SizedBox(height: 2.h),
              ),
              SliverToBoxAdapter(
                child: QuickActionsCard(
                  onAddItem: () => _navigateToScreen('/add-edit-item'),
                  onScanBarcode: () => _navigateToScreen('/barcode-scanner'),
                  onPlanMeal: () => _showComingSoon('Meal Planning'),
                  onViewRecipes: () => _showComingSoon('Recipe Browser'),
                ),
              ),
              SliverToBoxAdapter(
                child: InventoryOverviewCard(
                  inventoryData: _inventoryData,
                  onTap: () => _navigateToScreen('/inventory-management'),
                ),
              ),
              SliverToBoxAdapter(
                child: TodaysMealsCard(
                  todaysMeals: _todaysMeals,
                  onCookNow: _handleCookNow,
                ),
              ),
              SliverToBoxAdapter(
                child: ExpiringSoonCard(
                  expiringItems: _expiringItems,
                  onDismiss: _handleDismissExpiring,
                  onViewAll: () => _navigateToScreen('/inventory-management'),
                ),
              ),
              SliverToBoxAdapter(
                child: RecentActivityCard(
                  activities: _recentActivities,
                ),
              ),
              SliverToBoxAdapter(
                child: SizedBox(height: 10.h),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToScreen('/add-edit-item'),
        child: CustomIconWidget(
          iconName: 'add',
          color: AppTheme.lightTheme.colorScheme.onPrimary,
          size: 6.w,
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final now = DateTime.now();
    final greeting = _getGreeting();
    final dateString = "${_getMonthName(now.month)} ${now.day}, ${now.year}";

    return Container(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      greeting,
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppTheme.lightTheme.colorScheme.onSurface,
                          ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      dateString,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.primary
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: CustomIconWidget(
                  iconName: 'kitchen',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 8.w,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning!';
    } else if (hour < 17) {
      return 'Good Afternoon!';
    } else {
      return 'Good Evening!';
    }
  }

  String _getMonthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return months[month - 1];
  }

  Future<void> _handleRefresh() async {
    setState(() {
      _isRefreshing = true;
    });

    // Simulate refresh delay
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _isRefreshing = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Dashboard refreshed'),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _navigateToScreen(String route) {
    Navigator.pushNamed(context, route);
  }

  void _handleCookNow(String mealType) {
    if (mealType == 'plan') {
      _showComingSoon('Meal Planning');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Starting to cook $mealType'),
          backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _handleDismissExpiring(String itemId) {
    setState(() {
      _expiringItems.removeWhere((item) => item['id'].toString() == itemId);
      _dashboardStats['expiringSoon'] =
          (_dashboardStats['expiringSoon'] as int) - 1;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Item dismissed'),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: 'Undo',
          textColor: Colors.white,
          onPressed: () {
            // Undo functionality would restore the item
          },
        ),
      ),
    );
  }

  void _showComingSoon(String feature) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Coming Soon',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          content: Text(
            '$feature feature is coming soon! Stay tuned for updates.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
