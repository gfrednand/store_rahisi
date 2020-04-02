import 'package:flutter/material.dart';
import 'package:storeRahisi/providers/auth_model.dart';

import 'base_view.dart';

class SplashPage extends StatelessWidget {
  SplashPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<AuthModel>(
        onModelReady: (model) => model.handleStartUpLogic(),
        builder: (context, model, child) {
          return Scaffold(
            backgroundColor: Theme.of(context).primaryColor,
            body: new Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                SizedBox(),
                // new Image.asset('assets/images/erms.png'),
                Padding(
                  padding: new EdgeInsets.all(10.0),
                  child: Text(
                    'STORE RAHISI',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30.0,
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                ),
                Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).accentColor,
                    ),
                  ),
                ),
                Container(
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      'V 0.1',
                      style: TextStyle(
                          color: Theme.of(context).accentColor,
                          fontSize: 15.0),
                    ),
                  ),
                )
              ],
            )),
          );
        });
  }
}
