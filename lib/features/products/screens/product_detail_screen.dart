import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/providers.dart';
import '../../../core/utils/mock_data.dart';
import '../../../core/widgets/shared_widgets.dart';

class ProductDetailScreen extends StatefulWidget {
  final String productId;
  const ProductDetailScreen({super.key, required this.productId});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _imageIndex = 0;
  String? _selectedSize;
  String? _selectedColor;
  int _quantity = 1;
  bool _descExpanded = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductsProvider>().loadProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final productsProvider = context.watch<ProductsProvider>();
    final product =
        productsProvider.getProductById(widget.productId) ??
        MockData.products.firstWhere(
          (p) => p.id == widget.productId,
          orElse: () => MockData.products.first,
        );
    final cart = context.watch<CartProvider>();
    final wishlist = context.watch<WishlistProvider>();
    final isWishlisted = wishlist.isInWishlist(product.id);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              // Image gallery
              SliverAppBar(
                expandedHeight: 420,
                pinned: true,
                backgroundColor: AppColors.background,
                leading: _buildBackButton(context),
                actions: [
                  _buildWishlistButton(wishlist, isWishlisted, product),
                  _buildShareButton(),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: _buildImageGallery(product),
                ),
              ),

              // Content
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product header
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.surfaceVariant,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  product.brand,
                                  style: GoogleFontsHelper.inter(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ),
                              const Spacer(),
                              if (product.aiTryOnEnabled)
                                AiTryOnBadge(
                                  onTap: () {
                                    context
                                        .read<AiTryOnProvider>()
                                        .setSelectedProduct(product);
                                    context.go('/ai-tryon');
                                  },
                                ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            product.name,
                            style: AppTextStyles.elegantTitle.copyWith(
                              fontSize: 22,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              RatingWidget(
                                rating: product.rating,
                                reviewCount: product.reviewCount,
                              ),
                              const SizedBox(width: 12),
                              GestureDetector(
                                onTap: () => _showReviews(context, product.id),
                                child: Text(
                                  'See all reviews',
                                  style: GoogleFontsHelper.inter(
                                    fontSize: 12,
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          // Price
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '₹${_fmt(product.discountedPrice)}',
                                style: AppTextStyles.price.copyWith(
                                  fontSize: 26,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                '₹${_fmt(product.price)}',
                                style: AppTextStyles.originalPrice,
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.success.withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  '${product.discountPercent}% OFF',
                                  style: AppTextStyles.discount,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),
                    const Divider(indent: 16, endIndent: 16),
                    const SizedBox(height: 16),

                    // Size selector
                    _buildSizeSelector(product),
                    const SizedBox(height: 20),

                    // Color selector
                    _buildColorSelector(product),
                    const SizedBox(height: 20),

                    // Quantity
                    _buildQuantitySelector(),
                    const SizedBox(height: 20),

                    // Delivery info
                    _buildDeliveryInfo(),
                    const SizedBox(height: 20),

                    // Description
                    _buildDescription(product),
                    const SizedBox(height: 20),

                    // Product details
                    _buildProductDetails(product),
                    const SizedBox(height: 24),

                    // Complete the look
                    _buildCompleteTheLook(),
                    const SizedBox(height: 120),
                  ],
                ),
              ),
            ],
          ),

          // Bottom actions
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildBottomActions(context, product, cart),
          ),
        ],
      ),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: CircleAvatar(
        backgroundColor: Colors.white.withOpacity(0.9),
        radius: 18,
        child: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            size: 16,
            color: AppColors.textPrimary,
          ),
          onPressed: () => context.pop(),
        ),
      ),
    );
  }

  Widget _buildWishlistButton(
    WishlistProvider wishlist,
    bool isWishlisted,
    product,
  ) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: CircleAvatar(
        backgroundColor: Colors.white.withOpacity(0.9),
        radius: 18,
        child: IconButton(
          icon: Icon(
            isWishlisted ? Icons.favorite : Icons.favorite_border,
            size: 18,
            color: isWishlisted ? AppColors.primary : AppColors.textPrimary,
          ),
          onPressed: () => wishlist.toggle(product),
        ),
      ),
    );
  }

  Widget _buildShareButton() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: CircleAvatar(
        backgroundColor: Colors.white.withOpacity(0.9),
        radius: 18,
        child: IconButton(
          icon: const Icon(
            Icons.share_outlined,
            size: 18,
            color: AppColors.textPrimary,
          ),
          onPressed: () {},
        ),
      ),
    );
  }

  Widget _buildImageGallery(product) {
    return Stack(
      children: [
        PageView.builder(
          itemCount: product.images.length,
          onPageChanged: (i) => setState(() => _imageIndex = i),
          itemBuilder: (_, i) => GestureDetector(
            onTap: () => _openFullscreen(context, product.images, i),
            child: AppNetworkImage(url: product.images[i], fit: BoxFit.cover),
          ),
        ),
        // Image indicators
        Positioned(
          bottom: 16,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              product.images.length,
              (i) => AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: _imageIndex == i ? 20 : 6,
                height: 6,
                decoration: BoxDecoration(
                  color: _imageIndex == i
                      ? AppColors.primary
                      : Colors.white.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSizeSelector(product) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Select Size',
                style: GoogleFontsHelper.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () => _showSizeGuide(context),
                child: Text(
                  'Size Guide',
                  style: GoogleFontsHelper.inter(
                    fontSize: 12,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: product.sizes
                .map<Widget>(
                  (size) => GestureDetector(
                    onTap: () => setState(() => _selectedSize = size),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: _selectedSize == size
                            ? AppColors.primary
                            : AppColors.surface,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: _selectedSize == size
                              ? AppColors.primary
                              : AppColors.divider,
                        ),
                      ),
                      child: Text(
                        size,
                        style: GoogleFontsHelper.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: _selectedSize == size
                              ? Colors.white
                              : AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildColorSelector(product) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select Color',
            style: GoogleFontsHelper.inter(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: product.colors
                .map<Widget>(
                  (color) => GestureDetector(
                    onTap: () => setState(() => _selectedColor = color),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: _selectedColor == color
                            ? AppColors.primary.withOpacity(0.1)
                            : AppColors.surface,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: _selectedColor == color
                              ? AppColors.primary
                              : AppColors.divider,
                          width: _selectedColor == color ? 1.5 : 1,
                        ),
                      ),
                      child: Text(
                        color,
                        style: GoogleFontsHelper.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: _selectedColor == color
                              ? AppColors.primary
                              : AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildQuantitySelector() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Text(
            'Quantity',
            style: GoogleFontsHelper.inter(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const Spacer(),
          Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.divider),
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.remove, size: 18),
                  onPressed: () {
                    if (_quantity > 1) setState(() => _quantity--);
                  },
                ),
                Text(
                  '$_quantity',
                  style: GoogleFontsHelper.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add, size: 18),
                  onPressed: () => setState(() => _quantity++),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeliveryInfo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.success.withOpacity(0.06),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.success.withOpacity(0.2)),
        ),
        child: Column(
          children: [
            _buildInfoRow(
              Icons.local_shipping_outlined,
              'Free Delivery',
              'On orders above ₹2,000',
              AppColors.success,
            ),
            const SizedBox(height: 8),
            _buildInfoRow(
              Icons.replay_outlined,
              '30-Day Returns',
              'Easy returns & exchanges',
              AppColors.info,
            ),
            const SizedBox(height: 8),
            _buildInfoRow(
              Icons.verified_outlined,
              '100% Authentic',
              'Verified designer products',
              AppColors.primary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String title, String sub, Color color) {
    return Row(
      children: [
        Icon(icon, color: color, size: 18),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFontsHelper.inter(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
            Text(sub, style: AppTextStyles.caption),
          ],
        ),
      ],
    );
  }

  Widget _buildDescription(product) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Description',
            style: GoogleFontsHelper.inter(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            product.description,
            style: AppTextStyles.caption.copyWith(fontSize: 14, height: 1.6),
            maxLines: _descExpanded ? null : 3,
            overflow: _descExpanded ? null : TextOverflow.ellipsis,
          ),
          GestureDetector(
            onTap: () => setState(() => _descExpanded = !_descExpanded),
            child: Text(
              _descExpanded ? 'Show less' : 'Read more',
              style: GoogleFontsHelper.inter(
                fontSize: 13,
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductDetails(product) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Product Details',
            style: GoogleFontsHelper.inter(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          _buildDetailRow('Material', product.material),
          _buildDetailRow('Fabric', product.fabric),
          _buildDetailRow('Occasion', product.occasion),
          _buildDetailRow('Gender', product.gender),
          if (product.sku != null) _buildDetailRow('SKU', product.sku!),
          if (product.careInstructions.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              'Care Instructions',
              style: GoogleFontsHelper.inter(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            ...product.careInstructions.map(
              (c) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  children: [
                    const Icon(
                      Icons.info_outline,
                      size: 14,
                      color: AppColors.textTertiary,
                    ),
                    const SizedBox(width: 6),
                    Text(c, style: AppTextStyles.caption),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDetailRow(String key, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(width: 100, child: Text(key, style: AppTextStyles.caption)),
          Expanded(
            child: Text(
              value,
              style: GoogleFontsHelper.inter(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompleteTheLook() {
    final related = MockData.products
        .where((p) => p.id != widget.productId)
        .take(4)
        .toList();
    return Column(
      children: [
        SectionHeader(title: 'Complete The Look', subtitle: 'Pair it with'),
        const SizedBox(height: 12),
        SizedBox(
          height: 300,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: related.length,
            itemBuilder: (_, i) => Padding(
              padding: const EdgeInsets.only(right: 12),
              child: SizedBox(
                width: 170,
                child: ProductCard(product: related[i]),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomActions(BuildContext context, product, CartProvider cart) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: AppShadows.navbar,
      ),
      child: Row(
        children: [
          // AI Try-On
          if (product.aiTryOnEnabled)
            Expanded(
              child: SecondaryButton(
                text: '✨ Try On',
                onPressed: () {
                  context.read<AiTryOnProvider>().setSelectedProduct(product);
                  context.go('/ai-tryon');
                },
              ),
            ),
          if (product.aiTryOnEnabled) const SizedBox(width: 10),
          // Add to Cart
          Expanded(
            child: PrimaryButton(
              text: 'Add to Cart',
              icon: Icons.shopping_bag_outlined,
              onPressed: () => _addToCart(context, product, cart),
            ),
          ),
        ],
      ),
    );
  }

  void _addToCart(BuildContext context, product, CartProvider cart) {
    if (_selectedSize == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a size'),
          backgroundColor: AppColors.warning,
        ),
      );
      return;
    }
    cart.addItem(
      product,
      size: _selectedSize!,
      color: _selectedColor ?? product.colors.first,
      qty: _quantity,
    );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Added to cart!'),
        action: SnackBarAction(
          label: 'View Cart',
          onPressed: () => context.push('/cart'),
        ),
      ),
    );
  }

  void _openFullscreen(BuildContext context, List<String> images, int initial) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            leading: const CloseButton(color: Colors.white),
          ),
          body: PhotoViewGallery.builder(
            itemCount: images.length,
            pageController: PageController(initialPage: initial),
            builder: (_, i) {
              final img = images[i];
              final ImageProvider imageProvider;
              if (img.startsWith('assets/')) {
                imageProvider = AssetImage(img);
              } else if (img.startsWith('http://') ||
                  img.startsWith('https://')) {
                imageProvider = CachedNetworkImageProvider(img);
              } else if (!kIsWeb &&
                  (img.startsWith('/') || img.startsWith('file://'))) {
                final path = img.startsWith('file://')
                    ? img.replaceFirst('file://', '')
                    : img;
                imageProvider = FileImage(File(path));
              } else {
                imageProvider = const AssetImage(
                  'assets/images/bridal/panetar_01.png',
                );
              }
              return PhotoViewGalleryPageOptions(
                imageProvider: imageProvider,
                minScale: PhotoViewComputedScale.contained,
              );
            },
          ),
        ),
      ),
    );
  }

  void _showSizeGuide(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Size Guide', style: AppTextStyles.sectionTitle),
            const SizedBox(height: 16),
            Table(
              border: TableBorder.all(color: AppColors.divider),
              children: const [
                TableRow(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Text(
                        'Size',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Text(
                        'Bust (in)',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Text(
                        'Waist (in)',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    Padding(padding: EdgeInsets.all(8), child: Text('XS')),
                    Padding(padding: EdgeInsets.all(8), child: Text('32')),
                    Padding(padding: EdgeInsets.all(8), child: Text('26')),
                  ],
                ),
                TableRow(
                  children: [
                    Padding(padding: EdgeInsets.all(8), child: Text('S')),
                    Padding(padding: EdgeInsets.all(8), child: Text('34')),
                    Padding(padding: EdgeInsets.all(8), child: Text('28')),
                  ],
                ),
                TableRow(
                  children: [
                    Padding(padding: EdgeInsets.all(8), child: Text('M')),
                    Padding(padding: EdgeInsets.all(8), child: Text('36')),
                    Padding(padding: EdgeInsets.all(8), child: Text('30')),
                  ],
                ),
                TableRow(
                  children: [
                    Padding(padding: EdgeInsets.all(8), child: Text('L')),
                    Padding(padding: EdgeInsets.all(8), child: Text('38')),
                    Padding(padding: EdgeInsets.all(8), child: Text('32')),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showReviews(BuildContext context, String productId) {
    final reviews = MockData.sampleReviews
        .where((r) => r.productId == productId)
        .toList();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.95,
        minChildSize: 0.4,
        builder: (_, ctrl) => Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.divider,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              Text('Customer Reviews', style: AppTextStyles.sectionTitle),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.separated(
                  controller: ctrl,
                  itemCount: reviews.length,
                  separatorBuilder: (_, __) => const Divider(),
                  itemBuilder: (_, i) {
                    final r = reviews[i];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: AppColors.primary.withOpacity(
                                  0.12,
                                ),
                                radius: 18,
                                child: Text(
                                  r.userName[0],
                                  style: GoogleFontsHelper.inter(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    r.userName,
                                    style: GoogleFontsHelper.inter(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13,
                                    ),
                                  ),
                                  RatingWidget(rating: r.rating, size: 12),
                                ],
                              ),
                              const Spacer(),
                              if (r.isVerified)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.success.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: const Text(
                                    '✓ Verified',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: AppColors.success,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            r.comment,
                            style: AppTextStyles.caption.copyWith(
                              fontSize: 13,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _fmt(double price) => price
      .toStringAsFixed(0)
      .replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (m) => '${m[1]},',
      );
}
