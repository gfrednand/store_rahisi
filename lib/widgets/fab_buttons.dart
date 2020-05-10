import 'package:flutter/material.dart';
import 'package:storeRahisi/constants/routes.dart';

class AppBottonNavBar extends StatefulWidget {
  const AppBottonNavBar({
    Key key,
    @required this.context,
  }) : super(key: key);

  final BuildContext context;

  @override
  _AppBottonNavBarState createState() => _AppBottonNavBarState();
}

class _AppBottonNavBarState extends State<AppBottonNavBar>
    with TickerProviderStateMixin {
  List<_NavigationIconView> _navigationViews;
  int _currentIndex = 0;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_navigationViews == null) {
      _navigationViews = <_NavigationIconView>[
        _NavigationIconView(
          icon: const Icon(Icons.home),
          title: 'Home ',
          vsync: this,
        ),
        _NavigationIconView(
          icon: const Icon(Icons.select_all),
          title: 'Products',
          vsync: this,
        ),
        _NavigationIconView(
          icon: const Icon(Icons.ac_unit),
          title: 'Clients',
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

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    setState(() {
      // _currentIndex = model.index;
    });
    var bottomNavigationBarItems = _navigationViews
        .map<BottomNavigationBarItem>((navigationView) => navigationView.item)
        .toList();
    return BottomNavigationBar(
      showUnselectedLabels: false,
      items: bottomNavigationBarItems,
      currentIndex: _currentIndex,
      type: BottomNavigationBarType.fixed,
      selectedFontSize: textTheme.caption.fontSize,
      unselectedFontSize: textTheme.caption.fontSize,
      onTap: (index) {
        // setState(() {
        _navigationViews[_currentIndex].controller.reverse();
        // _currentIndex = index;
        index == 0
            ? Navigator.pushNamed(context, AppRoutes.home)
            : index == 1 ? Navigator.pushNamed(context, AppRoutes.client) : Container();
        // model.setCurrentIndex(index);
        _navigationViews[_currentIndex].controller.forward();
        // });
      },
      selectedItemColor: colorScheme.onPrimary,
      unselectedItemColor: colorScheme.onPrimary.withOpacity(0.38),
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
