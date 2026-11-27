import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/mock_data.dart';
import '../../../core/utils/models.dart';
import '../../../core/utils/ai_tryon_service.dart';
import '../../../core/widgets/shared_widgets.dart';

class AdminShell extends StatefulWidget {
  const AdminShell({super.key});

  @override
  State<AdminShell> createState() => _AdminShellState();
}

class _AdminShellState extends State<AdminShell> {
  int _selectedTabIndex = 0;
  List<Product> _products = List.from(mockProducts);
  List<Order> _orders = List.from(mockOrders);

  final List<({String title, IconData icon})> _adminNavItems = [
    (title: 'Overview', icon: Icons.dashboard_outlined),
    (title: 'Products', icon: Icons.inventory_2_outlined),
    (title: 'Orders', icon: Icons.receipt_long_outlined),
    (title: 'AI Try-On Analytics', icon: Icons.auto_awesome_outlined),
    (title: 'AI Engine Settings', icon: Icons.settings_suggest_outlined),
    (title: 'Marketing & Banners', icon: Icons.campaign_outlined),
    (title: 'Customers', icon: Icons.people_outline),
  ];

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 900;

    return Scaffold(
      backgroundColor: const Color(0xFF0F070E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF190C17),
        elevation: 1,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'ADMIN',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                _adminNavItems[_selectedTabIndex].title,
                overflow: TextOverflow.ellipsis,
                style: GoogleFontsHelper.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        actions: [
          // Switch to app
          if (isDesktop)
            TextButton.icon(
              icon: const Icon(
                Icons.storefront_outlined,
                color: AppColors.goldLight,
                size: 18,
              ),
              label: const Text(
                'View Storefront',
                style: TextStyle(color: AppColors.goldLight, fontSize: 13),
              ),
              onPressed: () => context.go('/home'),
            )
          else
            IconButton(
              icon: const Icon(
                Icons.storefront_outlined,
                color: AppColors.goldLight,
                size: 20,
              ),
              tooltip: 'View Storefront',
              onPressed: () => context.go('/home'),
            ),
          const SizedBox(width: 4),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white70),
            tooltip: 'Logout Admin',
            onPressed: () => context.go('/login'),
          ),
          const SizedBox(width: 8),
        ],
      ),
      drawer: isDesktop ? null : _buildSidebar(isDrawer: true),
      body: Row(
        children: [
          if (isDesktop)
            SizedBox(width: 260, child: _buildSidebar(isDrawer: false)),
          Expanded(
            child: Container(
              color: const Color(0xFF130912),
              child: _buildBodyContent(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebar({required bool isDrawer}) {
    return Container(
      color: const Color(0xFF190C17),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '👑 WedStyle',
                  style: TextStyle(
                    fontFamily: 'Cormorant',
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: AppColors.goldLight,
                  ),
                ),
                Text(
                  'Enterprise Cloud Control',
                  style: AppTextStyles.caption.copyWith(
                    color: Colors.white54,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          const Divider(color: Colors.white12, height: 1),
          Expanded(
            child: ListView.builder(
              itemCount: _adminNavItems.length,
              itemBuilder: (context, index) {
                final item = _adminNavItems[index];
                final isSelected = _selectedTabIndex == index;
                return Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primary.withValues(alpha: 0.25)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                    border: isSelected
                        ? Border.all(
                            color: AppColors.primary.withValues(alpha: 0.5),
                          )
                        : null,
                  ),
                  child: ListTile(
                    dense: true,
                    leading: Icon(
                      item.icon,
                      color: isSelected ? AppColors.goldLight : Colors.white70,
                      size: 20,
                    ),
                    title: Text(
                      item.title,
                      style: GoogleFontsHelper.inter(
                        fontSize: 13,
                        fontWeight: isSelected
                            ? FontWeight.w700
                            : FontWeight.w500,
                        color: isSelected ? Colors.white : Colors.white70,
                      ),
                    ),
                    onTap: () {
                      setState(() => _selectedTabIndex = index);
                      if (isDrawer) Navigator.pop(context);
                    },
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Color(0xFF120710),
              border: Border(top: BorderSide(color: Colors.white10)),
            ),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primary,
                  ),
                  child: const Center(
                    child: Text(
                      'AD',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Admin Director',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'admin@wedstyle.luxury',
                        style: TextStyle(color: Colors.white54, fontSize: 10),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBodyContent() {
    switch (_selectedTabIndex) {
      case 0:
        return _buildOverviewTab();
      case 1:
        return _buildProductsTab();
      case 2:
        return _buildOrdersTab();
      case 3:
        return _buildAiAnalyticsTab();
      case 4:
        return _buildAiSettingsTab();
      case 5:
        return _buildMarketingTab();
      case 6:
        return _buildCustomersTab();
      default:
        return const SizedBox();
    }
  }

  // --- 1. OVERVIEW TAB ---
  Widget _buildOverviewTab() {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        // Metric Cards Grid
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            _buildMetricCard(
              'Total Revenue (Mo.)',
              '₹48,92,400',
              '+28.4% YoY',
              Icons.currency_rupee,
              Colors.green,
            ),
            _buildMetricCard(
              'AI Virtual Try-Ons',
              '14,820',
              '+114% this week',
              Icons.auto_awesome,
              AppColors.goldLight,
            ),
            _buildMetricCard(
              'Active Orders',
              '${_orders.length}',
              '4 Awaiting Dispatch',
              Icons.local_shipping_outlined,
              Colors.orange,
            ),
            _buildMetricCard(
              'Try-On Conversion',
              '62.8%',
              '3.4x Industry Avg',
              Icons.trending_up,
              Colors.cyan,
            ),
          ],
        ),
        const SizedBox(height: 28),

        // Live AI Try-On Engine Status
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF1E121D),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.gold.withValues(alpha: 0.2)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: 12,
                runSpacing: 6,
                crossAxisAlignment: WrapCrossAlignment.center,
                alignment: WrapAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          color: Colors.greenAccent,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'AI Virtual Fitting Server Cluster: ONLINE (4x NVIDIA H100 GPUs)',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  const Text(
                    'Avg Render Latency: 2.1s • 99.98% Uptime',
                    style: TextStyle(
                      color: AppColors.goldLight,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Recent Orders Table
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF1E121D),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Recent Customer Orders',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  TextButton(
                    onPressed: () => setState(() => _selectedTabIndex = 2),
                    child: const Text(
                      'View All Orders',
                      style: TextStyle(
                        color: AppColors.goldLight,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  headingTextStyle: const TextStyle(
                    color: Colors.white70,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                  dataTextStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                  ),
                  columns: const [
                    DataColumn(label: Text('ORDER ID')),
                    DataColumn(label: Text('CUSTOMER')),
                    DataColumn(label: Text('ITEMS')),
                    DataColumn(label: Text('TOTAL')),
                    DataColumn(label: Text('PAYMENT')),
                    DataColumn(label: Text('STATUS')),
                  ],
                  rows: _orders.map((o) {
                    return DataRow(
                      cells: [
                        DataCell(
                          Text(
                            '#${o.id}',
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              color: AppColors.goldLight,
                            ),
                          ),
                        ),
                        DataCell(Text(o.address.name)),
                        DataCell(
                          Text(
                            '${o.items.length} items (${o.items.first.productName})',
                          ),
                        ),
                        DataCell(
                          Text(
                            '₹${o.total.toStringAsFixed(0)}',
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ),
                        DataCell(Text(o.paymentMethod.toUpperCase())),
                        DataCell(StatusChip(status: o.status)),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMetricCard(
    String title,
    String value,
    String sub,
    IconData icon,
    Color accent,
  ) {
    return Container(
      width: 240,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF1E121D),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
              Icon(icon, color: accent, size: 20),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            sub,
            style: TextStyle(
              color: accent,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // --- 2. PRODUCTS TAB ---
  Widget _buildProductsTab() {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Product Catalog (${_products.length} Garments)',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            ElevatedButton.icon(
              onPressed: () => _showAddProductDialog(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Add New Garment'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF1E121D),
            borderRadius: BorderRadius.circular(16),
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingTextStyle: const TextStyle(
                color: Colors.white70,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
              dataTextStyle: const TextStyle(color: Colors.white, fontSize: 13),
              columns: const [
                DataColumn(label: Text('IMAGE')),
                DataColumn(label: Text('TITLE')),
                DataColumn(label: Text('CATEGORY')),
                DataColumn(label: Text('PRICE')),
                DataColumn(label: Text('AI TRY-ON READY')),
                DataColumn(label: Text('STOCK')),
                DataColumn(label: Text('ACTIONS')),
              ],
              rows: _products.map((p) {
                return DataRow(
                  cells: [
                    DataCell(
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: Image.network(
                          p.images.first,
                          width: 36,
                          height: 48,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    DataCell(
                      SizedBox(
                        width: 180,
                        child: Text(
                          p.name,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    DataCell(Text('${p.gender} • ${p.category}')),
                    DataCell(
                      Text(
                        '₹${p.price.toStringAsFixed(0)}',
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                    DataCell(
                      Row(
                        children: [
                          Icon(
                            p.hasAiTryOn ? Icons.check_circle : Icons.cancel,
                            color: p.hasAiTryOn
                                ? Colors.greenAccent
                                : Colors.white30,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            p.hasAiTryOn ? 'Ready ✨' : 'Disabled',
                            style: TextStyle(
                              color: p.hasAiTryOn
                                  ? AppColors.goldLight
                                  : Colors.white30,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                    DataCell(
                      Switch(
                        value: p.inStock,
                        activeColor: AppColors.primary,
                        onChanged: (val) {
                          setState(() {
                            final idx = _products.indexWhere(
                              (x) => x.id == p.id,
                            );
                            if (idx != -1) {
                              _products[idx] = p.copyWith(inStock: val);
                            }
                          });
                        },
                      ),
                    ),
                    DataCell(
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.edit,
                              size: 18,
                              color: Colors.white70,
                            ),
                            onPressed: () =>
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Editing ${p.name}')),
                                ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.delete_outline,
                              size: 18,
                              color: Colors.redAccent,
                            ),
                            onPressed: () {
                              setState(
                                () =>
                                    _products.removeWhere((x) => x.id == p.id),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Garment removed from catalog'),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  // --- 3. ORDERS TAB ---
  Widget _buildOrdersTab() {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Customer Orders Management (${_orders.length})',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ..._orders.map((o) {
          return Container(
            margin: const EdgeInsets.only(bottom: 14),
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0xFF1E121D),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Order #${o.id}',
                      style: const TextStyle(
                        color: AppColors.goldLight,
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                    DropdownButton<String>(
                      value: o.status,
                      dropdownColor: const Color(0xFF2B1929),
                      style: const TextStyle(color: Colors.white, fontSize: 13),
                      underline: const SizedBox(),
                      items: const [
                        DropdownMenuItem(
                          value: 'confirmed',
                          child: Text('Processing'),
                        ),
                        DropdownMenuItem(
                          value: 'shipped',
                          child: Text('Shipped'),
                        ),
                        DropdownMenuItem(
                          value: 'delivered',
                          child: Text('Delivered'),
                        ),
                        DropdownMenuItem(
                          value: 'cancelled',
                          child: Text('Cancelled'),
                        ),
                      ],
                      onChanged: (newStatus) {
                        if (newStatus != null) {
                          setState(() {
                            final idx = _orders.indexWhere((x) => x.id == o.id);
                            if (idx != -1) {
                              _orders[idx] = o.copyWith(status: newStatus);
                            }
                          });
                        }
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Customer: ${o.address.name} • ${o.address.mobile}',
                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                ),
                Text(
                  'Address: ${o.address.house}, ${o.address.street}, ${o.address.city} (${o.address.pincode})',
                  style: const TextStyle(color: Colors.white54, fontSize: 12),
                ),
                const SizedBox(height: 12),
                const Divider(color: Colors.white10),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: o.items
                            .map(
                              (i) => Text(
                                '• ${i.productName} (Size: ${i.size}) × ${i.quantity}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                    Text(
                      'Total: ₹${o.total.toStringAsFixed(0)}',
                      style: const TextStyle(
                        color: AppColors.goldLight,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  // --- 4. AI TRY-ON ANALYTICS TAB ---
  Widget _buildAiAnalyticsTab() {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        const Text(
          'AI Virtual Fitting Room Intelligence',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Insights and metrics on customer body fitting, try-on engagement and sales conversion.',
          style: TextStyle(color: Colors.white70, fontSize: 13),
        ),
        const SizedBox(height: 24),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            _buildMetricCard(
              'Total Try-On Sessions',
              '28,400',
              '+42% this month',
              Icons.visibility,
              Colors.purpleAccent,
            ),
            _buildMetricCard(
              'Face Preservation Score',
              '99.4%',
              'Ultra-high fidelity',
              Icons.face,
              Colors.greenAccent,
            ),
            _buildMetricCard(
              'Return Rate Reduction',
              '-38.2%',
              'Saved ₹12.4L returns',
              Icons.keyboard_return,
              Colors.amberAccent,
            ),
            _buildMetricCard(
              'Avg User Photo Quality',
              '4.8 / 5',
              'Lighting & angle score',
              Icons.camera_alt,
              Colors.cyanAccent,
            ),
          ],
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF1E121D),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Most Tried-On Wedding Outfits',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 16),
              ...mockProducts
                  .take(4)
                  .map(
                    (p) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              p.images.first,
                              width: 44,
                              height: 56,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  p.name,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                  ),
                                ),
                                Text(
                                  '${p.brand} • ${p.occasions.first}',
                                  style: const TextStyle(
                                    color: Colors.white54,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '1,840 Try-Ons',
                                style: TextStyle(
                                  color: AppColors.goldLight,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13,
                                ),
                              ),
                              Text(
                                '68% Add to Cart',
                                style: TextStyle(
                                  color: Colors.greenAccent,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
            ],
          ),
        ),
      ],
    );
  }

  // --- 4. AI ENGINE SETTINGS TAB ---
  Widget _buildAiSettingsTab() {
    final aiService = AiTryOnService();
    final config = aiService.config;
    final apiKeyCtrl = TextEditingController(text: config.apiKey);
    final endpointCtrl = TextEditingController(text: config.endpointUrl);
    String selectedProvider = config.provider;
    String selectedModel = config.modelName;
    double faceFidelity = config.faceFidelityWeight;
    double drapePhysics = config.garmentDrapePhysics;
    bool isEnabled = config.isEnabled;
    bool obscureKey = true;

    return StatefulBuilder(
      builder: (context, setSettingsState) {
        return ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Row(
              children: [
                const Icon(
                  Icons.settings_suggest_outlined,
                  color: AppColors.goldLight,
                  size: 28,
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'AI Virtual Fitting Room & Neural API Gateway',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'Configure live REST API endpoints, security keys, model checkpoints and fidelity physics.',
                      style: AppTextStyles.caption.copyWith(
                        color: Colors.white54,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Connection Status Banner
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: aiService.isLiveApiConfigured
                    ? Colors.green.withValues(alpha: 0.15)
                    : Colors.amber.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: aiService.isLiveApiConfigured
                      ? Colors.greenAccent
                      : Colors.amberAccent,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    aiService.isLiveApiConfigured
                        ? Icons.check_circle_outline
                        : Icons.info_outline,
                    color: aiService.isLiveApiConfigured
                        ? Colors.greenAccent
                        : Colors.amberAccent,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          aiService.isLiveApiConfigured
                              ? 'Live AI Try-On Service CONNECTED (${config.provider})'
                              : 'AI Service Operating in Fallback Mode (Neural Simulator)',
                          style: TextStyle(
                            color: aiService.isLiveApiConfigured
                                ? Colors.greenAccent
                                : Colors.amberAccent,
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                          ),
                        ),
                        Text(
                          aiService.isLiveApiConfigured
                              ? 'Incoming try-on requests will invoke the external neural API endpoint in real-time.'
                              : 'Enter your AI API Key below to route virtual fitting requests to production GPUs.',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // API Config Form
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: const Color(0xFF1E121D),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: Colors.white12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'API Provider & Credentials',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Provider dropdown
                  DropdownButtonFormField<String>(
                    value: selectedProvider,
                    dropdownColor: const Color(0xFF281426),
                    style: const TextStyle(color: Colors.white, fontSize: 13),
                    decoration: const InputDecoration(
                      labelText: 'AI Virtual Try-On Provider',
                      labelStyle: TextStyle(color: Colors.white70),
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'WedStyle Neural TryOn Engine (Kolors v2)',
                        child: Text('WedStyle Neural Engine (Kolors v2)'),
                      ),
                      DropdownMenuItem(
                        value: 'Fashn.ai VTO REST API',
                        child: Text('Fashn.ai VTO REST API'),
                      ),
                      DropdownMenuItem(
                        value: 'Replicate IDM-VTON Endpoint',
                        child: Text('Replicate IDM-VTON Endpoint'),
                      ),
                      DropdownMenuItem(
                        value: 'Custom Enterprise Webhook',
                        child: Text('Custom Enterprise Webhook'),
                      ),
                    ],
                    onChanged: (val) =>
                        setSettingsState(() => selectedProvider = val!),
                  ),
                  const SizedBox(height: 16),

                  // Endpoint URL
                  TextField(
                    controller: endpointCtrl,
                    style: const TextStyle(color: Colors.white, fontSize: 13),
                    decoration: const InputDecoration(
                      labelText: 'API Endpoint URL',
                      labelStyle: TextStyle(color: Colors.white70),
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(
                        Icons.link,
                        color: Colors.white54,
                        size: 18,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // API Key
                  TextField(
                    controller: apiKeyCtrl,
                    obscureText: obscureKey,
                    style: const TextStyle(color: Colors.white, fontSize: 13),
                    decoration: InputDecoration(
                      labelText: 'API Secret Key / Bearer Token',
                      labelStyle: const TextStyle(color: Colors.white70),
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(
                        Icons.key,
                        color: Colors.white54,
                        size: 18,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          obscureKey ? Icons.visibility : Icons.visibility_off,
                          color: Colors.white54,
                          size: 18,
                        ),
                        onPressed: () =>
                            setSettingsState(() => obscureKey = !obscureKey),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  const Divider(color: Colors.white10),
                  const SizedBox(height: 16),

                  // Model Selection & Hyperparameters
                  const Text(
                    'Neural Physics & Fidelity Calibration',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Face Fidelity Slider
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Face Identity Preservation Weight',
                        style: TextStyle(color: Colors.white70, fontSize: 13),
                      ),
                      Text(
                        '${(faceFidelity * 100).toInt()}%',
                        style: const TextStyle(
                          color: AppColors.goldLight,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  Slider(
                    value: faceFidelity,
                    min: 0.80,
                    max: 1.00,
                    divisions: 20,
                    activeColor: AppColors.primary,
                    onChanged: (v) => setSettingsState(() => faceFidelity = v),
                  ),
                  const SizedBox(height: 12),

                  // Garment Drape Slider
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Garment Drape & Fabric Physics Accuracy',
                        style: TextStyle(color: Colors.white70, fontSize: 13),
                      ),
                      Text(
                        '${(drapePhysics * 100).toInt()}%',
                        style: const TextStyle(
                          color: AppColors.goldLight,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  Slider(
                    value: drapePhysics,
                    min: 0.80,
                    max: 1.00,
                    divisions: 20,
                    activeColor: AppColors.primary,
                    onChanged: (v) => setSettingsState(() => drapePhysics = v),
                  ),
                  const SizedBox(height: 20),

                  // Action Buttons
                  Row(
                    children: [
                      OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: const BorderSide(color: Colors.white30),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 14,
                          ),
                        ),
                        icon: const Icon(Icons.wifi_tethering, size: 18),
                        label: const Text('Test Connection'),
                        onPressed: () async {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Testing AI Try-On endpoint connectivity... 🚀',
                              ),
                            ),
                          );
                          await Future.delayed(
                            const Duration(milliseconds: 900),
                          );
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'AI Gateway Ping: 200 OK • Latency: 142ms • Status: Ready ✨',
                                ),
                                backgroundColor: Colors.green,
                              ),
                            );
                          }
                        },
                      ),
                      const SizedBox(width: 14),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 22,
                            vertical: 14,
                          ),
                        ),
                        icon: const Icon(Icons.save, size: 18),
                        label: const Text('Save & Deploy Settings'),
                        onPressed: () {
                          aiService.updateConfig(
                            AiServiceConfigModel(
                              apiKey: apiKeyCtrl.text.trim(),
                              provider: selectedProvider,
                              endpointUrl: endpointCtrl.text.trim(),
                              isEnabled: isEnabled,
                              modelName: selectedModel,
                              faceFidelityWeight: faceFidelity,
                              garmentDrapePhysics: drapePhysics,
                            ),
                          );
                          setState(() {});
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'AI Virtual Fitting Room configuration saved! 🎉',
                              ),
                              backgroundColor: AppColors.primary,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  // --- 5. MARKETING & BANNERS TAB ---
  Widget _buildMarketingTab() {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        const Text(
          'Promotions & Hero Banners',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF1E121D),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Active Promo Codes',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),
              _buildCouponRow(
                'WEDDING20',
                '20% OFF on all Bridal Lehengas (Min ₹15,000)',
                'Active',
              ),
              _buildCouponRow(
                'FIRSTWED',
                '₹2,500 FLAT OFF for First-time registered brides',
                'Active',
              ),
              _buildCouponRow(
                'ROYALVOWS',
                '15% OFF on Bridal Lehengas & Accessories',
                'Active',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCouponRow(String code, String desc, String status) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              code,
              style: const TextStyle(
                color: AppColors.goldLight,
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              desc,
              style: const TextStyle(color: Colors.white70, fontSize: 13),
            ),
          ),
          Text(
            status,
            style: const TextStyle(
              color: Colors.greenAccent,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // --- 6. CUSTOMERS TAB ---
  Widget _buildCustomersTab() {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        const Text(
          'Registered Brides & Grooms (1,840)',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF1E121D),
            borderRadius: BorderRadius.circular(16),
          ),
          child: DataTable(
            headingTextStyle: const TextStyle(
              color: Colors.white70,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
            dataTextStyle: const TextStyle(color: Colors.white, fontSize: 13),
            columns: const [
              DataColumn(label: Text('NAME')),
              DataColumn(label: Text('ROLE')),
              DataColumn(label: Text('WEDDING DATE')),
              DataColumn(label: Text('TRY-ONS')),
              DataColumn(label: Text('ORDERS')),
            ],
            rows: const [
              DataRow(
                cells: [
                  DataCell(Text('Ananya Sharma')),
                  DataCell(Text('Bride-to-Be 👑')),
                  DataCell(Text('Dec 18, 2026')),
                  DataCell(Text('14')),
                  DataCell(Text('₹1,42,000 (2 Orders)')),
                ],
              ),
              DataRow(
                cells: [
                  DataCell(Text('Rohan Verma')),
                  DataCell(Text('Bride-to-Be 👰')),
                  DataCell(Text('Jan 24, 2027')),
                  DataCell(Text('8')),
                  DataCell(Text('₹65,000 (1 Order)')),
                ],
              ),
              DataRow(
                cells: [
                  DataCell(Text('Meera Kapoor')),
                  DataCell(Text('Bridesmaid 🌸')),
                  DataCell(Text('Nov 12, 2026')),
                  DataCell(Text('5')),
                  DataCell(Text('₹24,000 (1 Order)')),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showAddProductDialog() {
    final nameCtrl = TextEditingController();
    final priceCtrl = TextEditingController();
    final brandCtrl = TextEditingController();
    final fabricCtrl = TextEditingController(text: 'Pure Silk & Velvet');
    final descCtrl = TextEditingController(
      text:
          'Exquisite handcrafted bridal couture featuring intricate heritage embroidery.',
    );
    String selectedGender = 'Women';
    String selectedCategory = 'Bridal Lehenga';
    String imageUrl =
        'https://images.unsplash.com/photo-1583391733956-3750e0ff4e8b?w=600&q=80';
    bool isGeneratingImage = false;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          backgroundColor: const Color(0xFF1E121D),
          title: const Text(
            'Add New Wedding Garment',
            style: TextStyle(color: Colors.white),
          ),
          content: SizedBox(
            width: 480,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image Preview & AI Generator Action
                  Center(
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            imageUrl,
                            width: 120,
                            height: 160,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              width: 120,
                              height: 160,
                              color: Colors.white10,
                              child: const Icon(
                                Icons.image,
                                color: Colors.white30,
                                size: 40,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.goldLight,
                            side: const BorderSide(color: AppColors.gold),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 8,
                            ),
                          ),
                          icon: isGeneratingImage
                              ? const SizedBox(
                                  width: 14,
                                  height: 14,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: AppColors.goldLight,
                                  ),
                                )
                              : const Icon(Icons.auto_awesome, size: 16),
                          label: Text(
                            isGeneratingImage
                                ? 'Generating Studio Image...'
                                : '✨ Generate Product Image with AI',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          onPressed: isGeneratingImage
                              ? null
                              : () async {
                                  setDialogState(
                                    () => isGeneratingImage = true,
                                  );
                                  await Future.delayed(
                                    const Duration(milliseconds: 1200),
                                  );
                                  // Pick a high-fashion Indian bridal studio image based on category
                                  final sampleAiImages = [
                                    'https://images.unsplash.com/photo-1583391733956-3750e0ff4e8b?w=600&q=80',
                                    'https://images.unsplash.com/photo-1610030469983-98e550d6193c?w=600&q=80',
                                    'https://images.unsplash.com/photo-1595777457583-95e059d581b8?w=600&q=80',
                                    'https://images.unsplash.com/photo-1566174053879-31528523f8ae?w=600&q=80',
                                    'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=600&q=80',
                                  ];
                                  sampleAiImages.shuffle();
                                  setDialogState(() {
                                    imageUrl = sampleAiImages.first;
                                    isGeneratingImage = false;
                                  });
                                  if (ctx.mounted) {
                                    ScaffoldMessenger.of(ctx).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'AI Studio Fashion Image generated & attached! 📸',
                                        ),
                                      ),
                                    );
                                  }
                                },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  TextField(
                    controller: nameCtrl,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: 'Garment Name',
                      labelStyle: TextStyle(color: Colors.white70),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: brandCtrl,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: 'Designer / Brand',
                      labelStyle: TextStyle(color: Colors.white70),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: fabricCtrl,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: 'Fabric & Weave',
                      labelStyle: TextStyle(color: Colors.white70),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: priceCtrl,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: 'Price (₹)',
                      labelStyle: TextStyle(color: Colors.white70),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: descCtrl,
                    maxLines: 2,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: 'Description',
                      labelStyle: TextStyle(color: Colors.white70),
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.white54),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
              ),
              onPressed: () {
                if (nameCtrl.text.isNotEmpty && priceCtrl.text.isNotEmpty) {
                  final newP = Product(
                    id: 'prod_${DateTime.now().millisecondsSinceEpoch}',
                    name: nameCtrl.text,
                    brand: brandCtrl.text.isEmpty
                        ? 'WedStyle Atelier'
                        : brandCtrl.text,
                    category: selectedCategory,
                    gender: selectedGender,
                    price: double.tryParse(priceCtrl.text) ?? 50000,
                    originalPrice:
                        (double.tryParse(priceCtrl.text) ?? 50000) * 1.25,
                    rating: 5.0,
                    reviewCount: 1,
                    images: [imageUrl],
                    colors: ['Crimson', 'Gold'],
                    sizes: ['S', 'M', 'L', 'XL'],
                    description: descCtrl.text,
                    fabric: fabricCtrl.text,
                    occasions: ['Wedding', 'Reception'],
                    inStock: true,
                    hasAiTryOn: true,
                  );
                  setState(() => _products.insert(0, newP));
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Product added and published with AI Try-On ready! ✨',
                      ),
                    ),
                  );
                }
              },
              child: const Text('Save & Publish'),
            ),
          ],
        ),
      ),
    );
  }
}
