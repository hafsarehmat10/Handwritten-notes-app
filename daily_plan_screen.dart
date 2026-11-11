import 'package:flutter/material.dart';
import '../store.dart';

class DailyPlanScreen extends StatelessWidget {
  const DailyPlanScreen({super.key});

  void addDialog(BuildContext context) {
    final ctrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('New task'),
        content: TextField(
            controller: ctrl,
            autofocus: true,
            decoration: const InputDecoration(hintText: 'What to do today?')),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              if (ctrl.text.trim().isNotEmpty) {
                NotesStore.instance.addPlan(ctrl.text.trim());
              }
              Navigator.pop(ctx);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final store = NotesStore.instance;
    final today = DateTime.now().toString().substring(0, 10);
    return Scaffold(
      appBar: AppBar(title: Text('Daily Plan - $today')),
      body: AnimatedBuilder(
        animation: store,
        builder: (context, _) {
          if (store.plans.isEmpty) {
            return const Center(child: Text('No tasks. Tap + to add one.'));
          }
          return ListView.builder(
            itemCount: store.plans.length,
            itemBuilder: (context, i) {
              final p = store.plans[i];
              return Dismissible(
                key: ValueKey(p.id),
                background: Container(color: Colors.red),
                onDismissed: (_) => store.deletePlan(p.id),
                child: CheckboxListTile(
                  value: p.done,
                  onChanged: (_) => store.togglePlan(p),
                  title: Text(
                    p.text,
                    style: TextStyle(
                        decoration:
                            p.done ? TextDecoration.lineThrough : null),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => addDialog(context),
        child: const Icon(Icons.add_task),
      ),
    );
  }
}
