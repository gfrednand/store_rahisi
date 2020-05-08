import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storeRahisi/app_localizations.dart';
import 'package:storeRahisi/models/item.dart';
import 'package:storeRahisi/providers/cart_model.dart';
import 'package:storeRahisi/providers/index.dart';

class OrderSummary extends StatefulWidget {
  final CartModel cartModel;

  const OrderSummary({Key key, this.cartModel}) : super(key: key);
  @override
  _OrderSummaryState createState() => _OrderSummaryState();
}

class _OrderSummaryState extends State<OrderSummary> {
  @override
  Widget build(BuildContext context) {
    ItemModel itemModel = Provider.of<ItemModel>(context);

    return ListView.builder(
        shrinkWrap: true,
        physics: AlwaysScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        itemCount: widget.cartModel.carts.length,
        itemBuilder: (context, index) {
          if (index < widget.cartModel.carts.length) {
            Item item =
                itemModel.getItemById(widget.cartModel.carts[index].itemId);
            return Dismissible(
              key: Key(widget.cartModel.carts[index].itemId),
              direction: DismissDirection.endToStart,
              secondaryBackground: slideLeftBackground(),
              background: slideLeftBackground(),
              child: Column(
                children: [
                  Divider(height:5.0),
                  ListTile(
                    onTap: () => {},
                    title: Text(
                      '${item?.name?.toUpperCase() ?? ''}',
                    ),
                    subtitle: Text(
                      'Tshs ${(widget.cartModel.carts[index].quantity * widget.cartModel.carts[index].paidAmount).toString()}/=',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: Text(
                      '${widget.cartModel.carts[index]?.quantity.toString()}',
                    ),
                  ),
                ],
              ),
              confirmDismiss: (direction) async {
                if (direction == DismissDirection.endToStart) {
                  final bool res = await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          content: Text(
                              "Are you sure you want to remove ${item.name.toUpperCase()}?"),
                          actions: <Widget>[
                            FlatButton(
                              child: Text(
                                "Cancel",
                                style: TextStyle(color: Colors.black),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            FlatButton(
                              child: Text(
                                "Delete",
                                style: TextStyle(color: Colors.red),
                              ),
                              onPressed: () {
                                setState(() {
                                  widget.cartModel.removeItem(item);
                                });
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      });
                  return res;
                } else {
                  // TODO: Navigate to edit page;
                }
              },
            );
          } else {
            return Card(child: Text("data"));
          }
        });

    // Column(
    //   mainAxisSize: MainAxisSize.min,
    //   children: [
    //     Expanded(
    //       child: ListView(
    //         shrinkWrap: true,
    //         scrollDirection: Axis.horizontal,
    //         children: <Widget>[
    //           DataTable(
    //             // columnSpacing: 160.0,
    //             sortColumnIndex: 2,
    //             sortAscending: isSort,
    //             columns: [
    //               DataColumn(
    //                 label: Text('Name'),
    //                 numeric: false,
    //               ),
    //               DataColumn(
    //                 label: Text('Quantity'),
    //                 numeric: false,
    //               ),
    //               DataColumn(
    //                   label: Text('Price'),
    //                   numeric: false,
    //                   onSort: (i, b) {
    //                     setState(() {
    //                       if (isSort) {
    //                         widget.widget.cartModel.carts.sort(
    //                             (a, b) => b.paidAmount.compareTo(a.paidAmount));

    //                         isSort = false;
    //                       } else {
    //                         widget.cartModel.carts.sort(
    //                             (a, b) => a.paidAmount.compareTo(b.paidAmount));

    //                         isSort = true;
    //                       }
    //                     });
    //                   }),
    //               DataColumn(
    //                 label: Text('Action'),
    //                 numeric: false,
    //               ),
    //             ],
    //             rows: widget.cartModel.carts.map(
    //               (cart) {
    //                 Item item = itemModel.getItemById(cart.itemId);
    //                 return DataRow(
    //                     // selected: sales.contains(sale),
    //                     cells: [
    //                       DataCell(
    //                         Text(item.name),
    //                         onTap: () {
    //                           // write your code..
    //                         },
    //                       ),
    //                       DataCell(
    //                         Text('${cart.quantity}'),
    //                       ),
    //                       DataCell(
    //                         Text('${cart.paidAmount}'),
    //                       ),
    //                       DataCell(
    //                         IconButton(
    //                           icon: Icon(
    //                             Icons.delete,
    //                             color: Theme.of(context).errorColor,
    //                           ),
    //                           onPressed: () => showDialog(
    //                               context: context,
    //                               builder: (BuildContext context) {
    //                                 return AlertDialog(
    //                                   title: Text(AppLocalizations.of(context)
    //                                       .translate('deleteFromCart')),
    //                                   content: Text(AppLocalizations.of(context)
    //                                       .translate('areYouSure')),
    //                                   actions: <Widget>[
    //                                     Row(
    //                                       mainAxisSize: MainAxisSize.min,
    //                                       mainAxisAlignment:
    //                                           MainAxisAlignment.spaceEvenly,
    //                                       children: <Widget>[
    //                                         FlatButton(
    //                                             child: Text(
    //                                                 AppLocalizations.of(context)
    //                                                     .translate('cancel')),
    //                                             onPressed: () {
    //                                               Navigator.of(context).pop();
    //                                             }),
    //                                         Container(
    //                                           color: Colors.grey,
    //                                           width: 1.0,
    //                                           height: 24.0,
    //                                         ),
    //                                         FlatButton(
    //                                             child: Text(
    //                                                 AppLocalizations.of(context)
    //                                                     .translate('ok')),
    //                                             onPressed: () {
    //                                               setState(() {
    //                                                 widget.cartModel
    //                                                     .removeItem(item);
    //                                               });
    //                                               Navigator.of(context).pop();
    //                                             })
    //                                       ],
    //                                     ),
    //                                   ],
    //                                 );
    //                               }),
    //                         ),
    //                       ),
    //                     ]);
    //               },
    //             ).toList(),
    //           ),
    //         ],
    //       ),
    //     ),
    //   ],
    // );
  }

  Widget slideLeftBackground() {
    return Container(
      color: Colors.red,
      child: Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Icon(
              Icons.delete,
              color: Colors.white,
            ),
            Text(
              " Delete",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.right,
            ),
            SizedBox(
              width: 20,
            ),
          ],
        ),
        alignment: Alignment.centerRight,
      ),
    );
  }
}
