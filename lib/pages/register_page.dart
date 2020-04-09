import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:storeRahisi/constants/routes.dart';
import 'package:storeRahisi/constants/ui_helpers.dart';
import 'package:storeRahisi/pages/base_view.dart';
import 'package:storeRahisi/providers/auth_model.dart';
import 'package:storeRahisi/widgets/busy_button.dart';
import 'package:storeRahisi/widgets/expansion_list.dart';
import 'package:storeRahisi/widgets/input_field.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({Key key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> _registerFormKey = GlobalKey<FormState>();
  TextEditingController firstNameInputController;
  TextEditingController lastNameInputController;
  TextEditingController emailInputController;
  TextEditingController pwdInputController;
  TextEditingController confirmPwdInputController;
  TextEditingController phoneNumberInputController;

  @override
  initState() {
    firstNameInputController = new TextEditingController();
    lastNameInputController = new TextEditingController();
    emailInputController = new TextEditingController();
    pwdInputController = new TextEditingController();
    confirmPwdInputController = new TextEditingController();
    phoneNumberInputController = new TextEditingController();

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
    return BaseView<AuthModel>(
        // onModelReady: (model) => model.getUserDetails(),
        builder: (context, model, child) {
      if (!model.busy) {}
      return Scaffold(
        appBar: AppBar(
          title: Text("Register"),
        ),
        body: Container(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Form(
              key: _registerFormKey,
              child: Column(
                children: <Widget>[
                  InputField(
                      placeholder: 'First Name',
                      controller: firstNameInputController,
                   ),
                  verticalSpaceSmall,
                  InputField(
                    placeholder: 'Last Name',
                    controller: lastNameInputController,
                  ),
                  verticalSpaceSmall,
                  InputField(
                      placeholder: 'Email',
                      controller: emailInputController,
               
                      textInputType: TextInputType.emailAddress),
                  verticalSpaceSmall,
                  InputField(
                    placeholder: 'Phone Number',
                    controller: phoneNumberInputController,
                  ),
                  verticalSpaceSmall,
                  ExpansionList<String>(
                      items: ['Admin', 'Cashier', 'User'],
                      title: model.selectedRole,
                      onItemSelected: model.setSelectedRole),
                  verticalSpaceSmall,
                  InputField(
                    placeholder: 'Password',
                    controller: pwdInputController,
                 
                    additionalNote:
                        'Password has to be a minimum of 8 characters.',
                    password: true,
                  ),
                  verticalSpaceSmall,
                  InputField(
                    placeholder: 'Confirm Password',
                    controller: confirmPwdInputController,
             
                    password: true,
                  ),
                  verticalSpaceSmall,

                  BusyButton(
                    title: 'Register',
                    busy: model.busy,
                    onPressed: () {
                      if (_registerFormKey.currentState.validate()) {
                        if (pwdInputController.text ==
                            confirmPwdInputController.text) {
                          model.signUp(
                            password: pwdInputController.text,
                            fname: firstNameInputController.text,
                            lname: lastNameInputController.text,
                            email: emailInputController.text,
                            phoneNumber: phoneNumberInputController.text,
                            companyId: '1',
                          );
                        } else {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text("Error"),
                                  content: Text("The passwords do not match"),
                                  actions: <Widget>[
                                    FlatButton(
                                      child: Text("Close"),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    )
                                  ],
                                );
                              });
                        }
                      }
                    },
                  ),

                  Text("Already have an account?"),
                  FlatButton(
                    child: Text("Login here!"),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
