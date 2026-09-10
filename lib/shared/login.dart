import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vivid_mapping_sandbox/shared/bot_select.dart';
import 'package:vivid_mapping_sandbox/shared/signup.dart';
import 'package:vivid_mapping_sandbox/ui/app_theme.dart';
import 'package:vivid_mapping_sandbox/ui/gcs_widgets.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _obscure = true;
  bool _loading = false;

  late final AnimationController _entryCtrl;
  late final List<Animation<double>> _anims;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );
    _entryCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _anims = List.generate(
      5,
      (i) => CurvedAnimation(
        parent: _entryCtrl,
        curve: Interval(i * 0.12, 0.6 + i * 0.08, curve: Curves.easeOutCubic),
      ),
    );
    _entryCtrl.forward();
  }

  @override
  void dispose() {
    _entryCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: AppTheme.red),
    );
  }

  // RESTORED: Placeholder Authentication with Persistent Session Save!
  Future<void> _login() async {
    // 1. Validate that the email and 6-char password are entered
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _loading = true);

    // 2. Simulate a quick network loading delay (placeholder)
    await Future.delayed(const Duration(milliseconds: 700));

    if (!mounted) return;

    try {
      // 3. SAVE THE SESSION SO IT SKIPS LOGIN NEXT TIME
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);

      setState(() => _loading = false);

      // 4. Navigate to Bot Select
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const BotSelectScreen()),
      );
    } catch (e) {
      setState(() => _loading = false);
      _showError('Failed to save session state locally.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final pad = AppTheme.screenPad(context);
    final isWide = size.width >= 600;
    final topPad = MediaQuery.of(context).padding.top;

    return ValueListenableBuilder<bool>(
      valueListenable: AppTheme.isLightMode,
      builder: (context, isLight, _) {
        return Scaffold(
          backgroundColor: AppTheme.bg,
          body: Stack(
            children: [
              // ── Grid background ───────────────────────────────────────────────
              Positioned.fill(
                child: CustomPaint(
                  painter: GridPainter(
                    color: AppTheme.borderDim.withOpacity(0.5),
                    spacing: 32,
                  ),
                ),
              ),
              // ── Cyan glow top-left ────────────────────────────────────────────
              Positioned(
                top: -60,
                left: -60,
                child: Container(
                  width: 220,
                  height: 220,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        AppTheme.cyan.withOpacity(0.08),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),

              SafeArea(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: pad),
                  child: isWide
                      ? _wideLayout(topPad)
                      : _compactLayout(topPad, size),
                ),
              ),
              Positioned(
                top: topPad + 16,
                right: 16,
                child: const ThemeToggleButton(),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _formContent() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _FadeSlide(
            anim: _anims[2],
            child: GcsTextField(
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
                if (v == null || v.trim().isEmpty) return 'Email required';
                if (!v.contains('@')) return 'Invalid email';
                return null;
              },
            ),
          ),
          const SizedBox(height: 14),
          _FadeSlide(
            anim: _anims[3],
            child: GcsTextField(
              controller: _passwordCtrl,
              label: 'Password',
              obscureText: _obscure,
              textInputAction: TextInputAction.done,
              onEditingComplete: _login,
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
                onPressed: () => setState(() => _obscure = !_obscure),
              ),
              validator: (v) {
                if (v == null || v.isEmpty) return 'Password required';
                if (v.length < 6) return 'Min 6 characters';
                return null;
              },
            ),
          ),
          const SizedBox(height: 24),
          _FadeSlide(
            anim: _anims[4],
            child: GcsButton(
              label: 'Authenticate',
              onPressed: _login,
              isLoading: _loading,
              width: double.infinity,
              icon: Icons.login_rounded,
            ),
          ),
          const SizedBox(height: 20),
          _FadeSlide(
            anim: _anims[4],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'No account?  ',
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 11,
                    color: AppTheme.textMid,
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SignupScreen()),
                  ),
                  child: Text(
                    'REGISTER',
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 11,
                      color: AppTheme.cyan,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1,
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

  Widget _brandBlock() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FadeSlide(
          anim: _anims[0],
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: AppTheme.cyanFaint,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppTheme.cyan, width: 1),
                ),
                child: Icon(
                  Icons.precision_manufacturing_rounded,
                  color: AppTheme.cyan,
                  size: 22,
                ), // Removed const
              ),
              const SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'VIVID GCS',
                    style: GoogleFonts.barlowCondensed(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.textHi,
                      letterSpacing: 3,
                    ),
                  ),
                  Text(
                    'GROUND CONTROL SYSTEM  v2.0',
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 8,
                      color: AppTheme.cyan,
                      letterSpacing: 1.5,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 36),
        _FadeSlide(
          anim: _anims[1],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'OPERATOR\nAUTHENTICATION',
                style: GoogleFonts.barlowCondensed(
                  fontSize: 36,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.textHi,
                  letterSpacing: 1,
                  height: 1.0,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Container(width: 28, height: 1.5, color: AppTheme.cyan),
                  const SizedBox(width: 8),
                  Text(
                    'SECURE ACCESS PORTAL',
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 9,
                      color: AppTheme.textMid,
                      letterSpacing: 2,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _compactLayout(double topPad, Size size) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: size.height * 0.07),
        _brandBlock(),
        const SizedBox(height: 40),
        // Form card
        _FadeSlide(
          anim: _anims[2],
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppTheme.bgCard,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.borderMid),
            ),
            child: _formContent(),
          ),
        ),
        const SizedBox(height: 32),
        _systemInfo(),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _wideLayout(double topPad) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 5,
          child: Padding(
            padding: const EdgeInsets.only(top: 60, right: 40),
            child: _brandBlock(),
          ),
        ),
        Expanded(
          flex: 4,
          child: Padding(
            padding: const EdgeInsets.only(top: 40),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppTheme.bgCard,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.borderMid),
              ),
              child: _formContent(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _systemInfo() {
    return Row(
      children: [
        PulseDot(color: AppTheme.green, size: 6),
        const SizedBox(width: 8),
        Text(
          'SYSTEM ONLINE  ·  ALL MODULES READY',
          style: GoogleFonts.jetBrainsMono(
            fontSize: 9,
            color: AppTheme.textMid,
            letterSpacing: 1.2,
          ),
        ),
      ],
    );
  }
}

class _FadeSlide extends StatelessWidget {
  final Animation<double> anim;
  final Widget child;

  const _FadeSlide({required this.anim, required this.child});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: anim,
      builder: (_, c) => Opacity(
        opacity: anim.value,
        child: Transform.translate(
          offset: Offset(0, 20 * (1 - anim.value)),
          child: c,
        ),
      ),
      child: child,
    );
  }
}