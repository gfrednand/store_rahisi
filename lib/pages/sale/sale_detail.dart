import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storeRahisi/app_localizations.dart';
import 'package:storeRahisi/models/index.dart';
import 'package:storeRahisi/providers/index.dart';

class SaleDetail extends StatelessWidget {
  final Sale sale;
  final SaleModel saleModel;

  const SaleDetail({Key key, this.sale, this.saleModel}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    List<String> tabs = [
      AppLocalizations.of(context).translate('details'),
      AppLocalizations.of(context).translate('items')
    ];
    ClientModel clientModel = Provider.of<ClientModel>(context);
    Client client = clientModel.getClientById(sale.clientId);

    if (sale.clientId == Client.defaultCustomer().id) {
      client = Client.defaultCustomer();
    }

    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: sale.saleDate == null
              ? Text(AppLocalizations.of(context).translate('customerDetails'),
                  style: Theme.of(context).textTheme.headline6)
              : Text('${sale.saleDate}',
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.headline6),
          bottom: TabBar(
            isScrollable: false,
            tabs: [
              for (final tab in tabs) Tab(text: tab),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  ListTile(
                    title: Text('${sale.referenceNumber}'),
                    subtitle: Text(AppLocalizations.of(context)
                        .translate('referenceNumber')),
                  ),
                  ListTile(
                    title: Text('${client?.contactPerson}'),
                    subtitle: Text(
                        AppLocalizations.of(context).translate('customer')),
                  ),
                  ListTile(
                    title: Text('${sale.paymentMethod}'),
                    subtitle: Text(AppLocalizations.of(context)
                        .translate('paymentMethod')),
                  ),
                  ListTile(
                    title: Text('${sale.grandTotal}'),
                    subtitle: Text(
                        AppLocalizations.of(context).translate('grandTotal')),
                  ),
                  ListTile(
                    title: Text('${sale.tax}'),
                    subtitle:
                        Text(AppLocalizations.of(context).translate('tax')),
                  ),
                  ListTile(
                    title: Text('${sale.discount}'),
                    subtitle: Text(
                        AppLocalizations.of(context).translate('discount')),
                  ),
                  Divider(
                    thickness: 10.0,
                  ),
                ],
              ),
            ),
            ListView.builder(
                itemCount: sale.items.length,
                itemBuilder: (buildContext, index) {
                  ItemModel itemModel = Provider.of<ItemModel>(context);
                  Item item = itemModel.getItemById(sale.items[index].id);
                  return Column(
                    children: [
                      Divider(height: 5.0),
                      ListTile(
                        leading: ExcludeSemantics(
                          child: CircleAvatar(
                            radius: 25.0,
                            backgroundColor:
                                Theme.of(context).colorScheme.onPrimary,
                            child: Text(
                              item?.name?.substring(0, 2)?.toUpperCase(),
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                        ),
                        title: Text(
                          '${item?.name}',
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppLocalizations.of(context)
                                      .translate('paidAmount') +
                                  ': ${sale.items[index].paidAmount} x ${sale.items[index].quantity} = ${sale.items[index].paidAmount * sale.items[index].quantity}',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                        onTap: () {
                          // Navigator.pushNamed(
                          //     context, AppRoutes.purchase_detail,
                          //     arguments: items[index]);
                        },
                      ),
                    ],
                  );
                }),
          ],
        ),
      ),
    );
  }
}
