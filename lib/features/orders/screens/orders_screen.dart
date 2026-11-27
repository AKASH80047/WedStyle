import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/providers.dart';
import '../../../core/utils/models.dart';
import '../../../core/widgets/shared_widgets.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;
  final List<(String, String)> _tabs = [
    ('all', 'All'), ('confirmed', 'Processing'), ('shipped', 'Shipped'),
    ('delivered', 'Delivered'), ('cancelled', 'Cancelled'),
  ];

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: _tabs.length, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OrdersProvider>().loadOrders();
    });
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<OrdersProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('My Orders', style: TextStyle(fontFamily: 'Cormorant', fontSize: 22, fontWeight: FontWeight.w700)),
        bottom: TabBar(
          controller: _tabCtrl,
          isScrollable: true,
          tabs: _tabs.map((t) => Tab(text: t.$2)).toList(),
        ),
      ),
      body: provider.isLoading
        ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
        : TabBarView(
            controller: _tabCtrl,
            children: _tabs.map((tab) {
              final orders = provider.getByStatus(tab.$1);
              return orders.isEmpty
                ? EmptyStateWidget(
                    emoji: '📦',
                    title: 'No ${tab.$2} Orders',
                    subtitle: tab.$1 == 'all'
                      ? 'You haven\'t placed any orders yet. Start shopping!'
                      : 'No ${tab.$2.toLowerCase()} orders found.',
                    actionLabel: tab.$1 == 'all' ? 'Start Shopping' : null,
                    onAction: tab.$1 == 'all' ? () => context.go('/home') : null,
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: orders.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (_, i) => _OrderCard(order: orders[i]),
                  );
            }).toList(),
          ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final OrderModel order;
  const _OrderCard({required this.order});

  @override
  Widget build(BuildContext context) {
    final item = order.items.first;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface, borderRadius: BorderRadius.circular(16), boxShadow: AppShadows.card,
      ),
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 0),
            child: Row(
              children: [
                Text('Order #${order.id}', style: GoogleFontsHelper.inter(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
                const Spacer(),
                StatusChip(status: order.status),
              ],
            ),
          ),
          const Divider(height: 16),

          // Product
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 0, 14, 12),
            child: Column(
              children: [
                Row(
                  children: [
                    AppNetworkImage(url: item.productImage, width: 70, height: 78, borderRadius: BorderRadius.circular(10)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(item.productName, style: AppTextStyles.productName, maxLines: 2),
                        const SizedBox(height: 4),
                        Text('Size: ${item.size} • Qty: ${item.quantity}', style: AppTextStyles.caption),
                        const SizedBox(height: 4),
                        Text(NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0).format(order.total), style: AppTextStyles.price),
                        const SizedBox(height: 4),
                        Text(DateFormat('MMM d, yyyy').format(order.createdAt), style: AppTextStyles.caption),
                      ]),
                    ),
                  ],
                ),

                if (order.items.length > 1)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text('+${order.items.length - 1} more item(s)',
                      style: GoogleFontsHelper.inter(fontSize: 12, color: AppColors.primary, fontWeight: FontWeight.w600)),
                  ),

                const SizedBox(height: 14),
                // Action buttons
                Row(
                  children: [
                    if (order.status == 'shipped' || order.status == 'processing')
                      Expanded(child: _OrderBtn(
                        label: 'Track Order', icon: Icons.local_shipping_outlined,
                        onTap: () => _showTrackSheet(context, order),
                      )),
                    if (order.status == 'shipped' || order.status == 'processing')
                      const SizedBox(width: 8),
                    Expanded(child: _OrderBtn(
                      label: 'View Details', icon: Icons.receipt_outlined,
                      onTap: () => context.push('/order-detail/${order.id}'),
                    )),
                    const SizedBox(width: 8),
                    if (order.status == 'delivered')
                      Expanded(child: _OrderBtn(
                        label: 'Reorder', icon: Icons.replay_outlined,
                        onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Added to cart!'))),
                      )),
                    if (order.status == 'confirmed' || order.status == 'processing')
                      Expanded(child: _OrderBtn(
                        label: 'Cancel', icon: Icons.cancel_outlined,
                        color: AppColors.error,
                        onTap: () => _confirmCancel(context, order),
                      )),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showTrackSheet(BuildContext context, OrderModel order) {
    final steps = [
      ('Order Confirmed', true, '${DateFormat('MMM d').format(order.createdAt)}'),
      ('Processing', true, '${DateFormat('MMM d').format(order.createdAt.add(const Duration(days: 1)))}'),
      ('Shipped', order.status == 'shipped' || order.status == 'delivered', 'In transit'),
      ('Out for Delivery', order.status == 'delivered', 'Expected today'),
      ('Delivered', order.status == 'delivered', 'Delivered'),
    ];

    showModalBottomSheet(
      context: context, isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Track Order', style: AppTextStyles.sectionTitle),
            const SizedBox(height: 8),
            Text('Order #${order.id}', style: AppTextStyles.caption),
            const SizedBox(height: 20),
            ...List.generate(steps.length, (i) => Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(children: [
                  Container(
                    width: 24, height: 24,
                    decoration: BoxDecoration(
                      color: steps[i].$2 ? AppColors.primary : AppColors.divider,
                      shape: BoxShape.circle,
                    ),
                    child: steps[i].$2
                      ? const Icon(Icons.check, color: Colors.white, size: 14)
                      : null,
                  ),
                  if (i < steps.length - 1)
                    Container(width: 2, height: 36, color: steps[i].$2 ? AppColors.primary : AppColors.divider),
                ]),
                const SizedBox(width: 12),
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(steps[i].$1, style: GoogleFontsHelper.inter(
                      fontSize: 13, fontWeight: FontWeight.w600,
                      color: steps[i].$2 ? AppColors.textPrimary : AppColors.textTertiary)),
                    Text(steps[i].$3, style: AppTextStyles.caption),
                    const SizedBox(height: 24),
                  ]),
                ),
              ],
            )),
          ],
        ),
      ),
    );
  }

  void _confirmCancel(BuildContext context, OrderModel order) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Cancel Order?'),
        content: const Text('Are you sure you want to cancel this order?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('No, Keep it')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Order cancellation requested')));
            },
            child: const Text('Yes, Cancel'),
          ),
        ],
      ),
    );
  }
}

class _OrderBtn extends StatelessWidget {
  final String label; final IconData icon; final VoidCallback onTap; final Color? color;
  const _OrderBtn({required this.label, required this.icon, required this.onTap, this.color});

  @override
  Widget build(BuildContext context) {
    final c = color ?? AppColors.primary;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: c.withOpacity(0.06), borderRadius: BorderRadius.circular(8),
          border: Border.all(color: c.withOpacity(0.3)),
        ),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(icon, size: 14, color: c),
          const SizedBox(width: 4),
          Flexible(child: Text(label, style: GoogleFontsHelper.inter(fontSize: 11, fontWeight: FontWeight.w600, color: c))),
        ]),
      ),
    );
  }
}

// ============ Order Detail ============
class OrderDetailScreen extends StatelessWidget {
  final String orderId;
  const OrderDetailScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    final provider = context.read<OrdersProvider>();
    OrderModel? order;
    try { order = provider.orders.firstWhere((o) => o.id == orderId); } catch (_) {}

    if (order == null) {
      return Scaffold(appBar: AppBar(title: const Text('Order Detail')),
        body: const Center(child: Text('Order not found')));
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Order Details', style: TextStyle(fontFamily: 'Cormorant', fontSize: 22, fontWeight: FontWeight.w700)),
        actions: [
          TextButton.icon(
            icon: const Icon(Icons.download_outlined, size: 18),
            label: const Text('Invoice'),
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Invoice downloaded!'))),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Status
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16), boxShadow: AppShadows.card),
            child: Column(children: [
              Row(children: [
                Text('Order #${order.id}', style: AppTextStyles.sectionTitle.copyWith(fontSize: 18)),
                const Spacer(),
                StatusChip(status: order.status),
              ]),
              const SizedBox(height: 8),
              Text(DateFormat('MMMM d, yyyy — h:mm a').format(order.createdAt), style: AppTextStyles.caption),
            ]),
          ),
          const SizedBox(height: 12),
          // Items
          ...order.items.map((item) => Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(14), boxShadow: AppShadows.card),
            child: Row(children: [
              AppNetworkImage(url: item.productImage, width: 70, height: 78, borderRadius: BorderRadius.circular(10)),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(item.productName, style: AppTextStyles.productName, maxLines: 2),
                Text('${item.brand} • ${item.size} • ${item.color}', style: AppTextStyles.caption),
                Text('Qty: ${item.quantity} × ₹${item.price.toStringAsFixed(0)}', style: AppTextStyles.caption),
                Text('= ₹${item.total.toStringAsFixed(0)}', style: AppTextStyles.price.copyWith(fontSize: 14)),
              ])),
            ]),
          )),
          const SizedBox(height: 4),
          // Price
          _Section(title: 'Price Details', child: Column(children: [
            _Row('Subtotal', '₹${order.subtotal.toStringAsFixed(0)}'),
            if (order.couponDiscount > 0) _Row('Coupon', '-₹${order.couponDiscount.toStringAsFixed(0)}'),
            _Row('Delivery', order.deliveryCharge == 0 ? 'FREE' : '₹${order.deliveryCharge.toStringAsFixed(0)}'),
            _Row('Tax', '₹${order.tax.toStringAsFixed(0)}'),
            const Divider(),
            _Row('Total', '₹${order.total.toStringAsFixed(0)}', bold: true),
          ])),
          const SizedBox(height: 12),
          _Section(title: 'Delivery Address', child: Text(
            '${order.address.name}\n${order.address.house}, ${order.address.street}\n${order.address.city}, ${order.address.state} - ${order.address.pincode}\n${order.address.mobile}',
            style: AppTextStyles.caption.copyWith(fontSize: 13, height: 1.6),
          )),
          const SizedBox(height: 12),
          _Section(title: 'Payment', child: Text(order.paymentMethod.toUpperCase(),
            style: GoogleFontsHelper.inter(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary))),
          const SizedBox(height: 60),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title; final Widget child;
  const _Section({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(14), boxShadow: AppShadows.card),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: GoogleFontsHelper.inter(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
        const SizedBox(height: 10),
        child,
      ]),
    );
  }
}

class _Row extends StatelessWidget {
  final String l, v; final bool bold;
  const _Row(this.l, this.v, {this.bold = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(children: [
        Text(l, style: AppTextStyles.caption),
        const Spacer(),
        Text(v, style: GoogleFontsHelper.inter(fontSize: 13, fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
          color: bold ? AppColors.primary : AppColors.textPrimary)),
      ]),
    );
  }
}
