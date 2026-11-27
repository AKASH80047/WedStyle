import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/providers.dart';
import '../../../core/widgets/shared_widgets.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final cart = context.watch<CartProvider>();
    final orders = context.watch<OrdersProvider>();
    final aiTryOn = context.watch<AiTryOnProvider>();
    final user = auth.user;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('My Profile', style: TextStyle(fontFamily: 'Cormorant', fontSize: 22, fontWeight: FontWeight.w700)),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () => context.push('/notifications'),
          ),
          IconButton(
            icon: const Icon(Icons.admin_panel_settings_outlined, color: AppColors.primary),
            tooltip: 'Admin Portal',
            onPressed: () => context.push('/admin'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        children: [
          // User Card
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF6D1A36), Color(0xFF8B2250)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.3),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Stack(
                      children: [
                        Container(
                          width: 72,
                          height: 72,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.gold, width: 2.5),
                          ),
                          child: ClipOval(
                            child: AppNetworkImage(
                              url: user?.profilePhoto ?? 'assets/images/bridal/contemporary_01.png',
                              width: 72,
                              height: 72,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: AppColors.gold,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.edit, size: 12, color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user?.name ?? 'Ananya Sharma',
                            style: GoogleFontsHelper.inter(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            user?.email ?? 'ananya.sharma@example.com',
                            style: GoogleFontsHelper.inter(fontSize: 12, color: Colors.white.withValues(alpha: 0.8)),
                          ),
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.gold.withValues(alpha: 0.25),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppColors.goldLight.withValues(alpha: 0.5)),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text('👑 ', style: TextStyle(fontSize: 10)),
                                Text(
                                  'Bride-to-Be • Royal Member',
                                  style: GoogleFontsHelper.inter(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.goldLight),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Divider(color: Colors.white24, height: 1),
                const SizedBox(height: 12),
                // Wedding Countdown Widget
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatItem('Wedding In', '48 Days', '💍 Dec 18, 2026'),
                    Container(height: 28, width: 1, color: Colors.white24),
                    _buildStatItem('Try-Ons', '${aiTryOn.history.length}', '✨ AI Saved'),
                    Container(height: 28, width: 1, color: Colors.white24),
                    _buildStatItem('Wishlist', '${cart.wishlist.length}', '❤️ Items'),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Quick Shortcut Tiles
          Row(
            children: [
              Expanded(
                child: _buildQuickTile(
                  icon: Icons.auto_awesome,
                  title: 'AI Fitting Room',
                  subtitle: '${aiTryOn.history.length} Saved Looks',
                  color: AppColors.primary,
                  onTap: () => context.push('/ai-tryon-history'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildQuickTile(
                  icon: Icons.shopping_bag_outlined,
                  title: 'My Orders',
                  subtitle: '${orders.orders.length} Placed',
                  color: AppColors.secondary,
                  onTap: () => context.push('/orders'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Virtual Fitting Room Profile
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              boxShadow: AppShadows.card,
              border: Border.all(color: AppColors.gold.withValues(alpha: 0.2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.gold.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.straighten, color: AppColors.goldDark, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('My Fitting Room Profile', style: AppTextStyles.sectionTitle.copyWith(fontSize: 15)),
                          Text('Measurements calibrated for AI size prediction', style: AppTextStyles.caption.copyWith(fontSize: 11)),
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: () => _showMeasurementsDialog(context),
                      child: const Text('Edit', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildMeasurementChip('Height', '5\' 6"'),
                    _buildMeasurementChip('Bust', '34B'),
                    _buildMeasurementChip('Waist', '28"'),
                    _buildMeasurementChip('Hip', '38"'),
                    _buildMeasurementChip('Fit', 'Regular'),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Menu Section: Wedding Services & Shopping
          _buildSectionHeader('Wedding Services & Concierge'),
          _buildMenuTile(
            icon: Icons.support_agent_outlined,
            title: 'Bridal Stylist Concierge',
            subtitle: 'Chat 1-on-1 with senior fashion experts',
            badge: 'VIP',
            badgeColor: AppColors.gold,
            onTap: () => _showStylistModal(context),
          ),
          _buildMenuTile(
            icon: Icons.palette_outlined,
            title: 'Wedding Color Palette & Theme',
            subtitle: 'Crimson & Champagne Gold (Winter Royal)',
            onTap: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Theme: Crimson & Antique Gold'))),
          ),
          _buildMenuTile(
            icon: Icons.confirmation_number_outlined,
            title: 'Coupons & Wedding Rewards',
            subtitle: '3 Active promotional offers available',
            onTap: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Explore coupons in Cart!'))),
          ),
          const SizedBox(height: 16),

          // Menu Section: Account Settings
          _buildSectionHeader('Account & Preferences'),
          _buildMenuTile(
            icon: Icons.location_on_outlined,
            title: 'Saved Delivery Addresses',
            subtitle: 'Home, Wedding Venue, Boutique',
            onTap: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('3 addresses saved.'))),
          ),
          _buildMenuTile(
            icon: Icons.credit_card_outlined,
            title: 'Saved Payment Methods',
            subtitle: 'UPI, Credit Cards, Net Banking',
            onTap: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('UPI: ananya@upi'))),
          ),
          _buildMenuTile(
            icon: Icons.admin_panel_settings_outlined,
            title: 'Switch to Admin Panel (Web)',
            subtitle: 'Manage products, orders, AI analytics & banners',
            badge: 'ADMIN',
            badgeColor: AppColors.primary,
            onTap: () => context.push('/admin'),
          ),
          _buildMenuTile(
            icon: Icons.privacy_tip_outlined,
            title: 'Privacy & Face Data Policy',
            subtitle: 'Your uploaded try-on photos are 100% encrypted',
            onTap: () => _showPrivacyDialog(context),
          ),
          _buildMenuTile(
            icon: Icons.help_outline,
            title: 'Help Center & FAQs',
            subtitle: 'Shipping, returns, try-on guide',
            onTap: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('WedStyle 24/7 Helpline: 1800-WED-STYLE'))),
          ),
          const SizedBox(height: 24),

          // Logout Button
          OutlinedButton.icon(
            onPressed: () {
              auth.logout();
              context.go('/login');
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.error,
              side: const BorderSide(color: AppColors.error),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            icon: const Icon(Icons.logout, size: 20),
            label: const Text('Log Out', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
          ),
          const SizedBox(height: 16),
          Center(
            child: Text(
              'WedStyle v2.4.0 • Made with ❤️ for Indian Weddings',
              style: AppTextStyles.caption.copyWith(fontSize: 11),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, String sub) {
    return Column(
      children: [
        Text(value, style: GoogleFontsHelper.inter(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.white)),
        const SizedBox(height: 2),
        Text(sub, style: GoogleFontsHelper.inter(fontSize: 11, color: AppColors.goldLight, fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget _buildQuickTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: AppShadows.card,
          border: Border.all(color: color.withValues(alpha: 0.15)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyles.productName.copyWith(fontSize: 13, fontWeight: FontWeight.w700)),
                  Text(subtitle, style: AppTextStyles.caption.copyWith(fontSize: 11)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMeasurementChip(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Text(label, style: AppTextStyles.caption.copyWith(fontSize: 10)),
          const SizedBox(height: 2),
          Text(value, style: GoogleFontsHelper.inter(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8, top: 8),
      child: Text(
        title.toUpperCase(),
        style: GoogleFontsHelper.inter(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.textSecondary, letterSpacing: 0.8),
      ),
    );
  }

  Widget _buildMenuTile({
    required IconData icon,
    required String title,
    required String subtitle,
    String? badge,
    Color? badgeColor,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        boxShadow: AppShadows.card,
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: AppColors.primary, size: 20),
        ),
        title: Row(
          children: [
            Text(title, style: GoogleFontsHelper.inter(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
            if (badge != null) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: (badgeColor ?? AppColors.primary).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  badge,
                  style: GoogleFontsHelper.inter(fontSize: 9, fontWeight: FontWeight.w800, color: badgeColor ?? AppColors.primary),
                ),
              ),
            ],
          ],
        ),
        subtitle: Text(subtitle, style: AppTextStyles.caption.copyWith(fontSize: 11)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.textLight),
        onTap: onTap,
      ),
    );
  }

  void _showMeasurementsDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Update Measurements', style: AppTextStyles.sectionTitle),
            const SizedBox(height: 8),
            Text('Accurate measurements ensure 99.4% AI Try-on precision fitting.', style: AppTextStyles.caption),
            const SizedBox(height: 20),
            TextFormField(initialValue: '5 ft 6 in', decoration: const InputDecoration(labelText: 'Height', prefixIcon: Icon(Icons.height))),
            const SizedBox(height: 12),
            TextFormField(initialValue: '34 in', decoration: const InputDecoration(labelText: 'Bust / Chest', prefixIcon: Icon(Icons.check))),
            const SizedBox(height: 12),
            TextFormField(initialValue: '28 in', decoration: const InputDecoration(labelText: 'Waist', prefixIcon: Icon(Icons.check))),
            const SizedBox(height: 12),
            TextFormField(initialValue: '38 in', decoration: const InputDecoration(labelText: 'Hip', prefixIcon: Icon(Icons.check))),
            const SizedBox(height: 20),
            AppButton(
              text: 'Save Measurements',
              onPressed: () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Measurements saved successfully!')));
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showStylistModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: AppColors.gold.withValues(alpha: 0.2), shape: BoxShape.circle),
              child: const Icon(Icons.support_agent, color: AppColors.goldDark, size: 36),
            ),
            const SizedBox(height: 16),
            Text('VIP Bridal Concierge', style: AppTextStyles.headline.copyWith(fontSize: 22)),
            const SizedBox(height: 8),
            Text(
              'Get matched with a dedicated celebrity wedding stylist who will curate custom outfit pairings and AI try-ons tailored to your body and wedding ceremonies.',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyText,
            ),
            const SizedBox(height: 20),
            AppButton(
              text: 'Start WhatsApp Stylist Session',
              onPressed: () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Connecting to Senior Bridal Stylist...')));
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showPrivacyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('AI Privacy & Face Data Guarantee'),
        content: const Text(
          'WedStyle strictly respects your privacy. Photos uploaded for Virtual Try-On are processed securely in memory and never sold, shared, or used for third-party AI training. You can purge your try-on history anytime with 1 tap.',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Got it')),
        ],
      ),
    );
  }
}
