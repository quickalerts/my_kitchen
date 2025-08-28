import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import './widgets/dietary_filter_chips.dart';
import './widgets/recipe_categories_section.dart';
import './widgets/recipe_search_bar.dart';
import './widgets/recipes_you_can_make_section.dart';
import './widgets/surprise_me_button.dart';

class RecipeDiscovery extends StatefulWidget {
  const RecipeDiscovery({super.key});

  @override
  State<RecipeDiscovery> createState() => _RecipeDiscoveryState();
}

class _RecipeDiscoveryState extends State<RecipeDiscovery>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  // Filter states
  Set<String> _selectedDietaryFilters = {};
  String _searchQuery = '';
  bool _isLoading = false;

  // Mock data for demonstration
  final List<String> _dietaryOptions = [
    'Vegetarian',
    'Gluten-Free',
    'Quick Meals',
    'Healthy',
    'Low-Carb',
    'Dairy-Free',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    setState(() => _isLoading = true);

    // Simulate loading recipes based on current inventory
    await Future.delayed(const Duration(milliseconds: 1500));

    setState(() => _isLoading = false);
  }

  Future<void> _onRefresh() async {
    await _loadInitialData();
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
    // Implement search functionality
    _performSearch(query);
  }

  void _performSearch(String query) {
    // Simulate search with debouncing
    Future.delayed(const Duration(milliseconds: 300), () {
      if (_searchQuery == query) {
        // Perform actual search
        debugPrint('Searching for: $query');
      }
    });
  }

  void _onDietaryFilterChanged(String filter, bool selected) {
    setState(() {
      if (selected) {
        _selectedDietaryFilters.add(filter);
      } else {
        _selectedDietaryFilters.remove(filter);
      }
    });
    _applyFilters();
  }

  void _applyFilters() {
    // Apply dietary filters and refresh results
    debugPrint('Applied filters: $_selectedDietaryFilters');
  }

  void _onVoiceSearch() {
    // Implement voice input functionality
    debugPrint('Voice search activated');
    // In real implementation, integrate with speech_to_text package
  }

  void _showAdvancedFilters() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildAdvancedFiltersSheet(),
    );
  }

  void _onSurpriseMe() {
    // Generate random recipe suggestions
    debugPrint('Surprise me activated');
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: DefaultTabController(
        length: 4,
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverAppBar(
              expandedHeight: 280,
              floating: false,
              pinned: true,
              backgroundColor: theme.colorScheme.surface,
              elevation: 0,
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: theme.colorScheme.onSurface,
                ),
                onPressed: () => Navigator.pop(context),
              ),
              actions: [
                IconButton(
                  icon: Icon(
                    Icons.tune,
                    color: theme.colorScheme.onSurface,
                  ),
                  onPressed: _showAdvancedFilters,
                ),
                const SizedBox(width: 8),
              ],
              flexibleSpace: FlexibleSpaceBar(
                background: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 80),

                      // Title
                      Text(
                        'Discover Recipes',
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        'Find delicious recipes using ingredients you have',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: 0.7),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Search Bar
                      RecipeSearchBar(
                        controller: _searchController,
                        onChanged: _onSearchChanged,
                        onVoiceSearch: _onVoiceSearch,
                      ),

                      const SizedBox(height: 16),

                      // Dietary Filter Chips
                      DietaryFilterChips(
                        options: _dietaryOptions,
                        selectedFilters: _selectedDietaryFilters,
                        onFilterChanged: _onDietaryFilterChanged,
                      ),
                    ],
                  ),
                ),
              ),
              bottom: TabBar(
                controller: _tabController,
                isScrollable: false,
                labelColor: theme.colorScheme.primary,
                unselectedLabelColor:
                    theme.colorScheme.onSurface.withValues(alpha: 0.6),
                indicatorColor: theme.colorScheme.primary,
                labelStyle: GoogleFonts.inter(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
                unselectedLabelStyle: GoogleFonts.inter(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
                tabs: const [
                  Tab(text: 'Recipes'),
                  Tab(text: 'Trending'),
                  Tab(text: 'Saved'),
                  Tab(text: 'Recent'),
                ],
              ),
            ),
          ],
          body: RefreshIndicator(
            key: _refreshIndicatorKey,
            onRefresh: _onRefresh,
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildRecipesTab(),
                _buildTrendingTab(),
                _buildSavedTab(),
                _buildRecentTab(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRecipesTab() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Recipes You Can Make Section
          RecipesYouCanMakeSection(
            searchQuery: _searchQuery,
            selectedFilters: _selectedDietaryFilters,
          ),

          const SizedBox(height: 32),

          // Recipe Categories
          RecipeCategoriesSection(
            searchQuery: _searchQuery,
            selectedFilters: _selectedDietaryFilters,
          ),

          const SizedBox(height: 32),

          // Surprise Me Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SurpriseMeButton(
              onPressed: _onSurpriseMe,
            ),
          ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildTrendingTab() {
    return const Center(
      child: Text('Trending recipes will be displayed here'),
    );
  }

  Widget _buildSavedTab() {
    return const Center(
      child: Text('Saved recipes will be displayed here'),
    );
  }

  Widget _buildRecentTab() {
    return const Center(
      child: Text('Recently viewed recipes will be displayed here'),
    );
  }

  Widget _buildAdvancedFiltersSheet() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle bar
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          const SizedBox(height: 24),

          Text(
            'Advanced Filters',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),

          const SizedBox(height: 24),

          // Filter options would go here
          const Text(
              'Cuisine Type, Cooking Method, Prep Time, Calorie Range filters would be implemented here'),

          const SizedBox(height: 32),

          // Apply button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Apply Filters'),
            ),
          ),

          SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
        ],
      ),
    );
  }
}
