import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storeRahisi/app_localizations.dart';
import 'package:storeRahisi/constants/routes.dart';
import 'package:storeRahisi/models/client.dart';
import 'package:storeRahisi/models/index.dart';
import 'package:storeRahisi/pages/client/client_form.dart';
import 'package:storeRahisi/pages/purchase/payment_form.dart';
import 'package:storeRahisi/providers/client_model.dart';
import 'package:storeRahisi/providers/index.dart';
import 'package:storeRahisi/widgets/custom_modal_sheet.dart';

class ClientDetailWidget extends StatefulWidget {
  final Client client;
  final ClientModel clientModel;

  const ClientDetailWidget({Key key, this.client, this.clientModel})
      : super(key: key);
  @override
  _ClientDetailWidgetState createState() => _ClientDetailWidgetState();
}

class _ClientDetailWidgetState extends State<ClientDetailWidget>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 3);
  }

  @override
  Widget build(BuildContext context) {
    PurchaseModel purchaseModel = Provider.of<PurchaseModel>(context);
    List<Purchase> purchases = widget.client == null
        ? []
        : purchaseModel.getPurchaseHistoryByClientId(widget.client.id);
    SaleModel saleModel = Provider.of<SaleModel>(context);
    List<Sale> sales = widget.client == null
        ? []
        : saleModel.getSaleHistoryByClientId(widget.client.id);
    List<String> tabs = [
      AppLocalizations.of(context).translate('details'),
      AppLocalizations.of(context).translate('paymentHistory'),
      AppLocalizations.of(context).translate('makePayment')
    ];

    PaymentModel paymentModel = Provider.of<PaymentModel>(context);
    List<Payment> payments =
        paymentModel.getPaymentsByClientId(widget.client.id);
    return widget.client == null
        ? Center(
            child: Text('Client Details'),
          )
        : Column(children: [
            TabBar(
              controller: _tabController,
              isScrollable: true,

              // indicator: CircleTabIndicator(
              //     color: Theme.of(context).accentColor, radius: 3),
              tabs: [
                for (final tab in tabs) Tab(text: tab),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        Wrap(
                          spacing: 0.0, // gap between adjacent chips
                          runSpacing: 0.0, // gap between lines
                          children: <Widget>[
                            chipDesign(
                                AppLocalizations.of(context).translate('edit'),
                                Color(0xFF4db6ac)),
                            purchases.length == 0 && sales.length == 0
                                ? chipDesign(
                                    AppLocalizations.of(context)
                                        .translate('delete'),
                                    Color(0xFFf06292))
                                : Container(),
                          ],
                        ),
                        Divider(
                          thickness: 10.0,
                        ),
                        widget.client.companyName == ''
                            ? Container()
                            : ListTile(
                                title: Text(
                                  '${widget.client.companyName}',
                                  style: Theme.of(context).textTheme.headline6,
                                ),
                                subtitle: Text(
                                  AppLocalizations.of(context)
                                      .translate('companyName'),
                                  style: Theme.of(context).textTheme.subtitle2,
                                ),
                              ),
                        ListTile(
                          title: Text(
                            '${widget.client.contactPerson}',
                            style: Theme.of(context).textTheme.headline6,
                          ),
                          subtitle: Text(
                            AppLocalizations.of(context)
                                .translate('contactPerson'),
                            style: Theme.of(context).textTheme.subtitle2,
                          ),
                        ),
                        Divider(
                          thickness: 10.0,
                        ),
                        ListTile(
                          title: Text(
                            '${widget.client.phoneNumber}',
                            style: Theme.of(context).textTheme.headline6,
                          ),
                          subtitle: Text(
                            AppLocalizations.of(context)
                                .translate('phoneNumber'),
                            style: Theme.of(context).textTheme.subtitle2,
                          ),
                        ),
                        ListTile(
                          title: Text(
                            '${widget.client.email}',
                            style: Theme.of(context).textTheme.headline6,
                          ),
                          subtitle: Text(
                            AppLocalizations.of(context).translate('email'),
                            style: Theme.of(context).textTheme.subtitle2,
                          ),
                        ),
                        ListTile(
                          title: Text(
                            '${widget.client.address}',
                            style: Theme.of(context).textTheme.headline6,
                          ),
                          subtitle: Text(
                            AppLocalizations.of(context).translate('address'),
                            style: Theme.of(context).textTheme.subtitle2,
                          ),
                        ),
                        ListTile(
                          title: Text(
                            '${widget.client.description}',
                            style: Theme.of(context).textTheme.headline6,
                          ),
                          subtitle: Text(
                            AppLocalizations.of(context).translate('notes'),
                            style: Theme.of(context).textTheme.subtitle2,
                          ),
                        ),
                        Divider(
                          thickness: 10.0,
                        ),
                      ],
                    ),
                  ),
                  ListView.builder(
                      itemCount: payments.length,
                      itemBuilder: (buildContext, index) {
                        return Column(
                          children: [
                            Divider(
                              height: 5.0,
                            ),
                            ListTile(
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
                                '${payments[index]?.method} | ${payments[index]?.type}',
                                style: Theme.of(context).textTheme.headline6,
                                overflow: TextOverflow.ellipsis,
                              ),
                              trailing: Text(
                                ' ${payments[index]?.amount} /=',
                                style: Theme.of(context).textTheme.subtitle2,
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

                      // TODO: Add ref number for sale
                  widget.client.proviousDue > 0
                      ? PaymentForm(
                          dueAmount: widget.client.proviousDue,
                          referenceNo: 'SaleRef',
                          clientId: widget.client.id,
                          tabController: _tabController,
                        )
                      : Container(
                          child: Center(
                            child: Text('No Due'),
                          ),
                        ),
                ],
              ),
            )
          ]);
  }

  Widget chipDesign(String label, Color color) {
    return GestureDetector(
      onTap: () {
        label == AppLocalizations.of(context).translate('delete')
            ? widget.clientModel.removeClient(widget.client.id)
            : label == AppLocalizations.of(context).translate('edit')
                ? Navigator.pushNamed(context, AppRoutes.client_form,
                    arguments: {
                        'title': AppLocalizations.of(context).translate('edit'),
                        'client': widget.client
                      })
                : Container();
      },
      child: Container(
        child: Chip(
          label: Text(
            label,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          backgroundColor: color,
          elevation: 4,
          shadowColor: Colors.grey[50],
          padding: EdgeInsets.all(4),
        ),
        margin: EdgeInsets.only(left: 12, right: 12, top: 2, bottom: 2),
      ),
    );
  }
}
