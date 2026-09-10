import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Added for Logout
import 'package:vivid_mapping_sandbox/shared/login.dart'; // Added for Logout routing
import 'package:vivid_mapping_sandbox/ui/gcs_widgets.dart';

import '../core/services/pip_manager.dart';
import 'app_theme.dart';

/// Sidebar navigation entry
class SidebarItem {
  final IconData icon;
  final String label;
  final String sublabel;
  final Color? accent;
  final VoidCallback onTap;

  const SidebarItem({
    required this.icon,
    required this.label,
    required this.sublabel,
    required this.onTap,
    this.accent,
  });
}

/// Wraps any screen content with a draggable sidebar & a scroll-reactive TopBar
class GcsScaffold extends StatefulWidget {
  final Widget body;
  final List<SidebarItem> items;
  final int activeIndex;
  final String screenTitle;
  final String screenCode;
  final Color? accentColor;
  final List<Widget>? actions;

  const GcsScaffold({
    super.key,
    required this.body,
    required this.items,
    required this.activeIndex,
    required this.screenTitle,
    required this.screenCode,
    this.accentColor,
    this.actions,
  });

  @override
  State<GcsScaffold> createState() => _GcsScaffoldState();
}

class _GcsScaffoldState extends State<GcsScaffold>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _slideAnim;
  late final Animation<double> _fadeAnim;
  bool _open = false;

  double _dragStart = 0;
  bool _isDragging = false;

  bool _isTopBarVisible = false;
  Timer? _hideTimer;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 280),
    );
    _slideAnim = CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic);
    _fadeAnim = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    _hideTimer?.cancel();
    super.dispose();
  }

  void _startHideTimer() {
    _hideTimer?.cancel();
    _hideTimer = Timer(const Duration(seconds: 2), () {
      if (mounted && !_open) {
        setState(() => _isTopBarVisible = false);
      }
    });
  }

  void _openSidebar() {
    HapticFeedback.lightImpact();
    setState(() {
      _open = true;
      _isTopBarVisible = true;
    });
    _hideTimer?.cancel();
    _ctrl.forward();
  }

  void _closeSidebar() {
    _ctrl.reverse().then((_) {
      setState(() => _open = false);
      _startHideTimer();
    });
  }

  double _sidebarWidth(BuildContext ctx) {
    final w = MediaQuery.of(ctx).size.width;
    if (w < 400) return w * 0.80;
    if (w < 600) return 280;
    return 320;
  }

  bool _handleScroll(ScrollNotification notif) {
    if (notif.metrics.axis == Axis.horizontal) return false;

    if (notif is ScrollUpdateNotification && notif.scrollDelta != null) {
      final dy = notif.scrollDelta!;

      if (dy > 10 && _isTopBarVisible) {
        _hideTimer?.cancel();
        setState(() => _isTopBarVisible = false);
      } else if (dy < -10) {
        if (!_isTopBarVisible) {
          setState(() => _isTopBarVisible = true);
        }
        _startHideTimer();
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final sw = _sidebarWidth(context);
    final topPadding = MediaQuery.of(context).padding.top;
    final topBarHeight = topPadding + 56.0;

    return ValueListenableBuilder<bool>(
      valueListenable: AppTheme.isLightMode,
      builder: (context, isLight, _) {
        return Scaffold(
          backgroundColor: AppTheme.bg,
          body: GestureDetector(
            onHorizontalDragStart: (d) {
              _dragStart = d.globalPosition.dx;
              _isDragging = true;
            },
            onHorizontalDragUpdate: (d) {
              if (!_isDragging) return;
              final dx = d.globalPosition.dx - _dragStart;
              if (!_open && _dragStart < 40 && dx > 12) {
                _isDragging = false;
                _openSidebar();
              } else if (_open && dx < -12) {
                _isDragging = false;
                _closeSidebar();
              }
            },
            onHorizontalDragEnd: (_) => _isDragging = false,
            child: Stack(
              children: [
                Column(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      height: _isTopBarVisible ? topBarHeight : 0.0,
                    ),
                    Expanded(
                      child: NotificationListener<ScrollNotification>(
                        onNotification: _handleScroll,
                        child: widget.body,
                      ),
                    ),
                  ],
                ),
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  top: _isTopBarVisible ? 0 : -topBarHeight,
                  left: 0,
                  right: 0,
                  height: topBarHeight,
                  child: Container(
                    color: AppTheme.bgPanel,
                    child: Column(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(
                              top: topPadding,
                              left: 56,
                              right: 12,
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        widget.screenTitle,
                                        style: GoogleFonts.barlowCondensed(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700,
                                          color: AppTheme.textHi,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Container(
                                            width: 5,
                                            height: 5,
                                            decoration: BoxDecoration(
                                              color:
                                                  widget.accentColor ??
                                                  AppTheme.cyan,
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                          const SizedBox(width: 5),
                                          Text(
                                            widget.screenCode,
                                            style: GoogleFonts.jetBrainsMono(
                                              fontSize: 9,
                                              color:
                                                  widget.accentColor ??
                                                  AppTheme.cyan,
                                              letterSpacing: 1.5,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                if (widget.actions != null) ...widget.actions!,
                                const SizedBox(width: 8),

                                // The PIP Trigger Button
                                IconButton(
                                  icon: Icon(
                                    Icons.picture_in_picture_alt_rounded,
                                    color: AppTheme.cyan,
                                    size: 20,
                                  ),
                                  tooltip: 'Picture-in-Picture',
                                  onPressed: () {
                                    // Toggles the Draggable In-App Overlay
                                    // sample
                                    PipManager.togglePip(context);
                                  },
                                ),
                                const SizedBox(width: 8),
                                const ThemeToggleButton(),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          height: 1,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.transparent,
                                (widget.accentColor ?? AppTheme.cyan)
                                    .withOpacity(0.4),
                                (widget.accentColor ?? AppTheme.cyan)
                                    .withOpacity(0.4),
                                Colors.transparent,
                              ],
                              stops: const [0, 0.2, 0.8, 1],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: topPadding + 4,
                  left: 4,
                  child: _MenuButton(
                    onTap: _openSidebar,
                    accent: widget.accentColor ?? AppTheme.cyan,
                  ),
                ),
                if (_open)
                  FadeTransition(
                    opacity: _fadeAnim,
                    child: GestureDetector(
                      onTap: _closeSidebar,
                      child: Container(color: Colors.black54),
                    ),
                  ),
                AnimatedBuilder(
                  animation: _slideAnim,
                  builder: (_, child) => Transform.translate(
                    offset: Offset(sw * (_slideAnim.value - 1), 0),
                    child: child,
                  ),
                  child: _SidebarPanel(
                    width: sw,
                    items: widget.items,
                    activeIndex: widget.activeIndex,
                    onClose: _closeSidebar,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _MenuButton extends StatefulWidget {
  final VoidCallback onTap;
  final Color accent;

  const _MenuButton({required this.onTap, required this.accent});

  @override
  State<_MenuButton> createState() => _MenuButtonState();
}

class _MenuButtonState extends State<_MenuButton> {
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
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        width: 44,
        height: 44,
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: _pressed
              ? widget.accent.withOpacity(0.12)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _bar(widget.accent, 18),
            const SizedBox(height: 4),
            _bar(widget.accent, 12),
            const SizedBox(height: 4),
            _bar(widget.accent, 15),
          ],
        ),
      ),
    );
  }

  Widget _bar(Color c, double w) => Container(
    width: w,
    height: 1.5,
    decoration: BoxDecoration(color: c, borderRadius: BorderRadius.circular(1)),
  );
}

// ── Sidebar panel ─────────────────────────────────────────────────────────────
class _SidebarPanel extends StatelessWidget {
  final double width;
  final List<SidebarItem> items;
  final int activeIndex;
  final VoidCallback onClose;

  const _SidebarPanel({
    required this.width,
    required this.items,
    required this.activeIndex,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final screenH = MediaQuery.of(context).size.height;
    final top = MediaQuery.of(context).padding.top;
    final bottom = MediaQuery.of(context).padding.bottom;

    return Container(
      width: width,
      height: screenH,
      decoration: BoxDecoration(
        color: AppTheme.bgPanel,
        border: Border(right: BorderSide(color: AppTheme.borderMid)),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(20, top + 16, 16, 16),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: AppTheme.borderDim)),
            ),
            child: Row(
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: AppTheme.cyanFaint,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: AppTheme.cyan, width: 1),
                  ),
                  child: Icon(
                    Icons.precision_manufacturing_rounded,
                    color: AppTheme.cyan,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'VIVID GCS',
                      style: GoogleFonts.barlowCondensed(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.textHi,
                        letterSpacing: 2,
                      ),
                    ),
                    Text(
                      'GROUND CONTROL SYSTEM',
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 7,
                        color: AppTheme.cyan,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                GestureDetector(
                  onTap: onClose,
                  child: Icon(
                    Icons.close_rounded,
                    color: AppTheme.textMid,
                    size: 18,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
              children: [
                const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 6,
                  ),
                  child: Text(
                    'NAVIGATION',
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 8,
                      color: AppTheme.textLo,
                      letterSpacing: 2,
                    ),
                  ),
                ),
                ...List.generate(items.length, (i) {
                  final item = items[i];
                  final active = i == activeIndex;
                  final accent = item.accent ?? AppTheme.cyan;
                  return _NavItem(
                    item: item,
                    active: active,
                    accent: accent,
                    onTap: () {
                      onClose();
                      Future.delayed(
                        const Duration(milliseconds: 200),
                        item.onTap,
                      );
                    },
                  );
                }),

                // 👉 THE FIX: Added a visually distinct Logout Button to your existing ListView
                const SizedBox(height: 24),
                Container(
                  height: 1,
                  color: AppTheme.borderDim.withOpacity(0.5),
                ),
                const SizedBox(height: 12),
                _NavItem(
                  item: SidebarItem(
                    icon: Icons.logout_rounded,
                    label: 'END SESSION',
                    sublabel: 'Securely log out of Vivid',
                    onTap: () {}, // Dummy function, overridden below
                  ),
                  active: false,
                  accent: AppTheme.red,
                  onTap: () async {
                    onClose();

                    // 👉 CLEAR PERSISTENT SESSION
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.remove('isLoggedIn');

                    if (context.mounted) {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginScreen()),
                        (route) => false,
                      );
                    }
                  },
                ),

                // 👈 END OF FIX
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(20, 14, 20, 14 + bottom),
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: AppTheme.borderDim)),
            ),
            child: Row(
              children: [
                PulseDot(color: AppTheme.green, size: 7),
                const SizedBox(width: 8),
                Text(
                  'SYSTEM ONLINE',
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 9,
                    color: AppTheme.green,
                    letterSpacing: 1.5,
                  ),
                ),
                const Spacer(),
                Text(
                  'v2.0',
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 9,
                    color: AppTheme.textLo,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatefulWidget {
  final SidebarItem item;
  final bool active;
  final Color accent;
  final VoidCallback onTap;

  const _NavItem({
    required this.item,
    required this.active,
    required this.accent,
    required this.onTap,
  });

  @override
  State<_NavItem> createState() => _NavItemState();
}

class _NavItemState extends State<_NavItem> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final active = widget.active;
    final accent = widget.accent;

    return GestureDetector(
      onTapDown: (_) => setState(() => _hover = true),
      onTapUp: (_) {
        setState(() => _hover = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _hover = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        margin: const EdgeInsets.only(bottom: 4),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: active
              ? accent.withOpacity(0.10)
              : _hover
              ? AppTheme.bgRaised
              : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
          border: active
              ? Border.all(color: accent.withOpacity(0.25))
              : Border.all(color: Colors.transparent),
        ),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: 2.5,
              height: 28,
              decoration: BoxDecoration(
                color: active ? accent : Colors.transparent,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 12),
            Icon(
              widget.item.icon,
              size: 18,
              color: active ? accent : AppTheme.textMid,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.item.label,
                    style: GoogleFonts.barlowCondensed(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: active ? accent : AppTheme.textHi,
                      letterSpacing: 0.5,
                    ),
                  ),
                  Text(
                    widget.item.sublabel,
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 8,
                      color: AppTheme.textLo,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
            if (active)
              Icon(Icons.chevron_right_rounded, size: 16, color: accent),
          ],
        ),
      ),
    );
  }
}