import 'package:flutter/material.dart';
import 'package:storeRahisi/app_localizations.dart';
import 'package:storeRahisi/constants/routes.dart';
import 'package:storeRahisi/models/user.dart';

class CustomDrawer extends StatelessWidget {
  final BuildContext ctx;
  final User user;
  CustomDrawer(this.ctx, this.user);
  @override
  Widget build(ctx) {
    return Drawer(
      child: ListView(
        // Important: Delete any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text('${user.fname} ${user.lname}'),
            accountEmail: Text("${user.email}"),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Theme.of(ctx).platform == TargetPlatform.iOS
                  ? Colors.blue
                  : Colors.white,
              child: Text(
                "S",
                style: TextStyle(fontSize: 40.0),
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.swap_horiz),
            title: Text(AppLocalizations.of(ctx).translate('transactions')),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.attach_money),
            title: Text(AppLocalizations.of(ctx).translate('expenses')),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.select_all),
            title: Text(AppLocalizations.of(ctx).translate('itemReport')),
            onTap: () {
              Navigator.pop(ctx);
              Navigator.pushNamed(ctx, AppRoutes.item_report);
            },
          ),
          ListTile(
            leading: Icon(Icons.view_week),
            title: Text(AppLocalizations.of(ctx).translate('purchaseReport')),
            onTap: () {
              Navigator.pop(ctx);
              Navigator.pushNamed(ctx, AppRoutes.purchase_report);
            },
          ),
          ListTile(
            leading: Icon(Icons.dns),
            title: Text(AppLocalizations.of(ctx).translate('salesReport')),
            onTap: () {
              Navigator.pop(ctx);
              Navigator.pushNamed(ctx, AppRoutes.sale_report);
            },
          ),
          ListTile(
            leading: Icon(Icons.timeline),
            title: Text(AppLocalizations.of(ctx).translate('profitReport')),
            onTap: () {
              Navigator.pop(ctx);
              Navigator.pushNamed(ctx, AppRoutes.profit_report);
            },
          ),
          Container(
            // This align moves the children to the bottom
            child: Align(
              alignment: FractionalOffset.bottomCenter,
              // This container holds all the children that will be aligned
              // on the bottom and should not scroll with the above ListView
              child: Container(
                child: Column(
                  children: <Widget>[
                    Divider(),
                    ListTile(
                        leading: Icon(Icons.settings),
                        title: Text(
                            AppLocalizations.of(ctx).translate('settings'))),
                    ListTile(
                        leading: Icon(Icons.help),
                        title: Text(AppLocalizations.of(ctx)
                            .translate('helpAndFeedback')))
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
