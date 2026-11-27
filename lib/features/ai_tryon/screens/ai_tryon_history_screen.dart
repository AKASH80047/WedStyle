import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/providers.dart';
import '../../../core/utils/models.dart';
import '../../../core/widgets/shared_widgets.dart';
import 'package:intl/intl.dart';

class AiTryOnHistoryScreen extends StatefulWidget {
  const AiTryOnHistoryScreen({super.key});

  @override
  State<AiTryOnHistoryScreen> createState() => _AiTryOnHistoryScreenState();
}

class _AiTryOnHistoryScreenState extends State<AiTryOnHistoryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AiTryOnProvider>().loadHistory();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AiTryOnProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Try-On History', style: TextStyle(fontFamily: 'Cormorant', fontSize: 22, fontWeight: FontWeight.w700)),
      ),
      body: provider.history.isEmpty
        ? EmptyStateWidget(
            emoji: '🪞',
            title: 'No Looks Yet',
            subtitle: 'Try your first wedding outfit with AI and see how it looks on you.',
            actionLabel: 'Try Your First Look',
            onAction: () {
              context.pop();
              context.go('/ai-tryon');
            },
          )
        : ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: provider.history.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (_, i) => _buildHistoryCard(context, provider.history[i], provider),
          ),
    );
  }

  Widget _buildHistoryCard(BuildContext context, AiTryOnModel item, AiTryOnProvider provider) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface, borderRadius: BorderRadius.circular(16), boxShadow: AppShadows.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image row
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Row(
              children: [
                Expanded(child: Stack(children: [
                  AppNetworkImage(
                    url: item.userPhotoUrl.isNotEmpty
                        ? item.userPhotoUrl
                        : 'assets/images/bridal/contemporary_01.png',
                    height: 200,
                  ),
                  const Positioned(bottom: 8, left: 8,
                    child: _ImageLabel(text: 'Your Photo')),
                ])),
                Container(width: 2, height: 200, color: AppColors.background),
                Expanded(child: Stack(children: [
                  AppNetworkImage(url: item.resultImageUrl ?? item.productImage, height: 200),
                  const Positioned(bottom: 8, right: 8,
                    child: _ImageLabel(text: 'With Outfit')),
                ])),
              ],
            ),
          ),

          // Info
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(item.productName, style: AppTextStyles.productName, maxLines: 1),
                    const SizedBox(height: 3),
                    Text(DateFormat('MMM d, yyyy').format(item.createdAt), style: AppTextStyles.caption),
                  ])),
                  StatusChip(status: item.status),
                ]),
                const SizedBox(height: 12),
                Row(children: [
                  Expanded(child: _HistoryAction(
                    icon: Icons.visibility_outlined, label: 'View',
                    onTap: () => context.push('/ai-tryon-result'),
                  )),
                  const SizedBox(width: 8),
                  Expanded(child: _HistoryAction(
                    icon: Icons.share_outlined, label: 'Share',
                    onTap: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Sharing...'))),
                  )),
                  const SizedBox(width: 8),
                  Expanded(child: _HistoryAction(
                    icon: Icons.shopping_bag_outlined, label: 'Buy',
                    onTap: () => context.push('/product/${item.productId}'),
                  )),
                  const SizedBox(width: 8),
                  _HistoryAction(
                    icon: Icons.delete_outline, label: 'Delete',
                    color: AppColors.error,
                    onTap: () => _confirmDelete(context, item.id, provider),
                  ),
                ]),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, String id, AiTryOnProvider provider) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Look?'),
        content: const Text('This will permanently remove this look from your history.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () {
              provider.deleteHistory(id);
              Navigator.pop(context);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

class _ImageLabel extends StatelessWidget {
  final String text;
  const _ImageLabel({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(6)),
      child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w600)),
    );
  }
}

class _HistoryAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? color;
  const _HistoryAction({required this.icon, required this.label, required this.onTap, this.color});

  @override
  Widget build(BuildContext context) {
    final c = color ?? AppColors.textSecondary;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: c.withOpacity(0.06), borderRadius: BorderRadius.circular(8),
          border: Border.all(color: c.withOpacity(0.2)),
        ),
        child: Column(children: [
          Icon(icon, size: 16, color: c),
          const SizedBox(height: 3),
          Text(label, style: GoogleFontsHelper.inter(fontSize: 10, fontWeight: FontWeight.w600, color: c)),
        ]),
      ),
    );
  }
}
