import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storeRahisi/app_localizations.dart';
import 'package:storeRahisi/constants/linear_icons.dart';
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
                leading: Icon(Icons.person,
                    color: Theme.of(context).iconTheme.color),
                title: Text(
                  '${widget.user.fname} ${widget.user.lname}',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                subtitle: Text(
                  AppLocalizations.of(context).translate('username'),
                  style: Theme.of(context).textTheme.subtitle2,
                ),
              )
            : Container(),
        // widget.user != null
        //     ? ListTile(
        //         leading: Icon(color: Theme.of(context).iconTheme.color, Icons.email),
        //         title: Text("${widget.user.email}"),
        //         subtitle: Text(AppLocalizations.of(context).translate('email')),
        //       )
        //     : Container(),

        widget.user != null
            ? ListTile(
                leading: Icon(Icons.person_pin,
                    color: Theme.of(context).iconTheme.color),
                title: Text(
                  "${widget.user.designation}",
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                subtitle: Text(
                  AppLocalizations.of(context).translate('designation'),
                  style: Theme.of(context).textTheme.subtitle2,
                ),
              )
            : Container(),
        widget.user != null
            ? ListTile(
                leading:
                    Icon(Icons.phone, color: Theme.of(context).iconTheme.color),
                title: Text(
                  "${widget.user.phoneNumber}",
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                subtitle: Text(
                  AppLocalizations.of(context).translate('phoneNumber'),
                  style: Theme.of(context).textTheme.subtitle2,
                ),
              )
            : Container(),

        // widget.user != null
        //     ? ListTile(
        //         leading: Icon(color: Theme.of(context).iconTheme.color, Icons.label_important),
        //         title: Text("${widget.user.id}"),
        //         subtitle: Text(
        //             AppLocalizations.of(context).translate('referenceNumber'), style: Theme.of(context).textTheme.subtitle2,),
        //       )
        //     : Container(),
        // Divider(),
        Spacer(),
        const Divider(height: 1.0, color: Colors.grey),
        SizedBox(
          width: double.infinity,
          child: FlatButton(
              // color: Theme.of(context).colorScheme.onPrimary,
              child: Text(
                AppLocalizations.of(context).translate('logout'),
                style: Theme.of(context).textTheme.bodyText1,
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
            leading: Icon(
              Icons.attach_money,
              color: Theme.of(context).iconTheme.color,
            ),
            title: Text(
              AppLocalizations.of(ctx).translate('expenses'),
              style: Theme.of(context).textTheme.bodyText1,
            ),
            onTap: () {
              Navigator.pop(ctx);
              Navigator.pushNamed(ctx, AppRoutes.expense);
            },
          ),
        ),
        Expanded(
          child: ListTile(
            leading: Icon(
              Icons.select_all,
              color: Theme.of(context).iconTheme.color,
            ),
            title: Text(
              AppLocalizations.of(ctx).translate('itemReport'),
              style: Theme.of(context).textTheme.bodyText1,
            ),
            onTap: () {
              Navigator.pop(ctx);
              Navigator.pushNamed(ctx, AppRoutes.item_report);
            },
          ),
        ),
        Expanded(
          child: ListTile(
            leading: Icon(
              Icons.view_week,
              color: Theme.of(context).iconTheme.color,
            ),
            title: Text(
              AppLocalizations.of(ctx).translate('purchaseReport'),
              style: Theme.of(context).textTheme.bodyText1,
            ),
            onTap: () {
              Navigator.pop(ctx);
              Navigator.pushNamed(ctx, AppRoutes.purchase_report);
            },
          ),
        ),
        Expanded(
          child: ListTile(
            leading: Icon(
              Icons.dns,
              color: Theme.of(context).iconTheme.color,
            ),
            title: Text(
              AppLocalizations.of(ctx).translate('salesReport'),
              style: Theme.of(context).textTheme.bodyText1,
            ),
            onTap: () {
              Navigator.pop(ctx);
              Navigator.pushNamed(ctx, AppRoutes.sale_report);
            },
          ),
        ),
        Expanded(
          child: ListTile(
            leading: Icon(
              Icons.timeline,
              color: Theme.of(context).iconTheme.color,
            ),
            title: Text(
              AppLocalizations.of(ctx).translate('profitReport'),
              style: Theme.of(context).textTheme.bodyText1,
            ),
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
              leading: Icon(
                LinearIcons.cog,
                color: Theme.of(context).iconTheme.color,
              ),
              title: Text(
                AppLocalizations.of(ctx).translate('settings'),
                style: Theme.of(context).textTheme.bodyText1,
              ),
              onTap: () {
                Navigator.pop(ctx);
                Navigator.pushNamed(ctx, AppRoutes.settings);
              },
            ),
            ListTile(
              leading: Icon(
                Icons.help,
                color: Theme.of(context).iconTheme.color,
              ),
              title: Text(
                AppLocalizations.of(ctx).translate('helpAndFeedback'),
                style: Theme.of(context).textTheme.bodyText1,
              ),
              onTap: () {
                Navigator.pop(ctx);
                Navigator.pushNamed(ctx, AppRoutes.help);
              },
            )
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
                children: <Widget>[
                  UserAccountsDrawerHeader(
                    accountName:
                        Text('${widget.user.fname} ${widget.user.lname}'),
                    accountEmail: Text("${widget.user.email}"),
                    currentAccountPicture: CircleAvatar(
                      backgroundColor:
                          Theme.of(ctx).platform == TargetPlatform.iOS
                              ? Theme.of(context).colorScheme.onPrimary
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
                    child: Container(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        child: showUserDetails
                            ? _buildUserDetail()
                            : _buildDrawerList(ctx)),
                  )
                  // ListTile(
                  //   leading: Icon(color: Theme.of(context).iconTheme.color, Icons.swap_horiz),
                  //   title: Text( AppLocalizations.of(ctx).translate('transactions'),    style: Theme.of(context)
                  // .textTheme
                  // .bodyText1,),
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
