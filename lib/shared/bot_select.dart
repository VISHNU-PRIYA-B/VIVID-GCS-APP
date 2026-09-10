import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vivid_mapping_sandbox/modules/wiper-gcs/screens/tasks_screen.dart';
import 'package:vivid_mapping_sandbox/shared/login.dart';
import 'package:vivid_mapping_sandbox/shared/settings_screen.dart';
import 'package:vivid_mapping_sandbox/ui/app_theme.dart';
import 'package:vivid_mapping_sandbox/ui/gcs_sidebar.dart';
import 'package:vivid_mapping_sandbox/ui/gcs_widgets.dart';

class BotSelectScreen extends StatefulWidget {
  const BotSelectScreen({super.key});

  @override
  State<BotSelectScreen> createState() => _BotSelectScreenState();
}

class _BotSelectScreenState extends State<BotSelectScreen>
    with TickerProviderStateMixin {
  late final AnimationController _stagger;
  late final List<Animation<double>> _anims;

  @override
  void initState() {
    super.initState();
    _stagger = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _anims = List.generate(
      3,
      (i) => CurvedAnimation(
        parent: _stagger,
        curve: Interval(i * 0.15, 0.65 + i * 0.12, curve: Curves.easeOutCubic),
      ),
    );
    _stagger.forward();
  }

  @override
  void dispose() {
    _stagger.dispose();
    super.dispose();
  }

  void _confirmSignOut(BuildContext ctx) {
    Future.delayed(const Duration(milliseconds: 300), () {
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (dialogCtx) => AlertDialog(
          backgroundColor: AppTheme.bgPanel,
          title: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: AppTheme.red.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: AppTheme.red.withOpacity(0.35)),
                ),
                child: Icon(
                  Icons.logout_rounded,
                  size: 16,
                  color: AppTheme.red,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Sign Out',
                style: GoogleFonts.barlowCondensed(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textHi,
                ),
              ),
            ],
          ),
          content: Text(
            'End your session and return\nto the login screen?',
            style: GoogleFonts.jetBrainsMono(
              fontSize: 12,
              color: AppTheme.textMid,
              height: 1.6,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogCtx),
              child: Text(
                'CANCEL',
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 11,
                  color: AppTheme.textMid,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(dialogCtx);
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (route) => false,
                );
              },
              child: Text(
                'SIGN OUT',
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.red,
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  List<SidebarItem> _sidebarItems(BuildContext ctx) => [
    // SidebarItem(
    //   icon: Icons.format_paint_rounded,
    //   label: 'VIBRANTQUE Bot',
    //   sublabel: 'Vibrantque-GCS · USB serial',
    //   accent: AppTheme.orange,
    //   onTap: () {
    //     ScaffoldMessenger.of(ctx).showSnackBar(
    //       SnackBar(
    //         content: Text(
    //           'Vibrantque module paused',
    //           style: GoogleFonts.jetBrainsMono(
    //             fontSize: 12,
    //             color: AppTheme.textHi,
    //           ),
    //         ),
    //         backgroundColor: AppTheme.bgCard,
    //       ),
    //     );
    //   },
    // ),
    // SidebarItem(
    //   icon: Icons.water_drop_rounded,
    //   label: 'WIPERQUE Bot',
    //   sublabel: 'Wiperque-GCS · Tasks',
    //   accent: AppTheme.cyan,
    //   onTap: () => Navigator.push(
    //     ctx,
    //     MaterialPageRoute(builder: (_) => const TasksScreen()),
    //   ),
    // ),
    SidebarItem(
      icon: Icons.settings_outlined,
      label: 'System Settings',
      sublabel: 'Configuration',
      onTap: () => Navigator.push(
        ctx,
        MaterialPageRoute(builder: (_) => const SettingsScreen()),
      ),
    ),
    // SidebarItem(
    //   icon: Icons.logout_rounded,
    //   label: 'Sign Out',
    //   sublabel: 'End session',
    //   accent: AppTheme.red,
    //   onTap: () => _confirmSignOut(ctx),
    // ),
  ];

  @override
  Widget build(BuildContext context) {
    // 👉 THE FIX: Wraps the entire screen to instantly update when theme changes in the background
    return ValueListenableBuilder<bool>(
      valueListenable: AppTheme.isLightMode,
      builder: (context, isLight, child) {
        final size = MediaQuery.of(context).size;
        final pad = AppTheme.screenPad(context);
        final isWide = size.width >= 600;

        return GcsScaffold(
          screenTitle: 'Control Module',
          screenCode: 'SYS · BOT · SELECT',
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
              SafeArea(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: pad, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _FadeSlide(
                        anim: _anims[0],
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'SELECT MODULE',
                              style: GoogleFonts.jetBrainsMono(
                                fontSize: 9,
                                color: AppTheme.textLo,
                                letterSpacing: 2.5,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Robotic Control\nInterfaces',
                              style: GoogleFonts.barlowCondensed(
                                fontSize: AppTheme.adaptive(context, 28, 34),
                                fontWeight: FontWeight.w800,
                                color: AppTheme.textHi,
                                height: 1.0,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 14),
                            Row(
                              children: [
                                PulseDot(color: AppTheme.green, size: 6),
                                const SizedBox(width: 6),
                                Text(
                                  '2 MODULES AVAILABLE',
                                  style: GoogleFonts.jetBrainsMono(
                                    fontSize: 9,
                                    color: AppTheme.textMid,
                                    letterSpacing: 1.5,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                GcsChip(label: 'ONLINE', color: AppTheme.green),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 28),

                      if (isWide)
                        _FadeSlide(
                          anim: _anims[1],
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: _BotCard(
                                  title: 'WIPERQUE',
                                  code: 'Wiperque-GCS',
                                  subtitle: 'High-Rise Facade Cleaning Robot',
                                  description:
                                      'Task-based facade cleaning operations. '
                                      'Multi-camera vision streams. '
                                      'Real-time altitude & cleaning telemetry.',
                                  icon: Icons.water_drop_rounded,
                                  accent: AppTheme.cyan,
                                  glow: AppTheme.cyanGlow,
                                  tag: 'WIFI / LTE',
                                  tagColor: AppTheme.cyan,
                                  specs: const ['WebRTC', 'MQTT', 'Task DB'],
                                  status: 'READY',
                                  statusColor: AppTheme.green,
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const TasksScreen(),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _BotCard(
                                  title: 'VIBRANTQUE',
                                  code: 'Vibrantque-GCS',
                                  subtitle: 'Industrial Spray Painting Robot',
                                  description:
                                      'MAVLink v2 telemetry over USB serial. '
                                      'RTSP/WebRTC camera feeds. '
                                      'Rail system & cobot joint control.',
                                  icon: Icons.format_paint_rounded,
                                  accent: AppTheme.orange,
                                  glow: AppTheme.orangeGlow,
                                  tag: 'USB SERIAL',
                                  tagColor: AppTheme.orange,
                                  specs: const [
                                    'MAVLink v2',
                                    'USB CDC',
                                    'RTSP',
                                  ],
                                  status: 'PAUSED',
                                  statusColor: AppTheme.amber,
                                  onTap: () {},
                                ),
                              ),
                            ],
                          ),
                        )
                      else
                        Column(
                          children: [
                            _FadeSlide(
                              anim: _anims[2],
                              child: _BotCard(
                                title: 'Wiperque BOT',
                                code: 'WIPERQUE-GCS',
                                subtitle: 'High-Rise Wiperque Robot',
                                description:
                                    'Task management · Cameras · Telemetry',
                                icon: Icons.water_drop_rounded,
                                accent: AppTheme.cyan,
                                glow: AppTheme.cyanGlow,
                                tag: 'WIFI / LTE',
                                tagColor: AppTheme.cyan,
                                specs: const ['WebRTC', 'MQTT', 'Task DB'],
                                status: 'READY',
                                statusColor: AppTheme.green,
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const TasksScreen(),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 14),
                            _FadeSlide(
                              anim: _anims[1],
                              child: _BotCard(
                                title: 'Vibrantque Bot',
                                code: 'VIBRANTQUE-GCS',
                                subtitle: 'Industrial Spray Painting Robot',
                                description:
                                    'MAVLink v2 · USB serial · RTSP/WebRTC',
                                icon: Icons.format_paint_rounded,
                                accent: AppTheme.orange,
                                glow: AppTheme.orangeGlow,
                                tag: 'USB SERIAL',
                                tagColor: AppTheme.orange,
                                specs: const ['MAVLink v2', 'USB CDC', 'RTSP'],
                                status: 'PAUSED',
                                statusColor: AppTheme.amber,
                                onTap: () {},
                              ),
                            ),
                          ],
                        ),

                      const SizedBox(height: 28),
                      _FadeSlide(
                        anim: _anims[2],
                        child: Center(
                          child: Text(
                            'VIVID ROBOTICS  ·  GCS v2.0  ·  ADAPTIVE BUILD',
                            style: GoogleFonts.jetBrainsMono(
                              fontSize: 8,
                              color: AppTheme.textLo,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ── Bot card ──────────────────────────────────────────────────────────────────
class _BotCard extends StatefulWidget {
  final String title;
  final String code;
  final String subtitle;
  final String description;
  final IconData icon;
  final Color accent;
  final Color glow;
  final String tag;
  final Color tagColor;
  final List<String> specs;
  final String status;
  final Color statusColor;
  final VoidCallback onTap;

  const _BotCard({
    required this.title,
    required this.code,
    required this.subtitle,
    required this.description,
    required this.icon,
    required this.accent,
    required this.glow,
    required this.tag,
    required this.tagColor,
    required this.specs,
    required this.status,
    required this.statusColor,
    required this.onTap,
  });

  @override
  State<_BotCard> createState() => _BotCardState();
}

class _BotCardState extends State<_BotCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppTheme.bgCard,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: _pressed
                  ? widget.accent.withOpacity(0.5)
                  : AppTheme.borderMid,
              width: 1.2,
            ),
            boxShadow: _pressed
                ? [
                    BoxShadow(
                      color: widget.accent.withOpacity(0.08),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ]
                : [],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      color: widget.glow,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: widget.accent.withOpacity(0.3)),
                    ),
                    child: Icon(widget.icon, color: widget.accent, size: 24),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          style: GoogleFonts.barlowCondensed(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: AppTheme.textHi,
                            letterSpacing: 1.5,
                          ),
                        ),
                        Text(
                          widget.code,
                          style: GoogleFonts.jetBrainsMono(
                            fontSize: 9,
                            color: widget.accent,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 7,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: widget.statusColor.withOpacity(0.10),
                      border: Border.all(
                        color: widget.statusColor.withOpacity(0.35),
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        PulseDot(
                          color: widget.statusColor,
                          size: 5,
                          pulse: widget.status == 'READY',
                        ),
                        const SizedBox(width: 4),
                        Text(
                          widget.status,
                          style: GoogleFonts.jetBrainsMono(
                            fontSize: 8,
                            fontWeight: FontWeight.w700,
                            color: widget.statusColor,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Container(
                height: 1,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      widget.accent.withOpacity(0.3),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                widget.subtitle.toUpperCase(),
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 9,
                  color: widget.accent,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                widget.description,
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 11,
                  color: AppTheme.textMid,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 14),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: widget.specs
                    .map((s) => GcsChip(label: s, color: widget.accent))
                    .toList(),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  GcsChip(label: widget.tag, color: widget.tagColor),
                  const Spacer(),
                  Text(
                    'LAUNCH',
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: widget.accent,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Icon(
                    Icons.arrow_forward_rounded,
                    color: widget.accent,
                    size: 16,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
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
          offset: Offset(0, 24 * (1 - anim.value)),
          child: c,
        ),
      ),
      child: child,
    );
  }
}