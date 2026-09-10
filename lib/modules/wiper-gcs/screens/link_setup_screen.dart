import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:usb_serial/usb_serial.dart';

import '../../../core/services/link_manager.dart';
import '../../../ui/app_theme.dart';
import '../../../ui/gcs_sidebar.dart';
import '../../../ui/gcs_widgets.dart';

class LinkSetupScreen extends StatefulWidget {
  const LinkSetupScreen({super.key});

  @override
  State<LinkSetupScreen> createState() => _LinkSetupScreenState();
}

class _LinkSetupScreenState extends State<LinkSetupScreen> {
  // Hold devices based on platform
  List<UsbDevice> _androidDevices = [];
  List<String> _desktopPorts = [];

  bool _isScanning = false;
  late int _currentBaud;

  @override
  void initState() {
    super.initState();
    _currentBaud = LinkManager.selectedBaudRate;
    _refresh();
  }

  Future<void> _refresh() async {
    if (!mounted) return;
    setState(() => _isScanning = true);

    await Future.delayed(const Duration(milliseconds: 400));

    // ── THE PLATFORM SWITCH LOGIC ──
    if (Platform.isAndroid) {
      List<UsbDevice> devices = await UsbSerial.listDevices();
      if (mounted) setState(() => _androidDevices = devices);
    } else if (Platform.isWindows || Platform.isLinux) {
      List<String> ports = SerialPort.availablePorts;
      if (mounted) setState(() => _desktopPorts = ports);
    }

    if (mounted) setState(() => _isScanning = false);
  }

  // Handle Android Selection
  void _selectAndroidDevice(UsbDevice device) {
    setState(() {
      LinkManager.clearConnection();
      LinkManager.selectedUsbDevice = device;
      LinkManager.selectedBaudRate = _currentBaud;
    });
    _showLockSnack('${device.productName ?? "USB Device"}');
  }

  // Handle Desktop Selection
  void _selectDesktopPort(String portName) {
    setState(() {
      LinkManager.clearConnection();
      LinkManager.selectedDesktopPort = portName;
      LinkManager.selectedBaudRate = _currentBaud;
    });
    _showLockSnack(portName);
  }

  void _showLockSnack(String name) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Hardware Locked: $name @ $_currentBaud',
          style: GoogleFonts.jetBrainsMono(fontSize: 12),
        ),
        backgroundColor: AppTheme.green.withOpacity(0.9),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _unlinkDevice() {
    setState(() => LinkManager.clearConnection());
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Hardware Unlinked. Defaulting to UDP.',
          style: GoogleFonts.jetBrainsMono(fontSize: 12, color: AppTheme.bg),
        ),
        backgroundColor: AppTheme.amber,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  List<SidebarItem> _sidebarItems(BuildContext ctx) => [
    SidebarItem(
      icon: Icons.arrow_back_rounded,
      label: 'Back',
      sublabel: 'Return to Tasks',
      onTap: () => Navigator.pop(ctx),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final pad = AppTheme.screenPad(context);

    // Determine active connection string for the UI
    String? activeName;
    if (Platform.isAndroid && LinkManager.selectedUsbDevice != null) {
      activeName = LinkManager.selectedUsbDevice!.productName ?? 'USB Device';
    } else if ((Platform.isWindows || Platform.isLinux) &&
        LinkManager.selectedDesktopPort != null) {
      activeName = LinkManager.selectedDesktopPort;
    }

    return GcsScaffold(
      screenTitle: 'Hardware Link Setup',
      screenCode: 'SYS · COMM · LINK',
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
          Padding(
            padding: EdgeInsets.symmetric(horizontal: pad, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── HEADER ──
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'HARDWARE LINK',
                          style: GoogleFonts.jetBrainsMono(
                            fontSize: 10,
                            color: AppTheme.textLo,
                            letterSpacing: 2,
                          ),
                        ),
                        Text(
                          'USB UART Configuration',
                          style: GoogleFonts.barlowCondensed(
                            fontSize: 32,
                            fontWeight: FontWeight.w800,
                            color: AppTheme.textHi,
                          ),
                        ),
                      ],
                    ),
                    GcsButton(
                      label: _isScanning ? 'SCANNING...' : 'REFRESH LIST',
                      icon: Icons.refresh_rounded,
                      onPressed: _isScanning ? null : _refresh,
                      outlined: true,
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // ── ACTIVE CONNECTION CARD ──
                if (activeName != null) ...[
                  Text(
                    'ACTIVE CONNECTION',
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 10,
                      color: AppTheme.green,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppTheme.green.withOpacity(0.4),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: AppTheme.green.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          // child: const Icon(
                          child: Icon(Icons.usb_rounded, color: AppTheme.green),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                activeName,
                                style: GoogleFonts.barlowCondensed(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: AppTheme.green,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'LOCKED @ ${LinkManager.selectedBaudRate} BAUD',
                                style: GoogleFonts.jetBrainsMono(
                                  fontSize: 10,
                                  color: AppTheme.green,
                                ),
                              ),
                            ],
                          ),
                        ),
                        GcsButton(
                          label: 'UNLINK',
                          color: AppTheme.red,
                          icon: Icons.link_off_rounded,
                          onPressed: _unlinkDevice,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                ],

                // ── BAUD RATE TOGGLES ──
                Text(
                  'SELECT BAUD RATE',
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 10,
                    color: AppTheme.textMid,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _BaudToggle(
                      baud: 57600,
                      active: _currentBaud == 57600,
                      onTap: () {
                        setState(() {
                          _currentBaud = 57600;

                          LinkManager.selectedBaudRate = 57600;
                        });
                      },
                    ),
                    const SizedBox(width: 12),
                    _BaudToggle(
                      baud: 115200,
                      active: _currentBaud == 115200,
                      onTap: () {
                        setState(() {
                          _currentBaud = 115200;

                          LinkManager.selectedBaudRate = 115200;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // ── DEVICE LIST ──
                Text(
                  'AVAILABLE HARDWARE',
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 10,
                    color: AppTheme.textMid,
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: (_androidDevices.isEmpty && _desktopPorts.isEmpty)
                      ? Center(
                          child: Text(
                            _isScanning
                                ? 'Scanning Ports...'
                                : 'NO DEVICES DETECTED',
                            style: GoogleFonts.jetBrainsMono(
                              fontSize: 12,
                              color: AppTheme.textLo,
                            ),
                          ),
                        )
                      : ListView(
                          children: [
                            if (Platform.isAndroid)
                              ..._androidDevices.map((d) {
                                bool isLocked =
                                    LinkManager.selectedUsbDevice?.vid ==
                                        d.vid &&
                                    LinkManager.selectedUsbDevice?.pid == d.pid;
                                return _DeviceTile(
                                  name: d.productName ?? 'Unknown Device',
                                  subName: 'VID: ${d.vid} PID: ${d.pid}',
                                  isLocked: isLocked,
                                  onConnect: () => _selectAndroidDevice(d),
                                );
                              }),
                            if (Platform.isWindows || Platform.isLinux)
                              ..._desktopPorts.map((port) {
                                bool isLocked =
                                    LinkManager.selectedDesktopPort == port;
                                return _DeviceTile(
                                  name: port,
                                  subName: 'Desktop Serial Port',
                                  isLocked: isLocked,
                                  onConnect: () => _selectDesktopPort(port),
                                );
                              }),
                          ],
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

class _BaudToggle extends StatelessWidget {
  final int baud;
  final bool active;
  final VoidCallback onTap;
  const _BaudToggle({
    required this.baud,
    required this.active,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: active ? AppTheme.cyan.withOpacity(0.15) : AppTheme.bgCard,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: active ? AppTheme.cyan : AppTheme.borderDim,
          ),
        ),
        child: Text(
          '$baud',
          style: GoogleFonts.jetBrainsMono(
            fontSize: 12,
            fontWeight: active ? FontWeight.w700 : FontWeight.w400,
            color: active ? AppTheme.cyan : AppTheme.textMid,
          ),
        ),
      ),
    );
  }
}

class _DeviceTile extends StatelessWidget {
  final String name;
  final String subName;
  final bool isLocked;
  final VoidCallback onConnect;
  const _DeviceTile({
    required this.name,
    required this.subName,
    required this.isLocked,
    required this.onConnect,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isLocked ? AppTheme.bgCard.withOpacity(0.5) : AppTheme.bgCard,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isLocked
              ? AppTheme.borderDim.withOpacity(0.2)
              : AppTheme.borderDim,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isLocked
                  ? AppTheme.textLo.withOpacity(0.1)
                  : AppTheme.cyan.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(
              Icons.usb_rounded,
              color: isLocked ? AppTheme.textLo : AppTheme.cyan,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: GoogleFonts.barlowCondensed(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: isLocked ? AppTheme.textLo : AppTheme.textHi,
                  ),
                ),
                Text(
                  subName,
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 10,
                    color: AppTheme.textMid,
                  ),
                ),
              ],
            ),
          ),
          GcsButton(
            label: isLocked ? 'LOCKED' : 'CONNECT',
            color: isLocked ? AppTheme.textLo : AppTheme.cyan,
            onPressed: isLocked ? null : onConnect,
          ),
        ],
      ),
    );
  }
}