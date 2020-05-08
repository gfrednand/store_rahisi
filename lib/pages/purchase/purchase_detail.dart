import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:storeRahisi/app_localizations.dart';
import 'package:storeRahisi/constants/routes.dart';
import 'package:storeRahisi/models/index.dart';

import 'package:storeRahisi/models/purchase.dart';
import 'package:storeRahisi/pages/purchase/purchase_detail_widget.dart';

import 'package:storeRahisi/providers/index.dart';

class PurchaseDetail extends StatelessWidget {
  final Purchase purchase;
  final PurchaseModel purchaseModel;
  const PurchaseDetail({Key key, this.purchase, this.purchaseModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var purchaseDate =
        new DateFormat('MMM dd, yyyy').format(purchase.purchaseDate);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: purchase.purchaseDate == null
            ? Text(AppLocalizations.of(context).translate('purchaseDetails'))
            : Text('$purchaseDate',
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.headline6),
      ),
      body: PurchaseDetailWidget(
        purchase: purchase,
        purchaseModel: purchaseModel,
      ),
    );
  }
}
