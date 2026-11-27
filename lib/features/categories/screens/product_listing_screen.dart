import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/providers.dart';
import '../../../core/widgets/shared_widgets.dart';

class ProductListingScreen extends StatefulWidget {
  final String categoryId;
  final String categoryName;
  const ProductListingScreen({super.key, required this.categoryId, required this.categoryName});

  @override
  State<ProductListingScreen> createState() => _ProductListingScreenState();
}

class _ProductListingScreenState extends State<ProductListingScreen> {
  String _sortBy = 'popular';
  bool _showFilters = false;
  RangeValues _priceRange = const RangeValues(0, 50000);
  String? _selectedGender;
  String? _selectedOccasion;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductsProvider>().loadProducts(
        categoryId: widget.categoryId == 'all' ? null : widget.categoryId,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProductsProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(widget.categoryName, style: const TextStyle(fontFamily: 'Cormorant', fontSize: 20, fontWeight: FontWeight.w700)),
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () => context.push('/search')),
          IconButton(
            icon: Icon(_showFilters ? Icons.filter_list_off : Icons.filter_list, color: _showFilters ? AppColors.primary : null),
            onPressed: () => setState(() => _showFilters = !_showFilters),
          ),
        ],
      ),
      body: Column(
        children: [
          // Sort & Filter bar
          _buildSortBar(provider),
          // Filter panel
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 300),
            firstChild: _buildFilterPanel(),
            secondChild: const SizedBox.shrink(),
            crossFadeState: _showFilters ? CrossFadeState.showFirst : CrossFadeState.showSecond,
          ),
          // Product count
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Text(
                  '${provider.filteredProducts.length} products found',
                  style: GoogleFontsHelper.inter(fontSize: 13, color: AppColors.textTertiary),
                ),
              ],
            ),
          ),
          // Grid
          Expanded(
            child: provider.isLoading
              ? _buildShimmerGrid()
              : provider.filteredProducts.isEmpty
                ? const EmptyStateWidget(
                    emoji: '🔍',
                    title: 'No Products Found',
                    subtitle: 'Try adjusting your filters or search for something else.',
                  )
                : GridView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.52,
                    ),
                    itemCount: provider.filteredProducts.length,
                    itemBuilder: (_, i) => ProductCard(product: provider.filteredProducts[i]),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildSortBar(ProductsProvider provider) {
    return Container(
      height: 48,
      color: AppColors.surface,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          _SortChip('Popular', 'popular', _sortBy, (v) { setState(() => _sortBy = v); provider.sortProducts(v); }),
          _SortChip('Newest', 'newest', _sortBy, (v) { setState(() => _sortBy = v); provider.sortProducts(v); }),
          _SortChip('Price ↑', 'price_low', _sortBy, (v) { setState(() => _sortBy = v); provider.sortProducts(v); }),
          _SortChip('Price ↓', 'price_high', _sortBy, (v) { setState(() => _sortBy = v); provider.sortProducts(v); }),
          _SortChip('Rating', 'rating', _sortBy, (v) { setState(() => _sortBy = v); provider.sortProducts(v); }),
        ],
      ),
    );
  }

  Widget _buildFilterPanel() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: AppColors.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Price Range', style: GoogleFontsHelper.inter(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
          RangeSlider(
            values: _priceRange,
            min: 0, max: 50000,
            divisions: 100,
            activeColor: AppColors.primary,
            labels: RangeLabels('₹${_priceRange.start.round()}', '₹${_priceRange.end.round()}'),
            onChanged: (v) => setState(() => _priceRange = v),
            onChangeEnd: (_) => context.read<ProductsProvider>().applyFilters(
              minPrice: _priceRange.start, maxPrice: _priceRange.end,
            ),
          ),
          Row(
            children: [
              Text('Occasion:', style: GoogleFontsHelper.inter(fontSize: 13, fontWeight: FontWeight.w600)),
              const SizedBox(width: 8),
              ...['Wedding', 'Engagement', 'Mehendi'].map((o) => Padding(
                padding: const EdgeInsets.only(right: 6),
                child: FilterChip(
                  label: Text(o, style: const TextStyle(fontSize: 11)),
                  selected: _selectedOccasion == o,
                  onSelected: (_) {
                    setState(() => _selectedOccasion = _selectedOccasion == o ? null : o);
                    context.read<ProductsProvider>().applyFilters(occasion: _selectedOccasion);
                  },
                  selectedColor: AppColors.primary.withOpacity(0.1),
                  checkmarkColor: AppColors.primary,
                ),
              )),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 0.6,
      ),
      itemCount: 6,
      itemBuilder: (_, __) => const ProductCardShimmer(),
    );
  }
}

class _SortChip extends StatelessWidget {
  final String label, value, current;
  final void Function(String) onSelect;
  const _SortChip(this.label, this.value, this.current, this.onSelect);

  @override
  Widget build(BuildContext context) {
    final isSelected = current == value;
    return Padding(
      padding: const EdgeInsets.only(right: 8, top: 6, bottom: 6),
      child: GestureDetector(
        onTap: () => onSelect(value),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: isSelected ? AppColors.primary : AppColors.divider),
          ),
          child: Center(child: Text(label, style: GoogleFontsHelper.inter(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            color: isSelected ? Colors.white : AppColors.textSecondary,
          ))),
        ),
      ),
    );
  }
}
