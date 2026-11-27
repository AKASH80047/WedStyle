import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/providers.dart';
import '../../../core/widgets/shared_widgets.dart';

class AiTryOnResultScreen extends StatelessWidget {
  const AiTryOnResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AiTryOnProvider>();
    final session = provider.currentSession;
    final cart = context.read<CartProvider>();

    if (session == null) {
      return const Scaffold(body: Center(child: Text('No result available')));
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Your WedStyle Look',
          style: TextStyle(
            fontFamily: 'Cormorant',
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Result image
            Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                boxShadow: AppShadows.card,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Stack(
                  children: [
                    AppNetworkImage(
                      url: session.resultImageUrl ?? session.productImage,
                      width: double.infinity,
                      height: 520,
                      fit: BoxFit.cover,
                      alignment: Alignment.topCenter,
                    ),
                    Positioned(
                      top: 12,
                      left: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Row(
                          children: [
                            Icon(
                              Icons.auto_fix_high,
                              color: Colors.white,
                              size: 14,
                            ),
                            SizedBox(width: 4),
                            Text(
                              'AI Generated',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Product info
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: AppShadows.card,
                ),
                child: Row(
                  children: [
                    AppNetworkImage(
                      url: session.productImage,
                      width: 64,
                      height: 72,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Tried Outfit', style: AppTextStyles.caption),
                          Text(
                            session.productName,
                            style: AppTextStyles.productName,
                            maxLines: 2,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Action buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  // Share row
                  Row(
                    children: [
                      Expanded(
                        child: _ActionButton(
                          icon: Icons.download_outlined,
                          label: 'Download',
                          onTap: () => _showSnack(context, 'Saved to gallery!'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _ActionButton(
                          icon: Icons.share_outlined,
                          label: 'Share',
                          onTap: () => _showSnack(context, 'Sharing...'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _ActionButton(
                          icon: Icons.bookmark_border_outlined,
                          label: 'Save Look',
                          onTap: () => _showSnack(context, 'Look saved!'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  PrimaryButton(
                    text: 'Add Outfit to Cart',
                    icon: Icons.shopping_bag_outlined,
                    onPressed: () {
                      final product = provider.selectedProduct;
                      if (product != null) {
                        cart.addItem(
                          product,
                          size: product.sizes.first,
                          color: product.colors.first,
                        );
                        _showSnack(context, 'Added to cart!');
                      }
                    },
                  ),
                  const SizedBox(height: 10),
                  SecondaryButton(
                    text: 'Try Another Outfit',
                    icon: Icons.refresh,
                    onPressed: () {
                      provider.reset(keepPhoto: true);
                      context.pop();
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),

            // Comparison (before/after)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Before & After', style: AppTextStyles.sectionTitle),
                  const SizedBox(height: 12),
                  Row(children: [
                    Expanded(
                      child: Column(children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: AppNetworkImage(
                            url: session.userPhotoUrl,
                            height: 150,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text('Your Photo', style: AppTextStyles.caption),
                      ]),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: AppNetworkImage(
                            url: session.resultImageUrl ?? session.productImage,
                            height: 150,
                            fit: BoxFit.cover,
                            alignment: Alignment.topCenter,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text('With Outfit', style: AppTextStyles.caption),
                      ]),
                    ),
                  ]),
                ],
              ),
            ),
            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }

  void _showSnack(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.divider),
          boxShadow: AppShadows.card,
        ),
        child: Column(
          children: [
            Icon(icon, color: AppColors.primary, size: 22),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFontsHelper.inter(
                fontSize: 11,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
