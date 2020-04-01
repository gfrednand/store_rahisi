import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:storeRahisi/constants/routes.dart';

class SplashPage extends StatefulWidget {
  SplashPage({Key key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  initState() {
    FirebaseAuth.instance
        .currentUser()
        .then((currentUser) => currentUser == null
            ? Navigator.pushReplacementNamed(context, AppRoutes.login)
            : Firestore.instance
                .collection("users")
                .document(currentUser.uid)
                .get()
                .then(
                    (DocumentSnapshot result) => Navigator.pushReplacementNamed(
                          context,
                          AppRoutes.home,
                        ))
                .catchError((err) => print(err)))
        .catchError((err) => print(err));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
          Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
          Container(
            child: Align(
              alignment: Alignment.bottomRight,
              child: Text(
                'V 0.1',
                style: TextStyle(color: Colors.white, fontSize: 15.0),
              ),
            ),
          )
        ],
      )),
    );
  }
}
