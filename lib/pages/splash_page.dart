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
          Center(
            child: CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).textTheme.headline6.color,
              ),
            ),
          ),
          Container(
            child: Align(
              alignment: Alignment.bottomRight,
              child: Text(
                'V 0.1 ',
                style: TextStyle(
                    color: Theme.of(context).textTheme.headline6.color,
                    fontSize: 15.0),
              ),
            ),
          ),
        ],
      )),
    );
  }
}
