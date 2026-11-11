import 'package:flutter/material.dart';
import '../store.dart';
import '../widgets.dart';
import 'all_notes_screen.dart';

class FoldersScreen extends StatelessWidget {
  const FoldersScreen({super.key});

  void addFolderDialog(BuildContext context) {
    final ctrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('New folder'),
        content: TextField(
            controller: ctrl,
            autofocus: true,
            decoration: const InputDecoration(hintText: 'Folder name')),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              if (ctrl.text.trim().isNotEmpty) {
                NotesStore.instance.addFolder(ctrl.text.trim());
              }
              Navigator.pop(ctx);
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final store = NotesStore.instance;
    return Scaffold(
      appBar: AppBar(title: const Text('Folders')),
      body: AnimatedBuilder(
        animation: store,
        builder: (context, _) {
          if (store.folders.isEmpty) {
            return const Center(child: Text('No folders. Tap + to create one.'));
          }
          return ListView.builder(
            itemCount: store.folders.length,
            itemBuilder: (context, i) {
              final f = store.folders[i];
              final count = store.notesIn(f.id).length;
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  leading: const Icon(Icons.folder),
                  title: Text(f.name),
                  subtitle: Text('$count notes'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => store.deleteFolder(f.id),
                  ),
                  onTap: () => goTo(context,
                      AllNotesScreen(folderId: f.id, title: f.name)),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => addFolderDialog(context),
        child: const Icon(Icons.create_new_folder),
      ),
    );
  }
}
