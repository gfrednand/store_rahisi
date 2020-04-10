import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
import 'package:storeRahisi/pages/supplier/supplier_form.dart';
import 'package:storeRahisi/pages/supplier/supplier_list.dart';
import 'package:storeRahisi/providers/auth_model.dart';
import 'package:storeRahisi/providers/cart_model.dart';
import 'package:storeRahisi/providers/item_model.dart';
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
        ? "Products"
        : _currentIndex == 1
            ? "Suppliers"
            : _currentIndex == 2
                ? "Purchases"
                : _currentIndex == 3
                    ? "Expenses"
                    : _currentIndex == 4 ? "POS" : "";
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_navigationViews == null) {
      _navigationViews = <_NavigationIconView>[
        _NavigationIconView(
          icon: const Icon(Icons.select_all),
          title: 'Products',
          vsync: this,
        ),
        _NavigationIconView(
          icon: const Icon(Icons.ac_unit),
          title: 'Suppliers',
          vsync: this,
        ),
        _NavigationIconView(
          icon: const Icon(Icons.view_week),
          title: 'Purchases',
          vsync: this,
        ),
        _NavigationIconView(
          icon: const Icon(Icons.terrain),
          title: 'Expense',
          vsync: this,
        ),
        // _NavigationIconView(
        //   icon: const Icon(Icons.trending_up),
        //   title: 'Reports',
        //   vsync: this,
        // ),
        _NavigationIconView(
          icon: const Icon(Icons.style),
          title: 'POS',
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
                        subtitle: Text('Username'),
                      )
                    : Container(),
                model.currentUser != null
                    ? ListTile(
                        leading: Icon(Icons.email),
                        title: Text("${model.currentUser.email}"),
                        subtitle: Text('Email'),
                      )
                    : Container(),

                model.currentUser != null
                    ? ListTile(
                        leading: Icon(Icons.person_pin),
                        title: Text("${model.currentUser.designation}"),
                        subtitle: Text('Designation'),
                      )
                    : Container(),
                model.currentUser != null
                    ? ListTile(
                        leading: Icon(Icons.phone),
                        title: Text("${model.currentUser.phoneNumber}"),
                        subtitle: Text('Phone Number'),
                      )
                    : Container(),

                model.currentUser != null
                    ? ListTile(
                        leading: Icon(Icons.label_important),
                        title: Text("${model.currentUser.id}"),
                        subtitle: Text('Reference Number'),
                      )
                    : Container(),
                // Divider(),
                SizedBox(
                  width: double.infinity,
                  child: FlatButton(
                      color: Theme.of(context).primaryColor,
                      child: Text(
                        'Logout',
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
                      child: Text('Cancel'),
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
                items = await itemModel.items;
                final List<Item> history = await showSearch(
                    context: context, delegate: ItemSearchDelegate(items));
                items = history;
              },
            )
          : _currentIndex == 4 && cartModel.carts.length > 0
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
          if (value == 'Logout') {
            await model.logout();
            Navigator.of(context).pushReplacementNamed(AppRoutes.splash);
          }
          if (value == 'Profile') {
            var body = _getProfileBody(model);
            _showModalSheetAppBar(context, 'Profile', body, 0.5);
          }
        },
        itemBuilder: (context) => <PopupMenuEntry<String>>[
          PopupMenuItem<String>(
            value: 'Settings',
            child: ListTile(
              leading: Icon(Icons.settings),
              title: Text(
                'Settings',
              ),
            ),
          ),
          PopupMenuItem<String>(
            value: 'Profile',
            child: ListTile(
              leading: Icon(Icons.person_outline),
              title: Text(
                'Profile',
              ),
            ),
          ),
          const PopupMenuDivider(),
          PopupMenuItem<String>(
            value: 'Logout',
            child: ListTile(
              leading: Icon(Icons.remove_circle_outline),
              title: Text(
                'Logout',
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
            ? SupplierList()
            : _currentIndex == 2
                ? PurchaseList()
                : _currentIndex == 4 ? PosItemList() : Container();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    var bottomNavigationBarItems = _navigationViews
        .map<BottomNavigationBarItem>((navigationView) => navigationView.item)
        .toList();
    return BaseView<AuthModel>(
        builder: (context, model, child) => Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                title: Text(_title(context)),
                actions: _buildActions(context, model),
              ),
              // resizeToAvoidBottomPadding: true,
              // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
              floatingActionButton: _currentIndex == 0 ||
                      _currentIndex == 1 ||
                      _currentIndex == 2 ||
                      _currentIndex == 3
                  ? FloatingActionButton(
                      onPressed: () {
                        _currentIndex == 0
                            ? _showModalSheetAppBar(
                                context, 'Add Product', ItemForm(), 0.67)
                            : _currentIndex == 1
                                ? _showModalSheetAppBar(context, 'Add Supplier',
                                    SupplierForm(), 0.7)
                                : _currentIndex == 2
                                    ? Navigator.pushNamed(
                                        context, AppRoutes.purchase_add,
                                        arguments: 'Add Purchase')
                                    : _currentIndex == 3
                                        ? _showModalSheetAppBar(context,
                                            'Add Expense', Container(), 0.5)
                                        : Container();
                      },
                      child: Icon(
                        Icons.add,
                        color: colorScheme.onPrimary,
                      ),
                      tooltip: 'Add',
                    )
                  : Container(),
              body: Center(
                child: _buildTransitionsStack(),
              ),
              bottomNavigationBar: BottomNavigationBar(
                showUnselectedLabels: false,
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
              ),
            ));
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
