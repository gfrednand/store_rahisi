import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storeRahisi/models/supplier.dart';
import 'package:storeRahisi/providers/supplier_model.dart';
import 'package:storeRahisi/widgets/toast.dart';
import 'package:storeRahisi/pages/base_view.dart';
class SupplierForm extends StatefulWidget {
  const SupplierForm({
    Key key,
  }) : super(key: key);

  @override
  _SupplierFormState createState() => _SupplierFormState();
}

class _SupplierFormState extends State<SupplierForm> {
  TextEditingController nameController;
  TextEditingController contactPersonController;
  TextEditingController phoneNumberController;
  TextEditingController emailController;
  TextEditingController addressController;
  TextEditingController descriptionController;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    nameController = new TextEditingController();
    contactPersonController = new TextEditingController();
    phoneNumberController = new TextEditingController();
    emailController = new TextEditingController();
    addressController = new TextEditingController();
    descriptionController = new TextEditingController();
    super.initState();
  }

  void _showToast(String message, Color backGroundColor, IconData icon) {
    Toast.show(
      message: message,
      context: context,
      icon: Icon(icon, color: Colors.white),
      backgroundColor: backGroundColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    SupplierModel supplierModel = Provider.of<SupplierModel>(context);

    // Build a Form widget using the _formKey created above.
    return BaseView<SupplierModel>(
        // onModelReady: (model) => model.listenToSuppliers(),
        builder: (context, model, child) {
          return Container(
            padding: const EdgeInsets.all(20.0),
            child: supplierModel.busy
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          TextFormField(
                            decoration: InputDecoration(
                                labelText: 'Supplier Name*',
                                hintText: "John Store"),
                            controller: nameController,
                            validator: (value) {
                              if (value.isEmpty) {
                                return "Please enter a valid supplier name.";
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                                labelText: 'Contact Person*',
                                hintText: "John Doe"),
                            controller: contactPersonController,
                            validator: (value) {
                              if (value.isEmpty) {
                                return "Please enter a valid contact person";
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                                labelText: 'Phone Number*',
                                hintText: "07XXXXXXXX"),
                            controller: phoneNumberController,
                            keyboardType: TextInputType.numberWithOptions(),
                            validator: (value) {
                              if (value.isEmpty) {
                                return "Please enter a valid phone number.";
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                                labelText: 'Email', hintText: "john@email.com"),
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              return null;
                            },
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                                labelText: 'Address',
                                hintText: "P.O.Box 000, Dar, Tabata"),
                            controller: addressController,
                            validator: (value) {
                              return null;
                            },
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                                labelText: 'Description', hintText: ""),
                            controller: descriptionController,
                            validator: (value) {
                              return null;
                            },
                          ),
                          supplierModel.busy
                              ? Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                )
                              : RaisedButton(
                                  onPressed: () {
                                    // Validate returns true if the form is valid, or false
                                    // otherwise.
                                    if (_formKey.currentState.validate()) {
                                      // If the form is valid, display a Snackbar.
                                      Supplier supplier = Supplier(
                                          address: addressController.text,
                                          contactPerson:
                                              contactPersonController.text,
                                          description:
                                              descriptionController.text,
                                          email: emailController.text,
                                          name: nameController.text,
                                          phoneNumber:
                                              phoneNumberController.text);
                                      supplierModel.addSupplier(supplier);
                               
                                    }
                                  },
                                  child: SizedBox(
                                      width: double.infinity,
                                      child: Text(
                                        'Submit',
                                        textAlign: TextAlign.center,
                                      )),
                                ),
                          SizedBox(
                            width: double.infinity,
                            child: FlatButton(
                                child: Text('Cancel'),
                                onPressed: () {
                                  Navigator.pop(context);
                                }),
                          ),
                          // Padding(
                          //     padding: EdgeInsets.only(
                          //         bottom: MediaQuery.of(context).viewInsets.bottom)),
                        ],
                      ),
                    ),
                  ),
          );
        });
  }
}
