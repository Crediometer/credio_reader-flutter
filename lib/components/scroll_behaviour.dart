import 'package:flutter/widgets.dart';

class CredioScrollAttitude extends ScrollBehavior {
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
