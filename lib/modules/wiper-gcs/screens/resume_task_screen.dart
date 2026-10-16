import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vivid_mapping_sandbox/ui/app_theme.dart';
import 'package:vivid_mapping_sandbox/ui/gcs_sidebar.dart';
import 'package:vivid_mapping_sandbox/ui/gcs_widgets.dart';

import '../../../core/db/isar_service.dart';
import '../../../core/models/task.dart';
import '../../../core/utils/device_id.dart';

class ResumeTaskScreen extends StatefulWidget {
  const ResumeTaskScreen({super.key});

  @override
  State<ResumeTaskScreen> createState() => _ResumeTaskScreenState();
}

class _ResumeTaskScreenState extends State<ResumeTaskScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  
  // Standard building details
  final _nameCtrl = TextEditingController();
  final _heightCtrl = TextEditingController();
  final _areaCtrl = TextEditingController();
  final _facesCtrl = TextEditingController(text: '1');
  
  // 👉 NEW: Resume coordinates
  final _startFaceCtrl = TextEditingController(text: '1');
  final _startStripCtrl = TextEditingController(text: '1');

  final _camACtrl = TextEditingController();
  final _camBCtrl = TextEditingController();

  bool _loading = false;

  late final AnimationController _entryCtrl;
  late final Animation<double> _entryAnim;

  @override
  void initState() {
    super.initState();
    _entryCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _entryAnim = CurvedAnimation(
      parent: _entryCtrl,
      curve: Curves.easeOutCubic,
    );
    _entryCtrl.forward();
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _heightCtrl.dispose();
    _areaCtrl.dispose();
    _facesCtrl.dispose();
    _startFaceCtrl.dispose();
    _startStripCtrl.dispose();
    _camACtrl.dispose();
    _camBCtrl.dispose();
    _entryCtrl.dispose();
    super.dispose();
  }

  Future<void> _resumeTask() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _loading = true);

    final deviceId = await DeviceId.get();
    
    // Parse the human-readable UI numbers (1-indexed) into system logic
    int startFace = int.tryParse(_startFaceCtrl.text) ?? 1;
    int startStrip = int.tryParse(_startStripCtrl.text) ?? 1;

    final task = Task()
      ..buildingName = _nameCtrl.text.trim() + " (RESUMED)"
      ..buildingHeight = double.tryParse(_heightCtrl.text) ?? 0
      ..surfaceArea = double.tryParse(_areaCtrl.text) ?? 0
      ..numberOfFaces = int.tryParse(_facesCtrl.text) ?? 1
      ..currentFace = startFace
      ..currentStrip = startStrip - 1 // Convert to 0-indexed for the mapping array
      ..cameraALink = _camACtrl.text.trim()
      ..cameraBLink = _camBCtrl.text.trim()
      ..telemetryPort = "AUTO-DETECT"
      ..deviceId = deviceId
      ..isSynced = false
      ..updatedAt = DateTime.now();

    await IsarService.addTask(task);
    if (mounted) Navigator.pop(context);
  }

  List<SidebarItem> _sidebarItems(BuildContext ctx) => [
    SidebarItem(
      icon: Icons.arrow_back_rounded,
      label: 'Cancel Resume',
      sublabel: 'Return to tasks',
      accent: AppTheme.amber,
      onTap: () => Navigator.pop(ctx),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final pad = AppTheme.screenPad(context);
    final size = MediaQuery.of(context).size;

    return GcsScaffold(
      screenTitle: 'Resume Task',
      screenCode: 'WIPER · TASK · RESUME',
      accentColor: AppTheme.amber,
      items: _sidebarItems(context),
      activeIndex: -1,
      body: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: GridPainter(
                spacing: 28,
                color: AppTheme.borderDim.withOpacity(0.4),
              ),
            ),
          ),
          AnimatedBuilder(
            animation: _entryAnim,
            builder: (_, child) => Opacity(
              opacity: _entryAnim.value,
              child: Transform.translate(
                offset: Offset(0, 30 * (1 - _entryAnim.value)),
                child: child,
              ),
            ),
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: pad, vertical: 24),
              child: size.width >= 600 ? _wideLayout() : _compactLayout(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _header() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'EMERGENCY RECOVERY',
          style: GoogleFonts.jetBrainsMono(
            fontSize: 9,
            color: AppTheme.textLo,
            letterSpacing: 2.5,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Resume Active\nOperation',
          style: GoogleFonts.barlowCondensed(
            fontSize: 32,
            fontWeight: FontWeight.w800,
            color: AppTheme.amber,
            height: 1.0,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Use this to reconnect to a robot currently deployed on a wall if the primary tablet fails. The altimeter will automatically snap to the correct height.',
          style: GoogleFonts.jetBrainsMono(
            fontSize: 10,
            color: AppTheme.textMid,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _formPanel() {
    return Form(
      key: _formKey,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppTheme.bgCard,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppTheme.amber.withOpacity(0.5)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GcsSectionLabel('Building Identity', color: AppTheme.amber),
            const SizedBox(height: 12),
            GcsTextField(
              controller: _nameCtrl,
              label: 'Building name',
              hint: 'e.g. Marina Bay Tower A',
              prefixIcon: Icon(Icons.domain_rounded, size: 17, color: AppTheme.textLo),
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: GcsTextField(
                    controller: _heightCtrl,
                    label: 'Height (m)',
                    keyboardType: TextInputType.number,
                    prefixIcon: Icon(Icons.height_rounded, size: 17, color: AppTheme.textLo),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GcsTextField(
                    controller: _areaCtrl,
                    label: 'Total Surface Area (m²)',
                    keyboardType: TextInputType.number,
                    prefixIcon: Icon(Icons.square_foot_rounded, size: 17, color: AppTheme.textLo),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            GcsTextField(
              controller: _facesCtrl,
              label: 'Total Building Faces',
              keyboardType: TextInputType.number,
              prefixIcon: Icon(Icons.layers_rounded, size: 17, color: AppTheme.textLo),
            ),
            
            const SizedBox(height: 24),
            Container(height: 1, color: AppTheme.borderDim),
            const SizedBox(height: 24),

            // 👉 INJECTION POINTS FOR THE X-AXIS
            GcsSectionLabel('Current Robot Position (Operator Eyes)', color: AppTheme.amber),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: GcsTextField(
                    controller: _startFaceCtrl,
                    label: 'Starting Face (1-based)',
                    hint: 'e.g. 2',
                    keyboardType: TextInputType.number,
                    prefixIcon: Icon(Icons.flip_to_front_rounded, size: 17, color: AppTheme.amber),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GcsTextField(
                    controller: _startStripCtrl,
                    label: 'Starting Strip (1-based)',
                    hint: 'e.g. 4',
                    keyboardType: TextInputType.number,
                    prefixIcon: Icon(Icons.view_column_rounded, size: 17, color: AppTheme.amber),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            GcsSectionLabel('Vision Links', color: AppTheme.amber),
            const SizedBox(height: 12),
            GcsTextField(
              controller: _camACtrl,
              label: 'Camera A Link',
              prefixIcon: Icon(Icons.videocam_outlined, size: 17, color: AppTheme.textLo),
            ),
            const SizedBox(height: 12),
            GcsTextField(
              controller: _camBCtrl,
              label: 'Camera B Link',
              prefixIcon: Icon(Icons.videocam_outlined, size: 17, color: AppTheme.textLo),
            ),
            const SizedBox(height: 24),
            GcsButton(
              label: 'Resume Task',
              color: AppTheme.amber,
              onPressed: _resumeTask,
              isLoading: _loading,
              width: double.infinity,
              icon: Icons.restore_rounded,
            ),
          ],
        ),
      ),
    );
  }

  Widget _compactLayout() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [_header(), const SizedBox(height: 28), _formPanel()],
  );
  
  Widget _wideLayout() => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Expanded(
        flex: 4,
        child: Padding(
          padding: const EdgeInsets.only(top: 24, right: 40),
          child: _header(),
        ),
      ),
      Expanded(flex: 5, child: _formPanel()),
    ],
  );
}



//updated code for resume task

// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:vivid_mapping_sandbox/ui/app_theme.dart';
// import 'package:vivid_mapping_sandbox/ui/gcs_sidebar.dart';
// import 'package:vivid_mapping_sandbox/ui/gcs_widgets.dart';

// import '../../../core/db/isar_service.dart';
// import '../../../core/models/task.dart';
// import '../../../core/utils/device_id.dart';

// class ResumeTaskScreen extends StatefulWidget {
//   const ResumeTaskScreen({super.key});

//   @override
//   State<ResumeTaskScreen> createState() => _ResumeTaskScreenState();
// }

// class _ResumeTaskScreenState extends State<ResumeTaskScreen>
//     with SingleTickerProviderStateMixin {
//   final _formKey = GlobalKey<FormState>();

//   // Standard building details
//   final _nameCtrl = TextEditingController();
//   final _heightCtrl = TextEditingController();
//   final _areaCtrl = TextEditingController();
//   final _facesCtrl = TextEditingController(text: '1');

//   // Resume coordinates
//   final _startFaceCtrl = TextEditingController(text: '1');
//   final _startStripCtrl = TextEditingController(text: '1');

//   final _camACtrl = TextEditingController();
//   final _camBCtrl = TextEditingController();

//   bool _loading = false;

//   // --- matching state ---
//   List<Task> _matchedTasks = [];
//   Task? _matchedTask;
//   Timer? _debounce;

//   late final AnimationController _entryCtrl;
//   late final Animation<double> _entryAnim;

//   @override
//   void initState() {
//     super.initState();
//     _entryCtrl = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 500),
//     );
//     _entryAnim = CurvedAnimation(
//       parent: _entryCtrl,
//       curve: Curves.easeOutCubic,
//     );
//     _entryCtrl.forward();

//     _nameCtrl.addListener(_onNameChanged);
//   }

//   @override
//   void dispose() {
//     _nameCtrl.removeListener(_onNameChanged);
//     _debounce?.cancel();
//     _nameCtrl.dispose();
//     _heightCtrl.dispose();
//     _areaCtrl.dispose();
//     _facesCtrl.dispose();
//     _startFaceCtrl.dispose();
//     _startStripCtrl.dispose();
//     _camACtrl.dispose();
//     _camBCtrl.dispose();
//     _entryCtrl.dispose();
//     super.dispose();
//   }

//   void _onNameChanged() {
//     _debounce?.cancel();
//     _debounce = Timer(const Duration(milliseconds: 400), _findMatchingTask);
//   }

//   String _normalize(String s) =>
//       s.toLowerCase().replaceAll(' (resumed)', '').trim();

//   /// Filters saved tasks by STATUS first (only open sessions can be
//   /// resumed), then by building NAME. This is the core of the resume
//   /// matching logic.
//   Future<void> _findMatchingTask() async {
//     final rawName = _nameCtrl.text.trim();
//     // if (rawName.isEmpty) {
//     //   if (_matchedTasks.isNotEmpty || _matchedTask != null) {
//     //     setState(() {
//     //       _matchedTasks = [];
//     //       _matchedTask = null;
//     //     });
//     //   }
//     //   return;
//     // }

//     final allTasks = await IsarService.getAllTasks(); // adjust to your actual method
//     final normalizedInput = _normalize(rawName);

//     // Step 1: status filter — only sessions that are still "live"
//     final openTasks = allTasks.where((t) =>
//         t.status == TaskStatus.paused || t.status == TaskStatus.inProgress);

//     // Step 2: name filter — of the open ones, match by building name
//     final matches = openTasks
//         .where((t) => _normalize(t.buildingName) == normalizedInput)
//         .toList();

//     matches.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));

//     // setState(() {
//     //   _matchedTasks = matches;
//     //   if (matches.length == 1) {
//     //     _matchedTask = matches.first;
//     //     _applyMatch(matches.first);
//     //   } else {
//     //     // 0 matches -> nothing to prefill
//     //     // 2+ matches -> ambiguous, wait for operator to pick from the list
//     //     _matchedTask = null;
//     //   }
//     // });
//   }

//   void _applyMatch(Task t) {
//     _facesCtrl.text = t.numberOfFaces.toString();
//     _startFaceCtrl.text = t.currentFace.toString();
//     _startStripCtrl.text = (t.currentStrip + 1).toString(); // 0-indexed -> 1-indexed
//     _camACtrl.text = t.cameraALink;
//     _camBCtrl.text = t.cameraBLink;
//     if (_heightCtrl.text.isEmpty) _heightCtrl.text = t.buildingHeight.toString();
//     if (_areaCtrl.text.isEmpty) _areaCtrl.text = t.surfaceArea.toString();
//   }

//   Future<void> _resumeTask() async {
//     if (!(_formKey.currentState?.validate() ?? false)) return;

//     // Guard: if there are multiple candidates, operator must pick one first
//     if (_matchedTasks.length > 1 && _matchedTask == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Multiple saved sessions found — select one to resume above.'),
//         ),
//       );
//       return;
//     }

//     // setState(() => _loading = true);
//     try{

//     final deviceId = await DeviceId.get();

//     final startFace = int.tryParse(_startFaceCtrl.text) ?? 1;
//     final startStrip = int.tryParse(_startStripCtrl.text) ?? 1;

//     final task = Task()
//       ..buildingName = '${_nameCtrl.text.trim()} (RESUMED)'
//       ..buildingHeight = double.tryParse(_heightCtrl.text) ?? 0
//       ..surfaceArea = double.tryParse(_areaCtrl.text) ?? 0
//       ..numberOfFaces = int.tryParse(_facesCtrl.text) ?? 1
//       ..currentFace = startFace
//       ..currentStrip = startStrip - 1 // back to 0-indexed for mapping array
//       ..cameraALink = _camACtrl.text.trim()
//       ..cameraBLink = _camBCtrl.text.trim()
//       ..telemetryPort = "AUTO-DETECT"
//       ..deviceId = deviceId
//       ..isSynced = false
//       ..status = TaskStatus.inProgress
//       ..updatedAt = DateTime.now();

//     await IsarService.addTask(task);

//     // Mark the old session completed so it can't be matched/resumed again
//     if (_matchedTask != null) {
//       _matchedTask!.status = TaskStatus.completed;
//       _matchedTask!.updatedAt = DateTime.now();
//       await IsarService.updateTask(_matchedTask!); // adjust to your actual method
//     }

//     if (mounted) Navigator.pop(context);
//   }
//   catch(e,st){
//     debugPrint('Resume task failed: $e\n$st');
//     if(mounted){
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to resume task: $e')),
//       );
//     }
//   }
//   finally{
//     if(mounted){
//       setState(() => _loading = false);
//     }
//   }
//   }

//   List<SidebarItem> _sidebarItems(BuildContext ctx) => [
//     SidebarItem(
//       icon: Icons.arrow_back_rounded,
//       label: 'Cancel Resume',
//       sublabel: 'Return to tasks',
//       accent: AppTheme.amber,
//       onTap: () => Navigator.pop(ctx),
//     ),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     final pad = AppTheme.screenPad(context);
//     final size = MediaQuery.of(context).size;

//     return GcsScaffold(
//       screenTitle: 'Resume Task',
//       screenCode: 'WIPER · TASK · RESUME',
//       accentColor: AppTheme.amber,
//       items: _sidebarItems(context),
//       activeIndex: -1,
//       body: Stack(
//         children: [
//           Positioned.fill(
//             child: CustomPaint(
//               painter: GridPainter(
//                 spacing: 28,
//                 color: AppTheme.borderDim.withOpacity(0.4),
//               ),
//             ),
//           ),
//           AnimatedBuilder(
//             animation: _entryAnim,
//             builder: (_, child) => Opacity(
//               opacity: _entryAnim.value,
//               child: Transform.translate(
//                 offset: Offset(0, 30 * (1 - _entryAnim.value)),
//                 child: child,
//               ),
//             ),
//             child: SingleChildScrollView(
//               padding: EdgeInsets.symmetric(horizontal: pad, vertical: 24),
//               child: size.width >= 600 ? _wideLayout() : _compactLayout(),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _header() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           'EMERGENCY RECOVERY',
//           style: GoogleFonts.jetBrainsMono(
//             fontSize: 9,
//             color: AppTheme.textLo,
//             letterSpacing: 2.5,
//           ),
//         ),
//         const SizedBox(height: 6),
//         Text(
//           'Resume Active\nOperation',
//           style: GoogleFonts.barlowCondensed(
//             fontSize: 32,
//             fontWeight: FontWeight.w800,
//             color: AppTheme.amber,
//             height: 1.0,
//           ),
//         ),
//         const SizedBox(height: 12),
//         Text(
//           'Use this to reconnect to a robot currently deployed on a wall if the primary tablet fails. The altimeter will automatically snap to the correct height.',
//           style: GoogleFonts.jetBrainsMono(
//             fontSize: 10,
//             color: AppTheme.textMid,
//             height: 1.5,
//           ),
//         ),
//       ],
//     );
//   }

//   // --- Match status banners -------------------------------------------

//   Widget _singleMatchBanner() {
//     final t = _matchedTask!;
//     return Container(
//       margin: const EdgeInsets.only(top: 12),
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: AppTheme.amber.withOpacity(0.12),
//         borderRadius: BorderRadius.circular(8),
//         border: Border.all(color: AppTheme.amber.withOpacity(0.4)),
//       ),
//       child: Row(
//         children: [
//           Icon(Icons.sync_rounded, size: 16, color: AppTheme.amber),
//           const SizedBox(width: 8),
//           Expanded(
//             child: Text(
//               'Matched saved session from device ${t.deviceId} '
//               '(status: ${t.status}, updated '
//               '${t.updatedAt.hour.toString().padLeft(2, '0')}:'
//               '${t.updatedAt.minute.toString().padLeft(2, '0')}). '
//               'Position auto-filled below.',
//               style: GoogleFonts.jetBrainsMono(fontSize: 9, color: AppTheme.textMid),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _multiMatchPicker() {
//     return Container(
//       margin: const EdgeInsets.only(top: 12),
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: Colors.red.withOpacity(0.10),
//         borderRadius: BorderRadius.circular(8),
//         border: Border.all(color: Colors.redAccent.withOpacity(0.5)),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               const Icon(Icons.warning_amber_rounded, size: 16, color: Colors.redAccent),
//               const SizedBox(width: 8),
//               Expanded(
//                 child: Text(
//                   '${_matchedTasks.length} open sessions match this name — select one to resume',
//                   style: GoogleFonts.jetBrainsMono(fontSize: 9, color: AppTheme.textMid),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 10),
//           ..._matchedTasks.map((t) {
//             final selected = _matchedTask == t;
//             return Padding(
//               padding: const EdgeInsets.only(bottom: 6),
//               child: InkWell(
//                 // onTap: () => setState(() {
//                 //   _matchedTask = t;
//                 //   _applyMatch(t);
//                 // }),
//                 borderRadius: BorderRadius.circular(6),
//                 child: Container(
//                   padding: const EdgeInsets.all(10),
//                   decoration: BoxDecoration(
//                     color: selected ? AppTheme.amber.withOpacity(0.15) : AppTheme.bgCard,
//                     borderRadius: BorderRadius.circular(6),
//                     border: Border.all(
//                       color: selected ? AppTheme.amber : AppTheme.borderDim,
//                     ),
//                   ),
//                   child: Row(
//                     children: [
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               'Device: ${t.deviceId}  ·  ${t.status}',
//                               style: GoogleFonts.jetBrainsMono(
//                                 fontSize: 10,
//                                 color: AppTheme.textHi,
//                                 fontWeight: FontWeight.w600,
//                               ),
//                             ),
//                             const SizedBox(height: 2),
//                             Text(
//                               'Face ${t.currentFace}, Strip ${t.currentStrip + 1} · Updated ${t.updatedAt}',
//                               style: GoogleFonts.jetBrainsMono(fontSize: 9, color: AppTheme.textLo),
//                             ),
//                           ],
//                         ),
//                       ),
//                       if (selected)
//                         Icon(Icons.check_circle_rounded, size: 16, color: AppTheme.amber),
//                     ],
//                   ),
//                 ),
//               ),
//             );
//           }),
//         ],
//       ),
//     );
//   }

//   Widget _formPanel() {
//     return Form(
//       key: _formKey,
//       child: Container(
//         padding: const EdgeInsets.all(20),
//         decoration: BoxDecoration(
//           color: AppTheme.bgCard,
//           borderRadius: BorderRadius.circular(10),
//           border: Border.all(color: AppTheme.amber.withOpacity(0.5)),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             GcsSectionLabel('Building Identity', color: AppTheme.amber),
//             const SizedBox(height: 12),
//             GcsTextField(
//               key: const ValueKey('name_field'),
//               controller: _nameCtrl,
//               label: 'Building name',
//               hint: 'e.g. Marina Bay Tower A',
//               prefixIcon: Icon(Icons.domain_rounded, size: 17, color: AppTheme.textLo),
//               validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
//             ),

//             // Match feedback: exactly one of these renders, or neither.
//             if (_matchedTasks.length > 1) _multiMatchPicker(),
//             if (_matchedTasks.length == 1 && _matchedTask != null) _singleMatchBanner(),

//             const SizedBox(height: 12),
//             Row(
//               children: [
//                 Expanded(
//                   child: GcsTextField(
//                     key: const ValueKey('height_field'),
//                     controller: _heightCtrl,
//                     label: 'Height (m)',
//                     keyboardType: TextInputType.number,
//                     prefixIcon: Icon(Icons.height_rounded, size: 17, color: AppTheme.textLo),
//                   ),
//                 ),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: GcsTextField(
//                     key: const ValueKey('area_field'),
//                     controller: _areaCtrl,
//                     label: 'Total Surface Area (m²)',
//                     keyboardType: TextInputType.number,
//                     prefixIcon: Icon(Icons.square_foot_rounded, size: 17, color: AppTheme.textLo),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 12),
//             GcsTextField(
//               key: const ValueKey('faces_field'),
//               controller: _facesCtrl,
//               label: 'Total Building Faces',
//               keyboardType: TextInputType.number,
//               prefixIcon: Icon(Icons.layers_rounded, size: 17, color: AppTheme.textLo),
//             ),

//             const SizedBox(height: 24),
//             Container(height: 1, color: AppTheme.borderDim),
//             const SizedBox(height: 24),

//             GcsSectionLabel('Current Robot Position (Operator Eyes)', color: AppTheme.amber),
//             const SizedBox(height: 12),
//             Row(
//               children: [
//                 Expanded(
//                   child: GcsTextField(
//                     key: const ValueKey('start_face_field'),
//                     controller: _startFaceCtrl,
//                     label: 'Starting Face (1-based)',
//                     hint: 'e.g. 2',
//                     keyboardType: TextInputType.number,
//                     prefixIcon: Icon(Icons.flip_to_front_rounded, size: 17, color: AppTheme.amber),
//                   ),
//                 ),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: GcsTextField(
//                     key: const ValueKey('start_strip_field'),
//                     controller: _startStripCtrl,
//                     label: 'Starting Strip (1-based)',
//                     hint: 'e.g. 4',
//                     keyboardType: TextInputType.number,
//                     prefixIcon: Icon(Icons.view_column_rounded, size: 17, color: AppTheme.amber),
//                   ),
//                 ),
//               ],
//             ),

//             const SizedBox(height: 24),
//             GcsSectionLabel('Vision Links', color: AppTheme.amber),
//             const SizedBox(height: 12),
//             GcsTextField(
//               key: const ValueKey('cam_a_field'),
//               controller: _camACtrl,
//               label: 'Camera A Link',
//               prefixIcon: Icon(Icons.videocam_outlined, size: 17, color: AppTheme.textLo),
//             ),
//             const SizedBox(height: 12),
//             GcsTextField(
//               key: const ValueKey('cam_b_field'),
//               controller: _camBCtrl,
//               label: 'Camera B Link',
//               prefixIcon: Icon(Icons.videocam_outlined, size: 17, color: AppTheme.textLo),
//             ),
//             const SizedBox(height: 24),
//             GcsButton(
//               label: 'Resume Task',
//               color: AppTheme.amber,
//               onPressed: _resumeTask,
//               isLoading: _loading,
//               width: double.infinity,
//               icon: Icons.restore_rounded,
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _compactLayout() => Column(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: [_header(), const SizedBox(height: 28), _formPanel()],
//   );

//   Widget _wideLayout() => Row(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: [
//       Expanded(
//         flex: 4,
//         child: Padding(
//           padding: const EdgeInsets.only(top: 24, right: 40),
//           child: _header(),
//         ),
//       ),
//       Expanded(flex: 5, child: _formPanel()),
//     ],
//   );
// }
