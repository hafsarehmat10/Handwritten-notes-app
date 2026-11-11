import 'package:flutter/material.dart';
import '../store.dart';
import '../widgets.dart';
import 'all_notes_screen.dart';
import 'daily_plan_screen.dart';
import 'folders_screen.dart';
import 'note_editor_screen.dart';
import 'settings_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  Widget stat(IconData icon, String label, int value, VoidCallback onTap) {
    return Expanded(
      child: Card(
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                Icon(icon),
                const SizedBox(height: 6),
                Text('$value',
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold)),
                Text(label, style: const TextStyle(fontSize: 12)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget navTile(BuildContext context, IconData icon, String text, Widget screen) {
    return Card(
      child: ListTile(
        leading: Icon(icon),
        title: Text(text),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => goTo(context, screen),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final store = NotesStore.instance;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () => goTo(context, const SettingsScreen())),
        ],
      ),
      body: AnimatedBuilder(
        animation: store,
        builder: (context, _) {
          final pending = store.plans.where((p) => !p.done).length;
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const Text('Welcome back!',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Row(
                children: [
                  stat(Icons.note, 'Notes', store.notes.length,
                      () => goTo(context, const AllNotesScreen())),
                  stat(Icons.folder, 'Folders', store.folders.length,
                      () => goTo(context, const FoldersScreen())),
                  stat(Icons.checklist, 'Pending', pending,
                      () => goTo(context, const DailyPlanScreen())),
                ],
              ),
              const SizedBox(height: 12),
              const Text('Recent notes',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              if (store.notes.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Center(child: Text('No notes yet. Tap + New Note.')),
                )
              else
                SizedBox(
                  height: 160,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: store.notes.length > 8 ? 8 : store.notes.length,
                    itemBuilder: (context, i) {
                      final n = store.notes[i];
                      return SizedBox(
                        width: 130,
                        child: Card(
                          clipBehavior: Clip.antiAlias,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(child: NoteThumb(note: n)),
                              Padding(
                                padding: const EdgeInsets.all(6),
                                child: Text(n.title,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              const SizedBox(height: 12),
              navTile(context, Icons.notes, 'All Notes', const AllNotesScreen()),
              navTile(context, Icons.folder_open, 'Folders', const FoldersScreen()),
              navTile(context, Icons.today, 'Daily Plan', const DailyPlanScreen()),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => goTo(context, const NoteEditorScreen()),
        icon: const Icon(Icons.add),
        label: const Text('New Note'),
      ),
    );
  }
}
