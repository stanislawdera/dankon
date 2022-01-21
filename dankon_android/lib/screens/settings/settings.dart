import 'package:dankon/services/authentication.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            ListTile(
              title: const Text('Search for friends'),
              leading: const Icon(Icons.person_add),
              onTap: () {
                Navigator.of(context).pushNamed("/search");
              },
            ),
            ListTile(
              title: const Text('Logout'),
              leading: const Icon(Icons.logout),
              onTap: () {
                context.read<AuthenticationService>().signOut();
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              title: const Text('About the app'),
              leading: const Icon(Icons.info),
              onTap: () {
                showAboutDialog(context: context, applicationIcon: CircleAvatar(backgroundColor: Theme.of(context).primaryColor, backgroundImage: const AssetImage('assets/app_logo.png')), applicationVersion: dotenv.env['VERSION']);
              },
            )
          ],
      ),
    );
  }
}