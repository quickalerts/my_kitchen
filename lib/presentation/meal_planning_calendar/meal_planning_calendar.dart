import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import './widgets/auto_plan_dialog.dart';
import './widgets/calendar_header_widget.dart';
import './widgets/meal_slot_widget.dart';
import './widgets/recipe_browser_sheet.dart';
import './widgets/weekly_view_widget.dart';

class MealPlanningCalendar extends StatefulWidget {
  const MealPlanningCalendar({super.key});

  @override
  State<MealPlanningCalendar> createState() => _MealPlanningCalendarState();
}

class _MealPlanningCalendarState extends State<MealPlanningCalendar>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late PageController _weekPageController;

  DateTime _currentWeekStart =
      DateTime.now().subtract(Duration(days: DateTime.now().weekday - 1));
  bool _isWeeklyView = false;

  // Mock planned meals data - in real app this would come from database
  Map<String, Map<String, Map<String, dynamic>>> _plannedMeals = {
    '2024-08-28': {
      'breakfast': {
        'id': '1',
        'name': 'Greek Yogurt Bowl',
        'image':
            'https://images.unsplash.com/photo-1488477181946-6428a0291777?w=400&h=300&fit=crop',
        'difficulty': 'Easy',
        'cookTime': '5 min',
      },
      'lunch': {
        'id': '2',
        'name': 'Mediterranean Chicken',
        'image':
            'https://images.unsplash.com/photo-1598103442097-8b74394b95c6?w=400&h=300&fit=crop',
        'difficulty': 'Medium',
        'cookTime': '25 min',
      },
    },
    '2024-08-29': {
      'dinner': {
        'id': '3',
        'name': 'Salmon Teriyaki',
        'image':
            'https://images.unsplash.com/photo-1467003909585-2f8a72700288?w=400&h=300&fit=crop',
        'difficulty': 'Medium',
        'cookTime': '30 min',
      },
    },
  };

  // Available recipes for meal planning
  final List<Map<String, dynamic>> _availableRecipes = [
    {
      'id': '4',
      'name': 'Avocado Toast',
      'image':
          'https://images.unsplash.com/photo-1482049016688-2d3e1b311543?w=400&h=300&fit=crop',
      'difficulty': 'Easy',
      'cookTime': '5 min',
      'category': 'breakfast',
    },
    {
      'id': '5',
      'name': 'Caesar Salad',
      'image':
          'https://images.unsplash.com/photo-1546793665-c74683f339c1?w=400&h=300&fit=crop',
      'difficulty': 'Easy',
      'cookTime': '15 min',
      'category': 'lunch',
    },
    {
      'id': '6',
      'name': 'Beef Stir Fry',
      'image':
          'https://images.unsplash.com/photo-1512058564366-18510be2db19?w=400&h=300&fit=crop',
      'difficulty': 'Medium',
      'cookTime': '20 min',
      'category': 'dinner',
    },
    {
      'id': '7',
      'name': 'Pancakes',
      'image':
          'https://images.unsplash.com/photo-1506084868230-bb9d95c24759?w=400&h=300&fit=crop',
      'difficulty': 'Easy',
      'cookTime': '15 min',
      'category': 'breakfast',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
        length: 4, vsync: this, initialIndex: 2); // Plan tab active
    _weekPageController = PageController();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _weekPageController.dispose();
    super.dispose();
  }

  List<DateTime> get _currentWeekDays {
    return List.generate(
        7, (index) => _currentWeekStart.add(Duration(days: index)));
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  void _previousWeek() {
    setState(() {
      _currentWeekStart = _currentWeekStart.subtract(const Duration(days: 7));
    });
  }

  void _nextWeek() {
    setState(() {
      _currentWeekStart = _currentWeekStart.add(const Duration(days: 7));
    });
  }

  void _showRecipeBrowser(DateTime date, String mealType) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => RecipeBrowserSheet(
        recipes: _availableRecipes,
        mealType: mealType,
        onRecipeSelected: (recipe) {
          _assignMealToSlot(date, mealType, recipe);
          Navigator.pop(context);
        },
      ),
    );
  }

  void _assignMealToSlot(
      DateTime date, String mealType, Map<String, dynamic> recipe) {
    final dateStr = _formatDate(date);

    setState(() {
      if (!_plannedMeals.containsKey(dateStr)) {
        _plannedMeals[dateStr] = {};
      }
      _plannedMeals[dateStr]![mealType] = recipe;
    });

    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            '${recipe['name']} added to ${mealType.toUpperCase()} on ${_formatDateForDisplay(date)}'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _removeMealFromSlot(DateTime date, String mealType) {
    final dateStr = _formatDate(date);

    setState(() {
      if (_plannedMeals.containsKey(dateStr)) {
        _plannedMeals[dateStr]!.remove(mealType);
        if (_plannedMeals[dateStr]!.isEmpty) {
          _plannedMeals.remove(dateStr);
        }
      }
    });

    HapticFeedback.lightImpact();
  }

  void _editMeal(DateTime date, String mealType) {
    _showRecipeBrowser(date, mealType);
  }

  void _cookNow(Map<String, dynamic> recipe) {
    Navigator.pushNamed(context, '/recipe-detail');
  }

  void _showMealContextMenu(
      DateTime date, String mealType, Map<String, dynamic> recipe) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              recipe['name'],
              style: GoogleFonts.inter(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 3.h),
            _buildContextMenuItem(
              icon: Icons.edit,
              title: 'Edit',
              onTap: () {
                Navigator.pop(context);
                _editMeal(date, mealType);
              },
            ),
            _buildContextMenuItem(
              icon: Icons.delete,
              title: 'Remove',
              onTap: () {
                Navigator.pop(context);
                _removeMealFromSlot(date, mealType);
              },
            ),
            _buildContextMenuItem(
              icon: Icons.play_arrow,
              title: 'Cook Now',
              onTap: () {
                Navigator.pop(context);
                _cookNow(recipe);
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  Widget _buildContextMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey[700]),
      title: Text(
        title,
        style: GoogleFonts.inter(
          fontSize: 16.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
    );
  }

  void _toggleView() {
    setState(() {
      _isWeeklyView = !_isWeeklyView;
    });
  }

  void _showAutoPlanDialog() {
    showDialog(
      context: context,
      builder: (context) => AutoPlanDialog(
        onAutoPlan: (preferences) {
          _generateAutoPlan(preferences);
          Navigator.pop(context);
        },
      ),
    );
  }

  void _generateAutoPlan(Map<String, dynamic> preferences) {
    // Mock auto-plan generation
    final autoPlannedMeals = <String, Map<String, Map<String, dynamic>>>{};

    for (int i = 0; i < 7; i++) {
      final date = _currentWeekStart.add(Duration(days: i));
      final dateStr = _formatDate(date);

      autoPlannedMeals[dateStr] = {
        'breakfast':
            _availableRecipes.where((r) => r['category'] == 'breakfast').first,
        'lunch': _availableRecipes.where((r) => r['category'] == 'lunch').first,
        'dinner':
            _availableRecipes.where((r) => r['category'] == 'dinner').first,
      };
    }

    setState(() {
      _plannedMeals.addAll(autoPlannedMeals);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Auto-plan generated for this week!'),
        duration: Duration(seconds: 3),
      ),
    );
  }

  void _generateShoppingList() {
    final plannedRecipes = <String>[];

    _plannedMeals.forEach((date, meals) {
      meals.forEach((mealType, recipe) {
        plannedRecipes.add(recipe['name']);
      });
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            'Shopping list generated for ${plannedRecipes.length} recipes'),
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'View',
          onPressed: () {
            Navigator.pushNamed(context, '/shopping-list');
          },
        ),
      ),
    );
  }

  String _formatDateForDisplay(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dateOnly = DateTime(date.year, date.month, date.day);

    if (dateOnly == today) return 'Today';
    if (dateOnly == today.add(const Duration(days: 1))) return 'Tomorrow';

    final weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];

    return '${weekdays[date.weekday - 1]}, ${months[date.month - 1]} ${date.day}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Meal Planning',
          style: GoogleFonts.inter(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              _isWeeklyView ? Icons.calendar_view_month : Icons.view_week,
              color: Colors.black87,
            ),
            onPressed: _toggleView,
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.black87),
            onSelected: (value) {
              switch (value) {
                case 'auto_plan':
                  _showAutoPlanDialog();
                  break;
                case 'shopping_list':
                  _generateShoppingList();
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'auto_plan',
                child: Row(
                  children: [
                    Icon(Icons.auto_fix_high, color: Colors.black87),
                    SizedBox(width: 8),
                    Text('Auto-Plan Week'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'shopping_list',
                child: Row(
                  children: [
                    Icon(Icons.help_outline, color: Colors.black87),
                    SizedBox(width: 8),
                    Text('Generate Shopping List'),
                  ],
                ),
              ),
            ],
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.blue,
          unselectedLabelColor: Colors.grey[600],
          indicatorColor: Colors.blue,
          tabs: const [
            Tab(text: 'Discover'),
            Tab(text: 'Inventory'),
            Tab(text: 'Plan'),
            Tab(text: 'Shopping'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          const Center(child: Text('Discover Tab')),
          const Center(child: Text('Inventory Tab')),
          _buildPlanningView(),
          const Center(child: Text('Shopping Tab')),
        ],
      ),
    );
  }

  Widget _buildPlanningView() {
    if (_isWeeklyView) {
      return WeeklyViewWidget(
        currentWeekDays: _currentWeekDays,
        plannedMeals: _plannedMeals,
        onMealTap: _showMealContextMenu,
        onEmptySlotTap: _showRecipeBrowser,
        onGenerateShoppingList: _generateShoppingList,
      );
    }

    return Column(
      children: [
        CalendarHeaderWidget(
          currentWeekStart: _currentWeekStart,
          onPreviousWeek: _previousWeek,
          onNextWeek: _nextWeek,
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(4.w),
            child: Column(
              children: [
                // Week days header
                Container(
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                  child: Row(
                    children: _currentWeekDays.map((date) {
                      final isToday = DateTime.now().day == date.day &&
                          DateTime.now().month == date.month &&
                          DateTime.now().year == date.year;

                      return Expanded(
                        child: Container(
                          alignment: Alignment.center,
                          child: Column(
                            children: [
                              Text(
                                [
                                  'Mon',
                                  'Tue',
                                  'Wed',
                                  'Thu',
                                  'Fri',
                                  'Sat',
                                  'Sun'
                                ][date.weekday - 1],
                                style: GoogleFonts.inter(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey[600],
                                ),
                              ),
                              SizedBox(height: 0.5.h),
                              Container(
                                width: 8.w,
                                height: 8.w,
                                decoration: BoxDecoration(
                                  color: isToday
                                      ? Colors.blue
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Center(
                                  child: Text(
                                    date.day.toString(),
                                    style: GoogleFonts.inter(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                      color: isToday
                                          ? Colors.white
                                          : Colors.black87,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                // Meal slots grid
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: _currentWeekDays.map((date) {
                        return Container(
                          margin: EdgeInsets.only(bottom: 2.h),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Date column
                              SizedBox(
                                width: 20.w,
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 1.h),
                                  child: Text(
                                    _formatDateForDisplay(date),
                                    style: GoogleFonts.inter(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                              ),
                              // Meal slots
                              Expanded(
                                child: Row(
                                  children: ['breakfast', 'lunch', 'dinner']
                                      .map((mealType) {
                                    final dateStr = _formatDate(date);
                                    final meal =
                                        _plannedMeals[dateStr]?[mealType];

                                    return Expanded(
                                      child: Container(
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 1.w),
                                        child: MealSlotWidget(
                                          mealType: mealType,
                                          meal: meal,
                                          onTap: meal != null
                                              ? () => _showMealContextMenu(
                                                  date, mealType, meal)
                                              : () => _showRecipeBrowser(
                                                  date, mealType),
                                          onLongPress: meal != null
                                              ? () => _showMealContextMenu(
                                                  date, mealType, meal)
                                              : null,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
