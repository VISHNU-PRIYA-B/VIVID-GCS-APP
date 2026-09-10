import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vivid_mapping_sandbox/ui/app_theme.dart';
import 'package:vivid_mapping_sandbox/ui/gcs_sidebar.dart';
import 'package:vivid_mapping_sandbox/ui/gcs_widgets.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}


class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _obscure = true;
  bool _loading = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;
    setState(() => _loading = false);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final pad = AppTheme.screenPad(context);

    return GcsScaffold(
      screenTitle: 'Register Operator',
      screenCode: 'SYS · AUTH · REG',
      accentColor: AppTheme.cyan,
      items: _sidebarItems(context),
      activeIndex: -1,
      body: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: GridPainter(
                spacing: 32,
                color: AppTheme.borderDim.withOpacity(0.4),
              ),
            ),
          ),
          SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: pad, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Header ─────────────────────────────────────────────────
                Text(
                  'NEW OPERATOR',
                  style: GoogleFonts.barlowCondensed(
                    fontSize: 30,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.textHi,
                    letterSpacing: 1,
                  ),
                ),
                Text(
                  'Create your operator credentials',
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 10,
                    color: AppTheme.textMid,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 28),

                // ── Form ───────────────────────────────────────────────────
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppTheme.bgCard,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppTheme.borderMid),
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GcsSectionLabel('Identity'),
                        const SizedBox(height: 12),
                        GcsTextField(
                          controller: _nameCtrl,
                          label: 'Full name',
                          hint: 'Operator name',
                          textInputAction: TextInputAction.next,
                          prefixIcon: Icon(
                            Icons.person_outline_rounded,
                            size: 17,
                            color: AppTheme.textLo,
                          ), // Removed const
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) {
                              return 'Name required';
                            }
                            return RegExp(r'^[a-zA-Z ]+$').hasMatch(v.trim())
                                ? null
                                : 'Enter a valid name';
                          },
                        ),
                        const SizedBox(height: 14),
                        GcsTextField(
                          controller: _emailCtrl,
                          label: 'Email address',
                          hint: 'operator@vivid.io',
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          prefixIcon: Icon(
                            Icons.mail_outline_rounded,
                            size: 17,
                            color: AppTheme.textLo,
                          ), // Removed const
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) {
                              return 'Email required';
                            }
                            if (!v.contains('@')) return 'Invalid email';
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        GcsSectionLabel('Security'),
                        const SizedBox(height: 12),
                        GcsTextField(
                          controller: _passwordCtrl,
                          label: 'Password',
                          obscureText: _obscure,
                          textInputAction: TextInputAction.next,
                          prefixIcon: Icon(
                            Icons.lock_outline_rounded,
                            size: 17,
                            color: AppTheme.textLo,
                          ), // Removed const
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscure
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              size: 17,
                              color: AppTheme.textLo,
                            ),
                            onPressed: () =>
                                setState(() => _obscure = !_obscure),
                          ),
                          validator: (v) {
                            if (v == null || v.isEmpty) {
                              return 'Password required';
                            }
                            if (v.length < 6) return 'Min 6 characters';
                            return null;
                          },
                        ),
                        const SizedBox(height: 14),
                        GcsTextField(
                          controller: _confirmCtrl,
                          label: 'Confirm password',
                          obscureText: _obscure,
                          textInputAction: TextInputAction.done,
                          onEditingComplete: _submit,
                          prefixIcon: Icon(
                            Icons.lock_outline_rounded,
                            size: 17,
                            color: AppTheme.textLo,
                          ), // Removed const
                          validator: (v) {
                            if (v != _passwordCtrl.text) {
                              return 'Passwords do not match';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),
                        GcsButton(
                          label: 'Create Operator Account',
                          onPressed: _submit,
                          isLoading: _loading,
                          width: double.infinity,
                          icon: Icons.person_add_rounded,
                        ),
                        const SizedBox(height: 16),
                        Center(
                          child: GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Have an account?  ',
                                    style: GoogleFonts.jetBrainsMono(
                                      fontSize: 11,
                                      color: AppTheme.textMid,
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'SIGN IN',
                                    style: GoogleFonts.jetBrainsMono(
                                      fontSize: 11,
                                      color: AppTheme.cyan,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<SidebarItem> _sidebarItems(BuildContext ctx) => [
    SidebarItem(
      icon: Icons.login_rounded,
      label: 'Sign In',
      sublabel: 'Return to login',
      onTap: () => Navigator.pop(ctx),
    ),
  ];
}