import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storeRahisi/app_localizations.dart';
import 'package:storeRahisi/constants/app_constants.dart';
import 'package:storeRahisi/constants/routes.dart';
import 'package:storeRahisi/constants/ui_helpers.dart';
import 'package:storeRahisi/pages/base_view.dart';
import 'package:storeRahisi/models/index.dart';
import 'package:storeRahisi/providers/index.dart';
import 'package:storeRahisi/widgets/toast.dart';

class PurchaseAdd extends StatefulWidget {
  final String title;
  final Purchase purchase;

  const PurchaseAdd({Key key, this.title, this.purchase}) : super(key: key);

  @override
  _PurchaseAddState createState() => _PurchaseAddState();
}

class _PurchaseAddState extends State<PurchaseAdd> {
  Client _client;
  bool isEditing = false;
  @override
  Widget build(BuildContext context) {
    ItemModel itemModel = Provider.of<ItemModel>(context);
    isEditing = widget.purchase != null;
    return BaseView<PurchaseModel>(
        // onModelReady: (model) => model.getclients(),
        builder: (context, model, child) {
      return Scaffold(
        appBar: buildAppBar(model, context),
        body: buildBody(model, context),
        floatingActionButton: _client == null || model.busy
            ? Container()
            : FloatingActionButton.extended(
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.item_purchase_form,
                      arguments: {
                        'title':
                            AppLocalizations.of(context).translate('addItem'),
                        'purchaseModel': model,
                        'items': itemModel.items ?? []
                      });
                },
                foregroundColor: Colors.white,
                label: Text(AppLocalizations.of(context).translate('addItem')),
                icon: Icon(Icons.add),
                backgroundColor: Theme.of(context).accentColor,
              ),
      );
    });
  }

  Column buildBody(PurchaseModel model, BuildContext context) {
    var items = model.selectedItems;
    ClientModel clientModel = Provider.of<ClientModel>(context);
    List<Client> clients =
        clientModel.getByClientType(AppConstants.clientTypeSupplier);
    if (isEditing) {
      _client = clientModel.getClientById(widget.purchase.clientId);
    }
    return Column(
      children: <Widget>[
        Center(
          child: Container(
            padding: EdgeInsets.all(8.0),
            width: double.infinity,
            child: DropdownButtonHideUnderline(
              child: new DropdownButton<Client>(
                hint: Text(
                    AppLocalizations.of(context).translate('selectSupplier')),
                value: _client,
                items: clients.map((Client value) {
                  return new DropdownMenuItem<Client>(
                    value: value,
                    child: new Text(value.companyName),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _client = value;
                  });
                },
                // style: Theme.of(context).textTheme.headline6,
              ),
            ),
          ),
        ),
        items == null || items.length == 0
            ? Container()
            : Flexible(
                child: ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (buildContext, index) {
                      ItemModel itemModel = Provider.of<ItemModel>(context);
                      Item item = itemModel.getItemById(items[index].id);
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
                                  item?.name?.substring(0, 2)?.toUpperCase() ??
                                      '',
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                              ),
                            ),
                            title: Text(
                              '${item.name}',
                              overflow: TextOverflow.ellipsis,
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppLocalizations.of(context)
                                          .translate('purchasePrice') +
                                      ': ${items[index].purchasePrice?.toString()?.replaceAllMapped(reg, mathFunc)} @1',
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  AppLocalizations.of(context)
                                          .translate('salePrice') +
                                      ': ${items[index].salePrice?.toString()?.replaceAllMapped(reg, mathFunc)} @1',
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  AppLocalizations.of(context)
                                          .translate('quantity') +
                                      ': ${items[index].quantity}',
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                            trailing: IconButton(
                                icon: Icon(Icons.delete_outline),
                                onPressed: () {
                                  setState(() {
                                    items.removeWhere(
                                        (item) => item.id == items[index].id);
                                  });
                                }),
                            onTap: () {
                              // Navigator.pushNamed(
                              //     context, AppRoutes.purchase_detail,
                              //     arguments: items[index]);
                            },
                          ),
                        ],
                      );
                    }),
              ),
      ],
    );
  }

  AppBar buildAppBar(PurchaseModel model, BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: Text(widget.title, style: Theme.of(context).textTheme.headline6),
      actions: <Widget>[
        model.busy
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: SizedBox(
                    height: 20.0,
                    width: 20.0,
                    child: CircularProgressIndicator(
                      strokeWidth: 5.0,
                      valueColor:
                          AlwaysStoppedAnimation(Theme.of(context).accentColor),
                    ),
                  ),
                ),
              )
            : model.selectedItems.length > 0
                ? FlatButton.icon(
                    icon: Icon(Icons.save),
                    color: Theme.of(context).accentColor,
                    textColor: Colors.white,
                    onPressed: () async {
                      var grandTotalAmount = 0.0;
                      var paidAmount = 0.0;
                      model.selectedItems.forEach((element) {
                        grandTotalAmount =
                            grandTotalAmount + element.purchasePrice;
                        paidAmount = paidAmount + element.paidAmount;
                      });
                      bool success = await model.savePurchase(
                          data: Purchase(
                              id: widget.purchase?.id ?? '',
                              clientId: _client.id,
                              companyName: _client.companyName,
                              items: model.selectedItems,
                              grandTotalAmount: grandTotalAmount,
                              paidAmount: paidAmount,
                              dueAmount: grandTotalAmount - paidAmount,
                              userId: ''));
                      if (success)
                        Toast.show(
                            message: 'Purchased Successful', context: context);
                    },
                    label: Text(AppLocalizations.of(context).translate('save')),

                    // shape: CircleBorder(side: BorderSide(color: Colors.transparent)),
                  )
                : Container(),
      ],
    );
  }
}
