import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';

class MainShell extends StatefulWidget {
  final Widget child;
  const MainShell({super.key, required this.child});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  final List<_NavItem> _navItems = [
    _NavItem(icon: Icons.home_outlined, activeIcon: Icons.home, label: 'Home', path: '/home'),
    _NavItem(icon: Icons.grid_view_outlined, activeIcon: Icons.grid_view, label: 'Categories', path: '/categories'),
    _NavItem(icon: Icons.auto_fix_high_outlined, activeIcon: Icons.auto_fix_high, label: 'AI Try-On', path: '/ai-tryon'),
    _NavItem(icon: Icons.shopping_bag_outlined, activeIcon: Icons.shopping_bag, label: 'Orders', path: '/orders'),
    _NavItem(icon: Icons.person_outline, activeIcon: Icons.person, label: 'Profile', path: '/profile'),
  ];

  int _calculateSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    if (location.startsWith('/home')) return 0;
    if (location.startsWith('/categories')) return 1;
    if (location.startsWith('/ai-tryon')) return 2;
    if (location.startsWith('/orders')) return 3;
    if (location.startsWith('/profile')) return 4;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = _calculateSelectedIndex(context);
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          border: Border(
            top: BorderSide(
              color: AppColors.royalGold.withValues(alpha: 0.35),
              width: 1,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.08),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: 66,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(_navItems.length, (i) {
                final item = _navItems[i];
                final isActive = currentIndex == i;
                final isAiTryOn = i == 2;

                return Expanded(
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        context.go(item.path);
                      },
                      child: isAiTryOn
                          ? _buildAiTryOnButton(isActive)
                          : _buildNavItem(item, isActive),
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(_NavItem item, bool isActive) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: isActive
                ? AppColors.primary.withValues(alpha: 0.08)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            isActive ? item.activeIcon : item.icon,
            key: ValueKey(isActive),
            color: isActive ? AppColors.primary : AppColors.textTertiary,
            size: 23,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          item.label,
          style: GoogleFontsHelper.inter(
            fontSize: 10,
            fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
            color: isActive ? AppColors.primary : AppColors.textTertiary,
            letterSpacing: 0.2,
          ),
        ),
      ],
    );
  }

  Widget _buildAiTryOnButton(bool isActive) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFBA1828), Color(0xFF7A1C2C)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: AppColors.royalGold,
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.4),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
              BoxShadow(
                color: AppColors.royalGold.withValues(alpha: 0.3),
                blurRadius: 6,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: const Icon(Icons.auto_awesome, color: AppColors.royalGold, size: 22),
        ),
        const SizedBox(height: 2),
        Text(
          'AI Try-On',
          style: GoogleFontsHelper.inter(
            fontSize: 9.5,
            fontWeight: FontWeight.w700,
            color: AppColors.primary,
            letterSpacing: 0.2,
          ),
        ),
      ],
    );
  }
}

class _NavItem {
  final IconData icon, activeIcon;
  final String label, path;
  _NavItem({required this.icon, required this.activeIcon, required this.label, required this.path});
}
