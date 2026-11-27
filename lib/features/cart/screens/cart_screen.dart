import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/models.dart';
import '../../../core/utils/providers.dart';
import '../../../core/widgets/shared_widgets.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Row(children: [
          const Text('Shopping Cart', style: TextStyle(fontFamily: 'Cormorant', fontSize: 22, fontWeight: FontWeight.w700)),
          const SizedBox(width: 8),
          if (cart.itemCount > 0)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(12)),
              child: Text('${cart.itemCount}', style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700)),
            ),
        ]),
      ),
      body: cart.isEmpty
        ? EmptyStateWidget(
            emoji: '🛍️',
            title: 'Your Cart is Empty',
            subtitle: 'Discover beautiful wedding outfits and add them to your cart.',
            actionLabel: 'Start Shopping',
            onAction: () => context.go('/categories'),
          )
        : Column(
            children: [
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: cart.items.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (_, i) => _CartItemCard(item: cart.items[i], cart: cart),
                ),
              ),
              _buildCouponSection(context, cart),
              _buildPriceSummary(context, cart),
            ],
          ),
    );
  }

  Widget _buildCouponSection(BuildContext context, CartProvider cart) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: cart.appliedCoupon != null
        ? Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.success.withOpacity(0.08),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.success.withOpacity(0.3)),
            ),
            child: Row(children: [
              const Icon(Icons.local_offer, color: AppColors.success, size: 18),
              const SizedBox(width: 8),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Coupon "${cart.appliedCoupon}" Applied!', style: GoogleFontsHelper.inter(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.success)),
                Text('You save ₹${cart.couponDiscount.toStringAsFixed(0)}', style: AppTextStyles.caption),
              ])),
              IconButton(icon: const Icon(Icons.close, size: 16, color: AppColors.success), onPressed: () => cart.removeCoupon()),
            ]),
          )
        : GestureDetector(
            onTap: () => _showCouponSheet(context, cart),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.surface, borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.primary.withOpacity(0.3), style: BorderStyle.solid),
              ),
              child: Row(children: [
                const Icon(Icons.local_offer_outlined, color: AppColors.primary, size: 20),
                const SizedBox(width: 10),
                Text('Apply Coupon', style: GoogleFontsHelper.inter(fontSize: 14, color: AppColors.primary, fontWeight: FontWeight.w600)),
                const Spacer(),
                const Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.primary),
              ]),
            ),
          ),
    );
  }

  Widget _buildPriceSummary(BuildContext context, CartProvider cart) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 28),
      decoration: BoxDecoration(color: AppColors.surface, boxShadow: AppShadows.navbar),
      child: Column(
        children: [
          _PriceLine('Subtotal', '₹${cart.subtotal.toStringAsFixed(0)}'),
          if (cart.couponDiscount > 0) _PriceLine('Coupon Discount', '-₹${cart.couponDiscount.toStringAsFixed(0)}', color: AppColors.success),
          _PriceLine('Delivery', cart.deliveryCharge == 0 ? 'FREE' : '₹${cart.deliveryCharge.toStringAsFixed(0)}', color: cart.deliveryCharge == 0 ? AppColors.success : null),
          _PriceLine('Tax (5%)', '₹${cart.tax.toStringAsFixed(0)}'),
          const Divider(height: 16),
          _PriceLine('Total', '₹${cart.total.toStringAsFixed(0)}', isBold: true, large: true),
          const SizedBox(height: 14),
          PrimaryButton(
            text: 'Proceed to Checkout',
            icon: Icons.arrow_forward,
            onPressed: () => context.push('/checkout'),
          ),
        ],
      ),
    );
  }

  void _showCouponSheet(BuildContext context, CartProvider cart) {
    final ctrl = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => Padding(
        padding: EdgeInsets.fromLTRB(20, 20, 20, MediaQuery.of(context).viewInsets.bottom + 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Apply Coupon', style: AppTextStyles.sectionTitle),
            const SizedBox(height: 16),
            Row(children: [
              Expanded(child: TextFormField(controller: ctrl, decoration: const InputDecoration(
                labelText: 'Enter Coupon Code', prefixIcon: Icon(Icons.local_offer_outlined)))),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: () {
                  from_mock_data(ctrl.text.trim(), cart, context);
                  Navigator.pop(context);
                },
                child: const Text('Apply'),
              ),
            ]),
            const SizedBox(height: 20),
            Text('Available Coupons', style: GoogleFontsHelper.inter(fontSize: 14, fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            ...['WED10 - 10% off on ₹5000+', 'BRIDE20 - 20% off on ₹10000+', 'FIRSTORDER - 15% off on ₹2000+']
              .map((c) => ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
                  child: Text(c.split(' -')[0], style: GoogleFontsHelper.inter(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.primary)),
                ),
                title: Text(c.split('- ')[1], style: AppTextStyles.caption.copyWith(fontSize: 12)),
                trailing: TextButton(
                  onPressed: () {
                    ctrl.text = c.split(' -')[0];
                    from_mock_data(ctrl.text.trim(), cart, context);
                    Navigator.pop(context);
                  },
                  child: const Text('Apply'),
                ),
              )),
          ],
        ),
      ),
    );
  }

  void from_mock_data(String code, CartProvider cart, BuildContext context) {
    from_coupons_data(code, cart, context);
  }

  void from_coupons_data(String code, CartProvider cart, BuildContext context) {
    final coupons = {
      'WED10': {'type': 'percentage', 'value': 10.0, 'min': 5000.0, 'max': 2000.0},
      'BRIDE20': {'type': 'percentage', 'value': 20.0, 'min': 10000.0, 'max': 5000.0},
      'FIRSTORDER': {'type': 'percentage', 'value': 15.0, 'min': 2000.0, 'max': 1500.0},
      'GROOM15': {'type': 'percentage', 'value': 15.0, 'min': 8000.0, 'max': 3000.0},
    };
    final c = coupons[code.toUpperCase()];
    if (c == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Invalid coupon code'), backgroundColor: AppColors.error));
      return;
    }
    if (cart.subtotal < (c['min'] as double)) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Minimum order ₹${(c['min'] as double).toStringAsFixed(0)} required'),
        backgroundColor: AppColors.warning,
      ));
      return;
    }
    final disc = (cart.subtotal * (c['value'] as double) / 100).clamp(0, c['max'] as double).toDouble();
    cart.removeCoupon();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Coupon applied! You save ₹${disc.toStringAsFixed(0)}'), backgroundColor: AppColors.success),
    );
    // Simulate applying
    cart.applyCoupon(_buildCoupon(code, c));
  }

  _buildCoupon(String code, Map c) {
    return _MockCoupon(code: code, discount: c['value'] as double, min: c['min'] as double, max: c['max'] as double);
  }
}

class _MockCoupon {
  final String code; final double discount, min, max;
  _MockCoupon({required this.code, required this.discount, required this.min, required this.max});
  bool get isValid => true;
  double calculateDiscount(double amount) {
    if (amount < min) return 0;
    final d = amount * discount / 100;
    return d > max ? max : d;
  }
  String get discountType => 'percentage';
  double get discountValue => discount;
}

class _CartItemCard extends StatelessWidget {
  final CartItemModel item;
  final CartProvider cart;
  const _CartItemCard({required this.item, required this.cart});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface, borderRadius: BorderRadius.circular(16), boxShadow: AppShadows.card,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: AppNetworkImage(url: item.product.images.first, width: 88, height: 100),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.product.name, style: AppTextStyles.productName, maxLines: 2),
                const SizedBox(height: 4),
                Text('${item.selectedSize} • ${item.selectedColor}', style: AppTextStyles.caption),
                const SizedBox(height: 8),
                Text('₹${item.product.discountedPrice.toStringAsFixed(0)}', style: AppTextStyles.price),
                const SizedBox(height: 10),
                Row(
                  children: [
                    // Quantity
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.divider), borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          InkWell(
                            onTap: () => cart.updateQuantity(item.id, item.quantity - 1),
                            child: const Padding(padding: EdgeInsets.all(6), child: Icon(Icons.remove, size: 16)),
                          ),
                          Padding(padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text('${item.quantity}', style: GoogleFontsHelper.inter(fontSize: 13, fontWeight: FontWeight.w700))),
                          InkWell(
                            onTap: () => cart.updateQuantity(item.id, item.quantity + 1),
                            child: const Padding(padding: EdgeInsets.all(6), child: Icon(Icons.add, size: 16)),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    TextButton.icon(
                      onPressed: () => cart.removeItem(item.id),
                      icon: const Icon(Icons.delete_outline, size: 16, color: AppColors.error),
                      label: const Text('Remove', style: TextStyle(color: AppColors.error, fontSize: 12)),
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
}

class _PriceLine extends StatelessWidget {
  final String label, value;
  final bool isBold, large;
  final Color? color;
  const _PriceLine(this.label, this.value, {this.isBold = false, this.large = false, this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Text(label, style: GoogleFontsHelper.inter(
            fontSize: large ? 16 : 13, fontWeight: isBold ? FontWeight.w700 : FontWeight.w400,
            color: AppColors.textSecondary)),
          const Spacer(),
          Text(value, style: GoogleFontsHelper.inter(
            fontSize: large ? 18 : 13, fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
            color: color ?? (isBold ? AppColors.primary : AppColors.textPrimary))),
        ],
      ),
    );
  }
}
