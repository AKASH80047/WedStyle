import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/providers.dart';
import '../../../core/widgets/shared_widgets.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _obscurePass = true;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    final auth = context.read<AuthProvider>();
    final success = await auth.login(_emailCtrl.text.trim(), _passCtrl.text);
    if (mounted) {
      if (success) {
        context.go('/home');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(auth.error ?? 'Login failed'), backgroundColor: AppColors.error),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header with gradient
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(24, 40, 24, 40),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF4A0F24), Color(0xFF8B2250)],
                  ),
                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
                ),
                child: Column(
                  children: [
                    Text('💒', style: TextStyle(fontSize: 48)),
                    const SizedBox(height: 12),
                    const Text(
                      AppConstants.appName,
                      style: TextStyle(
                        fontFamily: 'Cormorant', fontSize: 38, fontWeight: FontWeight.w700,
                        color: Colors.white, letterSpacing: 3,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      AppConstants.appShortTagline,
                      style: TextStyle(fontFamily: 'Inter', fontSize: 13, color: Colors.white.withOpacity(0.75), letterSpacing: 1.5),
                    ),
                  ],
                ),
              ),

              // Login form
              Padding(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      Text('Welcome back', style: AppTextStyles.elegantTitle),
                      const SizedBox(height: 4),
                      Text('Sign in to your WedStyle account', style: AppTextStyles.caption.copyWith(fontSize: 14)),
                      const SizedBox(height: 28),

                      // Email/Mobile field
                      TextFormField(
                        controller: _emailCtrl,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: 'Email / Mobile Number',
                          prefixIcon: Icon(Icons.person_outline, color: AppColors.textTertiary),
                        ),
                        validator: (v) => (v == null || v.isEmpty) ? 'Please enter email or mobile' : null,
                      ),
                      const SizedBox(height: 16),

                      // Password field
                      TextFormField(
                        controller: _passCtrl,
                        obscureText: _obscurePass,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          prefixIcon: const Icon(Icons.lock_outline, color: AppColors.textTertiary),
                          suffixIcon: IconButton(
                            icon: Icon(_obscurePass ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                                color: AppColors.textTertiary),
                            onPressed: () => setState(() => _obscurePass = !_obscurePass),
                          ),
                        ),
                        validator: (v) => (v == null || v.length < 6) ? 'Password must be at least 6 characters' : null,
                      ),

                      // Forgot password
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () => _showForgotPasswordDialog(),
                          child: const Text('Forgot Password?'),
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Login button
                      PrimaryButton(
                        text: 'Login',
                        isLoading: auth.isLoading,
                        onPressed: _login,
                        icon: Icons.login,
                      ),
                      const SizedBox(height: 16),

                      // Divider
                      Row(
                        children: [
                          const Expanded(child: Divider()),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text('or continue with', style: AppTextStyles.caption),
                          ),
                          const Expanded(child: Divider()),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Social login
                      Row(
                        children: [
                          Expanded(child: _SocialButton(
                            label: 'Google',
                            icon: '🇬',
                            onTap: () => context.go('/home'),
                          )),
                          const SizedBox(width: 12),
                          Expanded(child: _SocialButton(
                            label: 'Apple',
                            icon: '🍎',
                            onTap: () => context.go('/home'),
                          )),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Guest login
                      SecondaryButton(
                        text: 'Continue as Guest',
                        icon: Icons.person_outline,
                        onPressed: () async {
                          await context.read<AuthProvider>().continueAsGuest();
                          if (mounted) context.go('/home');
                        },
                      ),
                      const SizedBox(height: 24),

                      // Register link
                      Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text("Don't have an account? ", style: AppTextStyles.caption.copyWith(fontSize: 14)),
                            GestureDetector(
                              onTap: () => context.push('/register'),
                              child: Text('Create Account', style: GoogleFontsHelper.inter(
                                fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.primary,
                              )),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Admin link
                      Center(
                        child: TextButton.icon(
                          onPressed: () => context.push('/admin/login'),
                          icon: const Icon(Icons.admin_panel_settings_outlined, size: 16),
                          label: const Text('Admin Panel'),
                          style: TextButton.styleFrom(foregroundColor: AppColors.textTertiary),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showForgotPasswordDialog() {
    final ctrl = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Reset Password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Enter your email to receive reset instructions.'),
            const SizedBox(height: 16),
            TextFormField(controller: ctrl, decoration: const InputDecoration(labelText: 'Email')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Password reset link sent!')),
              );
            },
            child: const Text('Send Link'),
          ),
        ],
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  final String label, icon;
  final VoidCallback onTap;
  const _SocialButton({required this.label, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 14),
        side: const BorderSide(color: AppColors.divider),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        foregroundColor: AppColors.textPrimary,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(icon, style: const TextStyle(fontSize: 18)),
          const SizedBox(width: 8),
          Text(label, style: GoogleFontsHelper.inter(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
        ],
      ),
    );
  }
}
