import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/mock_data.dart';
import '../../../core/utils/models.dart';
import '../../../core/widgets/shared_widgets.dart';

class SearchScreen extends StatefulWidget {
  final String? query;
  const SearchScreen({super.key, this.query});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late TextEditingController _searchCtrl;
  String _currentQuery = '';
  String _selectedOccasion = 'All';
  String _selectedGender = 'All';
  final RangeValues _priceRange = const RangeValues(0, 250000);

  final List<String> _recentSearches = [
    'Bridal Lehenga',
    'Silk Saree',
    'Kundan Choker',
    'Mehendi Outfits',
    'Pastel Pink',
  ];

  final List<String> _trendingSearches = [
    '✨ Velvet Sabyasachi Lehenga',
    '👑 Royal Bridal Lehenga',
    '💛 Yellow Haldi Sharara',
    '💚 Emerald Polki Jewelry',
    '💎 Cocktail Evening Gown',
    '🌸 Floral Organza Saree',
  ];

  @override
  void initState() {
    super.initState();
    _currentQuery = widget.query ?? '';
    _searchCtrl = TextEditingController(text: _currentQuery);
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  List<Product> _getFilteredProducts() {
    if (_currentQuery.trim().isEmpty &&
        _selectedOccasion == 'All' &&
        _selectedGender == 'All') {
      return [];
    }

    return mockProducts.where((p) {
      final matchesQuery =
          _currentQuery.isEmpty ||
          p.name.toLowerCase().contains(_currentQuery.toLowerCase()) ||
          p.brand.toLowerCase().contains(_currentQuery.toLowerCase()) ||
          p.description.toLowerCase().contains(_currentQuery.toLowerCase()) ||
          p.occasions.any(
            (o) => o.toLowerCase().contains(_currentQuery.toLowerCase()),
          );

      final matchesOccasion =
          _selectedOccasion == 'All' || p.occasions.contains(_selectedOccasion);
      final matchesGender =
          _selectedGender == 'All' ||
          p.gender.toLowerCase() == _selectedGender.toLowerCase();
      final matchesPrice =
          p.price >= _priceRange.start && p.price <= _priceRange.end;

      return matchesQuery && matchesOccasion && matchesGender && matchesPrice;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final results = _getFilteredProducts();
    final hasActiveSearch =
        _currentQuery.isNotEmpty ||
        _selectedOccasion != 'All' ||
        _selectedGender != 'All';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        titleSpacing: 0,
        title: Container(
          height: 44,
          margin: const EdgeInsets.only(right: 16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: TextField(
            controller: _searchCtrl,
            autofocus: widget.query == null,
            textInputAction: TextInputAction.search,
            onChanged: (val) => setState(() => _currentQuery = val),
            onSubmitted: (val) => setState(() => _currentQuery = val),
            decoration: InputDecoration(
              hintText: 'Search lehengas, sarees, jewelry...',
              hintStyle: AppTextStyles.caption.copyWith(fontSize: 13),
              prefixIcon: const Icon(
                Icons.search,
                color: AppColors.textSecondary,
                size: 20,
              ),
              suffixIcon: _searchCtrl.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(
                        Icons.clear,
                        size: 18,
                        color: AppColors.textSecondary,
                      ),
                      onPressed: () {
                        _searchCtrl.clear();
                        setState(() => _currentQuery = '');
                      },
                    )
                  : null,
              contentPadding: const EdgeInsets.symmetric(vertical: 10),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // Filter Row
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: const BoxDecoration(
              color: AppColors.surface,
              border: Border(bottom: BorderSide(color: AppColors.border)),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildDropdownChip(
                    label: 'Occasion: $_selectedOccasion',
                    onTap: () => _showOccasionPicker(),
                  ),
                  const SizedBox(width: 8),
                  _buildDropdownChip(
                    label: 'Gender: $_selectedGender',
                    onTap: () => _showGenderPicker(),
                  ),
                  const SizedBox(width: 8),
                  _buildDropdownChip(
                    label: 'Try-On Ready ✨',
                    isSelected: false,
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ),

          // Content
          Expanded(
            child: !hasActiveSearch
                ? _buildDiscoveryView()
                : results.isEmpty
                ? const EmptyStateWidget(
                    icon: Icons.search_off,
                    title: 'No Matching Styles Found',
                    subtitle:
                        'Try searching with general keywords like "Lehenga", "Saree", "Kundan" or clear your filters.',
                  )
                : _buildResultsGrid(results),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownChip({
    required String label,
    bool isSelected = false,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.1)
              : AppColors.background,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: GoogleFontsHelper.inter(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isSelected ? AppColors.primary : AppColors.textPrimary,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(
              Icons.arrow_drop_down,
              size: 16,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDiscoveryView() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Recent Searches
        if (_recentSearches.isNotEmpty) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Searches',
                style: AppTextStyles.sectionTitle.copyWith(fontSize: 15),
              ),
              TextButton(
                onPressed: () => setState(() => _recentSearches.clear()),
                child: const Text(
                  'Clear',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _recentSearches.map((term) {
              return ActionChip(
                label: Text(term),
                backgroundColor: AppColors.surface,
                labelStyle: GoogleFontsHelper.inter(
                  fontSize: 12,
                  color: AppColors.textPrimary,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: const BorderSide(color: AppColors.border),
                ),
                onPressed: () {
                  _searchCtrl.text = term;
                  setState(() => _currentQuery = term);
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
        ],

        // Trending Searches
        Text(
          'Trending Wedding Searches 🔥',
          style: AppTextStyles.sectionTitle.copyWith(fontSize: 15),
        ),
        const SizedBox(height: 12),
        ..._trendingSearches.map((term) {
          final cleanTerm = term.replaceAll(RegExp(r'^[^\w\s]+\s*'), '');
          return ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(
              Icons.trending_up,
              color: AppColors.primary,
              size: 18,
            ),
            title: Text(
              term,
              style: GoogleFontsHelper.inter(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            trailing: const Icon(
              Icons.north_west,
              size: 14,
              color: AppColors.textLight,
            ),
            onTap: () {
              _searchCtrl.text = cleanTerm;
              setState(() => _currentQuery = cleanTerm);
            },
          );
        }),
      ],
    );
  }

  Widget _buildResultsGrid(List<Product> results) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Text(
            '${results.length} styles found for "$_currentQuery"',
            style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.w600),
          ),
        ),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.58,
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
            ),
            itemCount: results.length,
            itemBuilder: (context, index) {
              return ProductCard(product: results[index]);
            },
          ),
        ),
      ],
    );
  }

  void _showOccasionPicker() {
    final occasions = [
      'All',
      'Wedding',
      'Sangeet',
      'Mehendi',
      'Haldi',
      'Reception',
      'Engagement',
    ];
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Column(
        mainAxisSize: MainAxisSize.min,
        children: occasions.map((occ) {
          return ListTile(
            title: Text(
              occ,
              style: TextStyle(
                fontWeight: _selectedOccasion == occ
                    ? FontWeight.w700
                    : FontWeight.w500,
              ),
            ),
            trailing: _selectedOccasion == occ
                ? const Icon(Icons.check, color: AppColors.primary)
                : null,
            onTap: () {
              setState(() => _selectedOccasion = occ);
              Navigator.pop(ctx);
            },
          );
        }).toList(),
      ),
    );
  }

  void _showGenderPicker() {
    final genders = ['All', 'Women', 'Accessories'];
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Column(
        mainAxisSize: MainAxisSize.min,
        children: genders.map((g) {
          return ListTile(
            title: Text(
              g,
              style: TextStyle(
                fontWeight: _selectedGender == g
                    ? FontWeight.w700
                    : FontWeight.w500,
              ),
            ),
            trailing: _selectedGender == g
                ? const Icon(Icons.check, color: AppColors.primary)
                : null,
            onTap: () {
              setState(() => _selectedGender = g);
              Navigator.pop(ctx);
            },
          );
        }).toList(),
      ),
    );
  }
}
