import 'package:flutter/material.dart';

class HorizontalLine extends StatelessWidget {
  final String centerText;
  const HorizontalLine({
    Key key,
    this.centerText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(children: <Widget>[
      Expanded(
        child: new Container(
            margin: const EdgeInsets.only(left: 10.0, right: 20.0),
            child: Divider(
              color: Theme.of(context).colorScheme.primary,
              height: 36,
            )),
      ),
      Text(centerText ?? ""),
      Expanded(
        child: new Container(
            margin: const EdgeInsets.only(left: 20.0, right: 10.0),
            child: Divider(
              color: Theme.of(context).colorScheme.primary,
              height: 36,
            )),
      ),
    ]);
  }
}
