import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_constants.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  final List<_OnboardingPage> _pages = [
    _OnboardingPage(
      emoji: '👗',
      title: 'Discover Wedding\nFashion',
      subtitle:
          'Explore thousands of bridal wear and wedding accessories from top designers.',
      gradient: [const Color(0xFF4A0F24), const Color(0xFF6D1A36)],
    ),
    _OnboardingPage(
      emoji: '🪄',
      title: 'AI Virtual\nTry-On',
      subtitle:
          'Upload your photo and see how any outfit looks on you — without stepping out.',
      gradient: [const Color(0xFF6D1A36), const Color(0xFFB76E79)],
    ),
    _OnboardingPage(
      emoji: '💒',
      title: 'Your Perfect\nWedding Look',
      subtitle:
          'Try. Style. Celebrate. Create your dream wedding wardrobe with WedStyle.',
      gradient: [const Color(0xFFB76E79), const Color(0xFF8B2250)],
    ),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppConstants.keyOnboardingComplete, true);
    if (mounted) context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _controller,
            onPageChanged: (i) => setState(() => _currentPage = i),
            itemCount: _pages.length,
            itemBuilder: (_, i) => _OnboardingPageWidget(page: _pages[i]),
          ),
          // Bottom controls
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 48),
              child: Column(
                children: [
                  // Page indicators
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _pages.length,
                      (i) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: _currentPage == i ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _currentPage == i
                              ? Colors.white
                              : Colors.white38,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Buttons
                  Row(
                    children: [
                      if (_currentPage < _pages.length - 1) ...[
                        Expanded(
                          child: TextButton(
                            onPressed: _completeOnboarding,
                            child: const Text(
                              'Skip',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          flex: 2,
                          child: ElevatedButton(
                            onPressed: () => _controller.nextPage(
                              duration: const Duration(milliseconds: 400),
                              curve: Curves.easeInOut,
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: AppColors.primary,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'Next',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                      ] else
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _completeOnboarding,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: AppColors.primary,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Get Started',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(width: 8),
                                Icon(Icons.arrow_forward, size: 18),
                              ],
                            ),
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

class _OnboardingPage {
  final String emoji, title, subtitle;
  final List<Color> gradient;
  _OnboardingPage({
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.gradient,
  });
}

class _OnboardingPageWidget extends StatelessWidget {
  final _OnboardingPage page;
  const _OnboardingPageWidget({required this.page});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: page.gradient,
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(32, 80, 32, 200),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(40),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.25),
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Text(page.emoji, style: const TextStyle(fontSize: 70)),
                ),
              ),
              const SizedBox(height: 48),
              Text(
                page.title,
                style: const TextStyle(
                  fontFamily: 'Cormorant',
                  fontSize: 40,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  height: 1.2,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Text(
                page.subtitle,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 16,
                  color: Colors.white.withOpacity(0.8),
                  height: 1.6,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
