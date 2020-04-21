import 'package:flutter/material.dart';
import 'package:storeRahisi/constants/routes.dart';
import 'package:storeRahisi/pages/base_view.dart';
import 'package:storeRahisi/pages/expense/expense_form.dart';
import 'package:storeRahisi/providers/index.dart';
import 'package:storeRahisi/widgets/custom_modal_sheet.dart';
import '../../app_localizations.dart';

class ExpenseList extends StatelessWidget {
  _showModalSheetAppBar(
      BuildContext context, String title, Widget body, double heightFactor) {
    CustomModalSheet.show(
      title: title,
      context: context,
      body: body,
      heightFactor: heightFactor,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<ExpenseModel>(
      onModelReady: (model) => model.listenToExpenses(),
      builder: (context, model, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(AppLocalizations.of(context).translate('expenses')),
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
                            return Card(
                              child: ListTile(
                                leading: ExcludeSemantics(
                                  child: CircleAvatar(
                                    radius: 25.0,
                                    backgroundColor:
                                        Theme.of(context).primaryColor,
                                    child: Text(
                                      model.expenses[index].responsiblePerson
                                          .substring(0, 2)
                                          .toUpperCase(),
                                      style: TextStyle(
                                          color: Theme.of(context).accentColor),
                                    ),
                                  ),
                                ),
                                title: Text(
                                  '${model.expenses[index].responsiblePerson.toUpperCase()}',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(
                                  '${model.expenses[index].description ?? ''}',
                                  overflow: TextOverflow.ellipsis,
                                ),
                                trailing: Text(
                                  '${model.expenses[index].amount}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
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
              _showModalSheetAppBar(
                  context,
                  AppLocalizations.of(context).translate('addExpense'),
                  ExpenseForm(),
                  0.45);
            },
            child: Icon(
              Icons.add,
              color: Theme.of(context).primaryColor,
            ),
            tooltip: AppLocalizations.of(context).translate('add'),
          ),
        );
      },
    );
  }
}
