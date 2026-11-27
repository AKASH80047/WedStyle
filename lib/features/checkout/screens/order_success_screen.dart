import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/shared_widgets.dart';

class OrderSuccessScreen extends StatefulWidget {
  final String orderId;
  const OrderSuccessScreen({super.key, required this.orderId});

  @override
  State<OrderSuccessScreen> createState() => _OrderSuccessScreenState();
}

class _OrderSuccessScreenState extends State<OrderSuccessScreen> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _scale = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(parent: _ctrl, curve: Curves.elasticOut));
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ScaleTransition(
                scale: _scale,
                child: Container(
                  width: 120, height: 120,
                  decoration: const BoxDecoration(color: AppColors.success, shape: BoxShape.circle),
                  child: const Icon(Icons.check, color: Colors.white, size: 60),
                ),
              ),
              const SizedBox(height: 28),
              Text('Order Placed! 🎉', style: AppTextStyles.elegantTitle.copyWith(fontSize: 28)),
              const SizedBox(height: 8),
              Text(
                'Your order has been placed successfully.\nWe\'ll notify you when it ships!',
                style: AppTextStyles.caption.copyWith(fontSize: 15, height: 1.6),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                decoration: BoxDecoration(
                  color: AppColors.surface, borderRadius: BorderRadius.circular(16), boxShadow: AppShadows.card,
                ),
                child: Column(children: [
                  Text('Order ID', style: AppTextStyles.caption),
                  const SizedBox(height: 4),
                  Text(widget.orderId, style: GoogleFontsHelper.inter(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.primary, letterSpacing: 1)),
                ]),
              ),
              const SizedBox(height: 12),
              const Text('💍 Thank you for shopping with WedStyle!\nWishing you a beautiful wedding.',
                style: TextStyle(fontFamily: 'Inter', fontSize: 14, color: AppColors.textTertiary, height: 1.5),
                textAlign: TextAlign.center),
              const SizedBox(height: 40),
              PrimaryButton(text: 'Track Order', icon: Icons.local_shipping_outlined,
                onPressed: () => context.go('/orders')),
              const SizedBox(height: 12),
              SecondaryButton(text: 'Continue Shopping', icon: Icons.shopping_bag_outlined,
                onPressed: () => context.go('/home')),
            ],
          ),
        ),
      ),
    );
  }
}
