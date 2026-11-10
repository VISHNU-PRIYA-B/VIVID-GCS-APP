import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vivid_mapping_sandbox/ui/app_theme.dart';
import 'package:vivid_mapping_sandbox/ui/gcs_widgets.dart';
import 'package:vivid_mapping_sandbox/modules/wiper-gcs/screens/archived_tasks_screen.dart';
import 'package:vivid_mapping_sandbox/modules/wiper-gcs/sections/telemetry.dart';

// import 'dart:io';
// FOR CSV FILE:
// import 'package:path_provider/path_provider.dart';
// import 'package:share_plus/share_plus.dart';

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
                          const SizedBox(height: 28),
                          GcsSectionLabel('Task Data'),
                          const SizedBox(height: 12),
                          _ArchivedTasksTile(),
                          const SizedBox(height: 16),
                          // GcsButton(
                          //   label: 'Export Telemetry (CSV)',
                          //   icon: Icons.ios_share_rounded,
                          //   color: AppTheme.cyan,
                          //   onPressed: () async {
                          //     ScaffoldMessenger.of(context).showSnackBar(
                          //       SnackBar(
                          //         content: Text('Generating CSV...', style: GoogleFonts.jetBrainsMono(fontSize: 12)),
                          //         backgroundColor: AppTheme.amber,
                          //       ),
                          //     );
                          //     //  FOR CSV FILE:
                          //     // await shareSensoryDataCsv();
                          //   },
                          // ),
                          // for csv file:
                          GcsButton(
                            label: 'Export Telemetry (CSV)',
                            icon: Icons.ios_share_rounded,
                            color: AppTheme.cyan,
                            onPressed: () async {
                              final messenger = ScaffoldMessenger.of(context);
                              final ok = await WiperTelemetry.shareSensoryDataCsv();
                              if (!ok) {
                                messenger.showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'No telemetry recorded yet. Open the telemetry screen first.',
                                      style: GoogleFonts.jetBrainsMono(fontSize: 12),
                                    ),
                                    backgroundColor: AppTheme.amber,
                                  ),
                                );
                              }
                            },
                          ),
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

  class _ArchivedTasksTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
            color: AppTheme.amber.withOpacity(0.10),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppTheme.amber.withOpacity(0.3)),
          ),
          child: Icon(
            Icons.archive_outlined,
            color: AppTheme.amber,
            size: 20,
          ),
        ),
        title: Text(
          'Archived Tasks',
          style: GoogleFonts.barlowCondensed(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppTheme.textHi,
            letterSpacing: 0.5,
          ),
        ),
        subtitle: Text(
          'View or restore archived task data',
          style: GoogleFonts.jetBrainsMono(
            fontSize: 10,
            color: AppTheme.textMid,
          ),
        ),
        trailing: Icon(Icons.chevron_right_rounded, color: AppTheme.textMid),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ArchivedTasksScreen()),
        ),
      ),
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

// FOR CSV FILE:

// Future<void> shareSensoryDataCsv() async {
//   try {
//     StringBuffer csvContent = StringBuffer();
//     csvContent.writeln("timestamp,altitude,chamber_a,chamber_b,thrust_1,thrust_2,impel_1,impel_2,stabLatched,status");
//     csvContent.writeln("2026-11-05T11:55:00,120.5,24.2,45.0,ACTIVE");
//     csvContent.writeln("2026-11-05T11:55:01,120.6,24.3,46.1,ACTIVE");

//     final dir = await getApplicationDocumentsDirectory();
//     final file = File('${dir.path}/vivid_telemetry_export.csv');
    
//     await file.writeAsString(csvContent.toString());

//     await Share.shareXFiles(
//       [XFile(file.path)], 
//       text: 'Virtual Twin Telemetry Export',
//       subject: 'Vivid GCS Sensor Data'
//     );
//   } catch (e) {
//     debugPrint("Export failed: $e");
//   }
// }



// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:vivid_mapping_sandbox/modules/wiper-gcs/screens/archived_tasks_screen.dart';
// import 'package:vivid_mapping_sandbox/ui/app_theme.dart';
// import 'package:vivid_mapping_sandbox/ui/gcs_widgets.dart';

// class SettingsScreen extends StatelessWidget {
//   const SettingsScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final pad = AppTheme.screenPad(context);

//     return ValueListenableBuilder<bool>(
//       valueListenable: AppTheme.isLightMode,
//       builder: (context, isLight, _) {
//         return Scaffold(
//           backgroundColor: AppTheme.bg,
//           body: Stack(
//             children: [
//               // Background Grid for Industrial Aesthetic
//               Positioned.fill(
//                 child: CustomPaint(
//                   painter: GridPainter(
//                     spacing: 32,
//                     color: AppTheme.borderDim.withOpacity(0.4),
//                   ),
//                 ),
//               ),
//               SafeArea(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // ── Header & Back Button ──
//                     Padding(
//                       padding: EdgeInsets.fromLTRB(pad / 2, 16, pad, 16),
//                       child: Row(
//                         children: [
//                           IconButton(
//                             icon: Icon(
//                               Icons.arrow_back_rounded,
//                               color: AppTheme.textHi,
//                             ),
//                             onPressed: () => Navigator.pop(context),
//                             splashRadius: 24,
//                           ),
//                           const SizedBox(width: 8),
//                           Text(
//                             'SYSTEM SETTINGS',
//                             style: GoogleFonts.barlowCondensed(
//                               fontSize: 24,
//                               fontWeight: FontWeight.w800,
//                               color: AppTheme.textHi,
//                               letterSpacing: 1.0,
//                             ),
//                           ),
//                           const Spacer(),
//                           const ThemeToggleButton(),
//                         ],
//                       ),
//                     ),

//                     const SizedBox(height: 16),

//                     // ── Settings List ──
//                     Expanded(
//                       child: ListView(
//                         padding: EdgeInsets.symmetric(horizontal: pad),
//                         children: [
//                           GcsSectionLabel('Appearance & Display'),
//                           const SizedBox(height: 12),
//                           _ThemeSettingTile(),
//                           const SizedBox(height: 28),
//                           GcsSectionLabel('Task Data'),
//                           const SizedBox(height: 12),
//                           _ArchivedTasksTile(),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }

// class _ArchivedTasksTile extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: AppTheme.bgCard,
//         borderRadius: BorderRadius.circular(10),
//         border: Border.all(color: AppTheme.borderMid),
//       ),
//       child: ListTile(
//         contentPadding: const EdgeInsets.symmetric(
//           horizontal: 16,
//           vertical: 12,
//         ),
//         leading: Container(
//           padding: const EdgeInsets.all(10),
//           decoration: BoxDecoration(
//             color: AppTheme.amber.withOpacity(0.10),
//             borderRadius: BorderRadius.circular(8),
//             border: Border.all(color: AppTheme.amber.withOpacity(0.3)),
//           ),
//           child: Icon(
//             Icons.archive_outlined,
//             color: AppTheme.amber,
//             size: 20,
//           ),
//         ),
//         title: Text(
//           'Archived Tasks',
//           style: GoogleFonts.barlowCondensed(
//             fontSize: 18,
//             fontWeight: FontWeight.w700,
//             color: AppTheme.textHi,
//             letterSpacing: 0.5,
//           ),
//         ),
//         subtitle: Text(
//           'View or restore archived task data',
//           style: GoogleFonts.jetBrainsMono(
//             fontSize: 10,
//             color: AppTheme.textMid,
//           ),
//         ),
//         trailing: Icon(Icons.chevron_right_rounded, color: AppTheme.textMid),
//         onTap: () => Navigator.push(
//           context,
//           MaterialPageRoute(builder: (_) => const ArchivedTasksScreen()),
//         ),
//       ),
//     );
//   }
// }

// class _ThemeSettingTile extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return ValueListenableBuilder<bool>(
//       valueListenable: AppTheme.isLightMode,
//       builder: (context, isLight, _) {
//         return Container(
//           decoration: BoxDecoration(
//             color: AppTheme.bgCard,
//             borderRadius: BorderRadius.circular(10),
//             border: Border.all(color: AppTheme.borderMid),
//           ),
//           child: ListTile(
//             contentPadding: const EdgeInsets.symmetric(
//               horizontal: 16,
//               vertical: 12,
//             ),
//             leading: Container(
//               padding: const EdgeInsets.all(10),
//               decoration: BoxDecoration(
//                 color: AppTheme.cyanFaint,
//                 borderRadius: BorderRadius.circular(8),
//                 border: Border.all(color: AppTheme.cyan.withOpacity(0.3)),
//               ),
//               child: Icon(
//                 isLight ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
//                 color: AppTheme.cyan,
//                 size: 20,
//               ),
//             ),
//             title: Text(
//               'UI Theme',
//               style: GoogleFonts.barlowCondensed(
//                 fontSize: 18,
//                 fontWeight: FontWeight.w700,
//                 color: AppTheme.textHi,
//                 letterSpacing: 0.5,
//               ),
//             ),
//             subtitle: Text(
//               'Toggle application color mode',
//               style: GoogleFonts.jetBrainsMono(
//                 fontSize: 10,
//                 color: AppTheme.textMid,
//               ),
//             ),
//             // The Popup Menu (Floating widget)
//             trailing: PopupMenuButton<bool>(
//               initialValue: isLight,
//               tooltip: 'Select Theme',
//               color: AppTheme.bgPanel,
//               offset: const Offset(0, 40),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(8),
//                 side: BorderSide(color: AppTheme.borderMid),
//               ),
//               onSelected: (bool isLightSelected) {
//                 AppTheme.isLightMode.value = isLightSelected;
//               },
//               itemBuilder: (BuildContext context) => <PopupMenuEntry<bool>>[
//                 PopupMenuItem<bool>(
//                   value: false,
//                   child: Row(
//                     children: [
//                       Icon(
//                         Icons.dark_mode_rounded,
//                         size: 16,
//                         color: !isLight ? AppTheme.cyan : AppTheme.textMid,
//                       ),
//                       const SizedBox(width: 12),
//                       Text(
//                         'Dark Mode',
//                         style: GoogleFonts.jetBrainsMono(
//                           fontSize: 12,
//                           fontWeight: !isLight
//                               ? FontWeight.w700
//                               : FontWeight.normal,
//                           color: !isLight ? AppTheme.cyan : AppTheme.textHi,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 PopupMenuItem<bool>(
//                   value: true,
//                   child: Row(
//                     children: [
//                       Icon(
//                         Icons.light_mode_rounded,
//                         size: 16,
//                         color: isLight ? AppTheme.cyan : AppTheme.textMid,
//                       ),
//                       const SizedBox(width: 12),
//                       Text(
//                         'Light Mode',
//                         style: GoogleFonts.jetBrainsMono(
//                           fontSize: 12,
//                           fontWeight: isLight
//                               ? FontWeight.w700
//                               : FontWeight.normal,
//                           color: isLight ? AppTheme.cyan : AppTheme.textHi,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//               child: Container(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 12,
//                   vertical: 8,
//                 ),
//                 decoration: BoxDecoration(
//                   color: AppTheme.bgPanel,
//                   borderRadius: BorderRadius.circular(6),
//                   border: Border.all(color: AppTheme.borderDim),
//                 ),
//                 child: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Text(
//                       isLight ? 'LIGHT' : 'DARK',
//                       style: GoogleFonts.jetBrainsMono(
//                         fontSize: 11,
//                         fontWeight: FontWeight.w700,
//                         color: AppTheme.textHi,
//                       ),
//                     ),
//                     const SizedBox(width: 6),
//                     Icon(
//                       Icons.arrow_drop_down_rounded,
//                       size: 16,
//                       color: AppTheme.textMid,
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }