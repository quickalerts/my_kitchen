import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import './widgets/ingredients_list_widget.dart';
import './widgets/instructions_widget.dart';
import './widgets/nutrition_accordion_widget.dart';
import './widgets/recipe_action_buttons_widget.dart';
import './widgets/recipe_header_widget.dart';
import './widgets/recipe_info_widget.dart';

class RecipeDetail extends StatefulWidget {
  const RecipeDetail({super.key});

  @override
  State<RecipeDetail> createState() => _RecipeDetailState();
}

class _RecipeDetailState extends State<RecipeDetail>
    with SingleTickerProviderStateMixin {
  late ScrollController _scrollController;
  late AnimationController _animationController;
  bool _isHeaderVisible = true;
  bool _isSaved = false;
  bool _isCookingMode = false;
  int _currentStep = 0;

  // Mock recipe data - in real app this would come from API/database
  final Map<String, dynamic> _recipeData = {
    'id': '1',
    'name': 'Mediterranean Grilled Chicken',
    'image':
        'https://images.unsplash.com/photo-1598103442097-8b74394b95c6?w=800&h=600&fit=crop',
    'rating': 4.8,
    'difficulty': 'Medium',
    'prepTime': '15 min',
    'cookTime': '25 min',
    'totalTime': '40 min',
    'servings': 4,
    'calories': 320,
    'ingredients': [
      {
        'name': 'Chicken breast',
        'quantity': '500g',
        'owned': true,
        'stock': 'high'
      },
      {
        'name': 'Olive oil',
        'quantity': '3 tbsp',
        'owned': true,
        'stock': 'medium'
      },
      {
        'name': 'Lemon juice',
        'quantity': '2 tbsp',
        'owned': false,
        'stock': 'none'
      },
      {
        'name': 'Garlic cloves',
        'quantity': '3 pieces',
        'owned': true,
        'stock': 'low'
      },
      {'name': 'Oregano', 'quantity': '1 tsp', 'owned': false, 'stock': 'none'},
      {'name': 'Salt', 'quantity': '1 tsp', 'owned': true, 'stock': 'high'},
      {
        'name': 'Black pepper',
        'quantity': '1/2 tsp',
        'owned': true,
        'stock': 'medium'
      },
    ],
    'instructions': [
      {
        'step': 1,
        'text':
            'Marinate chicken with olive oil, lemon juice, garlic, oregano, salt and pepper for 30 minutes',
        'timer': 30
      },
      {'step': 2, 'text': 'Preheat grill to medium-high heat', 'timer': 10},
      {
        'step': 3,
        'text': 'Grill chicken for 6-7 minutes per side until cooked through',
        'timer': 14
      },
      {'step': 4, 'text': 'Let rest for 5 minutes before serving', 'timer': 5},
    ],
    'nutrition': {
      'calories': 320,
      'protein': '35g',
      'carbs': '2g',
      'fat': '18g',
      'fiber': '0g',
      'sugar': '1g',
    }
  };

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final isVisible = _scrollController.offset < 200;
    if (isVisible != _isHeaderVisible) {
      setState(() => _isHeaderVisible = isVisible);
    }
  }

  void _toggleSaved() {
    setState(() => _isSaved = !_isSaved);
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isSaved ? 'Recipe saved!' : 'Recipe removed from saved'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _shareRecipe() {
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Recipe shared!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _startCookingMode() {
    setState(() {
      _isCookingMode = true;
      _currentStep = 0;
    });
    _animationController.forward();
  }

  void _exitCookingMode() {
    setState(() => _isCookingMode = false);
    _animationController.reverse();
  }

  void _nextStep() {
    if (_currentStep < _recipeData['instructions'].length - 1) {
      setState(() => _currentStep++);
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    }
  }

  void _addToMealPlan() {
    Navigator.pushNamed(context, '/meal-planning-calendar');
  }

  void _addMissingToShoppingList() {
    final missingItems = _recipeData['ingredients']
        .where((item) => !item['owned'])
        .map((item) => '${item['quantity']} ${item['name']}')
        .join(', ');

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Added to shopping list: $missingItems'),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isCookingMode) {
      return _buildCookingModeView();
    }

    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          RecipeHeaderWidget(
            imageUrl: _recipeData['image'],
            isVisible: _isHeaderVisible,
            isSaved: _isSaved,
            onBack: () => Navigator.of(context).pop(),
            onSave: _toggleSaved,
            onShare: _shareRecipe,
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RecipeInfoWidget(
                    name: _recipeData['name'],
                    rating: _recipeData['rating'],
                    difficulty: _recipeData['difficulty'],
                    prepTime: _recipeData['prepTime'],
                    cookTime: _recipeData['cookTime'],
                    servings: _recipeData['servings'],
                  ),
                  SizedBox(height: 3.h),
                  IngredientsListWidget(
                    ingredients: List<Map<String, dynamic>>.from(
                        _recipeData['ingredients']),
                    onAddMissingToShoppingList: _addMissingToShoppingList,
                  ),
                  SizedBox(height: 3.h),
                  InstructionsWidget(
                    instructions: List<Map<String, dynamic>>.from(
                        _recipeData['instructions']),
                  ),
                  SizedBox(height: 3.h),
                  NutritionAccordionWidget(
                    nutrition:
                        Map<String, dynamic>.from(_recipeData['nutrition']),
                  ),
                  SizedBox(height: 10.h),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: RecipeActionButtonsWidget(
        onStartCooking: _startCookingMode,
        onAddToMealPlan: _addToMealPlan,
      ),
    );
  }

  Widget _buildCookingModeView() {
    final currentInstruction = _recipeData['instructions'][_currentStep];

    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: _exitCookingMode,
        ),
        title: Text(
          'Cooking Mode',
          style: GoogleFonts.inter(
            color: Colors.white,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(6.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Step ${_currentStep + 1} of ${_recipeData['instructions'].length}',
              style: GoogleFonts.inter(
                color: Colors.white70,
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              currentInstruction['text'],
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 24.sp,
                fontWeight: FontWeight.w600,
                height: 1.3,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 4.h),
            if (currentInstruction['timer'] != null) ...[
              Container(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: Colors.orange.withAlpha(51),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.orange),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.timer, color: Colors.orange),
                    SizedBox(width: 2.w),
                    Text(
                      '${currentInstruction['timer']} minutes',
                      style: GoogleFonts.inter(
                        color: Colors.orange,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 4.h),
            ],
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                if (_currentStep > 0)
                  ElevatedButton(
                    onPressed: _previousStep,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[800],
                      padding: EdgeInsets.symmetric(
                          horizontal: 6.w, vertical: 1.5.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Previous',
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                if (_currentStep < _recipeData['instructions'].length - 1)
                  ElevatedButton(
                    onPressed: _nextStep,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: EdgeInsets.symmetric(
                          horizontal: 6.w, vertical: 1.5.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Next Step',
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                if (_currentStep == _recipeData['instructions'].length - 1)
                  ElevatedButton(
                    onPressed: () {
                      _exitCookingMode();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              'Recipe completed! Ingredients deducted from inventory.'),
                          duration: Duration(seconds: 3),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      padding: EdgeInsets.symmetric(
                          horizontal: 6.w, vertical: 1.5.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Complete',
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
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
