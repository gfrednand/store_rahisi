// import 'package:flutter/material.dart';
// import 'package:storeRahisi/app_localizations.dart';
// import 'package:storeRahisi/constants/ui_helpers.dart';
// import 'package:storeRahisi/models/purchase.dart';
// import 'package:storeRahisi/pages/base_view.dart';
// import 'package:storeRahisi/providers/purchase_model.dart';
// import 'package:storeRahisi/widgets/busy_button.dart';
// import 'package:storeRahisi/widgets/input_field.dart';

// class PurchaseForm extends StatelessWidget {
//   final Purchase purchase;
//   final clientController = new TextEditingController();
//   final paidAmountController = new TextEditingController();

//   PurchaseForm({
//     Key key,
//     this.purchase,
//   }) : super(key: key);

//   final _formKey = GlobalKey<FormState>();

//   @override
//   Widget build(BuildContext context) {
//     var isEditing = purchase != null;

//     // Build a Form widget using the _formKey created above.
//     return BaseView<PurchaseModel>(
//       onModelReady: (model) {
//         // update the text in the controller
//         clientController.text = purchase?.companyName ?? '';
//         paidAmountController.text = purchase?.paidAmount.toString() ?? '';

//         model.setEdittingPurchase(purchase);
//       },
//       builder: (context, model, child) => Container(
//         padding: const EdgeInsets.all(20.0),
//         child: SingleChildScrollView(
//           child: Form(
//             key: _formKey,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: <Widget>[
//                 InputField(
//                     isReadOnly: model.busy,
//                     placeholder: AppLocalizations.of(context).translate('client') +'*',
//                     controller: clientController,
//                     validator: (value) {
//                       if (value.isEmpty) {
//                         return "Please enter a valid client.";
//                       }
//                       return null;
//                     }),
//                 InputField(
//                     isReadOnly: model.busy,
//                     placeholder: AppLocalizations.of(context).translate('paidAmount') +'*',
//                     controller: paidAmountController,
//                     validator: (value) {
//                       if (value.isEmpty) {
//                         return "Please enter a valid Paid Amount.";
//                       }
//                       return null;
//                     }),
//                 verticalSpaceSmall,
//                 // ExpansionList<String>(
//                 //     isReadOnly: model.busy,
//                 //     purchases: [
//                 //       'Beer',
//                 //       'Cider',
//                 //       'Spirits',
//                 //       'Wine',
//                 //       'Bottled Water',
//                 //       'Soft Drinks',
//                 //       'Juice',
//                 //       'Energy Drinks',
//                 //       'Hot Drinks'
//                 //     ],
//                 //     title: isEditing ? purchase.category : model.selectedCategory,
//                 //     onpurchaseSelected: model.setSelectedCategory),

//                 Center(
//                   child: BusyButton(
//                     title: AppLocalizations.of(context).translate('submit') ,
//                     busy: model.busy,
//                     onPressed: () async {
//                       if (_formKey.currentState.validate()) {
//                         // If the form is valid, display a Snackbar.

//                         model.savePurchase(
//                             data: Purchase(
//                           id: purchase?.id ?? '',
//                           clientId: clientController.text,
//                           paidAmount: double.parse(paidAmountController.text),
//                           updatedAt: isEditing? new DateTime.now(): null,
//                           userId: null,
//                         ));
//                       }
//                     },
//                   ),
//                 ),

//                 SizedBox(
//                   width: double.infinity,
//                   child: FlatButton(
//                       child: Text(AppLocalizations.of(context).translate('cancel'),style: TextStyle(color: Colors.grey[800]),),
//                       onPressed: () {
//                         Navigator.pop(context);
//                       }),
//                 ),
//                 // Padding(
//                 //     padding: EdgeInsets.only(
//                 //         bottom: MediaQuery.of(context).viewInsets.bottom)),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
