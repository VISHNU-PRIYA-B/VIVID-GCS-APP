import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vivid_mapping_sandbox/ui/app_theme.dart';
import 'package:vivid_mapping_sandbox/ui/gcs_sidebar.dart';
import 'package:vivid_mapping_sandbox/ui/gcs_widgets.dart';

import '../../../core/db/isar_service.dart';
import '../../../core/models/task.dart';
import '../../../core/utils/device_id.dart';

class CreateTaskScreen extends StatefulWidget {
  const CreateTaskScreen({super.key});

  @override
  State<CreateTaskScreen> createState() => _CreateTaskScreenState();
}

class _CreateTaskScreenState extends State<CreateTaskScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _heightCtrl = TextEditingController();
  final _areaCtrl = TextEditingController();
  final _facesCtrl = TextEditingController(text: '1');

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
    _camACtrl.dispose();
    _camBCtrl.dispose();
    _entryCtrl.dispose();
    super.dispose();
  }

  Future<void> _createTask() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _loading = true);

    final deviceId = await DeviceId.get();
    final task = Task()
      ..buildingName = _nameCtrl.text.trim()
      ..buildingHeight = double.tryParse(_heightCtrl.text) ?? 0
      ..surfaceArea = double.tryParse(_areaCtrl.text) ?? 0
      ..numberOfFaces = int.tryParse(_facesCtrl.text) ?? 1
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
      icon: Icons.water_drop_rounded,
      label: 'Task List',
      sublabel: 'All operations',
      accent: AppTheme.cyan,
      onTap: () => Navigator.pop(ctx),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final pad = AppTheme.screenPad(context);
    final size = MediaQuery.of(context).size;

    return GcsScaffold(
      screenTitle: 'New Task',
      screenCode: 'WIPER · TASK · CREATE',
      accentColor: AppTheme.cyan,
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
          'CONFIGURE TASK',
          style: GoogleFonts.jetBrainsMono(
            fontSize: 9,
            color: AppTheme.textLo,
            letterSpacing: 2.5,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'New Cleaning\nOperation',
          style: GoogleFonts.barlowCondensed(
            fontSize: 32,
            fontWeight: FontWeight.w800,
            color: AppTheme.textHi,
            height: 1.0,
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
          border: Border.all(color: AppTheme.borderMid),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GcsSectionLabel('Building Identity & Dimensions'),
            const SizedBox(height: 12),
            GcsTextField(
              controller: _nameCtrl,
              label: 'Building name',
              hint: 'e.g. Marina Bay Tower A',
              prefixIcon: Icon(
                Icons.domain_rounded,
                size: 17,
                color: AppTheme.textLo,
              ),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Required' : null,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: GcsTextField(
                    controller: _heightCtrl,
                    label: 'Height (m)',
                    keyboardType: TextInputType.number,
                    prefixIcon: Icon(
                      Icons.height_rounded,
                      size: 17,
                      color: AppTheme.textLo,
                    ),
                    validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Required' : null,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GcsTextField(
                    controller: _areaCtrl,
                    label: 'Total Surface Area (m²)',
                    keyboardType: TextInputType.number,
                    prefixIcon: Icon(
                      Icons.square_foot_rounded,
                      size: 17,
                      color: AppTheme.textLo,
                    ),
                    validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Required' : null,
                  
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            GcsTextField(
              controller: _facesCtrl,
              label: 'Number of Building Faces',
              hint: 'e.g. 4',
              keyboardType: TextInputType.number,
              prefixIcon: Icon(
                Icons.layers_rounded,
                size: 17,
                color: AppTheme.textLo,
              ),
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Required';
                if (int.tryParse(v) == null) return 'Must be a number';
                return null;
              },
            ),
            const SizedBox(height: 24),
            GcsSectionLabel('Vision Links (Dynamic Telemetry)'),
            const SizedBox(height: 12),
            GcsTextField(
              controller: _camACtrl,
              label: 'Camera A Link (RTSP/WebRTC)',
              hint: 'rtsp://192.168.1.10:8554/camA',
              prefixIcon: Icon(
                Icons.videocam_outlined,
                size: 17,
                color: AppTheme.textLo,
              ),
            ),
            const SizedBox(height: 12),
            GcsTextField(
              controller: _camBCtrl,
              label: 'Camera B Link (RTSP/WebRTC)',
              hint: 'rtsp://192.168.1.10:8554/camB',
              prefixIcon: Icon(
                Icons.videocam_outlined,
                size: 17,
                color: AppTheme.textLo,
              ),
            ),
            const SizedBox(height: 24),
            GcsButton(
              label: 'Create Task',
              onPressed: _createTask,
              isLoading: _loading,
              width: double.infinity,
              icon: Icons.add_task_rounded,
            ),
            const SizedBox(height: 12),
            GcsButton(
              label: 'Cancel',
              onPressed: () => Navigator.pop(context),
              width: double.infinity,
              outlined: true,
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