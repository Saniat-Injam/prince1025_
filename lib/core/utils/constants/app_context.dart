import 'package:flutter/widgets.dart';

class AppContext {
  static final GlobalKey<NavigatorState> navigatorkey =
      GlobalKey<NavigatorState>();
  static BuildContext get context => navigatorkey.currentContext!;
}
