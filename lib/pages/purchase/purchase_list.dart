import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:storeRahisi/app_localizations.dart';
import 'package:storeRahisi/constants/routes.dart';
import 'package:storeRahisi/models/index.dart';
import 'package:storeRahisi/pages/base_view.dart';
import 'package:storeRahisi/pages/purchase/purchase_detail_widget.dart';
import 'package:storeRahisi/providers/payment_model.dart';
import 'package:storeRahisi/providers/purchase_model.dart';
import 'package:storeRahisi/providers/client_model.dart';

class PurchaseList extends StatefulWidget {
  @override
  _PurchaseListState createState() => _PurchaseListState();
}

class _PurchaseListState extends State<PurchaseList> {
  Purchase selectedValue;
  int selectedIndex;
  bool isLargeScreen = false;
  @override
  Widget build(BuildContext context) {
    ClientModel clientModel = Provider.of<ClientModel>(context);
    PaymentModel paymentModel = Provider.of<PaymentModel>(context);
    return BaseView<PurchaseModel>(
      onModelReady: (model) => model.listenToPurchases(),
      builder: (context, model, child) {
        return OrientationBuilder(builder: (context, orientation) {
          if (MediaQuery.of(context).size.width > 600) {
            isLargeScreen = true;
          } else {
            isLargeScreen = false;
          }

          return Row(children: <Widget>[
            Expanded(
              flex: 2,
              child: buildScrollbar(model, context, clientModel, paymentModel),
            ),
            isLargeScreen
                ? Expanded(
                    flex: 3,
                    child: PurchaseDetailWidget(
                      purchase: selectedValue,
                      purchaseModel: model,
                    ))
                : Container(),
          ]);
        });
      },
    );
  }

  Scrollbar buildScrollbar(PurchaseModel model, BuildContext context,
      ClientModel clientModel, PaymentModel paymentModel) {
    return Scrollbar(
        child: !model.busy
            ? model.purchases == null
                ? Center(
                    child: Text(
                        AppLocalizations.of(context).translate('nothingFound')),
                  )
                : ListView.builder(
                    itemCount: model.purchases.length,
                    itemBuilder: (buildContext, index) {
                      Client client = clientModel
                          .getClientById(model.purchases[index].clientId);
                      model.purchases[index].companyName = client?.companyName;

                      List<Payment> payments = paymentModel
                          .getPaymentsByPurchaseId(model.purchases[index].id);
                      double paidAmount = 0.0;
                      payments.forEach((payment) {
                        paidAmount = paidAmount + payment.amount;
                      });
                      model.purchases[index].paidAmount = paidAmount;
                      var purchaseDate = new DateFormat('MMM dd, yyyy')
                          .format(model.purchases[index].purchaseDate);
                      return Card(
                        elevation: selectedIndex != null &&
                                selectedIndex == index &&
                                isLargeScreen
                            ? 10
                            : 2,
                        child: Container(
                          color: selectedIndex != null &&
                                  selectedIndex == index &&
                                  isLargeScreen
                              ? Colors.red[50]
                              : Colors.white,
                          child: ListTile(
                            leading: ExcludeSemantics(
                              child: CircleAvatar(
                                radius: 30.0,
                                backgroundColor: Theme.of(context).primaryColor,
                                child: Text(
                                  'P',
                                  style: TextStyle(
                                      color: Theme.of(context).accentColor),
                                ),
                              ),
                            ),
                            title: Text(
                              '$purchaseDate',
                              overflow: TextOverflow.ellipsis,
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppLocalizations.of(context)
                                          .translate('billNo') +
                                      ': ${model.purchases[index]?.referenceNumber}',
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  AppLocalizations.of(context)
                                          .translate('supplier') +
                                      ': ${model.purchases[index]?.companyName}',
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  AppLocalizations.of(context)
                                          .translate('paid') +
                                      ': ${model.purchases[index]?.paidAmount}/=',
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                            trailing: Text(
                                '${model.purchases[index].grandTotalAmount}/='),
                            onTap: () {
                              if (isLargeScreen) {
                                selectedValue = model.purchases[index];
                                setState(() {
                                  selectedIndex = index;
                                });
                              } else {
                                var arguments = {
                                  'purchase': model.purchases[index],
                                  'purchaseModel': model,
                                };
                                Navigator.pushNamed(
                                    context, AppRoutes.purchase_detail,
                                    arguments: arguments);
                              }
                            },
                          ),
                        ),
                      );
                    })
            : Center(
                child: CircularProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation(Theme.of(context).accentColor),
                ),
              ));
  }
}
