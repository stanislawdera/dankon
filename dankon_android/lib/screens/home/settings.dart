import 'package:dankon/services/authentication.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/src/provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Settings"),),
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: [
          ListTile(
            title: Text('Logout'),
            leading: Icon(Icons.logout),
            onTap: () {
              context.read<AuthenticationService>().signOut();
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            title: Text('About the app'),
            leading: Icon(Icons.info),
            onTap: () {
              showAboutDialog(context: context, applicationIcon: CircleAvatar(backgroundColor: Theme.of(context).primaryColor, backgroundImage: AssetImage('assets/app_logo.png')), applicationVersion: dotenv.env['VERSION']);
            },
          )
        ],
      ),
    );
  }
}