import 'package:flutter/material.dart';
import '../store.dart';
import '../widgets.dart';

class NoteEditorScreen extends StatefulWidget {
  final String? folderId;
  const NoteEditorScreen({super.key, this.folderId});
  @override
  State<NoteEditorScreen> createState() => _NoteEditorScreenState();
}

class _NoteEditorScreenState extends State<NoteEditorScreen> {
  final titleCtrl = TextEditingController();
  final List<Stroke> strokes = [];
  List<Offset> current = [];
  Color color = Colors.black;
  double width = 4;
  Size canvasSize = const Size(300, 400);
  String? folderId;

  final colors = [
    Colors.black,
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.orange
  ];

  @override
  void initState() {
    super.initState();
    folderId = widget.folderId;
  }

  void save() {
    if (strokes.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Write something first')));
      return;
    }
    final store = NotesStore.instance;
    final title =
        titleCtrl.text.trim().isEmpty ? 'Untitled' : titleCtrl.text.trim();
    store.addNote(Note(store.newId(), title, List.of(strokes), canvasSize,
        DateTime.now(),
        folderId: folderId));
    Navigator.pop(context);
  }

  @override
  void dispose() {
    titleCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final store = NotesStore.instance;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Note Editor'),
        actions: [
          IconButton(
              icon: const Icon(Icons.undo),
              onPressed: () {
                if (strokes.isNotEmpty) setState(() => strokes.removeLast());
              }),
          IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () => setState(() => strokes.clear())),
          IconButton(icon: const Icon(Icons.check), onPressed: save),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: TextField(
                    controller: titleCtrl,
                    decoration: const InputDecoration(
                        labelText: 'Title', border: OutlineInputBorder()),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 2,
                  child: DropdownButtonFormField<String?>(
                    isExpanded: true,
                    value: folderId,
                    decoration: const InputDecoration(
                        labelText: 'Folder', border: OutlineInputBorder()),
                    items: [
                      const DropdownMenuItem<String?>(
                          value: null, child: Text('None')),
                      ...store.folders.map((f) => DropdownMenuItem<String?>(
                          value: f.id, child: Text(f.name))),
                    ],
                    onChanged: (v) => setState(() => folderId = v),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: LayoutBuilder(builder: (context, box) {
              canvasSize = box.biggest;
              return GestureDetector(
                onPanStart: (d) => setState(() => current = [d.localPosition]),
                onPanUpdate: (d) =>
                    setState(() => current = [...current, d.localPosition]),
                onPanEnd: (_) => setState(() {
                  strokes.add(Stroke(current, color, width));
                  current = [];
                }),
                child: Container(
                  color: Colors.white,
                  child: ClipRect(
                    child: CustomPaint(
                      painter: StrokePainter([
                        ...strokes,
                        if (current.isNotEmpty) Stroke(current, color, width)
                      ]),
                      child: const SizedBox.expand(),
                    ),
                  ),
                ),
              );
            }),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                for (final c in colors)
                  GestureDetector(
                    onTap: () => setState(() => color = c),
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: c,
                        shape: BoxShape.circle,
                        border: Border.all(
                            width: 3,
                            color:
                                color == c ? Colors.indigo : Colors.transparent),
                      ),
                    ),
                  ),
                Expanded(
                  child: Slider(
                      min: 1,
                      max: 16,
                      value: width,
                      onChanged: (v) => setState(() => width = v)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
