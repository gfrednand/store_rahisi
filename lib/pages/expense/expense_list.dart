import 'package:flutter/material.dart';
import 'package:storeRahisi/constants/routes.dart';
import 'package:storeRahisi/pages/base_view.dart';
import 'package:storeRahisi/providers/index.dart';
import '../../app_localizations.dart';

class ExpenseList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseView<ExpenseModel>(
      onModelReady: (model) => model.listenToExpenses(),
      builder: (context, model, child) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(AppLocalizations.of(context).translate('expenses'),
                style: Theme.of(context).textTheme.headline6),
          ),
          body: Scrollbar(
              child: !model.busy
                  ? model.expenses == null || !(model.expenses.length > 0)
                      ? Center(
                          child: Text(AppLocalizations.of(context)
                              .translate('nothingFound')),
                        )
                      : ListView.builder(
                          itemCount: model.expenses.length,
                          itemBuilder: (buildContext, index) {
                            return Column(
                              children: [
                                Divider(height:5.0),
                                ListTile(
                                  leading: ExcludeSemantics(
                                    child: CircleAvatar(
                                      radius: 25.0,
                                      backgroundColor:
                                          Theme.of(context).colorScheme.onPrimary,
                                      child: Text(
                                        model.expenses[index].responsiblePerson
                                            .substring(0, 2)
                                            .toUpperCase(),
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                        ),
                                      ),
                                    ),
                                  ),
                                  title: Text(
                                    '${model.expenses[index].responsiblePerson.toUpperCase()}',
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context).textTheme.bodyText1,
                                  ),
                                  subtitle: Text(
                                    '${model.expenses[index].description ?? ''}',
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context).textTheme.subtitle2,
                                  ),
                                  // trailing: Text(
                                  //   '${model.expenses[index].amount}',
                                  //   style: TextStyle(
                                  //     fontWeight: FontWeight.bold,
                                  //   ),
                                  // ),
                                  trailing: Icon(
                                    Icons.arrow_forward_ios,
                                    color: Theme.of(context).iconTheme.color,
                                  ),
                                  onTap: () {
                                    var arguments = {
                                      'expense': model.expenses[index],
                                      'expenseModel': model,
                                    };

                                    Navigator.pushNamed(
                                        context, AppRoutes.expense_detail,
                                        arguments: arguments);
                                  },
                                ),
                              ],
                            );
                          },
                        )
                  : Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(
                            Theme.of(context).accentColor),
                      ),
                    )),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.expense_form, arguments: {
                'title': AppLocalizations.of(context).translate('addExpense')
              });
            },
            child: Icon(
              Icons.add,
            ),
            tooltip: AppLocalizations.of(context).translate('add'),
          ),
        );
      },
    );
  }
}
