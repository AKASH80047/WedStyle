import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/shared_widgets.dart';

class NotificationItem {
  final String id;
  final String title;
  final String message;
  final String type; // 'order', 'tryon', 'offer', 'reminder'
  final DateTime time;
  bool isRead;
  final String? actionRoute;

  NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.time,
    this.isRead = false,
    this.actionRoute,
  });
}

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  String _selectedFilter = 'all';

  final List<NotificationItem> _notifications = [
    NotificationItem(
      id: '1',
      title: '✨ AI Try-On Render Completed!',
      message:
          'Your try-on with Royal Crimson Sabyasachi Velvet Lehenga is ready for preview in 4K resolution.',
      type: 'tryon',
      time: DateTime.now().subtract(const Duration(minutes: 15)),
      actionRoute: '/ai-tryon-history',
    ),
    NotificationItem(
      id: '2',
      title: '🚚 Order #WS-8291 Shipped',
      message:
          'Your bridal lehenga is packed and dispatched via Express Air. Expected delivery by tomorrow.',
      type: 'order',
      time: DateTime.now().subtract(const Duration(hours: 2)),
      actionRoute: '/orders',
    ),
    NotificationItem(
      id: '3',
      title: '🎉 Bridal Flash Sale 25% Off',
      message:
          'Exclusive 24hr access: Use code WEDDING25 for 25% off all bridal heritage collections.',
      type: 'offer',
      time: DateTime.now().subtract(const Duration(hours: 6)),
      actionRoute: '/categories',
    ),
    NotificationItem(
      id: '4',
      title: '💍 48 Days to Your Wedding!',
      message:
          'Time to finalize jewelry matching and bridesmaid ensemble coordination with our stylist concierge.',
      type: 'reminder',
      time: DateTime.now().subtract(const Duration(days: 1)),
      actionRoute: '/profile',
    ),
    NotificationItem(
      id: '5',
      title: '📦 Order #WS-7412 Delivered',
      message:
          'Handcrafted Kundan Choker Set was delivered to your residence. Rate your experience!',
      type: 'order',
      time: DateTime.now().subtract(const Duration(days: 2)),
      isRead: true,
      actionRoute: '/orders',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final filtered = _selectedFilter == 'all'
        ? _notifications
        : _notifications.where((n) => n.type == _selectedFilter).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Notifications',
          style: TextStyle(
            fontFamily: 'Cormorant',
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                for (var n in _notifications) {
                  n.isRead = true;
                }
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('All marked as read')),
              );
            },
            child: const Text(
              'Mark all read',
              style: TextStyle(
                color: AppColors.primary,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                _buildFilterChip('all', 'All'),
                _buildFilterChip('tryon', '✨ AI Try-On'),
                _buildFilterChip('order', '📦 Orders'),
                _buildFilterChip('offer', '🏷️ Offers'),
                _buildFilterChip('reminder', '💍 Reminders'),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // List
          Expanded(
            child: filtered.isEmpty
                ? const EmptyStateWidget(
                    icon: Icons.notifications_none,
                    title: 'No Notifications',
                    subtitle:
                        'You are all caught up with your wedding updates.',
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final item = filtered[index];
                      return _buildNotificationCard(item);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String key, String label) {
    final isSelected = _selectedFilter == key;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (_) => setState(() => _selectedFilter = key),
        selectedColor: AppColors.primary.withValues(alpha: 0.15),
        checkmarkColor: AppColors.primary,
        labelStyle: GoogleFontsHelper.inter(
          fontSize: 12,
          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
          color: isSelected ? AppColors.primary : AppColors.textSecondary,
        ),
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: isSelected ? AppColors.primary : AppColors.border,
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationCard(NotificationItem item) {
    IconData icon;
    Color iconColor;

    switch (item.type) {
      case 'tryon':
        icon = Icons.auto_awesome;
        iconColor = AppColors.primary;
        break;
      case 'order':
        icon = Icons.local_shipping_outlined;
        iconColor = AppColors.secondary;
        break;
      case 'offer':
        icon = Icons.local_offer_outlined;
        iconColor = AppColors.accentGold;
        break;
      default:
        icon = Icons.favorite_border;
        iconColor = AppColors.goldDark;
    }

    return Dismissible(
      key: Key(item.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: AppColors.error.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.delete_outline, color: AppColors.error),
      ),
      onDismissed: (_) {
        setState(() => _notifications.removeWhere((n) => n.id == item.id));
      },
      child: GestureDetector(
        onTap: () {
          setState(() => item.isRead = true);
          if (item.actionRoute != null) {
            context.push(item.actionRoute!);
          }
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: item.isRead
                ? AppColors.surface
                : AppColors.primary.withValues(alpha: 0.04),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: item.isRead
                  ? AppColors.border
                  : AppColors.primary.withValues(alpha: 0.25),
            ),
            boxShadow: AppShadows.card,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            item.title,
                            style: GoogleFontsHelper.inter(
                              fontSize: 14,
                              fontWeight: item.isRead
                                  ? FontWeight.w600
                                  : FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        if (!item.isRead)
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.message,
                      style: AppTextStyles.bodyText.copyWith(
                        fontSize: 13,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      DateFormat('h:mm a • MMM d').format(item.time),
                      style: AppTextStyles.caption.copyWith(fontSize: 11),
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
}
