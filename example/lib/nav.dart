import 'package:flutter/material.dart';

class NavigationService {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Future<dynamic> navigateTo(String routeName) {
    return navigatorKey.currentState!
        .pushNamedAndRemoveUntil(routeName, (route) => false);
  }

  Future<dynamic> navigateToArg(
    String routeName,
    dynamic args,
  ) {
    return navigatorKey.currentState!.pushNamedAndRemoveUntil(
      routeName,
      (route) => false,
      arguments: args,
    );
  }

  Future<dynamic> showDialogue(Widget child) {
    return showDialog(
        context: navigatorKey.currentContext!, builder: (context) => child);
  }
}
