import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:storeRahisi/app_localizations.dart';
import 'package:storeRahisi/constants/routes.dart';
import 'package:storeRahisi/constants/ui_helpers.dart';
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
            ? model.purchases.length == 0
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

                      List<Payment> payments =
                          paymentModel.getPaymentsByReferenceNo(
                              model.purchases[index].referenceNumber);
                      double paidAmount = 0.0;
                      payments.forEach((payment) {
                        paidAmount = paidAmount + payment.amount;
                      });
                      model.purchases[index].paidAmount = paidAmount;
                      var purchaseDate = new DateFormat('MMM dd, yyyy')
                          .format(model.purchases[index].purchaseDate);
                      return Column(
                        children: [
                          Divider(
                            height: 5.0,
                          ),
                          Container(
                            color: selectedIndex != null &&
                                    selectedIndex == index &&
                                    isLargeScreen
                                ? Colors.red[50]
                                : Theme.of(context).colorScheme.primaryVariant,
                            child: ListTile(
                              leading: ExcludeSemantics(
                                child: CircleAvatar(
                                  radius: 25.0,
                                  backgroundColor:
                                      Theme.of(context).colorScheme.onPrimary,
                                  child: Text(
                                    'P',
                                    style: TextStyle(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                ),
                              ),
                              title: Text(
                                '$purchaseDate',
                                style: Theme.of(context).textTheme.bodyText1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    AppLocalizations.of(context)
                                            .translate('billNo') +
                                        ': ${model.purchases[index]?.referenceNumber}',
                                    style:
                                        Theme.of(context).textTheme.subtitle2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    AppLocalizations.of(context)
                                            .translate('supplier') +
                                        ': ${model.purchases[index]?.companyName}',
                                    style:
                                        Theme.of(context).textTheme.subtitle2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    AppLocalizations.of(context)
                                            .translate('grandTotal') +
                                        ': ${model.purchases[index]?.grandTotalAmount?.toString()?.replaceAllMapped(reg, mathFunc)}/=',
                                    style:
                                        Theme.of(context).textTheme.subtitle2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                              trailing: Icon(
                                Icons.arrow_forward_ios,
                                color: Theme.of(context).iconTheme.color,
                              ),
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
                        ],
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
