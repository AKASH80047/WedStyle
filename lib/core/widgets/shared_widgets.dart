import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../utils/models.dart';
import '../utils/providers.dart';

// =====================
// PRODUCT CARD
// =====================
class ProductCard extends StatefulWidget {
  final ProductModel product;
  final VoidCallback? onTap;
  final bool showTryOn;

  const ProductCard({
    super.key,
    required this.product,
    this.onTap,
    this.showTryOn = true,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final wishlist = context.watch<WishlistProvider>();
    final isWishlisted = wishlist.isInWishlist(widget.product.id);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap ?? () => context.push('/product/${widget.product.id}'),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          transform: Matrix4.identity()..translate(0.0, _isHovered ? -4.0 : 0.0),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(
              color: _isHovered
                  ? AppColors.royalGold.withValues(alpha: 0.6)
                  : AppColors.divider.withValues(alpha: 0.6),
              width: _isHovered ? 1.5 : 1.0,
            ),
            boxShadow: _isHovered
                ? [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.14),
                      blurRadius: 18,
                      offset: const Offset(0, 8),
                    ),
                    BoxShadow(
                      color: AppColors.royalGold.withValues(alpha: 0.12),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image (Flexible/Expanded)
              Expanded(
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    AppNetworkImage(
                      url: widget.product.images.first,
                      fit: BoxFit.cover,
                    ),
                    // Discount badge (Gold / Emerald Luxury Pill)
                    if (widget.product.discountPercent > 0)
                      Positioned(
                        top: 8,
                        left: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3.5),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFBA1828), Color(0xFF7A1C2C)],
                            ),
                            borderRadius: BorderRadius.circular(6),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.2),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                          child: Text(
                            '${widget.product.discountPercent}% OFF',
                            style: AppTextStyles.badge.copyWith(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    // Wishlist button
                    Positioned(
                      top: 7,
                      right: 7,
                      child: GestureDetector(
                        onTap: () => wishlist.toggle(widget.product),
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.95),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.12),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Icon(
                              isWishlisted ? Icons.favorite : Icons.favorite_border,
                              color: isWishlisted ? AppColors.deepKanku : AppColors.textTertiary,
                              size: 17,
                            ),
                          ),
                        ),
                      ),
                    ),
                    // AI Try-On Luxury Shimmer Pill
                    if (widget.showTryOn && widget.product.aiTryOnEnabled)
                      Positioned(
                        bottom: 8,
                        left: 8,
                        right: 8,
                        child: GestureDetector(
                          onTap: () {
                            context.read<AiTryOnProvider>().setSelectedProduct(widget.product);
                            context.go('/ai-tryon');
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 5.5),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  AppColors.primary.withValues(alpha: 0.95),
                                  const Color(0xFF9E2A3E).withValues(alpha: 0.95),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: AppColors.royalGold.withValues(alpha: 0.7),
                                width: 1,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primary.withValues(alpha: 0.35),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.auto_awesome, color: AppColors.royalGold, size: 13),
                                const SizedBox(width: 5),
                                Text(
                                  'AI Try-On',
                                  style: AppTextStyles.badge.copyWith(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.3,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              // Product Info
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.product.brand.toUpperCase(),
                      style: GoogleFontsHelper.inter(
                        fontSize: 9.5,
                        color: AppColors.textTertiary,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      widget.product.name,
                      style: AppTextStyles.productName.copyWith(
                        fontSize: 12.5,
                        height: 1.25,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1.5),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF6DF),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.star, color: AppColors.star, size: 11),
                              const SizedBox(width: 2.5),
                              Text(
                                widget.product.rating.toString(),
                                style: GoogleFontsHelper.inter(
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF8A6000),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          '(${widget.product.reviewCount})',
                          style: GoogleFontsHelper.inter(
                            fontSize: 10,
                            color: AppColors.textTertiary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        Text(
                          '₹${_formatPrice(widget.product.discountedPrice)}',
                          style: AppTextStyles.price.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '₹${_formatPrice(widget.product.price)}',
                          style: AppTextStyles.originalPrice.copyWith(
                            fontSize: 10.5,
                            decoration: TextDecoration.lineThrough,
                            color: AppColors.textHint,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShimmer() {
    return Shimmer.fromColors(
      baseColor: AppColors.shimmerBase,
      highlightColor: AppColors.shimmerHighlight,
      child: Container(color: AppColors.shimmerBase),
    );
  }

  String _formatPrice(double price) {
    if (price >= 1000) {
      return price.toStringAsFixed(0).replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (m) => '${m[1]},',
      );
    }
    return price.toStringAsFixed(0);
  }
}

// =====================
// SECTION HEADER
// =====================
class SectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final VoidCallback? onSeeAll;
  final String? seeAllText;

  const SectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.onSeeAll,
    this.seeAllText = 'See All',
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.sectionTitle),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(subtitle!, style: AppTextStyles.caption),
                ],
              ],
            ),
          ),
          if (onSeeAll != null)
            TextButton(
              onPressed: onSeeAll,
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              ),
              child: Row(
                children: [
                  Text(seeAllText!, style: GoogleFontsHelper.inter(fontSize: 13, color: AppColors.primary, fontWeight: FontWeight.w600)),
                  const SizedBox(width: 2),
                  const Icon(Icons.arrow_forward_ios, size: 12, color: AppColors.primary),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

// =====================
// SHIMMER PRODUCT CARD
// =====================
class ProductCardShimmer extends StatelessWidget {
  const ProductCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.shimmerBase,
      highlightColor: AppColors.shimmerHighlight,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Container(
                decoration: const BoxDecoration(
                  color: AppColors.shimmerBase,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(height: 10, width: 80, color: AppColors.shimmerBase),
                    const SizedBox(height: 6),
                    Container(height: 12, width: double.infinity, color: AppColors.shimmerBase),
                    const SizedBox(height: 4),
                    Container(height: 12, width: 120, color: AppColors.shimmerBase),
                    const SizedBox(height: 8),
                    Container(height: 16, width: 90, color: AppColors.shimmerBase),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =====================
// PRIMARY BUTTON
// =====================
class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;
  final double? width;
  final Color? backgroundColor;

  const PrimaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.icon,
    this.width,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: isLoading
            ? const SizedBox(
                width: 22, height: 22,
                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[Icon(icon, size: 20), const SizedBox(width: 8)],
                  Text(text, style: AppTextStyles.button.copyWith(color: Colors.white)),
                ],
              ),
      ),
    );
  }
}

// =====================
// SECONDARY BUTTON
// =====================
class SecondaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final double? width;

  const SecondaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: 52,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary, width: 1.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[Icon(icon, size: 20, color: AppColors.primary), const SizedBox(width: 8)],
            Text(text, style: AppTextStyles.button.copyWith(color: AppColors.primary)),
          ],
        ),
      ),
    );
  }
}

// =====================
// AI TRY-ON BANNER BUTTON
// =====================
class AiTryOnBadge extends StatelessWidget {
  final VoidCallback? onTap;
  final String label;

  const AiTryOnBadge({
    super.key,
    this.onTap,
    this.label = '✨ Try On',
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF6D1A36), Color(0xFFB76E79)],
            begin: Alignment.topLeft, end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(color: AppColors.primary.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 3)),
          ],
        ),
        child: Text(label, style: AppTextStyles.aiGlow.copyWith(color: Colors.white, fontSize: 12)),
      ),
    );
  }
}

typedef AppButton = PrimaryButton;

// =====================
// EMPTY STATE
// =====================
class EmptyStateWidget extends StatelessWidget {
  final String? emoji;
  final IconData? icon;
  final String title;
  final String subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;

  const EmptyStateWidget({
    super.key,
    this.emoji,
    this.icon,
    required this.title,
    required this.subtitle,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null)
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.08),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 56, color: AppColors.primary),
              )
            else
              Text(emoji ?? '👗', style: const TextStyle(fontSize: 72)),
            const SizedBox(height: 20),
            Text(title, style: AppTextStyles.sectionTitle, textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Text(subtitle, style: AppTextStyles.caption.copyWith(fontSize: 14), textAlign: TextAlign.center),
            if (actionLabel != null) ...[
              const SizedBox(height: 28),
              PrimaryButton(text: actionLabel!, onPressed: onAction, width: 200),
            ],
          ],
        ),
      ),
    );
  }
}

// =====================
// NETWORK & ASSET SMART IMAGE
// =====================
class AppNetworkImage extends StatelessWidget {
  final String url;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Alignment alignment;
  final BorderRadius? borderRadius;
  final Widget? placeholder;
  final Widget? errorWidget;

  const AppNetworkImage({
    super.key,
    required this.url,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.alignment = Alignment.center,
    this.borderRadius,
    this.placeholder,
    this.errorWidget,
  });

  @override
  Widget build(BuildContext context) {
    Widget imageWidget;
    final cleanUrl = url.trim();

    if (cleanUrl.isEmpty) {
      imageWidget = _buildFallback();
    } else if (cleanUrl.startsWith('assets/')) {
      imageWidget = Image.asset(
        cleanUrl,
        width: width,
        height: height,
        fit: fit,
        alignment: alignment,
        errorBuilder: (_, __, ___) => _buildFallback(),
      );
    } else if (cleanUrl.startsWith('http://') || cleanUrl.startsWith('https://')) {
      imageWidget = CachedNetworkImage(
        imageUrl: cleanUrl,
        width: width,
        height: height,
        fit: fit,
        alignment: alignment,
        placeholder: (_, __) =>
            placeholder ??
            Shimmer.fromColors(
              baseColor: AppColors.shimmerBase,
              highlightColor: AppColors.shimmerHighlight,
              child: Container(
                color: AppColors.shimmerBase,
                width: width,
                height: height,
              ),
            ),
        errorWidget: (_, __, ___) => errorWidget ?? _buildFallback(),
      );
    } else if (cleanUrl.startsWith('blob:')) {
      imageWidget = Image.network(
        cleanUrl,
        width: width,
        height: height,
        fit: fit,
        alignment: alignment,
        errorBuilder: (_, __, ___) => _buildFallback(),
      );
    } else if (cleanUrl.startsWith('data:image')) {
      try {
        final commaIdx = cleanUrl.indexOf(',');
        final base64Str =
            commaIdx != -1 ? cleanUrl.substring(commaIdx + 1) : cleanUrl;
        imageWidget = Image.memory(
          base64Decode(base64Str),
          width: width,
          height: height,
          fit: fit,
          alignment: alignment,
          errorBuilder: (_, __, ___) => _buildFallback(),
        );
      } catch (_) {
        imageWidget = _buildFallback();
      }
    } else if (!kIsWeb && (cleanUrl.startsWith('/') || cleanUrl.startsWith('file:'))) {
      final filePath = cleanUrl.startsWith('file://') ? cleanUrl.replaceFirst('file://', '') : cleanUrl;
      final file = File(filePath);
      if (file.existsSync()) {
        imageWidget = Image.file(
          file,
          width: width,
          height: height,
          fit: fit,
          alignment: alignment,
          errorBuilder: (_, __, ___) => _buildFallback(),
        );
      } else {
        imageWidget = _buildFallback();
      }
    } else if (kIsWeb && cleanUrl.startsWith('/')) {
      imageWidget = Image.network(
        cleanUrl,
        width: width,
        height: height,
        fit: fit,
        alignment: alignment,
        errorBuilder: (_, __, ___) => _buildFallback(),
      );
    } else {
      // Fallback for relative or unknown paths
      imageWidget = _buildFallback();
    }

    if (borderRadius != null) {
      return ClipRRect(borderRadius: borderRadius!, child: imageWidget);
    }
    return imageWidget;
  }

  Widget _buildFallback() {
    return Container(
      width: width,
      height: height,
      color: AppColors.surfaceVariant,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.spa_outlined,
              color: AppColors.primary.withValues(alpha: 0.4),
              size: (height != null && height! < 60) ? 18 : 28,
            ),
            if (height == null || height! >= 60) ...[
              const SizedBox(height: 4),
              Text(
                'WedStyle',
                style: GoogleFontsHelper.cormorant(
                  fontSize: 10,
                  color: AppColors.textTertiary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// =====================
// RATING WIDGET
// =====================
class RatingWidget extends StatelessWidget {
  final double rating;
  final int reviewCount;
  final double size;

  const RatingWidget({
    super.key,
    required this.rating,
    this.reviewCount = 0,
    this.size = 14,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...List.generate(5, (index) {
          final filled = (index + 1) <= rating;
          final half = !filled && (index < rating);
          return Icon(
            filled ? Icons.star : (half ? Icons.star_half : Icons.star_border),
            color: AppColors.star,
            size: size,
          );
        }),
        const SizedBox(width: 4),
        Text(
          rating.toStringAsFixed(1),
          style: GoogleFontsHelper.inter(fontSize: size - 2, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
        ),
        if (reviewCount > 0)
          Text(
            ' ($reviewCount)',
            style: GoogleFontsHelper.inter(fontSize: size - 3, color: AppColors.textTertiary),
          ),
      ],
    );
  }
}

// =====================
// STATUS CHIP
// =====================
class StatusChip extends StatelessWidget {
  final String status;

  const StatusChip({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final (color, bg, label) = _getStatusProps(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(label, style: GoogleFontsHelper.inter(fontSize: 11, fontWeight: FontWeight.w600, color: color)),
    );
  }

  (Color, Color, String) _getStatusProps(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed': return (const Color(0xFF1565C0), const Color(0xFFE3F2FD), 'Confirmed');
      case 'processing': return (const Color(0xFFE65100), const Color(0xFFFFF3E0), 'Processing');
      case 'packed': return (const Color(0xFF6A1B9A), const Color(0xFFF3E5F5), 'Packed');
      case 'shipped': return (const Color(0xFF0277BD), const Color(0xFFE1F5FE), 'Shipped');
      case 'out for delivery': return (const Color(0xFF2E7D32), const Color(0xFFE8F5E9), 'Out for Delivery');
      case 'delivered': return (AppColors.success, const Color(0xFFE8F5E9), 'Delivered');
      case 'cancelled': return (AppColors.error, const Color(0xFFFFEBEE), 'Cancelled');
      case 'returned': return (AppColors.textTertiary, AppColors.surfaceVariant, 'Returned');
      default: return (AppColors.textTertiary, AppColors.surfaceVariant, status);
    }
  }
}

// =====================
// RESPONSIVE WRAPPER (FOR WEB & TABLET)
// =====================
class ResponsiveWrapper extends StatelessWidget {
  final Widget child;
  final double maxWidth;

  const ResponsiveWrapper({
    super.key,
    required this.child,
    this.maxWidth = 1240,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: child,
      ),
    );
  }
}


