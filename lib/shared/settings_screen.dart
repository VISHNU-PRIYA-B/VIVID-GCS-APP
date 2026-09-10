import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vivid_mapping_sandbox/ui/app_theme.dart';
import 'package:vivid_mapping_sandbox/ui/gcs_widgets.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final pad = AppTheme.screenPad(context);

    return ValueListenableBuilder<bool>(
      valueListenable: AppTheme.isLightMode,
      builder: (context, isLight, _) {
        return Scaffold(
          backgroundColor: AppTheme.bg,
          body: Stack(
            children: [
              // Background Grid for Industrial Aesthetic
              Positioned.fill(
                child: CustomPaint(
                  painter: GridPainter(
                    spacing: 32,
                    color: AppTheme.borderDim.withOpacity(0.4),
                  ),
                ),
              ),
              SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Header & Back Button ──
                    Padding(
                      padding: EdgeInsets.fromLTRB(pad / 2, 16, pad, 16),
                      child: Row(
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.arrow_back_rounded,
                              color: AppTheme.textHi,
                            ),
                            onPressed: () => Navigator.pop(context),
                            splashRadius: 24,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'SYSTEM SETTINGS',
                            style: GoogleFonts.barlowCondensed(
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                              color: AppTheme.textHi,
                              letterSpacing: 1.0,
                            ),
                          ),
                          const Spacer(),
                          const ThemeToggleButton(),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // ── Settings List ──
                    Expanded(
                      child: ListView(
                        padding: EdgeInsets.symmetric(horizontal: pad),
                        children: [
                          GcsSectionLabel('Appearance & Display'),
                          const SizedBox(height: 12),
                          _ThemeSettingTile(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ThemeSettingTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: AppTheme.isLightMode,
      builder: (context, isLight, _) {
        return Container(
          decoration: BoxDecoration(
            color: AppTheme.bgCard,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppTheme.borderMid),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            leading: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppTheme.cyanFaint,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppTheme.cyan.withOpacity(0.3)),
              ),
              child: Icon(
                isLight ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                color: AppTheme.cyan,
                size: 20,
              ),
            ),
            title: Text(
              'UI Theme',
              style: GoogleFonts.barlowCondensed(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppTheme.textHi,
                letterSpacing: 0.5,
              ),
            ),
            subtitle: Text(
              'Toggle application color mode',
              style: GoogleFonts.jetBrainsMono(
                fontSize: 10,
                color: AppTheme.textMid,
              ),
            ),
            // The Popup Menu (Floating widget)
            trailing: PopupMenuButton<bool>(
              initialValue: isLight,
              tooltip: 'Select Theme',
              color: AppTheme.bgPanel,
              offset: const Offset(0, 40),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(color: AppTheme.borderMid),
              ),
              onSelected: (bool isLightSelected) {
                AppTheme.isLightMode.value = isLightSelected;
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<bool>>[
                PopupMenuItem<bool>(
                  value: false,
                  child: Row(
                    children: [
                      Icon(
                        Icons.dark_mode_rounded,
                        size: 16,
                        color: !isLight ? AppTheme.cyan : AppTheme.textMid,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Dark Mode',
                        style: GoogleFonts.jetBrainsMono(
                          fontSize: 12,
                          fontWeight: !isLight
                              ? FontWeight.w700
                              : FontWeight.normal,
                          color: !isLight ? AppTheme.cyan : AppTheme.textHi,
                        ),
                      ),
                    ],
                  ),
                ),
                PopupMenuItem<bool>(
                  value: true,
                  child: Row(
                    children: [
                      Icon(
                        Icons.light_mode_rounded,
                        size: 16,
                        color: isLight ? AppTheme.cyan : AppTheme.textMid,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Light Mode',
                        style: GoogleFonts.jetBrainsMono(
                          fontSize: 12,
                          fontWeight: isLight
                              ? FontWeight.w700
                              : FontWeight.normal,
                          color: isLight ? AppTheme.cyan : AppTheme.textHi,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.bgPanel,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: AppTheme.borderDim),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      isLight ? 'LIGHT' : 'DARK',
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textHi,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Icon(
                      Icons.arrow_drop_down_rounded,
                      size: 16,
                      color: AppTheme.textMid,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}