import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../theme/app_theme.dart';
import './widgets/onboarding_page_widget.dart';
import './widgets/page_indicator_widget.dart';
import './widgets/permission_request_widget.dart';
import './widgets/user_preferences_widget.dart';

class OnboardingFlow extends StatefulWidget {
  const OnboardingFlow({Key? key}) : super(key: key);

  @override
  State<OnboardingFlow> createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends State<OnboardingFlow> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final int _totalPages = 5; // 3 feature pages + permissions + preferences

  final List<Map<String, dynamic>> _onboardingData = [
    {
      'title': 'Smart Inventory Tracking',
      'description':
          'Scan barcodes to instantly add items to your kitchen inventory. Never forget what you have in stock again.',
      'imageUrl':
          'https://images.pexels.com/photos/4226140/pexels-photo-4226140.jpeg?auto=compress&cs=tinysrgb&w=800',
      'showAnimation': true,
    },
    {
      'title': 'Recipe Suggestions',
      'description':
          'Get personalized recipe recommendations based on ingredients you already have. Cook smarter, not harder.',
      'imageUrl':
          'https://images.pixabay.com/photo/2017/06/06/22/46/vegetables-2378297_1280.jpg?auto=compress&cs=tinysrgb&w=800',
      'showAnimation': false,
    },
    {
      'title': 'Meal Planning Made Easy',
      'description':
          'Plan your weekly meals with our intuitive calendar. Drag and drop recipes to create the perfect meal schedule.',
      'imageUrl':
          'https://images.unsplash.com/photo-1506368249639-73a05d6f6488?auto=compress&cs=tinysrgb&w=800',
      'showAnimation': false,
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      body: Column(
        children: [
          // Skip button
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (_currentPage < _totalPages - 1)
                    TextButton(
                      onPressed: _skipOnboarding,
                      child: Text(
                        'Skip',
                        style:
                            AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),

          // Page content
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() => _currentPage = index);
              },
              children: [
                // Feature introduction pages
                ..._onboardingData
                    .map((data) => OnboardingPageWidget(
                          title: data['title'],
                          description: data['description'],
                          imageUrl: data['imageUrl'],
                          showAnimation: data['showAnimation'],
                        ))
                    .toList(),

                // Permission request page
                PermissionRequestWidget(
                  onPermissionsGranted: _goToNextPage,
                ),

                // User preferences page
                UserPreferencesWidget(
                  onComplete: _completeOnboarding,
                ),
              ],
            ),
          ),

          // Bottom navigation area
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
              child: Column(
                children: [
                  // Page indicator (only for feature pages)
                  if (_currentPage < 3)
                    PageIndicatorWidget(
                      currentPage: _currentPage,
                      totalPages: 3,
                    ),

                  if (_currentPage < 3) SizedBox(height: 3.h),

                  // Navigation buttons (only for feature pages)
                  if (_currentPage < 3)
                    Row(
                      children: [
                        // Back button
                        if (_currentPage > 0)
                          Expanded(
                            child: OutlinedButton(
                              onPressed: _goToPreviousPage,
                              child: Text('Back'),
                            ),
                          ),

                        if (_currentPage > 0) SizedBox(width: 4.w),

                        // Next button
                        Expanded(
                          flex: _currentPage == 0 ? 1 : 1,
                          child: ElevatedButton(
                            onPressed: _goToNextPage,
                            child:
                                Text(_currentPage == 2 ? 'Continue' : 'Next'),
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

  void _goToNextPage() {
    if (_currentPage < _totalPages - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _goToPreviousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _skipOnboarding() {
    Navigator.pushReplacementNamed(context, '/dashboard-home');
  }

  void _completeOnboarding() {
    // Save onboarding completion status
    _saveOnboardingStatus();

    // Navigate to dashboard with first-time user guidance
    Navigator.pushReplacementNamed(context, '/dashboard-home');
  }

  void _saveOnboardingStatus() {
    // In a real app, this would save to SharedPreferences or secure storage
    // For now, we'll just mark it as completed in memory
  }
}
