import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:storeRahisi/app_localizations.dart';
import 'package:storeRahisi/constants/routes.dart';
import 'package:storeRahisi/models/index.dart';
import 'package:storeRahisi/providers/index.dart';
import 'package:provider/provider.dart';

class SaleList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<Sale> sales = context.select((SaleModel model) => model.sales);
    SaleModel model = context.watch<SaleModel>();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(AppLocalizations.of(context).translate('sales'),
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.headline6),
      ),
      body: ListView.builder(
          shrinkWrap: true,
          itemCount: sales.length,
          itemBuilder: (context, index) {
            var saleDate =
                new DateFormat('MMM dd, yyyy').format(sales[index].saleDate);
            return Column(
              children: [
                Divider(
                  height: 5.0,
                ),
                ListTile(
                  title: Text(
                    saleDate,
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    color: Theme.of(context).iconTheme.color,
                  ),
                  subtitle: Text(
                    AppLocalizations.of(context).translate('totalSales') +
                        ': ${sales[index].grandTotal} /=',
                    style: Theme.of(context).textTheme.subtitle2,
                  ),
                  onTap: () {
                    var arguments = {
                      'sale': sales[index],
                      'saleModel': model,
                    };

                    Navigator.pushNamed(context, AppRoutes.sale_detail,
                        arguments: arguments);
                  },
                ),
              ],
            );
          }),
    );
  }
}
