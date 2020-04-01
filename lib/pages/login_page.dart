import 'package:flutter/material.dart';

import 'package:storeRahisi/constants/routes.dart';
import 'package:storeRahisi/constants/ui_helpers.dart';
import 'package:storeRahisi/locator.dart';

import 'package:storeRahisi/pages/base_view.dart';
import 'package:storeRahisi/providers/auth_model.dart';
import 'package:storeRahisi/services/shared_pref_util.dart';
import 'package:storeRahisi/widgets/busy_button.dart';
import 'package:storeRahisi/widgets/input_field.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  TextEditingController emailInputController;
  TextEditingController pwdInputController;
  String errMsg;
  getLastEmail() async {
    emailInputController.text =
        await locator.get<SharedPrefsUtil>().getLastLoginEmail();
  }

  @override
  initState() {
    emailInputController = new TextEditingController();
    pwdInputController = new TextEditingController();
    getLastEmail();
    super.initState();
  }

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
        body: Container(
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
                            color: Theme.of(context).primaryColor,
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
                      validator: pwdValidator,
                    ),
                    verticalSpaceMedium,
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        BusyButton(
                          title: 'Login',
                          busy: model.busy,
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
        ),
      );
    });
  }
}
