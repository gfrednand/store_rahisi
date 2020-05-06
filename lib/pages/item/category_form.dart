import 'package:flutter/material.dart';
import 'package:storeRahisi/app_localizations.dart';
import 'package:storeRahisi/constants/ui_helpers.dart';
import 'package:storeRahisi/models/index.dart';
import 'package:storeRahisi/pages/base_view.dart';
import 'package:storeRahisi/providers/index.dart';
import 'package:storeRahisi/widgets/busy_button.dart';
import 'package:storeRahisi/widgets/toast.dart';

class CategoryForm extends StatefulWidget {
  final Category category;
  final String title;

  CategoryForm({Key key, this.category, this.title}) : super(key: key);

  @override
  _CategoryFormState createState() => _CategoryFormState();
}

class _CategoryFormState extends State<CategoryForm> {
  final categoryController = new TextEditingController();

  final _formKey = GlobalKey<FormState>();
  String requiredValidator(String value) {
    if (value.isEmpty) {
      return 'Required';
    } else {
      return null;
    }
  }
  @override
  Widget build(BuildContext context) {
    if (widget.category != null) {
      categoryController.text = widget.category?.name ?? '';
    }
    return BaseView<ItemModel>(
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Add Category', style: Theme.of(context).textTheme.headline6),
        ),
        body: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: TextFormField(
                  validator: requiredValidator,
                  controller: categoryController,
                  decoration: new InputDecoration(
                    labelText: "Category",
                  ),
                ),
              ),
              verticalSpaceSmall,
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  BusyButton(
                    enabled: categoryController.text != null ||
                        categoryController.text != '',
                    title: AppLocalizations.of(context).translate('submit'),
                    busy: model.busy,
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        bool success = await model.saveCategory(
                            data: Category(
                                id: widget.category?.id ?? '',
                                name: categoryController.text));
                        _formKey.currentState.reset();
                        if (success) {
                          Toast.show(
                              message: 'Category successfully Added',
                              context: context);
                        }
                      }
                    },
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
