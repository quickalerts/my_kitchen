import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';

class RecipeCategoriesSection extends StatelessWidget {
  final String searchQuery;
  final Set<String> selectedFilters;

  const RecipeCategoriesSection({
    super.key,
    required this.searchQuery,
    required this.selectedFilters,
  });

  @override
  Widget build(BuildContext context) {
    final categories = _getRecipeCategories();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: categories.map((category) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 24),
          child: _CategorySection(
            title: category['title'],
            recipes: category['recipes'],
          ),
        );
      }).toList(),
    );
  }

  List<Map<String, dynamic>> _getRecipeCategories() {
    return [
      {
        'title': 'Trending Now',
        'recipes': [
          {
            'title': 'Korean Bibimbap',
            'image':
                'https://images.unsplash.com/photo-1553163147-622ab57be1c7?w=300&h=200&fit=crop',
            'cookTime': '35 min',
            'difficulty': 'Medium',
            'rating': 4.7,
          },
          {
            'title': 'Avocado Toast',
            'image':
                'https://images.unsplash.com/photo-1541519227354-08fa5d50c44d?w=300&h=200&fit=crop',
            'cookTime': '10 min',
            'difficulty': 'Easy',
            'rating': 4.3,
          },
          {
            'title': 'Pad Thai',
            'image':
                'https://images.unsplash.com/photo-1559314809-0f31657def5e?w=300&h=200&fit=crop',
            'cookTime': '25 min',
            'difficulty': 'Medium',
            'rating': 4.6,
          },
        ],
      },
      {
        'title': 'Quick & Easy',
        'recipes': [
          {
            'title': 'Grilled Cheese',
            'image':
                'https://images.unsplash.com/photo-1528735602780-2552fd46c7af?w=300&h=200&fit=crop',
            'cookTime': '8 min',
            'difficulty': 'Easy',
            'rating': 4.2,
          },
          {
            'title': 'Greek Salad',
            'image':
                'https://images.unsplash.com/photo-1540189549336-e6e99c3679fe?w=300&h=200&fit=crop',
            'cookTime': '12 min',
            'difficulty': 'Easy',
            'rating': 4.4,
          },
          {
            'title': 'Smoothie Bowl',
            'image':
                'https://images.unsplash.com/photo-1511690743698-d9d85f2fbf38?w=300&h=200&fit=crop',
            'cookTime': '5 min',
            'difficulty': 'Easy',
            'rating': 4.5,
          },
        ],
      },
      {
        'title': 'Healthy Options',
        'recipes': [
          {
            'title': 'Quinoa Buddha Bowl',
            'image':
                'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=300&h=200&fit=crop',
            'cookTime': '20 min',
            'difficulty': 'Easy',
            'rating': 4.6,
          },
          {
            'title': 'Zucchini Noodles',
            'image':
                'https://images.unsplash.com/photo-1594756202441-bb45e5d76d04?w=300&h=200&fit=crop',
            'cookTime': '15 min',
            'difficulty': 'Easy',
            'rating': 4.1,
          },
          {
            'title': 'Kale Salad',
            'image':
                'https://images.unsplash.com/photo-1607532941433-304659e8198a?w=300&h=200&fit=crop',
            'cookTime': '10 min',
            'difficulty': 'Easy',
            'rating': 4.0,
          },
        ],
      },
      {
        'title': 'Seasonal Favorites',
        'recipes': [
          {
            'title': 'Pumpkin Soup',
            'image':
                'https://images.unsplash.com/photo-1476718406336-bb5a9690ee2a?w=300&h=200&fit=crop',
            'cookTime': '40 min',
            'difficulty': 'Medium',
            'rating': 4.8,
          },
          {
            'title': 'Apple Crisp',
            'image':
                'https://images.unsplash.com/photo-1571115764595-644a1f56a55c?w=300&h=200&fit=crop',
            'cookTime': '45 min',
            'difficulty': 'Medium',
            'rating': 4.9,
          },
          {
            'title': 'Butternut Squash Risotto',
            'image':
                'https://images.unsplash.com/photo-1604152135912-04a022e23696?w=300&h=200&fit=crop',
            'cookTime': '35 min',
            'difficulty': 'Hard',
            'rating': 4.7,
          },
        ],
      },
    ];
  }
}

class _CategorySection extends StatelessWidget {
  final String title;
  final List<Map<String, dynamic>> recipes;

  const _CategorySection({
    required this.title,
    required this.recipes,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              TextButton(
                onPressed: () {
                  // Navigate to category view
                },
                child: Text(
                  'See All',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: recipes.length,
            itemBuilder: (context, index) {
              final recipe = recipes[index];
              return Padding(
                padding: EdgeInsets.only(
                  right: index < recipes.length - 1 ? 16 : 0,
                ),
                child: _CompactRecipeCard(recipe: recipe),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _CompactRecipeCard extends StatelessWidget {
  final Map<String, dynamic> recipe;

  const _CompactRecipeCard({required this.recipe});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: 160,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(alpha: 0.08),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Recipe Image
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
                child: CachedNetworkImage(
                  imageUrl: recipe['image'],
                  width: double.infinity,
                  height: 100,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: theme.colorScheme.surfaceContainerHighest,
                    child: Center(
                      child: Icon(
                        Icons.image,
                        color:
                            theme.colorScheme.onSurface.withValues(alpha: 0.3),
                        size: 24,
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: theme.colorScheme.errorContainer,
                    child: Center(
                      child: Icon(
                        Icons.error,
                        color: theme.colorScheme.onErrorContainer,
                        size: 24,
                      ),
                    ),
                  ),
                ),
              ),

              // Save button
              Positioned(
                top: 6,
                right: 6,
                child: GestureDetector(
                  onTap: () {
                    // Handle save recipe
                  },
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface.withValues(alpha: 0.9),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.favorite_border,
                      color: theme.colorScheme.primary,
                      size: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Recipe Info
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recipe['title'],
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 12,
                        color:
                            theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                      const SizedBox(width: 3),
                      Text(
                        recipe['cookTime'],
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.star,
                        size: 12,
                        color: Colors.amber,
                      ),
                      const SizedBox(width: 3),
                      Text(
                        recipe['rating'].toString(),
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: 0.6),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        recipe['difficulty'],
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: theme.colorScheme.primary,
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
    );
  }
}
