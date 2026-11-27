import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/providers.dart';
import '../../../core/widgets/shared_widgets.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _mobileCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmPassCtrl = TextEditingController();
  final _cityCtrl = TextEditingController();
  String? _selectedGender;
  DateTime? _weddingDate;
  bool _obscurePass = true;
  bool _obscureConfirmPass = true;

  final List<String> _genders = ['Female', 'Prefer not to say'];

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _mobileCtrl.dispose();
    _passCtrl.dispose();
    _confirmPassCtrl.dispose();
    _cityCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickWeddingDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 90)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
      builder: (_, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(primary: AppColors.primary),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _weddingDate = picked);
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    final auth = context.read<AuthProvider>();
    final success = await auth.register(
      name: _nameCtrl.text.trim(),
      email: _emailCtrl.text.trim(),
      mobile: _mobileCtrl.text.trim(),
      password: _passCtrl.text,
      gender: _selectedGender,
      weddingDate: _weddingDate?.toIso8601String(),
      city: _cityCtrl.text.trim().isNotEmpty ? _cityCtrl.text.trim() : null,
    );
    if (mounted) {
      if (success)
        context.go('/home');
      else
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(auth.error ?? 'Registration failed'),
            backgroundColor: AppColors.error,
          ),
        );
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
              // Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(24, 32, 24, 32),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF4A0F24), Color(0xFF8B2250)],
                  ),
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(32),
                  ),
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                      ),
                      onPressed: () => context.pop(),
                    ),
                    const Expanded(
                      child: Column(
                        children: [
                          Text('💒', style: TextStyle(fontSize: 36)),
                          Text(
                            'Create Account',
                            style: TextStyle(
                              fontFamily: 'Cormorant',
                              fontSize: 28,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              letterSpacing: 1,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Join the WedStyle family',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 13,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 40),
                  ],
                ),
              ),

              // Form
              Padding(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      _buildSectionLabel('Personal Information'),
                      const SizedBox(height: 12),
                      _buildTextField(
                        _nameCtrl,
                        'Full Name',
                        Icons.person_outline,
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? 'Name is required'
                            : null,
                      ),
                      const SizedBox(height: 12),
                      _buildTextField(
                        _emailCtrl,
                        'Email Address',
                        Icons.email_outlined,
                        type: TextInputType.emailAddress,
                        validator: (v) {
                          if (v == null || v.isEmpty)
                            return 'Email is required';
                          if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(v))
                            return 'Enter a valid email';
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      _buildTextField(
                        _mobileCtrl,
                        'Mobile Number',
                        Icons.phone_outlined,
                        type: TextInputType.phone,
                        validator: (v) {
                          if (v == null || v.isEmpty)
                            return 'Mobile is required';
                          if (v.length < 10)
                            return 'Enter a valid mobile number';
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),

                      // Gender dropdown
                      DropdownButtonFormField<String>(
                        value: _selectedGender,
                        decoration: InputDecoration(
                          labelText: 'Gender',
                          prefixIcon: const Icon(
                            Icons.wc_outlined,
                            color: AppColors.textTertiary,
                          ),
                          filled: true,
                          fillColor: AppColors.surface,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: AppColors.divider,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: AppColors.divider,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: AppColors.primary,
                              width: 1.5,
                            ),
                          ),
                        ),
                        items: _genders
                            .map(
                              (g) => DropdownMenuItem(value: g, child: Text(g)),
                            )
                            .toList(),
                        onChanged: (v) => setState(() => _selectedGender = v),
                      ),
                      const SizedBox(height: 24),

                      _buildSectionLabel('Wedding Details (Optional)'),
                      const SizedBox(height: 12),

                      // Wedding date
                      GestureDetector(
                        onTap: _pickWeddingDate,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.divider),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.calendar_today_outlined,
                                color: AppColors.textTertiary,
                                size: 20,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  _weddingDate != null
                                      ? '${_weddingDate!.day}/${_weddingDate!.month}/${_weddingDate!.year}'
                                      : 'Wedding Date',
                                  style: TextStyle(
                                    color: _weddingDate != null
                                        ? AppColors.textPrimary
                                        : AppColors.textHint,
                                    fontFamily: 'Inter',
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              const Icon(
                                Icons.arrow_drop_down,
                                color: AppColors.textTertiary,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildTextField(
                        _cityCtrl,
                        'City',
                        Icons.location_city_outlined,
                      ),
                      const SizedBox(height: 24),

                      _buildSectionLabel('Security'),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _passCtrl,
                        obscureText: _obscurePass,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          prefixIcon: const Icon(
                            Icons.lock_outline,
                            color: AppColors.textTertiary,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePass
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: AppColors.textTertiary,
                            ),
                            onPressed: () =>
                                setState(() => _obscurePass = !_obscurePass),
                          ),
                        ),
                        validator: (v) => (v == null || v.length < 6)
                            ? 'Min 6 characters'
                            : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _confirmPassCtrl,
                        obscureText: _obscureConfirmPass,
                        decoration: InputDecoration(
                          labelText: 'Confirm Password',
                          prefixIcon: const Icon(
                            Icons.lock_outline,
                            color: AppColors.textTertiary,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureConfirmPass
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: AppColors.textTertiary,
                            ),
                            onPressed: () => setState(
                              () => _obscureConfirmPass = !_obscureConfirmPass,
                            ),
                          ),
                        ),
                        validator: (v) => v != _passCtrl.text
                            ? 'Passwords do not match'
                            : null,
                      ),
                      const SizedBox(height: 32),

                      PrimaryButton(
                        text: 'Create Account',
                        isLoading: auth.isLoading,
                        onPressed: _register,
                        icon: Icons.person_add_outlined,
                      ),
                      const SizedBox(height: 20),

                      Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Already have an account? ',
                              style: AppTextStyles.caption.copyWith(
                                fontSize: 14,
                              ),
                            ),
                            GestureDetector(
                              onTap: () => context.pop(),
                              child: Text(
                                'Login',
                                style: GoogleFontsHelper.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
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

  Widget _buildSectionLabel(String label) {
    return Row(
      children: [
        Container(
          width: 3,
          height: 16,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: GoogleFontsHelper.inter(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: AppColors.primary,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(
    TextEditingController ctrl,
    String label,
    IconData icon, {
    TextInputType type = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: ctrl,
      keyboardType: type,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppColors.textTertiary),
      ),
      validator: validator,
    );
  }
}
