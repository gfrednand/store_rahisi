import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:storeRahisi/app_localizations.dart';

class CustomModalSheet {
  static void show({
    @required Widget child,
    bool isExpanded = true,
    @required BuildContext context,
  }) {
    assert(child != null);
    assert(context != null);

    _show(context, child, isExpanded);
  }

  static void _show(BuildContext context, Widget child, bool isExpanded) async {
    await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: new BoxDecoration(
                //  color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius:
                    new BorderRadius.all(const Radius.circular(10.0))),
            child: ConstrainedBox(
              constraints: new BoxConstraints(
                minHeight: 0.0,
                maxHeight: MediaQuery.of(context).size.width * 1.3,
              ),
              child: new Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  isExpanded
                      ? Expanded(
                          child: child,
                        )
                      : child,
                  // Divider(),
              SizedBox(height: 5.0,),
                  Container(
                    decoration: new BoxDecoration(
                        color: Theme.of(context).appBarTheme.color,
                        borderRadius:
                            new BorderRadius.all(const Radius.circular(10.0))),
                    child: SizedBox(
                      width: double.infinity,
                      child: FlatButton(
                          child: Text(
                            AppLocalizations.of(context).translate('cancel'),
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          }),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
