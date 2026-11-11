import 'package:flutter/material.dart';
import '../store.dart';
import '../widgets.dart';
import 'about_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = NotesStore.instance;
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: AnimatedBuilder(
        animation: store,
        builder: (context, _) => ListView(
          children: [
            SwitchListTile(
              title: const Text('Dark mode'),
              secondary: const Icon(Icons.dark_mode),
              value: store.dark,
              onChanged: store.setDark,
            ),
            ListTile(
              leading: const Icon(Icons.delete_sweep),
              title: const Text('Delete all data'),
              onTap: () {
                store.clearAll();
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('All data deleted')));
              },
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('About'),
              onTap: () => goTo(context, const AboutScreen()),
            ),
          ],
        ),
      ),
    );
  }
}
