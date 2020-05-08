import 'package:flutter/material.dart';
import 'package:storeRahisi/constants/routes.dart';
import 'package:storeRahisi/providers/index.dart';

class TotalBar extends StatelessWidget {
  const TotalBar({
    Key key,
    @required this.cartModel,
    this.route,
    @required this.subtitle,
  }) : super(key: key);

  final CartModel cartModel;
  final String route;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Card(
        // alignment: Alignment.bottomLeft,
        // height: 60.0,
        elevation: 16.0,
        margin: EdgeInsets.only(bottom: 8.0, right: 10.0, left: 10.0),
        // color: Colors.green.shade100,
        child: ListTile(
          leading: IconButton(icon: Icon(Icons.info), onPressed: null),
          trailing: Icon(Icons.chevron_right),
          title: Text(
            'Total ${cartModel.totalPrice}',
            style: Theme.of(context).textTheme.bodyText1,
          ),
          subtitle: Text(
            subtitle,
            style: Theme.of(context).textTheme.subtitle2,
          ),
          onTap: () {
            Navigator.pushNamed(context, route);
          },
        ));
  }
}
