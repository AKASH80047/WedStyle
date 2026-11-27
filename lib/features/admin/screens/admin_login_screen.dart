import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/shared_widgets.dart';

class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({super.key});

  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  final _emailCtrl = TextEditingController(text: 'admin@wedstyle.luxury');
  final _passwordCtrl = TextEditingController(text: 'Admin@2026');
  bool _isLoading = false;
  bool _obscurePassword = true;

  void _login() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 700));
    if (mounted) {
      setState(() => _isLoading = false);
      context.go('/admin');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF130912),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 440),
            child: Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: const Color(0xFF1E121D),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.gold.withValues(alpha: 0.3)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.6),
                    blurRadius: 30,
                    offset: const Offset(0, 15),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.gold.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.shield_outlined, color: AppColors.goldLight, size: 40),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'WedStyle Portal',
                    style: AppTextStyles.headline.copyWith(color: Colors.white, fontSize: 28),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Enterprise Fashion & AI Management Suite',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.caption.copyWith(color: AppColors.goldLight.withValues(alpha: 0.8)),
                  ),
                  const SizedBox(height: 32),

                  // Email
                  TextField(
                    controller: _emailCtrl,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Admin Username / Email',
                      labelStyle: TextStyle(color: Colors.white.withValues(alpha: 0.7)),
                      prefixIcon: const Icon(Icons.email_outlined, color: AppColors.gold),
                      filled: true,
                      fillColor: const Color(0xFF281927),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Password
                  TextField(
                    controller: _passwordCtrl,
                    obscureText: _obscurePassword,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Security Key / Password',
                      labelStyle: TextStyle(color: Colors.white.withValues(alpha: 0.7)),
                      prefixIcon: const Icon(Icons.lock_outline, color: AppColors.gold),
                      suffixIcon: IconButton(
                        icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility, color: Colors.white54),
                        onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                      ),
                      filled: true,
                      fillColor: const Color(0xFF281927),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                    ),
                  ),
                  const SizedBox(height: 24),

                  AppButton(
                    text: 'Authenticate & Access Panel',
                    isLoading: _isLoading,
                    onPressed: _login,
                  ),
                  const SizedBox(height: 16),

                  TextButton.icon(
                    onPressed: () => context.go('/home'),
                    icon: const Icon(Icons.arrow_back, color: AppColors.goldLight, size: 16),
                    label: const Text('Back to Customer Marketplace', style: TextStyle(color: AppColors.goldLight, fontSize: 13)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
