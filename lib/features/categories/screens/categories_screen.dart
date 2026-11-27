import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/mock_data.dart';
import '../../../core/widgets/shared_widgets.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;
  final List<String> _tabs = ['Women', 'Accessories'];

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    super.dispose();
  }

  final Map<String, List<Map<String, String>>> _categoryData = {
    'Women': [
      {'name': 'Lehenga', 'emoji': '👗', 'count': '234', 'image': 'assets/images/bridal/bridal_lehenga_01.png'},
      {'name': 'Bridal Saree', 'emoji': '🥻', 'count': '189', 'image': 'assets/images/bridal/panetar_01.png'},
      {'name': 'Anarkali', 'emoji': '👘', 'count': '145', 'image': 'assets/images/bridal/contemporary_01.png'},
      {'name': 'Gown', 'emoji': '🎭', 'count': '98', 'image': 'assets/images/bridal/contemporary_02.png'},
      {'name': 'Sharara', 'emoji': '✨', 'count': '76', 'image': 'assets/images/bridal/bandhani_01.png'},
      {'name': 'Salwar Suit', 'emoji': '💃', 'count': '312', 'image': 'assets/images/bridal/contemporary_04.png'},
      {'name': 'Indo-Western', 'emoji': '🌸', 'count': '67', 'image': 'assets/images/bridal/patola_01.png'},
      {'name': 'Bridal Wear', 'emoji': '👰', 'count': '423', 'image': 'assets/images/bridal/complete_look_01.png'},
    ],
    'Accessories': [
      {'name': 'Jewellery', 'emoji': '💎', 'count': '421', 'image': 'assets/images/bridal/complete_look_02.png'},
      {'name': 'Bags & Clutches', 'emoji': '👛', 'count': '156', 'image': 'assets/images/bridal/complete_look_03.png'},
      {'name': 'Footwear', 'emoji': '👠', 'count': '203', 'image': 'assets/images/bridal/bandhani_02.png'},
      {'name': 'Dupatta', 'emoji': '🧣', 'count': '89', 'image': 'assets/images/bridal/gharchola_01.png'},
      {'name': 'Hair Accessories', 'emoji': '🌸', 'count': '45', 'image': 'assets/images/bridal/patola_03.png'},
      {'name': 'Bridal Hair Pins', 'emoji': '📌', 'count': '67', 'image': 'assets/images/bridal/complete_look_05.png'},
      {'name': 'Maang Tikka', 'emoji': '✨', 'count': '134', 'image': 'assets/images/bridal/complete_look_04.png'},
      {'name': 'Wedding Decor', 'emoji': '🌺', 'count': '78', 'image': 'assets/images/bridal/panetar_04.png'},
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Categories',
          style: TextStyle(
            fontFamily: 'Cormorant',
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => context.push('/search'),
          ),
        ],
        bottom: TabBar(
          controller: _tabCtrl,
          tabs: _tabs.map((t) => Tab(text: t)).toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabCtrl,
        children: _tabs.map((tab) => _buildCategoryGrid(tab)).toList(),
      ),
    );
  }

  Widget _buildCategoryGrid(String tab) {
    final items = _categoryData[tab] ?? [];
    final featuredImages = MockData.categories
        .where((c) => c.gender.toLowerCase() == tab.toLowerCase())
        .toList();

    return CustomScrollView(
      slivers: [
        // Featured banner
        SliverToBoxAdapter(child: _buildFeaturedBanner(tab)),

        // Grid
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.85,
            ),
            delegate: SliverChildBuilderDelegate(
              (_, i) => _buildCategoryTile(items[i]),
              childCount: items.length,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFeaturedBanner(String tab) {
    final (emoji, title, sub, color) = switch (tab) {
      'Women' => (
        '👰',
        'Bridal Collection',
        'Explore 1000+ designs',
        0xFF6D1A36,
      ),
      _ => ('💎', 'Wedding Accessories', 'Complete your look', 0xFFAD8C1E),
    };

    return Padding(
      padding: const EdgeInsets.all(16),
      child: GestureDetector(
        onTap: () => context.push('/products/all?name=$title'),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(color), Color(color).withValues(alpha: 0.8)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Color(color).withValues(alpha: 0.3),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontFamily: 'Cormorant',
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      sub,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12,
                        color: Colors.white.withValues(alpha: 0.85),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'Shop Now →',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(emoji, style: const TextStyle(fontSize: 48)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryTile(Map<String, String> item) {
    return GestureDetector(
      onTap: () => context.push('/products/all?name=${item['name']}'),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: AppShadows.card,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.gold.withValues(alpha: 0.3), width: 1),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: item['image'] != null
                    ? Image.asset(
                        item['image']!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Center(
                          child: Text(
                            item['emoji']!,
                            style: const TextStyle(fontSize: 26),
                          ),
                        ),
                      )
                    : Center(
                        child: Text(
                          item['emoji']!,
                          style: const TextStyle(fontSize: 26),
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                item['name']!,
                style: GoogleFontsHelper.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 3),
            Text('${item['count']} items', style: AppTextStyles.caption),
          ],
        ),
      ),
    );
  }
}
