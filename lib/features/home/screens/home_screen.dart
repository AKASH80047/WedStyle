import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/providers.dart';
import '../../../core/widgets/shared_widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _bannerIndex = 0;
  final CarouselSliderController _carouselCtrl = CarouselSliderController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductsProvider>().loadTrendingProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          _buildAppBar(),
          SliverToBoxAdapter(child: ResponsiveWrapper(child: _buildBody())),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    final cart = context.watch<CartProvider>();
    final notif = context.watch<NotificationsProvider>();
    final auth = context.watch<AuthProvider>();

    return SliverAppBar(
      floating: true,
      snap: true,
      backgroundColor: AppColors.background,
      elevation: 0,
      titleSpacing: 0,
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            // Logo
            Row(
              children: [
                Text('💒', style: TextStyle(fontSize: 22)),
                const SizedBox(width: 8),
                const Text(
                  'WedStyle',
                  style: TextStyle(
                    fontFamily: 'Cormorant',
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
            const Spacer(),
            // Search
            IconButton(
              icon: const Icon(Icons.search, color: AppColors.textPrimary),
              onPressed: () => context.push('/search'),
            ),
            // Wishlist
            IconButton(
              icon: const Icon(
                Icons.favorite_border,
                color: AppColors.textPrimary,
              ),
              onPressed: () => context.push('/wishlist'),
            ),
            // Cart
            Stack(
              clipBehavior: Clip.none,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.shopping_bag_outlined,
                    color: AppColors.textPrimary,
                  ),
                  onPressed: () => context.push('/cart'),
                ),
                if (cart.itemCount > 0)
                  Positioned(
                    right: 6,
                    top: 6,
                    child: Container(
                      width: 16,
                      height: 16,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '${cart.itemCount}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        _buildGreeting(),
        const SizedBox(height: 14),
        _buildGujaratiWeddingStories(),
        const SizedBox(height: 18),
        _buildHeroBanner(),
        const SizedBox(height: 20),
        _buildLookBuilderBanner(),
        const SizedBox(height: 24),
        _buildCategoryChips(),
        const SizedBox(height: 28),
        _buildOccasions(),
        const SizedBox(height: 28),
        _buildRegionalSection(),
        const SizedBox(height: 28),
        _buildPromoBanners(),
        const SizedBox(height: 28),
        _buildAiTryOnBanner(),
        const SizedBox(height: 28),
        _buildTrendingProducts(),
        const SizedBox(height: 28),
        _buildBrandsSection(),
        const SizedBox(height: 100),
      ],
    );
  }

  Widget _buildGreeting() {
    final auth = context.watch<AuthProvider>();
    final name = auth.currentUser?.name.split(' ').first ?? 'there';
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Namaste, $name 🙏',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFontsHelper.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'શુભ વિવાહ • Royal Gujarati Wedding Couture',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFontsHelper.cormorant(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.royalGold.withValues(alpha: 0.2),
                  AppColors.primary.withValues(alpha: 0.08),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.royalGold.withValues(alpha: 0.5),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.location_on,
                  color: AppColors.deepKanku,
                  size: 13,
                ),
                const SizedBox(width: 3),
                Text(
                  'Gujarat Edition',
                  style: GoogleFontsHelper.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGujaratiWeddingStories() {
    final stories = [
      {'name': 'Panetar', 'icon': '👰', 'tag': 'Lagna', 'route': '/categories', 'image': 'assets/images/bridal/panetar_01.png'},
      {'name': 'Gharchola', 'icon': '🌺', 'tag': 'Pheras', 'route': '/categories', 'image': 'assets/images/bridal/gharchola_01.png'},
      {'name': 'Raas Garba', 'icon': '💃', 'tag': 'Sanedo', 'route': '/occasions?occasion=Sangeet', 'image': 'assets/images/garba_chaniya_choli_1791538184299.jpg'},
      {'name': 'Mameru', 'icon': '🎁', 'tag': 'Mosalu', 'route': '/categories', 'image': 'assets/images/bridal/patola_01.png'},
      {'name': 'Jadau Gold', 'icon': '💎', 'tag': 'Damini', 'route': '/categories', 'image': 'assets/images/bridal/complete_look_01.png'},
      {'name': 'AI Try-On', 'icon': '✨', 'tag': 'Virtual', 'route': '/ai-tryon', 'image': 'assets/images/bridal/bridal_lehenga_01.png'},
    ];

    return SizedBox(
      height: 94,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        itemCount: stories.length,
        itemBuilder: (_, i) {
          final s = stories[i];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: GestureDetector(
              onTap: () {
                if (s['route'] == '/ai-tryon') {
                  context.go('/ai-tryon');
                } else {
                  context.push(s['route']!);
                }
              },
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(2.5),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFFBA1828),
                          Color(0xFFE5B84B),
                          Color(0xFF7A1C2C),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.15),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Container(
                      width: 54,
                      height: 54,
                      decoration: const BoxDecoration(
                        color: AppColors.surface,
                        shape: BoxShape.circle,
                      ),
                      child: ClipOval(
                        child: s['image'] != null
                            ? Image.asset(
                                s['image']!,
                                width: 54,
                                height: 54,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Center(
                                  child: Text(
                                    s['icon']!,
                                    style: const TextStyle(fontSize: 24),
                                  ),
                                ),
                              )
                            : Center(
                                child: Text(
                                  s['icon']!,
                                  style: const TextStyle(fontSize: 24),
                                ),
                              ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    s['name']!,
                    style: GoogleFontsHelper.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeroBanner() {
    final banners = [
      _HeroBanner(
        title: 'The Royal Gujarati\nBridal Collection',
        subtitle: 'Authentic Panetar, Gharchola & Patola',
        image: AppConstants.heroBanners[0],
        gradient: [const Color(0xFF4A0E18), const Color(0xFF7A1C2C)],
      ),
      _HeroBanner(
        title: 'AI Virtual\nBridal Try-On',
        subtitle: 'Experience your wedding look before buying',
        image: AppConstants.heroBanners[1],
        gradient: [const Color(0xFF7A1C2C), const Color(0xFFC27A86)],
      ),
      _HeroBanner(
        title: 'Raas-Garba &\nSanedo Chaniya Choli',
        subtitle: 'Real Kutch mirror-work & 12m flare',
        image: AppConstants.heroBanners[2],
        gradient: [const Color(0xFF9E2A3E), const Color(0xFF7A1C2C)],
      ),
    ];

    return Column(
      children: [
        CarouselSlider.builder(
          carouselController: _carouselCtrl,
          itemCount: banners.length,
          options: CarouselOptions(
            height: 220,
            viewportFraction: 0.88,
            enlargeCenterPage: true,
            enlargeFactor: 0.1,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 5),
            onPageChanged: (i, _) => setState(() => _bannerIndex = i),
          ),
          itemBuilder: (_, i, __) => _buildBannerCard(banners[i]),
        ),
        const SizedBox(height: 12),
        AnimatedSmoothIndicator(
          activeIndex: _bannerIndex,
          count: banners.length,
          effect: ExpandingDotsEffect(
            dotHeight: 6,
            dotWidth: 6,
            activeDotColor: AppColors.primary,
            dotColor: AppColors.divider,
          ),
        ),
      ],
    );
  }

  Widget _buildBannerCard(_HeroBanner banner) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Stack(
        fit: StackFit.expand,
        children: [
          AppNetworkImage(url: banner.image, fit: BoxFit.cover),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  banner.gradient[0].withValues(alpha: 0.85),
                  banner.gradient[1].withValues(alpha: 0.4),
                  Colors.transparent,
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  banner.title,
                  style: const TextStyle(
                    fontFamily: 'Cormorant',
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    height: 1.2,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  banner.subtitle,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    color: Colors.white.withValues(alpha: 0.85),
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    _SmallButton(
                      text: 'Shop Collection',
                      onTap: () => context.go('/categories'),
                      filled: true,
                    ),
                    const SizedBox(width: 8),
                    _SmallButton(
                      text: '✨ Try With AI',
                      onTap: () => context.go('/ai-tryon'),
                      filled: false,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChips() {
    final categories = [
      'All',
      'Bride',
      'Wedding Guests',
      'Jewellery',
      'Accessories',
      'Regional',
    ];
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length,
        itemBuilder: (_, i) => Padding(
          padding: const EdgeInsets.only(right: 8),
          child: FilterChip(
            label: Text(categories[i]),
            selected: i == 0,
            onSelected: (_) {
              if (categories[i] == 'Regional') {
                context.push('/regional');
              } else if (categories[i] == 'Wedding Guests') {
                context.push('/occasions?occasion=Wedding Guest');
              } else {
                context.push('/categories');
              }
            },
            selectedColor: AppColors.primary.withValues(alpha: 0.12),
            checkmarkColor: AppColors.primary,
            side: BorderSide(
              color: i == 0 ? AppColors.primary : AppColors.divider,
            ),
            labelStyle: GoogleFontsHelper.inter(
              fontSize: 13,
              fontWeight: i == 0 ? FontWeight.w600 : FontWeight.w400,
              color: i == 0 ? AppColors.primary : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLookBuilderBanner() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GestureDetector(
        onTap: () => context.push('/look-builder'),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF6D1A36), Color(0xFFB76E79)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.25),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.auto_awesome,
                  color: Colors.white,
                  size: 22,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Personalized Wedding Look Builder',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Bride & guest matching ensembles with jewellery',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 11,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                color: Colors.white,
                size: 14,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOccasions() {
    return Column(
      children: [
        SectionHeader(
          title: 'Shop By Occasion',
          subtitle: 'Ceremony-specific attire & jewellery',
          onSeeAll: () => context.push('/occasions'),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: AppConstants.occasions.length,
            itemBuilder: (_, i) {
              final occ = AppConstants.occasions[i];
              final occName = occ['name'] as String;
              return Padding(
                padding: const EdgeInsets.only(right: 16),
                child: GestureDetector(
                  onTap: () => context.push('/occasions?occasion=$occName'),
                  child: Column(
                    children: [
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: AppColors.gold.withValues(alpha: 0.6),
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(18),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              occ['image'] != null
                                  ? Image.asset(
                                      occ['image'] as String,
                                      fit: BoxFit.cover,
                                    )
                                  : Container(
                                      color: Color(occ['color'] as int).withValues(alpha: 0.2),
                                      child: Center(
                                        child: Text(
                                          occ['icon'] as String,
                                          style: const TextStyle(fontSize: 26),
                                        ),
                                      ),
                                    ),
                              Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.transparent,
                                      Colors.black.withValues(alpha: 0.55),
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 3,
                                right: 3,
                                child: Text(
                                  occ['icon'] as String,
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        occName,
                        style: GoogleFontsHelper.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildRegionalSection() {
    final regions = [
      {
        'name': 'Punjabi',
        'zone': 'North India',
        'tag': 'Zardozi Lehengas',
        'emoji': '🪡',
      },
      {
        'name': 'Rajasthani',
        'zone': 'West India',
        'tag': 'Gota Patti & Kundan',
        'emoji': '👑',
      },
      {
        'name': 'Banarasi',
        'zone': 'UP / Awadhi',
        'tag': 'Pure Silk Brocades',
        'emoji': '✨',
      },
      {
        'name': 'Kanchipuram',
        'zone': 'South India',
        'tag': 'Temple Zari Borders',
        'emoji': '🪔',
      },
      {
        'name': 'Bengali',
        'zone': 'East India',
        'tag': 'Baluchari & Shankha',
        'emoji': '🌸',
      },
      {
        'name': 'Manipuri',
        'zone': 'Northeast',
        'tag': 'Inaphi & Phanek Silk',
        'emoji': '🌺',
      },
    ];

    return Column(
      children: [
        SectionHeader(
          title: 'Shop By Region',
          subtitle: 'Indian heritage handlooms & regional couture',
          onSeeAll: () => context.push('/regional'),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 110,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: regions.length,
            itemBuilder: (_, i) {
              final r = regions[i];
              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: GestureDetector(
                  onTap: () => context.push('/regional?region=${r['name']}'),
                  child: Container(
                    width: 150,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppColors.gold.withOpacity(0.3),
                      ),
                      boxShadow: AppShadows.card,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Text(
                              r['emoji']!,
                              style: const TextStyle(fontSize: 20),
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                r['name']!,
                                style: GoogleFontsHelper.inter(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          r['tag']!,
                          style: GoogleFontsHelper.inter(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: AppColors.primary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          r['zone']!,
                          style: GoogleFontsHelper.inter(
                            fontSize: 9,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPromoBanners() {
    final promos = [
      {
        'title': 'Bridal Collection',
        'sub': 'Up to 40% OFF',
        'emoji': '👰',
        'color': 0xFF6D1A36,
        'route': '/categories',
      },
      {
        'title': 'Wedding Guests',
        'sub': 'Curated Ceremonial Sets',
        'emoji': '💃',
        'color': 0xFF8B2250,
        'route': '/occasions?occasion=Wedding Guest',
      },
      {
        'title': 'Jewellery & Sets',
        'sub': 'Kundan, Polki & Gold',
        'emoji': '💍',
        'color': 0xFFAD8C1E,
        'route': '/categories',
      },
    ];

    return Column(
      children: [
        SectionHeader(
          title: 'Shop By Collection',
          onSeeAll: () => context.push('/categories'),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: promos.length,
            itemBuilder: (_, i) {
              final p = promos[i];
              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: GestureDetector(
                  onTap: () => context.push(p['route'] as String),
                  child: Container(
                    width: 145,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(p['color'] as int),
                          Color(p['color'] as int).withOpacity(0.7),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          p['emoji'] as String,
                          style: const TextStyle(fontSize: 24),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              p['title'] as String,
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              p['sub'] as String,
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 10,
                                color: Colors.white.withOpacity(0.8),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAiTryOnBanner() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GestureDetector(
        onTap: () => context.go('/ai-tryon'),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF4A0F24), Color(0xFF8B2250), Color(0xFFB76E79)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.4),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        '✨ AI Powered',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 11,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'See How It\nLooks On You',
                      style: TextStyle(
                        fontFamily: 'Cormorant',
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Upload your photo and virtually try your favorite wedding outfits.',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.85),
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'Try Now →',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              const Text('🪞', style: TextStyle(fontSize: 70)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTrendingProducts() {
    final products = context.watch<ProductsProvider>().trendingProducts;

    return Column(
      children: [
        SectionHeader(
          title: 'Trending Now',
          subtitle: 'Most loved this season',
          onSeeAll: () => context.push('/products/all?name=All Products'),
        ),
        const SizedBox(height: 16),
        if (products.isEmpty)
          SizedBox(
            height: 310,
            child: GridView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                mainAxisSpacing: 12,
              ),
              itemCount: 4,
              itemBuilder: (_, __) => const ProductCardShimmer(),
            ),
          )
        else
          SizedBox(
            height: 310,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: products.length,
              itemBuilder: (_, i) => Padding(
                padding: const EdgeInsets.only(right: 12),
                child: SizedBox(
                  width: 175,
                  child: ProductCard(product: products[i]),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildBrandsSection() {
    final brands = [
      'Sabyasachi',
      'Manyavar',
      'Ritu Kumar',
      'FabIndia',
      'Pothys',
      'Benarasi',
    ];
    return Column(
      children: [
        SectionHeader(title: 'Top Brands', onSeeAll: () {}),
        const SizedBox(height: 16),
        SizedBox(
          height: 44,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: brands.length,
            itemBuilder: (_, i) => Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: AppColors.divider),
                  boxShadow: AppShadows.card,
                ),
                child: Text(
                  brands[i],
                  style: GoogleFontsHelper.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _HeroBanner {
  final String title, subtitle, image;
  final List<Color> gradient;
  _HeroBanner({
    required this.title,
    required this.subtitle,
    required this.image,
    required this.gradient,
  });
}

class _SmallButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final bool filled;
  const _SmallButton({
    required this.text,
    required this.onTap,
    required this.filled,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: filled ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: filled ? null : Border.all(color: Colors.white70),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: filled ? AppColors.primary : Colors.white,
          ),
        ),
      ),
    );
  }
}
