// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storeRahisi/app_localizations.dart';
import 'package:storeRahisi/constants/app_constants.dart';
import 'package:storeRahisi/constants/routes.dart';
import 'package:storeRahisi/models/item.dart';
import 'package:storeRahisi/models/user.dart';
import 'package:storeRahisi/pages/base_view.dart';
import 'package:storeRahisi/pages/home_page.dart';
import 'package:storeRahisi/pages/item/item_form.dart';
import 'package:storeRahisi/pages/item/item_list.dart';
import 'package:storeRahisi/pages/item/item_search_delegate.dart';
import 'package:storeRahisi/pages/pos/pos_item_list.dart';
import 'package:storeRahisi/pages/purchase/purchase_form.dart';
import 'package:storeRahisi/pages/purchase/purchase_list.dart';
import 'package:storeRahisi/pages/client/client_form.dart';
import 'package:storeRahisi/pages/client/client_list.dart';
import 'package:storeRahisi/providers/auth_model.dart';
import 'package:storeRahisi/providers/cart_model.dart';
import 'package:storeRahisi/providers/item_model.dart';
import 'package:storeRahisi/widgets/app_drawer.dart';
import 'package:storeRahisi/widgets/cart_button.dart';
import 'package:storeRahisi/widgets/custom_modal_sheet.dart';

class LayoutPage extends StatefulWidget {
  const LayoutPage({Key key}) : super(key: key);
  @override
  _LayoutPageState createState() => _LayoutPageState();
}

class _LayoutPageState extends State<LayoutPage> with TickerProviderStateMixin {
  int _currentIndex = 0;
  List<_NavigationIconView> _navigationViews;
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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_navigationViews == null) {
      _navigationViews = <_NavigationIconView>[
        _NavigationIconView(
          icon: const Icon(Icons.select_all),
          title: AppLocalizations.of(context).translate('items'),
          vsync: this,
        ),
        _NavigationIconView(
          icon: const Icon(Icons.ac_unit),
          title: AppLocalizations.of(context).translate('clients'),
          vsync: this,
        ),
        _NavigationIconView(
          icon: const Icon(Icons.view_week),
          title: AppLocalizations.of(context).translate('purchases'),
          vsync: this,
        ),
        _NavigationIconView(
          icon: const Icon(Icons.style),
          title: AppLocalizations.of(context).translate('pos'),
          vsync: this,
        ),
      ];

      _navigationViews[_currentIndex].controller.value = 1;
    }
  }

  @override
  void dispose() {
    for (_NavigationIconView view in _navigationViews) {
      view.controller.dispose();
    }
    super.dispose();
  }

  _getProfileBody(AuthModel model) {
    return ListView(
      children: <Widget>[
        Container(
            decoration: new BoxDecoration(
                color: Colors.white,
                borderRadius:
                    new BorderRadius.all(const Radius.circular(10.0))),
            child: Column(
              children: <Widget>[
                model.currentUser != null
                    ? ListTile(
                        leading: Icon(Icons.person),
                        title: Text(
                            '${model.currentUser.fname} ${model.currentUser.lname}'),
                        subtitle: Text(
                            AppLocalizations.of(context).translate('username')),
                      )
                    : Container(),
                model.currentUser != null
                    ? ListTile(
                        leading: Icon(Icons.email),
                        title: Text("${model.currentUser.email}"),
                        subtitle: Text(
                            AppLocalizations.of(context).translate('email')),
                      )
                    : Container(),

                model.currentUser != null
                    ? ListTile(
                        leading: Icon(Icons.person_pin),
                        title: Text("${model.currentUser.designation}"),
                        subtitle: Text(AppLocalizations.of(context)
                            .translate('designation')),
                      )
                    : Container(),
                model.currentUser != null
                    ? ListTile(
                        leading: Icon(Icons.phone),
                        title: Text("${model.currentUser.phoneNumber}"),
                        subtitle: Text(AppLocalizations.of(context)
                            .translate('phoneNumber')),
                      )
                    : Container(),

                model.currentUser != null
                    ? ListTile(
                        leading: Icon(Icons.label_important),
                        title: Text("${model.currentUser.id}"),
                        subtitle: Text(AppLocalizations.of(context)
                            .translate('referenceNumber')),
                      )
                    : Container(),
                // Divider(),
                SizedBox(
                  width: double.infinity,
                  child: FlatButton(
                      color: Theme.of(context).primaryColor,
                      child: Text(
                        AppLocalizations.of(context).translate('logout'),
                        style: TextStyle(color: Theme.of(context).accentColor),
                      ),
                      onPressed: () async {
                        bool loggedOut = await model.logout();
                        if (loggedOut) {
                          Navigator.pushReplacementNamed(
                              context, AppRoutes.login);
                        }
                      }),
                ),
                SizedBox(
                  width: double.infinity,
                  child: FlatButton(
                      child: Text(
                          AppLocalizations.of(context).translate('cancel')),
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                ),
              ],
            )),
        //  Divider(),
      ],
    );
  }

  _buildActions(BuildContext context, AuthModel model) {
    CartModel cartModel = Provider.of<CartModel>(context);
    return <Widget>[
      _currentIndex == 0
          ? IconButton(
              icon: const Icon(Icons.search),
              onPressed: () async {
                ItemModel itemModel =
                    Provider.of<ItemModel>(context, listen: false);
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
                    Navigator.of(context).pushNamed(AppRoutes.cart_items);
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
                AppLocalizations.of(context).translate('profile'), body, 0.5);
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

  _showModalSheetAppBar(
      BuildContext context, String title, Widget body, double heightFactor) {
    CustomModalSheet.show(
      title: title,
      context: context,
      body: body,
      heightFactor: heightFactor,
    );
  }

  Widget _buildTransitionsStack() {
    return _currentIndex == 0
        ? ItemList()
        : _currentIndex == 1
            ? TabBarView(children: [
                ClientList(
                  clientType: AppConstants.clientTypeSupplier,
                ),
                ClientList(
                  clientType: AppConstants.clientTypeCustomer,
                ),
              ])
            : _currentIndex == 2
                ? PurchaseList()
                : _currentIndex == 3 ? PosItemList() : Container();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    List<String> tabs = [
      AppLocalizations.of(context).translate('suppliers'),
      AppLocalizations.of(context).translate('customers'),
    ];
    var bottomNavigationBarItems = _navigationViews
        .map<BottomNavigationBarItem>((navigationView) => navigationView.item)
        .toList();
    return BaseView<AuthModel>(
        builder: (context, model, child) => _currentIndex == 1
            ? DefaultTabController(
                length: tabs.length,
                child: Builder(builder: (BuildContext context) {
                  return Scaffold(
                    drawer: CustomDrawer(context),
                    appBar: AppBar(
                      centerTitle: true,
                      // automaticallyImplyLeading: false,
                      title: Text(_title(context)),
                      actions: _buildActions(context, model),
                      bottom: TabBar(
                        isScrollable: false,
                        tabs: [
                          for (final tab in tabs) Tab(text: tab),
                        ],
                      ),
                    ),
                    body: _buildTransitionsStack(),
                    floatingActionButton:
                        floatingActionButton(context, colorScheme),
                    bottomNavigationBar: buildBottomNavigationBar(
                        bottomNavigationBarItems, textTheme, colorScheme),
                  );
                }),
              )
            : Scaffold(
                drawer: CustomDrawer(context),
                appBar: AppBar(
                  centerTitle: true,
                  // automaticallyImplyLeading: false,
                  title: Text(_title(context)),
                  actions: _buildActions(context, model),
                ),
                // resizeToAvoidBottomPadding: true,
                // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
                floatingActionButton:
                    floatingActionButton(context, colorScheme),
                body: Center(
                  child: _buildTransitionsStack(),
                ),
                bottomNavigationBar: buildBottomNavigationBar(
                    bottomNavigationBarItems, textTheme, colorScheme),
              ));
  }

  StatelessWidget floatingActionButton(
      BuildContext context, ColorScheme colorScheme) {
    return _currentIndex == 0 || _currentIndex == 1 || _currentIndex == 2
        ? FloatingActionButton(
            onPressed: () {
              int tabIndex = _currentIndex == 1
                  ? DefaultTabController.of(context).index
                  : 0;
              _currentIndex == 0
                  ? _showModalSheetAppBar(
                      context,
                      AppLocalizations.of(context).translate('addItem'),
                      ItemForm(),
                      0.67)
                  : _currentIndex == 1
                      ? _showModalSheetAppBar(
                          context,
                          tabIndex == 0
                              ? AppLocalizations.of(context).translate('add') +
                                  ' ' +
                                  AppConstants.clientTypeSupplier
                              : AppLocalizations.of(context).translate('add') +
                                  ' ' +
                                  AppConstants.clientTypeCustomer,
                          ClientForm(
                            clientType: tabIndex == 0
                                ? AppConstants.clientTypeSupplier
                                : AppConstants.clientTypeCustomer,
                          ),
                          0.7)
                      : _currentIndex == 2
                          ? Navigator.pushNamed(context, AppRoutes.purchase_add,
                              arguments: AppLocalizations.of(context)
                                  .translate('addPurchase'))
                          : Container();
            },
            child: Icon(
              Icons.add,
              color: colorScheme.onPrimary,
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
          _navigationViews[_currentIndex].controller.reverse();
          _currentIndex = index;
          _navigationViews[_currentIndex].controller.forward();
        });
      },
      selectedItemColor: colorScheme.secondary,
      // unselectedItemColor: colorScheme.onPrimary.withOpacity(0.4),
      backgroundColor: colorScheme.primary,
    );
  }
}

class _NavigationIconView {
  _NavigationIconView({
    this.title,
    this.icon,
    TickerProvider vsync,
  })  : item = BottomNavigationBarItem(
          icon: icon,
          title: Text(title),
        ),
        controller = AnimationController(
          duration: kThemeAnimationDuration,
          vsync: vsync,
        ) {
    _animation = controller.drive(CurveTween(
      curve: const Interval(0.5, 1.0, curve: Curves.fastOutSlowIn),
    ));
  }

  final String title;
  final Widget icon;
  final BottomNavigationBarItem item;
  final AnimationController controller;
  Animation<double> _animation;

  FadeTransition transition(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: Stack(
        children: [
          // ExcludeSemantics(
          //   child: Center(
          //     child: Padding(
          //       padding: const EdgeInsets.all(16),
          //       child: ClipRRect(
          //         borderRadius: BorderRadius.circular(8),
          //         child: Image.asset(
          //           'assets/demos/bottom_navigation_background.png',
          //         ),
          //       ),
          //     ),
          //   ),
          // ),
          Center(
            child: IconTheme(
              data: IconThemeData(
                color: Colors.white,
                size: 80,
              ),
              child: Semantics(
                label: 'Noma',
                child: icon,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
