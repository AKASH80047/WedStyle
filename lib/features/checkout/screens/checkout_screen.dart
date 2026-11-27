import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/providers.dart';
import '../../../core/utils/models.dart';
import '../../../core/widgets/shared_widgets.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  int _step = 0;
  final _addressFormKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController(text: 'Priya Sharma');
  final _mobileCtrl = TextEditingController(text: '+91 9876543210');
  final _houseCtrl = TextEditingController(text: 'Flat 4B');
  final _streetCtrl = TextEditingController(text: 'Andheri West');
  final _cityCtrl = TextEditingController(text: 'Mumbai');
  final _stateCtrl = TextEditingController(text: 'Maharashtra');
  final _pincodeCtrl = TextEditingController(text: '400058');
  String _deliveryType = 'standard';
  String _paymentMethod = 'upi';
  bool _isPlacingOrder = false;

  final List<String> _steps = ['Address', 'Delivery', 'Payment', 'Review'];

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(_steps[_step], style: const TextStyle(fontFamily: 'Cormorant', fontSize: 22, fontWeight: FontWeight.w700)),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: LinearProgressIndicator(
            value: (_step + 1) / _steps.length,
            backgroundColor: AppColors.divider,
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
        ),
      ),
      body: Column(
        children: [
          // Step indicator
          _buildStepBar(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: _step == 0 ? _buildAddressStep()
                : _step == 1 ? _buildDeliveryStep()
                : _step == 2 ? _buildPaymentStep()
                : _buildReviewStep(cart),
            ),
          ),
          _buildBottomBar(cart),
        ],
      ),
    );
  }

  Widget _buildStepBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: AppColors.surface,
      child: Row(
        children: List.generate(_steps.length, (i) => Expanded(
          child: Row(
            children: [
              Container(
                width: 26, height: 26,
                decoration: BoxDecoration(
                  color: _step >= i ? AppColors.primary : AppColors.divider,
                  shape: BoxShape.circle,
                ),
                child: Center(child: _step > i
                  ? const Icon(Icons.check, size: 14, color: Colors.white)
                  : Text('${i+1}', style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700))),
              ),
              if (i < _steps.length - 1)
                Expanded(child: Container(height: 2, color: _step > i ? AppColors.primary : AppColors.divider)),
            ],
          ),
        )),
      ),
    );
  }

  Widget _buildAddressStep() {
    return Form(
      key: _addressFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Delivery Address', style: AppTextStyles.sectionTitle),
          const SizedBox(height: 16),
          _field(_nameCtrl, 'Full Name', Icons.person_outline),
          const SizedBox(height: 12),
          _field(_mobileCtrl, 'Mobile Number', Icons.phone_outlined, type: TextInputType.phone),
          const SizedBox(height: 12),
          _field(_houseCtrl, 'House / Flat / Building', Icons.home_outlined),
          const SizedBox(height: 12),
          _field(_streetCtrl, 'Street / Area / Locality', Icons.location_on_outlined),
          const SizedBox(height: 12),
          Row(children: [
            Expanded(child: _field(_cityCtrl, 'City', Icons.location_city_outlined)),
            const SizedBox(width: 12),
            Expanded(child: _field(_stateCtrl, 'State', Icons.map_outlined)),
          ]),
          const SizedBox(height: 12),
          _field(_pincodeCtrl, 'Pincode', Icons.pin_drop_outlined, type: TextInputType.number),
        ],
      ),
    );
  }

  Widget _buildDeliveryStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Choose Delivery', style: AppTextStyles.sectionTitle),
        const SizedBox(height: 16),
        _DeliveryOption(
          title: 'Standard Delivery', subtitle: '5-7 business days', price: 'FREE',
          icon: Icons.local_shipping_outlined,
          isSelected: _deliveryType == 'standard',
          onSelect: () => setState(() => _deliveryType = 'standard'),
        ),
        const SizedBox(height: 12),
        _DeliveryOption(
          title: 'Express Delivery', subtitle: '2-3 business days', price: '₹149',
          icon: Icons.flash_on_outlined,
          isSelected: _deliveryType == 'express',
          onSelect: () => setState(() => _deliveryType = 'express'),
        ),
        const SizedBox(height: 12),
        _DeliveryOption(
          title: 'Same Day Delivery', subtitle: 'Order before 12 PM', price: '₹299',
          icon: Icons.access_time,
          isSelected: _deliveryType == 'same_day',
          onSelect: () => setState(() => _deliveryType = 'same_day'),
        ),
      ],
    );
  }

  Widget _buildPaymentStep() {
    final methods = [
      ('upi', 'UPI Payment', '📱', 'Google Pay, PhonePe, Paytm'),
      ('credit', 'Credit Card', '💳', 'Visa, Mastercard, Amex'),
      ('debit', 'Debit Card', '🏦', 'All major banks'),
      ('netbanking', 'Net Banking', '🌐', 'All banks supported'),
      ('wallet', 'Wallet', '👛', 'Paytm, Amazon Pay'),
      ('cod', 'Cash on Delivery', '💵', 'Pay when delivered'),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Payment Method', style: AppTextStyles.sectionTitle),
        const SizedBox(height: 16),
        ...methods.map((m) => Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: GestureDetector(
            onTap: () => setState(() => _paymentMethod = m.$1),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _paymentMethod == m.$1 ? AppColors.primary : AppColors.divider,
                  width: _paymentMethod == m.$1 ? 1.5 : 1,
                ),
              ),
              child: Row(children: [
                Text(m.$3, style: const TextStyle(fontSize: 24)),
                const SizedBox(width: 12),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(m.$2, style: GoogleFontsHelper.inter(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                  Text(m.$4, style: AppTextStyles.caption),
                ])),
                Radio<String>(
                  value: m.$1, groupValue: _paymentMethod,
                  onChanged: (v) => setState(() => _paymentMethod = v!),
                  activeColor: AppColors.primary,
                ),
              ]),
            ),
          ),
        )),
      ],
    );
  }

  Widget _buildReviewStep(CartProvider cart) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Order Review', style: AppTextStyles.sectionTitle),
        const SizedBox(height: 16),
        // Items
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), boxShadow: AppShadows.card),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Items (${cart.itemCount})', style: GoogleFontsHelper.inter(fontSize: 13, fontWeight: FontWeight.w700)),
              const SizedBox(height: 10),
              ...cart.items.map((i) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(children: [
                  AppNetworkImage(url: i.product.images.first, width: 48, height: 54, borderRadius: BorderRadius.circular(8)),
                  const SizedBox(width: 10),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(i.product.name, style: AppTextStyles.productName.copyWith(fontSize: 12), maxLines: 1),
                    Text('${i.selectedSize} • Qty: ${i.quantity}', style: AppTextStyles.caption),
                  ])),
                  Text('₹${i.total.toStringAsFixed(0)}', style: AppTextStyles.price.copyWith(fontSize: 13)),
                ]),
              )),
            ],
          ),
        ),
        const SizedBox(height: 12),
        // Address
        _ReviewBlock(
          icon: Icons.location_on_outlined,
          title: 'Delivery Address',
          content: '${_nameCtrl.text}, ${_houseCtrl.text}, ${_streetCtrl.text}, ${_cityCtrl.text} - ${_pincodeCtrl.text}',
        ),
        const SizedBox(height: 10),
        _ReviewBlock(
          icon: Icons.local_shipping_outlined,
          title: 'Delivery Type',
          content: _deliveryType == 'standard' ? 'Standard (5-7 days) - FREE'
            : _deliveryType == 'express' ? 'Express (2-3 days) - ₹149'
            : 'Same Day - ₹299',
        ),
        const SizedBox(height: 10),
        _ReviewBlock(
          icon: Icons.payment_outlined,
          title: 'Payment',
          content: {'upi': 'UPI Payment', 'credit': 'Credit Card', 'debit': 'Debit Card',
            'netbanking': 'Net Banking', 'wallet': 'Wallet', 'cod': 'Cash on Delivery'}[_paymentMethod]!,
        ),
        const SizedBox(height: 16),
        // Price summary
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), boxShadow: AppShadows.card),
          child: Column(children: [
            _PriceRow('Subtotal', '₹${cart.subtotal.toStringAsFixed(0)}'),
            if (cart.couponDiscount > 0) _PriceRow('Coupon', '-₹${cart.couponDiscount.toStringAsFixed(0)}', color: AppColors.success),
            _PriceRow('Delivery', cart.deliveryCharge == 0 ? 'FREE' : '₹${cart.deliveryCharge.toStringAsFixed(0)}', color: cart.deliveryCharge == 0 ? AppColors.success : null),
            _PriceRow('Tax', '₹${cart.tax.toStringAsFixed(0)}'),
            const Divider(),
            _PriceRow('Total', '₹${cart.total.toStringAsFixed(0)}', bold: true),
          ]),
        ),
      ],
    );
  }

  Widget _buildBottomBar(CartProvider cart) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
      decoration: BoxDecoration(color: AppColors.surface, boxShadow: AppShadows.navbar),
      child: Row(
        children: [
          if (_step > 0) ...[
            Expanded(child: SecondaryButton(text: 'Back', onPressed: () => setState(() => _step--))),
            const SizedBox(width: 12),
          ],
          Expanded(
            flex: 2,
            child: PrimaryButton(
              text: _step < 3 ? 'Continue' : 'Place Order ₹${cart.total.toStringAsFixed(0)}',
              isLoading: _isPlacingOrder,
              onPressed: () async {
                if (_step < 3) {
                  if (_step == 0 && !(_addressFormKey.currentState?.validate() ?? false)) return;
                  setState(() => _step++);
                } else {
                  await _placeOrder(context, cart);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _placeOrder(BuildContext context, CartProvider cart) async {
    setState(() => _isPlacingOrder = true);
    final address = AddressModel(
      id: 'addr_new', name: _nameCtrl.text, mobile: _mobileCtrl.text,
      house: _houseCtrl.text, street: _streetCtrl.text, city: _cityCtrl.text,
      state: _stateCtrl.text, pincode: _pincodeCtrl.text,
    );
    final orderId = await context.read<OrdersProvider>().placeOrder(
      cart: cart, address: address,
      paymentMethod: _paymentMethod, deliveryType: _deliveryType,
    );
    setState(() => _isPlacingOrder = false);
    if (mounted) context.go('/order-success/$orderId');
  }

  Widget _field(TextEditingController ctrl, String label, IconData icon, {TextInputType type = TextInputType.text}) {
    return TextFormField(
      controller: ctrl, keyboardType: type,
      decoration: InputDecoration(labelText: label, prefixIcon: Icon(icon, color: AppColors.textTertiary)),
      validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
    );
  }
}

class _DeliveryOption extends StatelessWidget {
  final String title, subtitle, price;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onSelect;
  const _DeliveryOption({required this.title, required this.subtitle, required this.price,
    required this.icon, required this.isSelected, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSelect,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surface, borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isSelected ? AppColors.primary : AppColors.divider, width: isSelected ? 1.5 : 1),
        ),
        child: Row(children: [
          Icon(icon, color: isSelected ? AppColors.primary : AppColors.textTertiary, size: 24),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: GoogleFontsHelper.inter(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
            Text(subtitle, style: AppTextStyles.caption),
          ])),
          Text(price, style: GoogleFontsHelper.inter(fontSize: 14, fontWeight: FontWeight.w700,
            color: price == 'FREE' ? AppColors.success : AppColors.textPrimary)),
          const SizedBox(width: 8),
          Radio<bool>(value: true, groupValue: isSelected, onChanged: (_) => onSelect(), activeColor: AppColors.primary),
        ]),
      ),
    );
  }
}

class _ReviewBlock extends StatelessWidget {
  final IconData icon; final String title, content;
  const _ReviewBlock({required this.icon, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), boxShadow: AppShadows.card),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Icon(icon, size: 18, color: AppColors.primary),
        const SizedBox(width: 10),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: GoogleFontsHelper.inter(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textTertiary)),
          const SizedBox(height: 3),
          Text(content, style: GoogleFontsHelper.inter(fontSize: 13, color: AppColors.textPrimary)),
        ])),
      ]),
    );
  }
}

class _PriceRow extends StatelessWidget {
  final String l, v; final bool bold; final Color? color;
  const _PriceRow(this.l, this.v, {this.bold = false, this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.symmetric(vertical: 3), child: Row(children: [
      Text(l, style: GoogleFontsHelper.inter(fontSize: 13, color: AppColors.textSecondary)),
      const Spacer(),
      Text(v, style: GoogleFontsHelper.inter(fontSize: 13, fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
        color: color ?? (bold ? AppColors.primary : AppColors.textPrimary))),
    ]));
  }
}
