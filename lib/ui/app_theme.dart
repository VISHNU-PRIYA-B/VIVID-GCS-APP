import 'package:flutter/material.dart';

class AppTheme {
  // false = Dark Mode (Default/Untouched), true = Light Mode
  static final ValueNotifier<bool> isLightMode = ValueNotifier<bool>(false);

  static void toggleTheme() {
    isLightMode.value = !isLightMode.value;
  }

  // ── HELPERS ──
  static double adaptive(BuildContext context, double mobile, double desktop) {
    return MediaQuery.of(context).size.width >= 600 ? desktop : mobile;
  }

  static double screenPad(BuildContext context) {
    return MediaQuery.of(context).size.width >= 600 ? 32.0 : 16.0;
  }

  // ── DYNAMIC COLORS ──
  static Color get bg =>
      isLightMode.value ? const Color(0xFFF8FAFC) : const Color(0xFF080B0F);

  static Color get bgPanel =>
      isLightMode.value ? const Color(0xFFFFFFFF) : const Color(0xFF0D1117);

  static Color get bgCard =>
      isLightMode.value ? const Color(0xFFF1F5F9) : const Color(0xFF111820);

  static Color get bgRaised =>
      isLightMode.value ? const Color(0xFFE2E8F0) : const Color(0xFF16202E);

  static Color get bgPanelHover =>
      isLightMode.value ? const Color(0xFFF8FAFC) : const Color(0xFF1A1D24);

  static Color get bgCardHover =>
      isLightMode.value ? const Color(0xFFE2E8F0) : const Color(0xFF22262E);

  static Color get textHi =>
      isLightMode.value ? const Color(0xFF0F1115) : const Color(0xFFECF2FF);

  static Color get textMid =>
      isLightMode.value ? const Color(0xFF475569) : const Color(0xFF7A8FA8);

  static Color get textLo =>
      isLightMode.value ? const Color(0xFF94A3B8) : const Color(0xFF3A4E63);

  static Color get borderDim =>
      isLightMode.value ? const Color(0xFFE2E8F0) : const Color(0xFF1E2D40);

  static Color get borderMid =>
      isLightMode.value ? const Color(0xFFCBD5E1) : const Color(0xFF253547);

  // ── BRAND ACCENTS ──
  static Color get cyan =>
      isLightMode.value ? const Color(0xFF0284C7) : const Color(0xFF00D9FF);
  static Color get cyanFaint => cyan.withOpacity(0.1);
  static Color get cyanGlow => cyan.withOpacity(0.15);

  static Color get green =>
      isLightMode.value ? const Color(0xFF059669) : const Color(0xFF00E676);
  static Color get greenGlow => green.withOpacity(0.15);

  static Color get amber =>
      isLightMode.value ? const Color(0xFFD97706) : const Color(0xFFFFC107);

  static Color get red =>
      isLightMode.value ? const Color(0xFFDC2626) : const Color(0xFFFF3D57);

  static Color get orange =>
      isLightMode.value ? const Color(0xFFEA580C) : const Color(0xFFFF6B2B);
  static Color get orangeGlow => orange.withOpacity(0.15);
}
