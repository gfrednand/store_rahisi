// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storeRahisi/app_localizations.dart';
import 'package:storeRahisi/constants/app_constants.dart';
import 'package:storeRahisi/constants/linear_icons.dart';
import 'package:storeRahisi/constants/routes.dart';
import 'package:storeRahisi/models/item.dart';
import 'package:storeRahisi/pages/base_view.dart';
import 'package:storeRahisi/pages/item/item_list.dart';
import 'package:storeRahisi/pages/item/item_search_delegate.dart';
import 'package:storeRahisi/pages/pos/pos_item_list.dart';
import 'package:storeRahisi/pages/purchase/purchase_list.dart';
import 'package:storeRahisi/pages/client/client_list.dart';
import 'package:storeRahisi/providers/auth_model.dart';
import 'package:storeRahisi/providers/cart_model.dart';
import 'package:storeRahisi/providers/index.dart';
import 'package:storeRahisi/providers/item_model.dart';
import 'package:storeRahisi/widgets/app_drawer.dart';
import 'package:storeRahisi/widgets/bottom_navigation_badge.dart';
import 'package:storeRahisi/widgets/cart_button.dart';
import 'package:storeRahisi/widgets/custom_modal_sheet.dart';

class LayoutPage extends StatefulWidget {
  const LayoutPage({Key key}) : super(key: key);
  @override
  _LayoutPageState createState() => _LayoutPageState();
}

class _LayoutPageState extends State<LayoutPage> with TickerProviderStateMixin {
  int _currentIndex = 0;
  List<Item> items;
  String _title(BuildContext context) {
    return _currentIndex == 0
        ? AppLocalizations.of(context).translate('items')
        : _currentIndex == 1
            ? AppLocalizations.of(context).translate('clients')
            : _currentIndex == 2
                ? AppLocalizations.of(context).translate('purchases')
                : _currentIndex == 3
                    ? AppLocalizations.of(context).translate('pos')
                    : "";
  }

  _getProfileBody(AuthModel model) {
    return ListView(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      children: <Widget>[
        Container(
            decoration: new BoxDecoration(
                color: Theme.of(context).appBarTheme.color,
                borderRadius:
                    new BorderRadius.all(const Radius.circular(10.0))),
            child: Column(
              children: <Widget>[
                model.currentUser != null
                    ? ListTile(
                        leading: Icon(Icons.person,
                            color: Theme.of(context).iconTheme.color),
                        title: Text(
                          '${model.currentUser.fname} ${model.currentUser.lname}',
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                        subtitle: Text(
                          AppLocalizations.of(context).translate('username'),
                          style: Theme.of(context).textTheme.subtitle2,
                        ),
                      )
                    : Container(),
                model.currentUser != null
                    ? ListTile(
                        leading: Icon(Icons.email,
                            color: Theme.of(context).iconTheme.color),
                        title: Text(
                          "${model.currentUser.email}",
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                        subtitle: Text(
                          AppLocalizations.of(context).translate('email'),
                          style: Theme.of(context).textTheme.subtitle2,
                        ),
                      )
                    : Container(),
                model.currentUser != null
                    ? ListTile(
                        leading: Icon(Icons.person_pin,
                            color: Theme.of(context).iconTheme.color),
                        title: Text(
                          "${model.currentUser.designation}",
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                        subtitle: Text(
                          AppLocalizations.of(context).translate('designation'),
                          style: Theme.of(context).textTheme.subtitle2,
                        ),
                      )
                    : Container(),
                model.currentUser != null
                    ? ListTile(
                        leading: Icon(LinearIcons.phone,
                            color: Theme.of(context).iconTheme.color),
                        title: Text(
                          "${model.currentUser.phoneNumber}",
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                        subtitle: Text(
                          AppLocalizations.of(context).translate('phoneNumber'),
                          style: Theme.of(context).textTheme.subtitle2,
                        ),
                      )
                    : Container(),
                model.currentUser != null && model.currentUser.id != null
                    ? ListTile(
                        leading: Icon(Icons.label_important,
                            color: Theme.of(context).iconTheme.color),
                        title: Text(
                          "${model.currentUser.id}",
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                        subtitle: Text(
                          AppLocalizations.of(context)
                              .translate('referenceNumber'),
                          style: Theme.of(context).textTheme.subtitle2,
                        ),
                      )
                    : Container(),
                Divider(
                  height: 5.0,
                ),
                SizedBox(
                  width: double.infinity,
                  child: FlatButton(
                      // color: Theme.of(context).primaryColor,
                      child: Text(
                        AppLocalizations.of(context).translate(
                          'logout',
                        ),
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      onPressed: () async {
                        bool loggedOut = await model.logout();
                        if (loggedOut) {
                          Navigator.pushReplacementNamed(
                              context, AppRoutes.login);
                        }
                      }),
                ),
              ],
            )),
        //  Divider(),
      ],
    );
  }

  _buildActions(BuildContext context, AuthModel model, CartModel cartModel,
      ClientModel clientModel, ItemModel itemModel) {
    return <Widget>[
      _currentIndex == 0
          ? IconButton(
              icon: const Icon(Icons.search),
              onPressed: () async {
                await itemModel.fetchItems();
                items = itemModel.items;
                final List<Item> history = await showSearch(
                    context: context, delegate: ItemSearchDelegate(items));
                items = history;
              },
            )
          : _currentIndex == 3 && cartModel.carts.length > 0
              ? CartButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(AppRoutes.checkout,
                        arguments: clientModel.clients);
                  },
                  itemCount: cartModel.carts.length)
              : Container(),
      PopupMenuButton<String>(
        padding: EdgeInsets.zero,
        onSelected: (value) async {
          print(value);
          if (value == AppLocalizations.of(context).translate('logout')) {
            await model.logout();
            Navigator.of(context).pushReplacementNamed(AppRoutes.splash);
          }
          if (value == AppLocalizations.of(context).translate('profile')) {
            var body = _getProfileBody(model);
            _showModalSheetAppBar(context,
                AppLocalizations.of(context).translate('profile'), body);
          }
        },
        itemBuilder: (context) => <PopupMenuEntry<String>>[
          // PopupMenuItem<String>(
          //   value: 'Settings',
          //   child: ListTile(
          //     leading: Icon(Icons.settings),
          //     title: Text(
          //       'Settings',
          //     ),
          //   ),
          // ),
          PopupMenuItem<String>(
            value: AppLocalizations.of(context).translate('profile'),
            child: ListTile(
              leading: Icon(Icons.person_outline),
              title: Text(
                AppLocalizations.of(context).translate('profile'),
              ),
            ),
          ),
          const PopupMenuDivider(),
          PopupMenuItem<String>(
            value: AppLocalizations.of(context).translate('logout'),
            child: ListTile(
              leading: Icon(Icons.remove_circle_outline),
              title: Text(
                AppLocalizations.of(context).translate('logout'),
              ),
            ),
          ),
        ],
      )
    ];
  }

  _showModalSheetAppBar(BuildContext context, String title, Widget child) {
    CustomModalSheet.show(
      isExpanded: false,
      context: context,
      child: child,
    );
  }

  Widget _buildTransitionsStack() {
    return _currentIndex == 0
        ? ItemList()
        : _currentIndex == 1
            ? TabBarView(children: [
                ClientList(
                  clientType: AppConstants.clientTypeCustomer,
                ),
                ClientList(
                  clientType: AppConstants.clientTypeSupplier,
                ),
              ])
            : _currentIndex == 2
                ? PurchaseList()
                : _currentIndex == 3 ? PosItemList() : Container();
  }

  StatelessWidget floatingActionButton(BuildContext context) {
    return _currentIndex == 0 || _currentIndex == 1 || _currentIndex == 2
        ? FloatingActionButton(
            onPressed: () {
              int tabIndex = _currentIndex == 1
                  ? DefaultTabController.of(context).index
                  : 0;
              _currentIndex == 0
                  ? Navigator.pushNamed(context, AppRoutes.item_form,
                      arguments: {
                          'title':
                              AppLocalizations.of(context).translate('addItem'),
                        })
                  : _currentIndex == 1
                      ? tabIndex == 0
                          ? Navigator.pushNamed(context, AppRoutes.client_form,
                              arguments: {
                                  'title': AppLocalizations.of(context)
                                          .translate('add') +
                                      ' ' +
                                      AppConstants.clientTypeCustomer,
                                  'clientType': AppConstants.clientTypeCustomer
                                })
                          : Navigator.pushNamed(context, AppRoutes.client_form,
                              arguments: {
                                  'title': AppLocalizations.of(context)
                                          .translate('add') +
                                      ' ' +
                                      AppConstants.clientTypeSupplier,
                                  'clientType': AppConstants.clientTypeSupplier
                                })
                      : _currentIndex == 2
                          ? Navigator.pushNamed(context, AppRoutes.purchase_add,
                              arguments: {
                                  'title': AppLocalizations.of(context)
                                      .translate('addPurchase'),
                                })
                          : Container();
            },
            child: Icon(
              Icons.add,
              // color: Theme.of(context).iconTheme.;,
            ),
            tooltip: AppLocalizations.of(context).translate('add'),
          )
        : Container();
  }

  BottomNavigationBar buildBottomNavigationBar(
      List<BottomNavigationBarItem> bottomNavigationBarItems,
      TextTheme textTheme,
      ColorScheme colorScheme) {
    return BottomNavigationBar(
      showUnselectedLabels: true,
      items: bottomNavigationBarItems,
      currentIndex: _currentIndex,
      type: BottomNavigationBarType.fixed,
      selectedFontSize: textTheme.caption.fontSize,
      unselectedFontSize: textTheme.caption.fontSize,
      onTap: (index) {
        setState(() {
          _currentIndex = index;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    CartModel cartModel = Provider.of<CartModel>(context);
    ClientModel clientModel = Provider.of<ClientModel>(context, listen: true);
    ItemModel itemModel = Provider.of<ItemModel>(context, listen: false);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    List<String> tabs = [
      AppLocalizations.of(context).translate('customers'),
      AppLocalizations.of(context).translate('suppliers'),
    ];

    BottomNavigationBadge badger = new BottomNavigationBadge(
        backgroundColor: Colors.red,
        badgeShape: BottomNavigationBadgeShape.circle,
        textColor: Colors.white,
        position: BottomNavigationBadgePosition.topRight,
        textSize: 8);

    List<BottomNavigationBarItem> bottomNavigationBarItems = [
      BottomNavigationBarItem(
        icon: const Icon(Icons.select_all),
        title: Text(AppLocalizations.of(context).translate('items')),
      ),
      BottomNavigationBarItem(
        icon: const Icon(LinearIcons.users),
        title: Text(AppLocalizations.of(context).translate('clients')),
      ),
      BottomNavigationBarItem(
        icon: const Icon(Icons.view_week),
        title: Text(AppLocalizations.of(context).translate('purchases')),
      ),
      BottomNavigationBarItem(
        icon: const Icon(Icons.style),
        title: Text(AppLocalizations.of(context).translate('pos')),
      ),
    ];

    int countClient = clientModel.numberOfClientsWithDue;
    String cl = countClient > 0 ? countClient.toString() : null;
    setState(() {
      bottomNavigationBarItems =
          badger.setBadge(bottomNavigationBarItems, cl, 1);
    });

    return BaseView<AuthModel>(
        builder: (context, model, child) => _currentIndex == 1
            ? DefaultTabController(
                length: tabs.length,
                child: Builder(builder: (BuildContext context) {
                  return Scaffold(
                    drawer: CustomDrawer(context, model.currentUser),
                    appBar: AppBar(
                      centerTitle: true,
                      // backgroundColor: Colors.white,
                      // automaticallyImplyLeading: false,

                      title: Text(
                        _title(context),
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      actions: _buildActions(
                          context, model, cartModel, clientModel, itemModel),
                      bottom: TabBar(
                        isScrollable: MediaQuery.of(context).orientation ==
                                Orientation.landscape
                            ? true
                            : false,
                        tabs: [
                          for (final tab in tabs) Tab(text: tab),
                        ],
                      ),
                    ),
                    body: _buildTransitionsStack(),
                    floatingActionButton: floatingActionButton(context),
                    bottomNavigationBar: buildBottomNavigationBar(
                        bottomNavigationBarItems, textTheme, colorScheme),
                  );
                }),
              )
            : Scaffold(
                drawer: CustomDrawer(context, model.currentUser),
                appBar: AppBar(
                  centerTitle: true,
                  // backgroundColor: Colors.white,
                  // automaticallyImplyLeading: false,
                  title: Text(
                    _title(context),
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  actions: _buildActions(
                      context, model, cartModel, clientModel, itemModel),
                ),
                // resizeToAvoidBottomPadding: true,
                // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
                floatingActionButton: floatingActionButton(context),
                body: Center(
                  child: _buildTransitionsStack(),
                ),
                bottomNavigationBar: buildBottomNavigationBar(
                    bottomNavigationBarItems, textTheme, colorScheme),
              ));
  }
}
