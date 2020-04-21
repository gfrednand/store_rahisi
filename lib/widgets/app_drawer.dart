import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storeRahisi/app_localizations.dart';
import 'package:storeRahisi/constants/routes.dart';
import 'package:storeRahisi/models/user.dart';
import 'package:storeRahisi/providers/auth_model.dart';

class CustomDrawer extends StatefulWidget {
  final BuildContext ctx;
  final User user;
  CustomDrawer(this.ctx, this.user);

  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  bool showUserDetails = false;

  Widget _buildUserDetail() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        widget.user != null
            ? ListTile(
                leading: Icon(Icons.person),
                title: Text('${widget.user.fname} ${widget.user.lname}'),
                subtitle:
                    Text(AppLocalizations.of(context).translate('username')),
              )
            : Container(),
        // widget.user != null
        //     ? ListTile(
        //         leading: Icon(Icons.email),
        //         title: Text("${widget.user.email}"),
        //         subtitle: Text(AppLocalizations.of(context).translate('email')),
        //       )
        //     : Container(),

        widget.user != null
            ? ListTile(
                leading: Icon(Icons.person_pin),
                title: Text("${widget.user.designation}"),
                subtitle:
                    Text(AppLocalizations.of(context).translate('designation')),
              )
            : Container(),
        widget.user != null
            ? ListTile(
                leading: Icon(Icons.phone),
                title: Text("${widget.user.phoneNumber}"),
                subtitle:
                    Text(AppLocalizations.of(context).translate('phoneNumber')),
              )
            : Container(),

        // widget.user != null
        //     ? ListTile(
        //         leading: Icon(Icons.label_important),
        //         title: Text("${widget.user.id}"),
        //         subtitle: Text(
        //             AppLocalizations.of(context).translate('referenceNumber')),
        //       )
        //     : Container(),
        // Divider(),
        const Expanded(child: SizedBox()),
        const Divider(height: 1.0, color: Colors.grey),
        SizedBox(
          width: double.infinity,
          child: FlatButton(
              color: Theme.of(context).primaryColor,
              child: Text(
                AppLocalizations.of(context).translate('logout'),
                style: TextStyle(color: Theme.of(context).accentColor),
              ),
              onPressed: () async {
                bool loggedOut = await Provider.of<AuthModel>(context).logout();
                if (loggedOut) {
                  Navigator.pushReplacementNamed(context, AppRoutes.login);
                }
              }),
        ),
      ],
    );
  }

  Widget _buildDrawerList(BuildContext ctx) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Expanded(
          child: ListTile(
            leading: Icon(Icons.attach_money),
            title: Text(AppLocalizations.of(ctx).translate('expenses')),
            onTap: () {
              Navigator.pop(ctx);
              Navigator.pushNamed(ctx, AppRoutes.expense);
            },
          ),
        ),
        Expanded(
          child: ListTile(
            leading: Icon(Icons.select_all),
            title: Text(AppLocalizations.of(ctx).translate('itemReport')),
            onTap: () {
              Navigator.pop(ctx);
              Navigator.pushNamed(ctx, AppRoutes.item_report);
            },
          ),
        ),
        Expanded(
          child: ListTile(
            leading: Icon(Icons.view_week),
            title: Text(AppLocalizations.of(ctx).translate('purchaseReport')),
            onTap: () {
              Navigator.pop(ctx);
              Navigator.pushNamed(ctx, AppRoutes.purchase_report);
            },
          ),
        ),
        Expanded(
          child: ListTile(
            leading: Icon(Icons.dns),
            title: Text(AppLocalizations.of(ctx).translate('salesReport')),
            onTap: () {
              Navigator.pop(ctx);
              Navigator.pushNamed(ctx, AppRoutes.sale_report);
            },
          ),
        ),
        Expanded(
          child: ListTile(
            leading: Icon(Icons.timeline),
            title: Text(AppLocalizations.of(ctx).translate('profitReport')),
            onTap: () {
              Navigator.pop(ctx);
              Navigator.pushNamed(ctx, AppRoutes.profit_report);
            },
          ),
        ),
        const Expanded(child: SizedBox()),
        const Divider(height: 1.0, color: Colors.grey),
        Column(
          children: <Widget>[
            // Divider(),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text(AppLocalizations.of(ctx).translate('settings')),
              onTap: () {
                Navigator.pop(ctx);
                Navigator.pushNamed(ctx, AppRoutes.settings);
              },
            ),
            // ListTile(
            //     leading: Icon(Icons.help),
            //     title: Text(AppLocalizations.of(ctx)
            //         .translate('helpAndFeedback')))
          ],
        ),
      ],
    );
  }

  @override
  Widget build(ctx) {
    return Drawer(
      child: LayoutBuilder(builder: (context, constraint) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraint.maxHeight),
            child: IntrinsicHeight(
              child: Column(
                // Important: Delete any padding from the ListView.
                children: <Widget>[
                  UserAccountsDrawerHeader(
                    accountName:
                        Text('${widget.user.fname} ${widget.user.lname}'),
                    accountEmail: Text("${widget.user.email}"),
                    currentAccountPicture: CircleAvatar(
                      backgroundColor:
                          Theme.of(ctx).platform == TargetPlatform.iOS
                              ? Colors.blue
                              : Colors.white,
                      child: Text(
                        "S",
                        style: TextStyle(fontSize: 40.0),
                      ),
                    ),
                    margin: EdgeInsets.zero,
                    onDetailsPressed: () {
                      setState(() {
                        showUserDetails = !showUserDetails;
                      });
                    },
                  ),
                  Expanded(
                      child: showUserDetails
                          ? _buildUserDetail()
                          : _buildDrawerList(ctx))
                  // ListTile(
                  //   leading: Icon(Icons.swap_horiz),
                  //   title: Text(AppLocalizations.of(ctx).translate('transactions')),
                  //   onTap: () {
                  //     Navigator.pop(ctx);
                  //     Navigator.pushNamed(ctx, AppRoutes.transaction_report);
                  //   },
                  // ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
