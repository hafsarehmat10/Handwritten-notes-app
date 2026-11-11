import 'package:flutter/material.dart';
import '../store.dart';
import '../widgets.dart';
import 'note_editor_screen.dart';

class AllNotesScreen extends StatefulWidget {
  final String? folderId;
  final String title;
  const AllNotesScreen({super.key, this.folderId, this.title = 'All Notes'});

  @override
  State<AllNotesScreen> createState() => _AllNotesScreenState();
}

class _AllNotesScreenState extends State<AllNotesScreen> {
  String query = '';

  void confirmDelete(Note n) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete note?'),
        content: Text('"${n.title}" will be removed.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              NotesStore.instance.deleteNote(n.id);
              Navigator.pop(ctx);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void openNote(Note n) {
    goTo(
      context,
      Scaffold(
        appBar: AppBar(title: Text(n.title)),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text('Created: ${n.created.toString().substring(0, 16)}'),
            ),
            Expanded(child: NoteThumb(note: n)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final store = NotesStore.instance;
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  hintText: 'Search notes...',
                  border: OutlineInputBorder()),
              onChanged: (v) => setState(() => query = v),
            ),
          ),
          Expanded(
            child: AnimatedBuilder(
              animation: store,
              builder: (context, _) {
                final list = store
                    .notesIn(widget.folderId)
                    .where((n) =>
                        n.title.toLowerCase().contains(query.toLowerCase()))
                    .toList();
                if (list.isEmpty) {
                  return const Center(child: Text('No notes found'));
                }
                return GridView.builder(
                  padding: const EdgeInsets.all(12),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12),
                  itemCount: list.length,
                  itemBuilder: (context, i) {
                    final n = list[i];
                    return InkWell(
                      onTap: () => openNote(n),
                      onLongPress: () => confirmDelete(n),
                      child: Card(
                        clipBehavior: Clip.antiAlias,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(child: NoteThumb(note: n)),
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: Text(n.title,
                                  maxLines: 1, overflow: TextOverflow.ellipsis),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            goTo(context, NoteEditorScreen(folderId: widget.folderId)),
        child: const Icon(Icons.add),
      ),
    );
  }
}
