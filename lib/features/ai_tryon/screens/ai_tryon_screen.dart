import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io' if (dart.library.html) 'dart:html';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/providers.dart';
import '../../../core/utils/mock_data.dart';
import '../../../core/widgets/shared_widgets.dart';

class AiTryOnScreen extends StatefulWidget {
  const AiTryOnScreen({super.key});

  @override
  State<AiTryOnScreen> createState() => _AiTryOnScreenState();
}

class _AiTryOnScreenState extends State<AiTryOnScreen> {
  int _step = 0; // 0=Upload, 1=Select Outfit, 2=Generating
  bool _hasConsent = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final p = context.read<AiTryOnProvider>();
      p.setUserPhoto('assets/images/user_face.jpg');
      if (p.selectedProduct == null && MockData.products.isNotEmpty) {
        p.setSelectedProduct(MockData.products.first);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AiTryOnProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Row(
          children: [
            const Text('✨', style: TextStyle(fontSize: 20)),
            const SizedBox(width: 8),
            const Text(
              'AI Virtual Try-On',
              style: TextStyle(
                fontFamily: 'Cormorant',
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        actions: [
          TextButton.icon(
            icon: const Icon(Icons.history, size: 18),
            label: const Text('History'),
            onPressed: () => context.push('/ai-tryon-history'),
          ),
        ],
      ),
      body: provider.isGenerating
          ? _buildGenerating(provider)
          : Column(
              children: [
                _buildStepper(),
                Expanded(
                  child: _step == 0
                      ? _buildUploadStep(provider)
                      : _buildSelectOutfitStep(provider),
                ),
                _buildBottomBar(provider),
              ],
            ),
    );
  }

  Widget _buildStepper() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      color: AppColors.surface,
      child: Row(
        children: [
          _buildStepCircle(1, 'Upload Photo', _step >= 0),
          _buildStepLine(_step >= 1),
          _buildStepCircle(2, 'Select Outfit', _step >= 1),
          _buildStepLine(_step >= 2),
          _buildStepCircle(3, 'Generate', _step >= 2),
        ],
      ),
    );
  }

  Widget _buildStepCircle(int num, String label, bool active) {
    return Column(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: active ? AppColors.primary : AppColors.divider,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              '$num',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFontsHelper.inter(
            fontSize: 10,
            color: active ? AppColors.primary : AppColors.textTertiary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildStepLine(bool active) {
    return Expanded(
      child: Container(
        height: 2,
        margin: const EdgeInsets.only(bottom: 20),
        color: active ? AppColors.primary : AppColors.divider,
      ),
    );
  }

  Widget _buildUploadStep(AiTryOnProvider provider) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Info banner
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primary.withOpacity(0.08),
                  AppColors.secondary.withOpacity(0.08),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.primary.withOpacity(0.2)),
            ),
            child: Column(
              children: [
                const Text('🪞', style: TextStyle(fontSize: 36)),
                const SizedBox(height: 8),
                Text('Upload Your Photo', style: AppTextStyles.sectionTitle),
                const SizedBox(height: 4),
                Text(
                  'Upload a clear full-body photo for the best result.\nOur AI preserves your face, body shape, and skin tone.',
                  style: AppTextStyles.caption.copyWith(
                    fontSize: 13,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Photo preview or upload zone
          GestureDetector(
            onTap: () => _showImageSourceSheet(context, provider),
            child: provider.currentUserPhotoPath != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: AppNetworkImage(
                      url: provider.currentUserPhotoPath!,
                      height: 280,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  )
                : Container(
                    height: 280,
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: AppColors.primary.withOpacity(0.3),
                        width: 2,
                        style: BorderStyle.solid,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 72,
                          height: 72,
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.08),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.add_a_photo_outlined,
                            color: AppColors.primary,
                            size: 32,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Tap to upload photo',
                          style: GoogleFontsHelper.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text('Camera or Gallery', style: AppTextStyles.caption),
                      ],
                    ),
                  ),
          ),

          if (provider.currentUserPhotoPath != null) ...[
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.camera_alt_outlined, size: 18),
                    label: const Text('Change / Upload Other Photo'),
                    onPressed: () => _showImageSourceSheet(context, provider),
                  ),
                ),
              ],
            ),
          ],

          // Quick face selection row
          const SizedBox(height: 20),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Select Face / Model Profile:',
              style: GoogleFontsHelper.inter(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 76,
            child: Builder(
              builder: (context) {
                final faceOptions = <(String, String)>[
                  ('assets/images/user_face.jpg', 'My Face'),
                  ('assets/images/bridal/contemporary_01.png', 'Model 1'),
                  ('assets/images/bridal/contemporary_02.png', 'Model 2'),
                  ('assets/images/bridal/contemporary_03.png', 'Model 3'),
                  ('assets/images/bridal/contemporary_04.png', 'Model 4'),
                  ('assets/images/bridal/patola_01.png', 'Model 5'),
                ];

                return ListView(
                  scrollDirection: Axis.horizontal,
                  children: faceOptions.map((item) {
                    final isSel = provider.currentUserPhotoPath == item.$1;
                    return GestureDetector(
                      onTap: () => provider.setUserPhoto(item.$1),
                      child: Container(
                        margin: const EdgeInsets.only(right: 12),
                        width: 62,
                        height: 76,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: isSel ? AppColors.primary : AppColors.border,
                            width: isSel ? 2.5 : 1,
                          ),
                          boxShadow: isSel
                              ? [
                                  BoxShadow(
                                    color: AppColors.primary.withValues(alpha: 0.3),
                                    blurRadius: 6,
                                    offset: const Offset(0, 2),
                                  ),
                                ]
                              : null,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              AppNetworkImage(url: item.$1, fit: BoxFit.cover),
                              if (isSel)
                                Container(
                                  color: AppColors.primary.withValues(alpha: 0.25),
                                  child: const Center(
                                    child: Icon(Icons.check_circle, color: Colors.white, size: 22),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ),

          const SizedBox(height: 24),
          CheckboxListTile(
            value: _hasConsent,
            contentPadding: EdgeInsets.zero,
            activeColor: AppColors.primary,
            title: const Text(
              'I consent to securely send this photo for virtual try-on processing.',
            ),
            subtitle: const Text(
              'Do not upload anyone else’s photo without their permission.',
            ),
            onChanged: (value) => setState(() => _hasConsent = value ?? false),
          ),
          const SizedBox(height: 12),
          // Tips
          _buildTipCard(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildTipCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '📸 Tips for best results',
            style: GoogleFontsHelper.inter(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 10),
          ...[
            'Use a full-body photo',
            'Stand in front of a plain background',
            'Wear form-fitting clothes for accuracy',
            'Ensure good lighting',
            'Look straight ahead',
          ].map(
            (t) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                children: [
                  const Icon(
                    Icons.check_circle_outline,
                    size: 14,
                    color: AppColors.success,
                  ),
                  const SizedBox(width: 6),
                  Text(t, style: AppTextStyles.caption.copyWith(fontSize: 12)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectOutfitStep(AiTryOnProvider provider) {
    final products = MockData.products.where((p) => p.aiTryOnEnabled).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Selected outfit preview
        if (provider.selectedProduct != null)
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.06),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.primary.withOpacity(0.2)),
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: AppNetworkImage(
                    url: provider.selectedProduct!.images.first,
                    width: 60,
                    height: 70,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Selected Outfit',
                        style: GoogleFontsHelper.inter(
                          fontSize: 11,
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        provider.selectedProduct!.name,
                        style: AppTextStyles.productName,
                        maxLines: 2,
                      ),
                      Text(
                        '₹${provider.selectedProduct!.discountedPrice.toStringAsFixed(0)}',
                        style: AppTextStyles.price,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, size: 18),
                  onPressed: () =>
                      provider.setSelectedProduct(MockData.products.first),
                ),
              ],
            ),
          ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Choose an Outfit to Try',
            style: AppTextStyles.sectionTitle.copyWith(fontSize: 18),
          ),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.65,
            ),
            itemCount: products.length,
            itemBuilder: (_, i) => _buildOutfitCard(products[i], provider),
          ),
        ),
      ],
    );
  }

  Widget _buildOutfitCard(product, AiTryOnProvider provider) {
    final isSelected = provider.selectedProduct?.id == product.id;
    return GestureDetector(
      onTap: () => provider.setSelectedProduct(product),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.transparent,
            width: 2,
          ),
          boxShadow: isSelected ? AppShadows.button : AppShadows.card,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(14),
                ),
                child: AppNetworkImage(
                  url: product.images.first,
                  width: double.infinity,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: AppTextStyles.productName.copyWith(fontSize: 12),
                    maxLines: 2,
                  ),
                  Text(
                    '₹${product.discountedPrice.toStringAsFixed(0)}',
                    style: AppTextStyles.price.copyWith(fontSize: 13),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 6),
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(14),
                  ),
                ),
                child: const Text(
                  '✓ Selected',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildGenerating(AiTryOnProvider provider) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primary, AppColors.primaryLight],
                ),
                shape: BoxShape.circle,
                boxShadow: AppShadows.button,
              ),
              child: const Center(
                child: Text('🪞', style: TextStyle(fontSize: 56)),
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'Creating Your WedStyle Look...',
              style: AppTextStyles.elegantTitle.copyWith(fontSize: 22),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Your selected photo and outfit are being sent securely for processing.\nResults may vary by pose, garment, and provider capability.',
              style: AppTextStyles.caption.copyWith(fontSize: 13, height: 1.6),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            // Progress bar
            LinearProgressIndicator(
              value: provider.generationProgress,
              backgroundColor: AppColors.divider,
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppColors.primary,
              ),
              minHeight: 6,
              borderRadius: BorderRadius.circular(3),
            ),
            const SizedBox(height: 12),
            Text(
              '${(provider.generationProgress * 100).round()}% complete',
              style: GoogleFontsHelper.inter(
                fontSize: 13,
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 32),
            // Tips while loading
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                '✨ Did you know? Our AI preserves your facial features, skin tone, and body proportions for the most realistic try-on experience.',
                style: AppTextStyles.caption.copyWith(
                  fontSize: 12,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar(AiTryOnProvider provider) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: AppShadows.navbar,
      ),
      child: Row(
        children: [
          if (_step > 0)
            Expanded(
              child: SecondaryButton(
                text: 'Back',
                icon: Icons.arrow_back_ios,
                onPressed: () => setState(() => _step--),
              ),
            ),
          if (_step > 0) const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: PrimaryButton(
              text: _step == 0 ? 'Next: Select Outfit' : 'Generate My Look',
              icon: _step == 0 ? Icons.arrow_forward : Icons.auto_fix_high,
              isLoading: provider.isGenerating,
              onPressed: () async {
                if (_step == 0) {
                  if (provider.currentUserPhotoPath == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please upload your photo first'),
                      ),
                    );
                    return;
                  }
                  setState(() => _step = 1);
                } else {
                  if (provider.selectedProduct == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please select an outfit')),
                    );
                    return;
                  }
                  if (!_hasConsent) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Please provide photo-processing consent first.',
                        ),
                      ),
                    );
                    return;
                  }
                  final result = await provider.generateTryOn();
                  if (result != null && mounted) {
                    context.push('/ai-tryon-result');
                  } else if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          provider.generationError ??
                              'Try-on could not be completed.',
                        ),
                      ),
                    );
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showImageSourceSheet(
    BuildContext context,
    AiTryOnProvider provider,
  ) async {
    await showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Choose Photo Source', style: AppTextStyles.sectionTitle),
            const SizedBox(height: 20),
            ListTile(
              leading: const CircleAvatar(
                backgroundColor: AppColors.primaryLight,
                child: Icon(Icons.camera_alt, color: Colors.white),
              ),
              title: const Text('Take a Photo'),
              subtitle: const Text('Use your camera'),
              onTap: () async {
                Navigator.pop(context);
                await _pickImage(ImageSource.camera, provider);
              },
            ),
            ListTile(
              leading: const CircleAvatar(
                backgroundColor: AppColors.secondary,
                child: Icon(Icons.photo_library, color: Colors.white),
              ),
              title: const Text('Choose from Gallery'),
              subtitle: const Text('Select from your photos'),
              onTap: () async {
                Navigator.pop(context);
                await _pickImage(ImageSource.gallery, provider);
              },
            ),
            ListTile(
              leading: const CircleAvatar(
                backgroundColor: AppColors.gold,
                child: Icon(Icons.face, color: Colors.black),
              ),
              title: const Text('Use My Face Photo'),
              subtitle: const Text('Directly use uploaded face photo'),
              onTap: () {
                Navigator.pop(context);
                provider.setUserPhoto('assets/images/user_face.jpg');
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source, AiTryOnProvider provider) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: source,
      imageQuality: 85,
      maxWidth: 1080,
    );
    if (picked != null) {
      provider.setUserPhoto(picked.path);
    }
  }
}
