import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/providers.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _textController;
  late Animation<double> _logoScale;
  late Animation<double> _logoOpacity;
  late Animation<double> _textOpacity;
  late Animation<Offset> _textSlide;

  @override
  void initState() {
    super.initState();
    _logoController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1000));
    _textController = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));

    _logoScale = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.elasticOut),
    );
    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: const Interval(0, 0.5)),
    );
    _textOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(_textController);
    _textSlide = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeOut),
    );

    _startAnimation();
  }

  Future<void> _startAnimation() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _logoController.forward();
    await Future.delayed(const Duration(milliseconds: 600));
    _textController.forward();
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) _navigate();
  }

  Future<void> _navigate() async {
    final prefs = await SharedPreferences.getInstance();
    final onboardingDone = prefs.getBool(AppConstants.keyOnboardingComplete) ?? false;
    final isLoggedIn = prefs.getBool(AppConstants.keyIsLoggedIn) ?? false;
    final isGuest = prefs.getBool(AppConstants.keyGuestMode) ?? false;

    if (!mounted) return;
    if (isLoggedIn || isGuest) {
      context.go('/home');
    } else if (onboardingDone) {
      context.go('/login');
    } else {
      context.go('/onboarding');
    }
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF4A0F24),
              Color(0xFF6D1A36),
              Color(0xFF8B2250),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ScaleTransition(
                  scale: _logoScale,
                  child: FadeTransition(
                    opacity: _logoOpacity,
                    child: Column(
                      children: [
                        // Logo diamond
                        Container(
                          width: 100, height: 100,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(color: Colors.white.withOpacity(0.3), width: 1.5),
                          ),
                          child: Center(
                            child: Text('💒', style: const TextStyle(fontSize: 50)),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          AppConstants.appName,
                          style: TextStyle(
                            fontFamily: 'Cormorant',
                            fontSize: 48,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            letterSpacing: 4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SlideTransition(
                  position: _textSlide,
                  child: FadeTransition(
                    opacity: _textOpacity,
                    child: Column(
                      children: [
                        Container(
                          width: 60, height: 1,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.transparent, AppColors.accent, Colors.transparent],
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          AppConstants.appShortTagline,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.75),
                            letterSpacing: 2,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 80),
                FadeTransition(
                  opacity: _textOpacity,
                  child: SizedBox(
                    width: 28, height: 28,
                    child: CircularProgressIndicator(
                      color: Colors.white.withOpacity(0.6),
                      strokeWidth: 2,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
