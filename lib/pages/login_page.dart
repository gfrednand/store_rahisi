import 'package:flutter/material.dart';
import 'package:storeRahisi/constants/ui_helpers.dart';
import 'package:storeRahisi/pages/base_view.dart';
import 'package:storeRahisi/providers/auth_model.dart';
import 'package:storeRahisi/widgets/busy_button.dart';
import 'package:storeRahisi/widgets/input_field.dart';
import 'package:storeRahisi/widgets/busy_overlay.dart';

class LoginPage extends StatelessWidget {
  LoginPage({Key key}) : super(key: key);

  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  final TextEditingController emailInputController =
      new TextEditingController();
  final TextEditingController pwdInputController = new TextEditingController();

  String emailValidator(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return 'Email format is invalid';
    } else {
      return null;
    }
  }

  String pwdValidator(String value) {
    if (value.length < 8) {
      return 'Password must be longer than 8 characters';
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    var pageSize = MediaQuery.of(context).size;
    return BaseView<AuthModel>(
        // onModelReady: (model) => model.getUserDetails(),
        builder: (context, model, child) {
      return Scaffold(
        body: BusyOverlay(
          show: model.busy,
          child: Container(
          width: pageSize.width,
          height: pageSize.height,
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: SingleChildScrollView(
              child: Form(
                key: _loginFormKey,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: new EdgeInsets.all(10.0),
                      child: Text(
                        'Store Rahisi',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).accentColor,
                            fontSize: 25.0),
                      ),
                    ),
                    InputField(
                      placeholder: 'Email',
                      isReadOnly: model.busy,
                      controller: emailInputController,
                      textInputType: TextInputType.emailAddress,
                    ),
                    verticalSpaceSmall,
                    InputField(
                      isReadOnly: model.busy,
                      placeholder: 'Password',
                      password: true,
                      controller: pwdInputController,
              
                    ),
                    verticalSpaceMedium,
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        BusyButton(
                          title: 'Login',
                          enabled: !model.busy,
                          onPressed: () {
                            if (_loginFormKey.currentState.validate()) {
                              model.login(
                                emailInputController.text,
                                pwdInputController.text,
                              );
                            }
                          },
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Text("Don't have an account yet?"),
                    FlatButton(
                      child: Text("Register here!"),
                      onPressed: () {
                        model.navigateToSignUp();
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
        ),)
      );
    });
  }
}
