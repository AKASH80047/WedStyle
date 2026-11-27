import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/mock_data.dart';
import '../../../core/utils/models.dart';
import '../../../core/widgets/shared_widgets.dart';

class RegionalCollectionsScreen extends StatefulWidget {
  final String? initialRegion;
  const RegionalCollectionsScreen({super.key, this.initialRegion});

  @override
  State<RegionalCollectionsScreen> createState() => _RegionalCollectionsScreenState();
}

class _RegionalCollectionsScreenState extends State<RegionalCollectionsScreen> {
  late String _selectedZone;
  late String _selectedSubRegion;

  final Map<String, List<String>> _zoneRegions = {
    'North India': ['Punjabi', 'Rajasthani', 'UP / Awadhi', 'Kashmiri'],
    'West India': ['Gujarati', 'Maharashtrian', 'Rajasthani'],
    'South India': ['Tamil', 'Telugu', 'Kannada', 'Kerala'],
    'East India': ['Bengali', 'Odia', 'Assamese'],
    'Northeast': ['Manipuri', 'Naga-inspired'],
  };

  final Map<String, String> _regionHighlights = {
    'Punjabi': 'Heavy Zardozi Velvet Lehengas, Phulkari Dupattas & Royal Sherwanis',
    'Rajasthani': 'Gota Patti Rajputi Poshaaks, Bandhani & Kundan Jadau Chokers',
    'UP / Awadhi': 'Varanasi Gold Katan Banarasi Silk Sarees & Lucknowi Chikankari Ghararas',
    'Kashmiri': 'Authentic Tilla Gold Embroidery, Pashmina Silk & Dejhoor Ornaments',
    'Gujarati': 'Rai Bandhej Gharcholas, Patola Silks & Mirror Work Chaniyas',
    'Maharashtrian': 'Pure Yeola Paithani Nauvari Sarees with Mor-Bangadi Zari Borders',
    'Tamil': 'Pure Mulberry Silk Kanchipuram Temple Border Gopuram Sarees',
    'Telugu': 'Guttapusalu Pearl Chokers & Handwoven Mangalgiri Silks',
    'Kannada': 'Mysore Silk Gold Zari Sarees & Ilkal Weaves',
    'Kerala': 'Auspicious Balaramapuram Kasavu Gold Zari Temple Sarees',
    'Bengali': 'Baluchari Jacquard Silk Sarees & Traditional Shankha Pola Sets',
    'Odia': 'Sambalpuri Bomkai Double Ikkat Silk Sarees & Filigree Silver Payals',
    'Assamese': 'Golden Muga Silk Mekhela Chadors with Kingkhap Zari Motifs',
    'Manipuri': 'Gossamer Silk Inaphi Wraps & Handwoven Floral Phanek Skirts',
    'Naga-inspired': 'Hand-beaded ceremonial stoles & brass tribal choker collars',
  };

  @override
  void initState() {
    super.initState();
    _selectedZone = 'North India';
    _selectedSubRegion = widget.initialRegion ?? 'Punjabi';
  }

  List<ProductModel> _getFilteredProducts() {
    return mockProducts.where((p) {
      return p.region.toLowerCase().contains(_selectedSubRegion.toLowerCase()) ||
             p.region.toLowerCase().contains(_selectedZone.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final products = _getFilteredProducts();
    final highlight = _regionHighlights[_selectedSubRegion] ?? 'Authentic regional wedding couture';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Shop By Region', style: TextStyle(fontFamily: 'Cormorant', fontSize: 22, fontWeight: FontWeight.w700)),
      ),
      body: Column(
        children: [
          // 1. Zone Tabs (North, West, South, East, Northeast)
          Container(
            color: AppColors.surface,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: _zoneRegions.keys.map((zone) {
                  final isSel = _selectedZone == zone;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(zone),
                      selected: isSel,
                      onSelected: (_) {
                        setState(() {
                          _selectedZone = zone;
                          _selectedSubRegion = _zoneRegions[zone]!.first;
                        });
                      },
                      selectedColor: AppColors.primary,
                      labelStyle: TextStyle(color: isSel ? Colors.white : AppColors.textPrimary, fontWeight: FontWeight.w600, fontSize: 13),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          // 2. Sub-region Chips
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: const BoxDecoration(
              color: AppColors.surfaceVariant,
              border: Border(bottom: BorderSide(color: AppColors.border)),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _zoneRegions[_selectedZone]!.map((sub) {
                  final isSel = _selectedSubRegion == sub;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(sub),
                      selected: isSel,
                      onSelected: (_) => setState(() => _selectedSubRegion = sub),
                      selectedColor: AppColors.secondary,
                      labelStyle: TextStyle(color: isSel ? Colors.white : AppColors.textPrimary, fontWeight: FontWeight.w600, fontSize: 12),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          // 3. Culture Heritage Highlight Card
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF8B2250), Color(0xFF6D1A36)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text('👑 ', style: TextStyle(fontSize: 16)),
                          Text(
                            '$_selectedSubRegion Wedding Heritage',
                            style: GoogleFontsHelper.inter(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.white),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        highlight,
                        style: GoogleFontsHelper.inter(fontSize: 12, color: AppColors.goldLight, height: 1.3),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // 4. Products Grid
          Expanded(
            child: products.isEmpty
                ? const EmptyStateWidget(
                    icon: Icons.history_edu,
                    title: 'Regional Heritage Styles Coming Soon',
                    subtitle: 'Master artisans are weaving customized heritage handlooms for this culture.',
                  )
                : GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
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
