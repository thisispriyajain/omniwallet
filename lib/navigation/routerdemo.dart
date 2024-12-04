import 'package:omniwallet/blocs/authentication/bloc/authentication_bloc.dart';
import 'package:omniwallet/pages/router_pages/home_page.dart';
import 'package:omniwallet/pages/router_pages/settings_page.dart';
import 'package:omniwallet/pages/router_pages/tracking_page.dart';
import 'package:omniwallet/pages/router_pages/transactions_page.dart';
import 'package:omniwallet/widgets/scaffold_with_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RouteName {
  static const home = "home";
  static const settings = "settings";
  static const tracking = "tracking";
  static const transaction = "transaction";
}

final GlobalKey<NavigatorState> rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: "Root");
final GlobalKey<NavigatorState> shellNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: "Shell");

GoRouter routerDemo(AuthenticationBloc authenticationBloc) {
  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: '/home',
    routes: [
      ShellRoute(
        navigatorKey: shellNavigatorKey,
        builder: (BuildContext context, GoRouterState state, Widget child) {
          return ScaffoldWithNavBar(child: child);
        },
        routes: <RouteBase>[
          GoRoute(
            path: '/home',
            name: RouteName.home,
            builder: (BuildContext context, GoRouterState state) {
              return const HomePage();
            },
          ),
          GoRoute(
            path: '/settings',
            name: RouteName.settings,
            builder: (BuildContext context, GoRouterState state) {
              return const SettingsPage();
            },
          ),
          GoRoute(
            path: '/tracking',
            name: RouteName.tracking,
            builder: (BuildContext context, GoRouterState state) {
              return const TrackingPage();
            },
          ),
          GoRoute(
            path: '/transactions',
            name: RouteName.transaction,
            builder: (BuildContext context, GoRouterState state) {
              return const TransactionsPage();
            },
          ),
        ],
      ),
    ],
  );
}
