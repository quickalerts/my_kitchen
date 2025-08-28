import 'package:flutter/material.dart';
import '../presentation/shopping_list/shopping_list.dart';
import '../presentation/add_edit_item/add_edit_item.dart';
import '../presentation/barcode_scanner/barcode_scanner.dart';
import '../presentation/onboarding_flow/onboarding_flow.dart';
import '../presentation/inventory_management/inventory_management.dart';
import '../presentation/dashboard_home/dashboard_home.dart';
import '../presentation/splash_screen/splash_screen.dart';
import '../presentation/recipe_discovery/recipe_discovery.dart';
import '../presentation/recipe_detail/recipe_detail.dart';
import '../presentation/meal_planning_calendar/meal_planning_calendar.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String shoppingList = '/shopping-list';
  static const String addEditItem = '/add-edit-item';
  static const String barcodeScanner = '/barcode-scanner';
  static const String onboardingFlow = '/onboarding-flow';
  static const String inventoryManagement = '/inventory-management';
  static const String dashboardHome = '/dashboard-home';
  static const String splashScreen = '/splash-screen';
  static const String recipeDiscovery = '/recipe-discovery';
  static const String recipeDetail = '/recipe-detail';
  static const String mealPlanningCalendar = '/meal-planning-calendar';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const SplashScreen(),
    shoppingList: (context) => const ShoppingList(),
    addEditItem: (context) => const AddEditItem(),
    barcodeScanner: (context) => const BarcodeScanner(),
    onboardingFlow: (context) => const OnboardingFlow(),
    inventoryManagement: (context) => const InventoryManagement(),
    dashboardHome: (context) => const DashboardHome(),
    splashScreen: (context) => const SplashScreen(),
    recipeDiscovery: (context) => const RecipeDiscovery(),
    recipeDetail: (context) => const RecipeDetail(),
    mealPlanningCalendar: (context) => const MealPlanningCalendar(),
    // TODO: Add your other routes here
  };
}
