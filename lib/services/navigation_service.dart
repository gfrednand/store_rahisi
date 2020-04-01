import 'package:flutter/material.dart';

class NavigationService {
  final GlobalKey<NavigatorState> navigatorKey =
      new GlobalKey<NavigatorState>();

  pop() {
    return navigatorKey.currentState.pop();
  }

  Future<dynamic> navigateTo({String routeName, Object arguments}) {
    return navigatorKey.currentState
        .pushReplacementNamed(routeName, arguments: arguments);
  }
}
