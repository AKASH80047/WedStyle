import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'core/utils/app_router.dart';
import 'core/utils/providers.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(const WedStyleApp());
}

class WedStyleApp extends StatelessWidget {
  const WedStyleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()..checkAuthStatus()),
        ChangeNotifierProvider(create: (_) => ProductsProvider()..loadProducts()),
        ChangeNotifierProvider(create: (_) => CartProvider()..loadCart()),
        ChangeNotifierProvider(create: (_) => WishlistProvider()),
        ChangeNotifierProvider(create: (_) => OrdersProvider()..loadOrders()),
        ChangeNotifierProvider(create: (_) => AiTryOnProvider()..loadHistory()),
        ChangeNotifierProvider(create: (_) => NotificationsProvider()..loadNotifications()),
      ],
      child: MaterialApp.router(
        title: 'WedStyle — Luxury Wedding Fashion & AI Try-On',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        routerConfig: AppRouter.router,
      ),
    );
  }
}
