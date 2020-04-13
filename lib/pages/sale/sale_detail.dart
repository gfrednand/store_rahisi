import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storeRahisi/models/index.dart';
import 'package:storeRahisi/providers/index.dart';

class SaleDetail extends StatelessWidget {
  final Sale sale;
  final SaleModel saleModel;

  const SaleDetail({Key key, this.sale, this.saleModel}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    List<String> tabs = ['Details', 'Items'];
ClientModel clientModel = Provider.of<ClientModel>(context);
        Client client = clientModel.getClientById(
                              sale.clientId);
                        
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: sale.saleDate == null
              ? Text('Client Details')
              : Text(
                  '${sale.saleDate}',
                  overflow: TextOverflow.ellipsis,
                ),
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
                    subtitle: Text(' Reference Number'),
                  ),
                  ListTile(
                    title: Text('${client?.companyName}'),
                    subtitle: Text(' Customer'),
                  ),
                  ListTile(
                    title: Text('${sale.paymentMethod}'),
                    subtitle: Text(' Payment Method'),
                  ),
                  ListTile(
                    title: Text('${sale.grandTotal}'),
                    subtitle: Text(' Grand Total'),
                  ),
                  ListTile(
                    title: Text('${sale.tax}'),
                    subtitle: Text(' Tax'),
                  ),
                  ListTile(
                    title: Text('${sale.discount}'),
                    subtitle: Text(' Discount'),
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
                  Item item =
                      itemModel.getItemById(sale.items[index].id);
                  return Card(
                    child: ListTile(
                      leading: ExcludeSemantics(
                        child: CircleAvatar(
                          radius: 30.0,
                          backgroundColor: Theme.of(context).primaryColor,
                          child: Text(
                            item?.name?.substring(0, 2)?.toUpperCase(),
                            style:
                                TextStyle(color: Theme.of(context).accentColor),
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
                            'Paid Amount: ${sale.items[index].paidAmount} @1',
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                      trailing:
                          Text('${sale.items[index].quantity}'),
                      onTap: () {
                        // Navigator.pushNamed(
                        //     context, AppRoutes.purchase_detail,
                        //     arguments: items[index]);
                      },
                    ),
                  );
                }),
          ],
        ),
      ),
    );
  }
}
