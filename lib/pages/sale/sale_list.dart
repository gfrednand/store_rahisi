import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:storeRahisi/app_localizations.dart';
import 'package:storeRahisi/constants/routes.dart';
import 'package:storeRahisi/pages/base_view.dart';
import 'package:storeRahisi/providers/index.dart';

class SaleList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseView<SaleModel>(
      onModelReady: (model) => model.listenToSales(),
      builder: (context, model, child) {
        return Expanded(
          child: ListView.builder(
              shrinkWrap: true,
              itemCount: model.sales.length,
              itemBuilder: (context, index) {
                var saleDate = new DateFormat('MMM dd, yyyy')
                    .format(model.sales[index].saleDate);
                return Card(
                  child: ListTile(
                    title: Text(saleDate),
                    trailing: Text('${model.sales[index].grandTotal} /='),
                    subtitle: Text(
                        AppLocalizations.of(context).translate('totalSales') +
                            ': ${model.sales[index].items.length}'),
                    onTap: () {
                      var arguments = {
                        'sale': model.sales[index],
                        'saleModel': model,
                      };

                      Navigator.pushNamed(context, AppRoutes.sale_detail,
                          arguments: arguments);
                    },
                  ),
                );
              }),
        );
      },
    );
  }
}
