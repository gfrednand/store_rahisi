import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storeRahisi/constants/routes.dart';
import 'package:storeRahisi/models/index.dart';
import 'package:storeRahisi/pages/base_view.dart';
import 'package:storeRahisi/providers/payment_model.dart';
import 'package:storeRahisi/providers/purchase_model.dart';
import 'package:storeRahisi/providers/client_model.dart';

class PurchaseList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ClientModel clientModel = Provider.of<ClientModel>(context);
    PaymentModel paymentModel = Provider.of<PaymentModel>(context);
    return BaseView<PurchaseModel>(
      onModelReady: (model) => model.listenToPurchases(),
      builder: (context, model, child) {
        return Scrollbar(
            child: !model.busy
                ? model.purchases == null
                    ? Center(
                        child: Text('Nothing Found'),
                      )
                    : ListView.builder(
                        itemCount: model.purchases.length,
                        itemBuilder: (buildContext, index) {
                          Client client = clientModel.getClientById(
                              model.purchases[index].clientId);
                          model.purchases[index].companyName = client?.companyName;

                          List<Payment> payments =
                              paymentModel.getPaymentsByPurchaseId(
                                  model.purchases[index].id);
                          double paidAmount = 0.0;
                          payments.forEach((payment) {
                            paidAmount = paidAmount + payment.amount;
                          });
                          model.purchases[index].paidAmount = paidAmount;
                          return Card(
                            child: ListTile(
                              leading: ExcludeSemantics(
                                child: CircleAvatar(
                                  radius: 30.0,
                                  backgroundColor:
                                      Theme.of(context).primaryColor,
                                  child: Text(
                                    'P',
                                    style: TextStyle(
                                        color: Theme.of(context).accentColor),
                                  ),
                                ),
                              ),
                              title: Text(
                                '${model.purchases[index].purchaseDate}',
                                overflow: TextOverflow.ellipsis,
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Bill No: ${model.purchases[index]?.referenceNumber}',
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    'Supplier: ${model.purchases[index]?.companyName}',
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    'Paid: ${model.purchases[index]?.paidAmount}/=',
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                              trailing: Text(
                                  '${model.purchases[index].grandTotalAmount}/='),
                              onTap: () {
                                var arguments = {
                                  'purchase': model.purchases[index],
                                  'purchaseModel': model,
                                };
                                Navigator.pushNamed(
                                    context, AppRoutes.purchase_detail,
                                    arguments: arguments);
                              },
                            ),
                          );
                        })
                : Center(
                    child: CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation(Theme.of(context).accentColor),
                    ),
                  ));
      },
    );
  }
}
