import 'package:flutter/material.dart';
import 'package:storeRahisi/constants/routes.dart';
import 'package:storeRahisi/models/user.dart';
import 'package:storeRahisi/providers/auth_model.dart';
import 'package:storeRahisi/widgets/busy_overlay.dart';
import 'package:storeRahisi/widgets/horizontal_line.dart';
import 'package:storeRahisi/widgets/input_field.dart';
import 'package:provider/provider.dart';

class CompanyRegistrationPage extends StatefulWidget {
  final User user;

  CompanyRegistrationPage({Key key, this.user}) : super(key: key);

  @override
  _CompanyRegistrationPageState createState() =>
      _CompanyRegistrationPageState();
}

class _CompanyRegistrationPageState extends State<CompanyRegistrationPage> {
  TextEditingController companyInputController = new TextEditingController();
  TextEditingController newcompanyInputController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    var pageSize = MediaQuery.of(context).size;
    bool busy = context.select((AuthModel model) => model.busy);
    return Scaffold(
      body: SafeArea(
        child: BusyOverlay(
          show: busy,
          child: Container(
            height: pageSize.height,
            width: pageSize.width,
            color: Theme.of(context).colorScheme.primaryVariant,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconButton(
                          tooltip: "Log Out",
                          icon: Icon(Icons.arrow_back),
                          onPressed: () async {
                            bool loggedOut =
                                await context.read<AuthModel>().logout();
                            if (loggedOut) {
                              Navigator.pushReplacementNamed(
                                  context, AppRoutes.login);
                            }
                          }),
                      Spacer(),
                      widget.user.photoUrl == null
                          ? Text(
                              widget.user.fullName,
                              style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary),
                            )
                          : new CircleAvatar(
                              radius: 20.0,
                              backgroundColor: const Color(0xFF778899),
                              backgroundImage:
                                  NetworkImage(widget.user.photoUrl),
                            ),
                      SizedBox(width: 16.0)
                    ],
                  ),
                  Container(
                    padding: new EdgeInsets.only(top: pageSize.width / 2),
                    child: Text(
                      'Finalize Your Registration',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ),
                  Container(
                    padding: new EdgeInsets.all(16.0),
                    child: InputField(
                      placeholder: 'Referal Business Code',
                      controller: companyInputController,
                      icon: Icons.info,
                      onIconPressed: () => showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("Business Code"),
                              content: Text(
                                  "Referal code from Admininistrator of existing Business in Store Rahisi App"),
                              actions: [
                                FlatButton(
                                  child: Text("OK"),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                )
                              ],
                            );
                          }),
                      // validationMessage: '',
                    ),
                  ),
                  RaisedButton(
                    onPressed: () {
                      if (!busy) {
                        context.read<AuthModel>().saveUserCompany(
                            companyName: newcompanyInputController.text);
                        Navigator.of(context).pop();
                      }
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40)),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                      child: Text(
                        'CONTINUE',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  ),
                  HorizontalLine(
                    centerText: "OR",
                  ),
                  FlatButton(
                    child: Text(
                      "Register New Business",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary),
                    ),
                    onPressed: () => showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return Dialog(
                            // backgroundColor: Theme.of(context).colorScheme.primaryVariant,
                            elevation: 16.0,

                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    20.0)), //this right here
                            child: Container(
                              height: 200,
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    InputField(
                                      placeholder: 'Business Name',
                                      controller: newcompanyInputController,
                                      // validationMessage: '',
                                    ),
                                    RaisedButton(
                                      onPressed: () {
                                        if (!busy) {
                                          context
                                              .read<AuthModel>()
                                              .saveUserCompany(
                                                  companyName:
                                                      newcompanyInputController
                                                          .text);
                                          Navigator.of(context).pop();
                                        }
                                      },
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(40)),
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            10, 10, 10, 10),
                                        child: Text(
                                          'REGISTER',
                                          style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
