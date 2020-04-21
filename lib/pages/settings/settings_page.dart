import 'package:flutter/material.dart';
import 'package:storeRahisi/app_localizations.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(AppLocalizations.of(context).translate('settings')),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Divider(
              thickness: 10.0,
              
            ),
            ListTile(
              title: Text('mail@mail.com'),
              subtitle: Text('Email'),
            ),
            ListTile(
              title: Text('Mail Name'),
              subtitle: Text('Name'),
            ),
            Divider(
              thickness: 10.0,
            ),
            ListTile(
              title: Text('Tzs'),
              subtitle: Text('Currency'),
            ),
            ListTile(
              title: Text('TZ'),
              subtitle: Text('Language'),
            ),
            ListTile(
              title: Text('Light'),
              subtitle: Text('Theme'),
            ),
          ],
        ),
      ),
    );
  }
}
