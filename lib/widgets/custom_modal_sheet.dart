import 'package:flutter/material.dart';

class CustomModalSheet {
  static void show({
    @required Widget body,
    @required String title,
    @required double heightFactor,
    @required BuildContext context,
  }) {
    assert(body != null);
    assert(context != null);

    _show(context, body, title, heightFactor);
  }

  static void _show(BuildContext context, Widget body, String title,
      double heightFactor) async {
    await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return SingleChildScrollView(
            
            child: Container(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              // margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              // decoration: new BoxDecoration(
              //     color: Colors.white,
              //     borderRadius:
              //         new BorderRadius.all(const Radius.circular(10.0))),
              // decoration: BoxDecoration(
              //   borderRadius: BorderRadius.only(
              //     topLeft: Radius.circular(16.0),
              //     topRight: Radius.circular(16.0),
              //   ),
              //   color: Theme.of(context).accentColor,
              // ),
              child: ConstrainedBox(
                constraints: new BoxConstraints(
                  minHeight: 0.0,
                  maxHeight: MediaQuery.of(context).size.height * heightFactor,
                ),
                child: Column(
                  children: [
                    Container(
                      height: 70,
                      child: Center(
                        child: Text(
                          title.toUpperCase(),
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 20.0),
                        ),
                      ),
                    ),
                    Divider(thickness: 1),
                    Expanded(child: body),
                  ],
                ),
              ),
            ),
          );

          // Container(
          //   padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          //   margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          //   decoration: new BoxDecoration(
          //       color: Colors.white,
          //       borderRadius:
          //           new BorderRadius.all(const Radius.circular(10.0))),
          //   child: ConstrainedBox(
          //     constraints: new BoxConstraints(
          //       minHeight: 0.0,
          //       maxHeight: MediaQuery.of(context).size.width * 1.3,
          //     ),
          //     child: new Column(
          //       mainAxisSize: MainAxisSize.min,
          //       children: <Widget>[
          //         isExpanded
          //             ? Expanded(
          //                 child: child,
          //               )
          //             : child,
          //         Divider(),
          //         Container(
          //           decoration: new BoxDecoration(
          //               color: Colors.white,
          //               borderRadius:
          //                   new BorderRadius.all(const Radius.circular(10.0))),
          //           child: SizedBox(
          //             width: double.infinity,
          //             child: FlatButton(
          //                 child: Text('Cancel'),
          //                 onPressed: () {
          //                   Navigator.pop(context);
          //                 }),
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),
          // );
        });
  }
}
