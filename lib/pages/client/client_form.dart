import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:storeRahisi/app_localizations.dart';
import 'package:storeRahisi/constants/app_constants.dart';
import 'package:storeRahisi/models/client.dart';
import 'package:storeRahisi/providers/client_model.dart';
import 'package:storeRahisi/pages/base_view.dart';
import 'package:storeRahisi/widgets/toast.dart';

class ClientForm extends StatefulWidget {
  final String clientType;
  final Client client;
  final String title;
  ClientForm({
    Key key,
    this.client,
    this.clientType,
    this.title,
  }) : super(key: key);

  @override
  _ClientFormState createState() => _ClientFormState();
}

class _ClientFormState extends State<ClientForm> {
  TextEditingController nameController = new TextEditingController();

  TextEditingController contactPersonController = new TextEditingController();

  TextEditingController phoneNumberController = new TextEditingController();

  TextEditingController emailController = new TextEditingController();

  TextEditingController addressController = new TextEditingController();

  TextEditingController descriptionController = new TextEditingController();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var isEditing = widget.client != null;
    // Build a Form widget using the _formKey created above.
    return BaseView<ClientModel>(onModelReady: (model) {
      // update the text in the controller
      if (isEditing) {
        nameController.text = widget.client?.companyName ?? '';
        descriptionController.text = widget.client?.description ?? '';
        contactPersonController.text = widget.client?.contactPerson ?? '';
        phoneNumberController.text = widget.client?.phoneNumber ?? '';
        emailController.text = widget.client?.email ?? '';
        addressController.text = widget.client?.address ?? '';
        model.setEdittingclient(widget.client);
      }
    }, builder: (context, model, child) {
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title:
              Text(widget.title, style: Theme.of(context).textTheme.headline6),
          // actions: <Widget>[
          //   new IconButton(icon: const Icon(Icons.save), onPressed: () {})
          // ],
        ),
        body: Container(
          padding: const EdgeInsets.all(20.0),
          child: model.busy
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
                              labelText: AppLocalizations.of(context)
                                      .translate('contactPerson') +
                                  '*',
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
                              labelText: AppLocalizations.of(context)
                                      .translate('phoneNumber') +
                                  '*',
                              hintText: "07XXXXXXXX"),
                          controller: phoneNumberController,
                          keyboardType: TextInputType.phone,
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Please enter a valid phone number.";
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                              labelText: AppLocalizations.of(context)
                                  .translate('companyName'),
                              hintText: "Store"),
                          controller: nameController,
                          validator: (value) {
                            if (value.isEmpty && widget.clientType == AppConstants.clientTypeSupplier) {
                              return "Please enter a valid Company name.";
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                              labelText: AppLocalizations.of(context)
                                  .translate('email'),
                              hintText: "john@email.com"),
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          // validator: (value) {
                          //   if (value.isEmpty || !value.contains('@')) {
                          //     return 'Please enter valid email';
                          //   }
                          // },
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                              labelText: AppLocalizations.of(context)
                                  .translate('address'),
                              hintText: "P.O.Box 000, Dar, Tabata"),
                          controller: addressController,
                          validator: (value) {
                            return null;
                          },
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                              labelText: AppLocalizations.of(context)
                                  .translate('description'),
                              hintText: ""),
                          controller: descriptionController,
                          validator: (value) {
                            return null;
                          },
                        ),
                        model.busy
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
                                    Client client = Client(
                                        id: widget.client?.id ?? '',
                                        proviousDue: 0,
                                        clientType: isEditing
                                            ? widget.client?.clientType
                                            : widget.clientType,
                                        address: addressController.text,
                                        contactPerson:
                                            contactPersonController.text,
                                        description: descriptionController.text,
                                        email: emailController.text,
                                        companyName: nameController.text,
                                        updatedAt: isEditing
                                            ? new DateFormat(
                                                    'MMM dd, yyyy HH:mm')
                                                .format(new DateTime.now())
                                            : null,
                                        phoneNumber:
                                            phoneNumberController.text);
                                    model.addClient(client).then((success) =>
                                        success
                                            ? Toast.show(
                                                message: isEditing
                                                    ? widget.client.clientType +
                                                        'Edited Successful'
                                                    : widget.clientType +
                                                        'Added Successful',
                                                context: context)
                                            : null);
                                  }
                                },
                                child: SizedBox(
                                    width: double.infinity,
                                    child: Text(
                                      AppLocalizations.of(context)
                                          .translate('submit'),
                                      textAlign: TextAlign.center,
                                    )),
                              ),
                        // SizedBox(
                        //   width: double.infinity,
                        //   child: FlatButton(
                        //       child: Text(
                        //         AppLocalizations.of(context)
                        //             .translate('cancel'),
                        //         style: TextStyle(color: Colors.grey[800]),
                        //       ),
                        //       onPressed: () {
                        //         Navigator.pop(context);
                        //       }),
                        // ),
                        // Padding(
                        //     padding: EdgeInsets.only(
                        //         bottom: MediaQuery.of(context).viewInsets.bottom)),
                      ],
                    ),
                  ),
                ),
        ),
      );
    });
  }
}
