import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/mock_data.dart';
import '../../../core/utils/models.dart';
import '../../../core/utils/providers.dart';
import '../../../core/widgets/shared_widgets.dart';

class LookBuilderScreen extends StatefulWidget {
  const LookBuilderScreen({super.key});

  @override
  State<LookBuilderScreen> createState() => _LookBuilderScreenState();
}

class _LookBuilderScreenState extends State<LookBuilderScreen> {
  String _selectedGender = 'Bride';
  String _selectedOccasion = 'Wedding';
  String _selectedColor = 'Crimson Red';
  String _selectedStyle = 'Traditional Royal';
  double _budget = 150000;
  bool _isGenerating = false;
  LookRecommendationModel? _recommendation;

  final List<String> _genders = ['Bride', 'Female Guest'];
  final List<String> _occasions = [
    'Wedding',
    'Sangeet',
    'Mehendi',
    'Haldi',
    'Reception',
    'Engagement',
    'Cocktail',
  ];
  final List<String> _colors = [
    'Crimson Red',
    'Pastel Pink',
    'Emerald Green',
    'Sunshine Yellow',
    'Ivory Champagne',
    'Royal Navy',
    'Midnight Black',
    'Metallic Gold',
  ];
  final List<String> _styles = [
    'Traditional Royal',
    'Modern Minimalist',
    'Indo-Western Fusion',
    'Regal Mughal',
  ];

  void _generateLook() async {
    setState(() => _isGenerating = true);
    await Future.delayed(const Duration(milliseconds: 900));

    const targetGender = 'Women';

    // Find best matching outfit
    final matchingOutfits = mockProducts.where((p) {
      final genderMatch = p.gender.toLowerCase() == targetGender.toLowerCase();
      final occasionMatch = p.occasionsList.any(
        (o) => o.toLowerCase().contains(_selectedOccasion.toLowerCase()),
      );
      return genderMatch && occasionMatch && p.price <= _budget;
    }).toList();

    final mainOutfit = matchingOutfits.isNotEmpty
        ? matchingOutfits.first
        : mockProducts.firstWhere((p) => p.gender == 'Women');

    // Find matching jewellery
    final matchingJewellery = mockProducts
        .where(
          (p) =>
              p.categoryName.contains('Jewellery') ||
              p.categoryName.contains('Choker') ||
              p.categoryName.contains('Rani Haar'),
        )
        .firstOrNull;

    // Find matching footwear
    final matchingFootwear = mockProducts
        .where(
          (p) => p.categoryId == 'cat_footwear' && p.gender == 'Accessories',
        )
        .firstOrNull;

    // Find matching accessories
    final matchingAccessory = mockProducts
        .where(
          (p) => p.categoryId == 'cat_accessories' && p.gender == 'Accessories',
        )
        .firstOrNull;

    setState(() {
      _recommendation = LookRecommendationModel(
        title: 'Curated $_selectedStyle $_selectedOccasion Ensemble',
        occasion: _selectedOccasion,
        gender: _selectedGender,
        colorTheme: _selectedColor,
        estimatedBudget: _budget,
        outfit: mainOutfit,
        jewellery: matchingJewellery,
        footwear: matchingFootwear,
        accessory: matchingAccessory,
      );
      _isGenerating = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'AI Wedding Look Builder',
          style: TextStyle(
            fontFamily: 'Cormorant',
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Header Banner
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF6D1A36), Color(0xFFB76E79)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.auto_awesome,
                      color: AppColors.goldLight,
                      size: 24,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'AI Stylist Concierge',
                      style: GoogleFontsHelper.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  'Select your ceremony details and let our AI match a coordinated outfit, heritage jewellery, footwear and accessories within your budget.',
                  style: GoogleFontsHelper.inter(
                    fontSize: 12,
                    color: Colors.white.withValues(alpha: 0.9),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // 1. Gender / Role Selection
          _buildSectionHeader('1. Who are you dressing for?'),
          Wrap(
            spacing: 8,
            children: _genders.map((g) {
              final isSel = _selectedGender == g;
              return ChoiceChip(
                label: Text(g),
                selected: isSel,
                onSelected: (_) => setState(() => _selectedGender = g),
                selectedColor: AppColors.primary,
                labelStyle: TextStyle(
                  color: isSel ? Colors.white : AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),

          // 2. Occasion
          _buildSectionHeader('2. Select Wedding Ceremony'),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _occasions.map((o) {
                final isSel = _selectedOccasion == o;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(o),
                    selected: isSel,
                    onSelected: (_) => setState(() => _selectedOccasion = o),
                    selectedColor: AppColors.primary,
                    labelStyle: TextStyle(
                      color: isSel ? Colors.white : AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),

          // 3. Color Palette
          _buildSectionHeader('3. Preferred Color Theme'),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _colors.map((c) {
              final isSel = _selectedColor == c;
              return ChoiceChip(
                label: Text(c),
                selected: isSel,
                onSelected: (_) => setState(() => _selectedColor = c),
                selectedColor: AppColors.secondary,
                labelStyle: TextStyle(
                  color: isSel ? Colors.white : AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),

          // 4. Style Vibe
          _buildSectionHeader('4. Wedding Style Vibe'),
          Wrap(
            spacing: 8,
            children: _styles.map((s) {
              final isSel = _selectedStyle == s;
              return ChoiceChip(
                label: Text(s),
                selected: isSel,
                onSelected: (_) => setState(() => _selectedStyle = s),
                selectedColor: AppColors.primary,
                labelStyle: TextStyle(
                  color: isSel ? Colors.white : AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),

          // 5. Budget Slider
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildSectionHeader('5. Estimated Budget'),
              Text(
                '₹${_budget.toStringAsFixed(0)}',
                style: AppTextStyles.price.copyWith(fontSize: 16),
              ),
            ],
          ),
          Slider(
            value: _budget,
            min: 20000,
            max: 350000,
            divisions: 33,
            activeColor: AppColors.primary,
            inactiveColor: AppColors.border,
            onChanged: (val) => setState(() => _budget = val),
          ),
          const SizedBox(height: 12),

          // Generate Button
          AppButton(
            text: '✨ Generate Curated Wedding Look',
            isLoading: _isGenerating,
            onPressed: _generateLook,
          ),
          const SizedBox(height: 28),

          // Recommendation Display
          if (_recommendation != null)
            _buildRecommendationView(_recommendation!),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: GoogleFontsHelper.inter(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }

  Widget _buildRecommendationView(LookRecommendationModel rec) {
    final cart = context.read<CartProvider>();

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.gold.withValues(alpha: 0.3)),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.gold.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.auto_awesome,
                  color: AppColors.goldDark,
                  size: 20,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      rec.title,
                      style: AppTextStyles.sectionTitle.copyWith(fontSize: 16),
                    ),
                    Text(
                      'Total Ensemble Value: ₹${rec.grandTotal.toStringAsFixed(0)}',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 12),

          // Main Outfit Card
          _buildItemTile(
            label: 'MAIN ATTIRE',
            product: rec.outfit,
            isMain: true,
          ),

          // Jewellery
          if (rec.jewellery != null) ...[
            const SizedBox(height: 10),
            _buildItemTile(
              label: 'MATCHING JEWELLERY',
              product: rec.jewellery!,
            ),
          ],

          // Footwear
          if (rec.footwear != null) ...[
            const SizedBox(height: 10),
            _buildItemTile(
              label: 'COMPATIBLE FOOTWEAR',
              product: rec.footwear!,
            ),
          ],

          // Accessories
          if (rec.accessory != null) ...[
            const SizedBox(height: 10),
            _buildItemTile(label: 'BRIDAL ACCESSORY', product: rec.accessory!),
          ],

          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    context.read<AiTryOnProvider>().setSelectedProduct(
                      rec.outfit,
                    );
                    context.go('/ai-tryon');
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: const BorderSide(color: AppColors.primary),
                  ),
                  icon: const Icon(Icons.auto_fix_high, size: 18),
                  label: const Text(
                    'Try Look on Photo',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    cart.addItem(
                      rec.outfit,
                      size: rec.outfit.sizes.first,
                      color: rec.outfit.colors.first,
                    );
                    if (rec.jewellery != null)
                      cart.addItem(
                        rec.jewellery!,
                        size: rec.jewellery!.sizes.first,
                        color: rec.jewellery!.colors.first,
                      );
                    if (rec.footwear != null)
                      cart.addItem(
                        rec.footwear!,
                        size: rec.footwear!.sizes.first,
                        color: rec.footwear!.colors.first,
                      );
                    if (rec.accessory != null)
                      cart.addItem(
                        rec.accessory!,
                        size: rec.accessory!.sizes.first,
                        color: rec.accessory!.colors.first,
                      );

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Complete Wedding Ensemble added to Cart! 🎉',
                        ),
                      ),
                    );
                    context.push('/cart');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                  ),
                  icon: const Icon(Icons.shopping_bag, size: 18),
                  label: const Text(
                    'Add All to Cart',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildItemTile({
    required String label,
    required ProductModel product,
    bool isMain = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: isMain
            ? AppColors.primary.withValues(alpha: 0.04)
            : AppColors.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isMain
              ? AppColors.primary.withValues(alpha: 0.2)
              : AppColors.border,
        ),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              product.images.first,
              width: 50,
              height: 62,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFontsHelper.inter(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textSecondary,
                  ),
                ),
                Text(
                  product.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.productName.copyWith(fontSize: 13),
                ),
                Text(
                  '₹${product.discountedPrice.toStringAsFixed(0)} • ${product.fabricType}',
                  style: AppTextStyles.caption.copyWith(fontSize: 11),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.arrow_forward_ios,
              size: 14,
              color: AppColors.textSecondary,
            ),
            onPressed: () => context.push('/product/${product.id}'),
          ),
        ],
      ),
    );
  }
}
