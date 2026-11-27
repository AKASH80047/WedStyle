import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/mock_data.dart';
import '../../../core/utils/models.dart';
import '../../../core/widgets/shared_widgets.dart';

class OccasionsScreen extends StatefulWidget {
  final String? initialOccasion;
  const OccasionsScreen({super.key, this.initialOccasion});

  @override
  State<OccasionsScreen> createState() => _OccasionsScreenState();
}

class _OccasionsScreenState extends State<OccasionsScreen> {
  late String _selectedOccasion;

  final Map<String, ({String emoji, String subtitle, String banner})> _occasionMeta = {
    'Engagement': (emoji: '💍', subtitle: 'Pastel lehengas, diamond gowns & tailored suits', banner: 'assets/images/bridal/contemporary_01.png'),
    'Roka': (emoji: '🌸', subtitle: 'Elegant chanderi suits & subtle kurtas', banner: 'assets/images/bridal/patola_01.png'),
    'Haldi': (emoji: '💛', subtitle: 'Sunshine yellow shararas & mirror kurtas', banner: 'assets/images/bridal/bandhani_01.png'),
    'Mehendi': (emoji: '🌿', subtitle: 'Lush green lehengas & easy drapes', banner: 'assets/images/bridal/gharchola_01.png'),
    'Sangeet': (emoji: '💃', subtitle: 'High-octane shimmer lehengas & Indo-westerns', banner: 'assets/images/garba_chaniya_choli_1791538184299.jpg'),
    'Wedding': (emoji: '👑', subtitle: 'Heritage zardozi lehengas & royal sherwanis', banner: 'assets/images/bridal/panetar_01.png'),
    'Pheras': (emoji: '🔥', subtitle: 'Auspicious sindoor silks & raw silk achkans', banner: 'assets/images/bridal/bridal_lehenga_01.png'),
    'Reception': (emoji: '🥂', subtitle: 'Sculpted metallic gowns & royal tuxedos', banner: 'assets/images/bridal/complete_look_01.png'),
    'Cocktail': (emoji: '✨', subtitle: 'Contemporary fusion & evening glam', banner: 'assets/images/bridal/contemporary_02.png'),
    'Wedding Guest': (emoji: '👗', subtitle: 'Handcrafted floral organzas & Nehru sets', banner: 'assets/images/bridal/panetar_02.png'),
    'Family Wedding': (emoji: '👨‍👩‍👧', subtitle: 'Banarasi brocades & jacquard bandhgalas', banner: 'assets/images/bridal/gharchola_02.png'),
    'Bridal Party': (emoji: '💐', subtitle: 'Coordinated bridesmaid & groomsmen sets', banner: 'assets/images/bridal/complete_look_02.png'),
  };

  @override
  void initState() {
    super.initState();
    _selectedOccasion = widget.initialOccasion ?? 'Wedding';
  }

  List<ProductModel> _getOccasionProducts() {
    return mockProducts.where((p) {
      return p.occasionsList.any((o) => o.toLowerCase().contains(_selectedOccasion.toLowerCase())) ||
             p.occasion.toLowerCase().contains(_selectedOccasion.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final meta = _occasionMeta[_selectedOccasion] ?? (emoji: '💍', subtitle: 'Curated ceremony fashion', banner: 'assets/images/bridal/panetar_01.png');
    final products = _getOccasionProducts();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Shop By Occasion', style: TextStyle(fontFamily: 'Cormorant', fontSize: 22, fontWeight: FontWeight.w700)),
      ),
      body: Column(
        children: [
          // Occasion Tab Selector
          Container(
            color: AppColors.surface,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: _occasionMeta.keys.map((occ) {
                  final isSel = _selectedOccasion == occ;
                  final occItem = _occasionMeta[occ]!;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text('${occItem.emoji} $occ'),
                      selected: isSel,
                      onSelected: (_) => setState(() => _selectedOccasion = occ),
                      selectedColor: AppColors.primary,
                      backgroundColor: AppColors.surfaceVariant,
                      labelStyle: GoogleFontsHelper.inter(
                        fontSize: 12,
                        fontWeight: isSel ? FontWeight.w700 : FontWeight.w500,
                        color: isSel ? Colors.white : AppColors.textPrimary,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(color: isSel ? AppColors.primary : AppColors.border),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          // Hero Banner for Selected Occasion
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF6D1A36), Color(0xFF8B2250)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.25),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.gold, width: 1.5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: AppNetworkImage(
                      url: meta.banner,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${meta.emoji} $_selectedOccasion Ceremony',
                        style: GoogleFontsHelper.inter(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.white),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        meta.subtitle,
                        style: GoogleFontsHelper.inter(fontSize: 11, color: AppColors.goldLight, height: 1.25),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: () => context.push('/look-builder'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.gold,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  ),
                  icon: const Icon(Icons.auto_awesome, size: 14),
                  label: const Text('AI Look', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800)),
                ),
              ],
            ),
          ),

          // Grid Results
          Expanded(
            child: products.isEmpty
                ? const EmptyStateWidget(
                    icon: Icons.celebration,
                    title: 'Ceremony Styles Coming Soon',
                    subtitle: 'Our stylists are currently curating more designer outfits for this ceremony.',
                  )
                : GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.58,
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 14,
                    ),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      return ProductCard(product: products[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
