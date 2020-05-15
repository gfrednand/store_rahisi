import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storeRahisi/app_localizations.dart';
import 'package:storeRahisi/providers/auth_model.dart';

import 'base_view.dart';

class SplashPage extends StatelessWidget {
  SplashPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    context.select((AuthModel p) => p.handleStartUpLogic());

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: new Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            SizedBox(),
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: new Image(
                image: AssetImage("assets/images/playstore.png"),
                height: 150.0,
                width: 100.0,
              ),
            ),
        
            Center(
              child: CircularProgressIndicator(
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ),
            Container(
              child: Align(
                alignment: Alignment.bottomRight,
                child: Text(
                  'V 0.1 ',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontSize: 15.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
