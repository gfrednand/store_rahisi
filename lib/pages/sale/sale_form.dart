import 'package:flutter/material.dart';

class SaleForm {

  getForm(_registerFormKey, context, firstNameInputController) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      child: SingleChildScrollView(
        child: Form(
          key: _registerFormKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration:
                    InputDecoration(labelText: 'First Name*', hintText: "John"),
                controller: firstNameInputController,
                validator: (value) {
                  if (value.length < 3) {
                    return "Please enter a valid first name.";
                  }
                },
              ),
          
              // FormField<String>(
              //   builder: (FormFieldState<String> state) {
              //     return InputDecorator(
              //       decoration: InputDecoration(
              //         // labelStyle: textStyle,
              //         errorStyle:
              //             TextStyle(color: Colors.redAccent, fontSize: 16.0),
              //         //   border: OutlineInputBorder(
              //         //       borderRadius: BorderRadius.circular(5.0)),
              //       ),
              //       isEmpty: _designation == null,
              //       child: DropdownButtonHideUnderline(
              //         child: DropdownButton<String>(
              //           value: _designation,
              //           isDense: true,
              //           hint: Text(
              //             "Select Designation",
              //           ),
              //           onChanged: (String newValue) {
              //             setState(() {
              //               _designation = newValue;
              //               state.didChange(newValue);
              //             });
              //           },
              //           items: [
              //             DropdownMenuItem(
              //               value: "ADMIN",
              //               child: Text(
              //                 "ADMIN",
              //               ),
              //             ),
              //             DropdownMenuItem(
              //               value: "CASHIER",
              //               child: Text(
              //                 "CASHIER",
              //               ),
              //             ),
              //           ],
              //         ),
              //       ),
              //     );
              //   },
              // ),
           
              RaisedButton(
                child: Text("Save"),
                color: Theme.of(context).primaryColor,
                textColor: Colors.white,
                onPressed: () {
                  // if (_registerFormKey.currentState.validate()) {
                    // if (pwdInputController.text ==
                    //     confirmPwdInputController.text) {
                      // FirebaseAuth.instance
                      //     .createUserWithEmailAndPassword(
                      //         email: emailInputController.text,
                      //         password: pwdInputController.text)
                      //     .then((currentUser) => Firestore.instance
                      //         .collection("users")
                      //         .document(currentUser.user.uid)
                      //         .setData({
                      //           "uid": currentUser.user.uid,
                      //           "fname": firstNameInputController.text,
                      //           "lname": lastNameInputController.text,
                      //           "email": emailInputController.text,
                      //           "phoneNumber": phoneNumberInputController.text,
                      //           "designation": _designation,
                      //           "companyId": 1,
                      //         })
                      //         .then((result) => {
                      //               Navigator.pushNamedAndRemoveUntil(
                      //                   context, AppRoutes.home, (_) => false),
                      //               firstNameInputController.clear(),
                      //               lastNameInputController.clear(),
                      //               emailInputController.clear(),
                      //               pwdInputController.clear(),
                      //               confirmPwdInputController.clear(),
                      //               phoneNumberInputController.clear(),
                      //             })
                      //         .catchError((err) => print(err)))
                      //     .catchError((err) => print(err));
                  //   } else {
                  //     showDialog(
                  //         context: context,
                  //         builder: (BuildContext context) {
                  //           return AlertDialog(
                  //             title: Text("Error"),
                  //             content: Text("The passwords do not match"),
                  //             actions: <Widget>[
                  //               FlatButton(
                  //                 child: Text("Close"),
                  //                 onPressed: () {
                  //                   Navigator.of(context).pop();
                  //                 },
                  //               )
                  //             ],
                  //           );
                  //         });
                  //   }
                  // }
                },
              ),
              // Text("Already have an account?"),
              // FlatButton(
              //   child: Text("Login here!"),
              //   onPressed: () {
              //     Navigator.pop(context);
              //   },
              // )
            ],
          ),
        ),
      ),
    );
  }
}
