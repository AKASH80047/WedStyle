import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/screens/splash_screen.dart';
import '../../features/auth/screens/onboarding_screen.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/register_screen.dart';
import '../../features/home/screens/main_shell.dart';
import '../../features/home/screens/home_screen.dart';
import '../../features/categories/screens/categories_screen.dart';
import '../../features/categories/screens/product_listing_screen.dart';
import '../../features/products/screens/product_detail_screen.dart';
import '../../features/ai_tryon/screens/ai_tryon_screen.dart';
import '../../features/ai_tryon/screens/ai_tryon_result_screen.dart';
import '../../features/ai_tryon/screens/ai_tryon_history_screen.dart';
import '../../features/cart/screens/cart_screen.dart';
import '../../features/cart/screens/wishlist_screen.dart';
import '../../features/checkout/screens/checkout_screen.dart';
import '../../features/checkout/screens/order_success_screen.dart';
import '../../features/orders/screens/orders_screen.dart';
import '../../features/orders/screens/order_detail_screen.dart';
import '../../features/profile/screens/profile_screen.dart';
import '../../features/notifications/screens/notifications_screen.dart';
import '../../features/search/screens/search_screen.dart';
import '../../features/home/screens/look_builder_screen.dart';
import '../../features/categories/screens/occasions_screen.dart';
import '../../features/categories/screens/regional_collections_screen.dart';
import '../../features/admin/screens/admin_login_screen.dart';
import '../../features/admin/screens/admin_shell.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

class AppRouter {
  static final GoRouter router = GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: '/splash',
    debugLogDiagnostics: false,
    routes: [
      // Auth Routes
      GoRoute(
        path: '/splash',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        name: 'onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => const RegisterScreen(),
      ),

      // Main Shell with bottom nav
      ShellRoute(
        builder: (context, state, child) => MainShell(child: child),
        routes: [
          GoRoute(
            path: '/home',
            name: 'home',
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: '/categories',
            name: 'categories',
            builder: (context, state) => const CategoriesScreen(),
          ),
          GoRoute(
            path: '/ai-tryon',
            name: 'aiTryon',
            builder: (context, state) => const AiTryOnScreen(),
          ),
          GoRoute(
            path: '/orders',
            name: 'orders',
            builder: (context, state) => const OrdersScreen(),
          ),
          GoRoute(
            path: '/profile',
            name: 'profile',
            builder: (context, state) => const ProfileScreen(),
          ),
        ],
      ),

      // Product Routes
      GoRoute(
        path: '/products/:categoryId',
        name: 'productListing',
        builder: (context, state) => ProductListingScreen(
          categoryId: state.pathParameters['categoryId'] ?? '',
          categoryName: state.uri.queryParameters['name'] ?? 'Products',
        ),
      ),
      GoRoute(
        path: '/product/:productId',
        name: 'productDetail',
        builder: (context, state) => ProductDetailScreen(
          productId: state.pathParameters['productId'] ?? '',
        ),
      ),

      // Search
      GoRoute(
        path: '/search',
        name: 'search',
        builder: (context, state) => SearchScreen(
          query: state.uri.queryParameters['q'],
        ),
      ),

      // Cart & Wishlist
      GoRoute(
        path: '/cart',
        name: 'cart',
        builder: (context, state) => const CartScreen(),
      ),
      GoRoute(
        path: '/wishlist',
        name: 'wishlist',
        builder: (context, state) => const WishlistScreen(),
      ),

      // Checkout
      GoRoute(
        path: '/checkout',
        name: 'checkout',
        builder: (context, state) => const CheckoutScreen(),
      ),
      GoRoute(
        path: '/order-success/:orderId',
        name: 'orderSuccess',
        builder: (context, state) => OrderSuccessScreen(
          orderId: state.pathParameters['orderId'] ?? '',
        ),
      ),

      // Order Detail
      GoRoute(
        path: '/order-detail/:orderId',
        name: 'orderDetail',
        builder: (context, state) => OrderDetailScreen(
          orderId: state.pathParameters['orderId'] ?? '',
        ),
      ),

      // AI Try-On flows
      GoRoute(
        path: '/ai-tryon-result',
        name: 'aiTryOnResult',
        builder: (context, state) => const AiTryOnResultScreen(),
      ),
      GoRoute(
        path: '/ai-tryon-history',
        name: 'aiTryOnHistory',
        builder: (context, state) => const AiTryOnHistoryScreen(),
      ),

      // Notifications
      GoRoute(
        path: '/notifications',
        name: 'notifications',
        builder: (context, state) => const NotificationsScreen(),
      ),

      // Look Builder & Curated Collections
      GoRoute(
        path: '/look-builder',
        name: 'lookBuilder',
        builder: (context, state) => const LookBuilderScreen(),
      ),
      GoRoute(
        path: '/occasions',
        name: 'occasions',
        builder: (context, state) => OccasionsScreen(
          initialOccasion: state.uri.queryParameters['occasion'],
        ),
      ),
      GoRoute(
        path: '/regional',
        name: 'regional',
        builder: (context, state) => RegionalCollectionsScreen(
          initialRegion: state.uri.queryParameters['region'],
        ),
      ),

      // Admin Routes
      GoRoute(
        path: '/admin/login',
        name: 'adminLogin',
        builder: (context, state) => const AdminLoginScreen(),
      ),
      GoRoute(
        path: '/admin',
        name: 'admin',
        builder: (context, state) => const AdminShell(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Page not found: ${state.error}'),
      ),
    ),
  );
}
