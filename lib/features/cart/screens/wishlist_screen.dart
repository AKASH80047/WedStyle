import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/providers.dart';
import '../../../core/utils/models.dart';
import '../../../core/widgets/shared_widgets.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final wishlist = context.watch<WishlistProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Wishlist (${wishlist.count})', style: const TextStyle(fontFamily: 'Cormorant', fontSize: 22, fontWeight: FontWeight.w700)),
      ),
      body: wishlist.items.isEmpty
        ? EmptyStateWidget(
            emoji: '❤️',
            title: 'Your Wishlist is Empty',
            subtitle: 'Save your favorite wedding outfits here and shop whenever you\'re ready.',
            actionLabel: 'Explore Collection',
            onAction: () {
              context.pop();
              context.go('/categories');
            },
          )
        : GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 0.55,
            ),
            itemCount: wishlist.items.length,
            itemBuilder: (_, i) => ProductCard(product: wishlist.items[i]),
          ),
    );
  }
}
