import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vivid_mapping_sandbox/core/db/isar_service.dart';
import 'package:vivid_mapping_sandbox/core/models/task.dart';
import 'package:vivid_mapping_sandbox/ui/app_theme.dart';
import 'package:vivid_mapping_sandbox/ui/gcs_widgets.dart';
import 'wiper_main_screen.dart';

class ArchivedTasksScreen extends StatefulWidget {
  const ArchivedTasksScreen({super.key});

  @override
  State<ArchivedTasksScreen> createState() => _ArchivedTasksScreenState();
}

class _ArchivedTasksScreenState extends State<ArchivedTasksScreen> {
  List<Task> _tasks = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadArchivedTasks();
  }

  Future<void> _loadArchivedTasks() async {
    final tasks = await IsarService.getTasks();
    if (!mounted) return;

    setState(() {
      _tasks = tasks.where((task) => task.isArchive).toList()
        ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
      _loading = false;
    });
  }
  bool _isNavigating = false;

Future<void> _openTask(Task task) async {
  if (_isNavigating) return;
  setState(() => _isNavigating = true);

  await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => WiperMainScreen(task: task, isActive: false),
    ),
  );

  if (mounted) {
    setState(() => _isNavigating = false);
    _loadArchivedTasks(); // refresh in case anything changed
  }
}

  Future<void> _restoreTask(Task task) async {
    task.isArchive = false;
    task.isSynced = false;
    task.updatedAt = DateTime.now();
    await IsarService.updateTask(task);
    await _loadArchivedTasks();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('"${task.buildingName}" restored to the task list'),
          backgroundColor: AppTheme.bgCard,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final pad = AppTheme.screenPad(context);

    return Scaffold(
      backgroundColor: AppTheme.bg,
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'ARCHIVED TASKS',
                          style: GoogleFonts.barlowCondensed(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            color: AppTheme.textHi,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                      const ThemeToggleButton(),
                    ],
                  ),
                ),
                Expanded(
                  child: _loading
                      ? Center(
                          child: CircularProgressIndicator(
                            color: AppTheme.cyan,
                          ),
                        )
                      : _tasks.isEmpty
                      ? Center(
                          child: Padding(
                            padding: EdgeInsets.all(pad),
                            child: Text(
                              'No archived tasks',
                              style: GoogleFonts.jetBrainsMono(
                                fontSize: 12,
                                color: AppTheme.textMid,
                              ),
                            ),
                          ),
                        )
                      : RefreshIndicator(
                          color: AppTheme.cyan,
                          backgroundColor: AppTheme.bgCard,
                          onRefresh: _loadArchivedTasks,
                          child: ListView.separated(
                            padding: EdgeInsets.symmetric(
                              horizontal: pad,
                              vertical: 8,
                            ),
                            itemCount: _tasks.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 10),
                            itemBuilder: (context, index) {
                              final task = _tasks[index];
                              return Container(
                                decoration: BoxDecoration(
                                  color: AppTheme.bgCard,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: AppTheme.borderMid),
                                ),
                                child: ListTile(
                                  onTap: () => _openTask(task),
                              contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  leading: Icon(
                                    Icons.domain_rounded,
                                    color: AppTheme.amber,
                                  ),
                                  title: Text(
                                    task.buildingName,
                                    style: GoogleFonts.barlowCondensed(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w700,
                                      color: AppTheme.textHi,
                                    ),
                                  ),
                                  subtitle: Text(
                                    '#${task.id.toString().padLeft(4, '0')} · ${task.status}',
                                    style: GoogleFonts.jetBrainsMono(
                                      fontSize: 10,
                                      color: AppTheme.textMid,
                                    ),
                                  ),
                                  trailing: IconButton(
                                    tooltip: 'Restore task',
                                    icon: Icon(
                                      Icons.unarchive_outlined,
                                      color: AppTheme.cyan,
                                    ),
                                    onPressed: () => _restoreTask(task),
                                  ),
                                ),
                              );
                            },
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
}
