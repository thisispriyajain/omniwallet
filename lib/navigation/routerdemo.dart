import 'package:firebase_auth/firebase_auth.dart';
import 'package:omniwallet/blocs/authentication/bloc/authentication_bloc.dart';
import 'package:omniwallet/pages/router_pages/home_page.dart';
import 'package:omniwallet/pages/router_pages/settings_page.dart';
import 'package:omniwallet/pages/router_pages/tracking_page.dart';
import 'package:omniwallet/pages/router_pages/transactions_page.dart';
import 'package:omniwallet/pages/login/landing_page.dart';
import 'package:omniwallet/utilities/stream_to_listenable.dart';
import 'package:omniwallet/widgets/scaffold_with_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';


class RouteName {
  static const home = "home";
  static const settings = "settings";
  static const tracking = "tracking";
  static const transaction = "transaction";
  static const login = "login";
  static const transactionDetails = "transactionDetails";
  static const newTransaction = "newTransaction";
}

final GlobalKey<NavigatorState> rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: "Root");
final GlobalKey<NavigatorState> shellNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: "Shell");

GoRouter routerDemo(AuthenticationBloc authenticationBloc) {
  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: '/home',
    refreshListenable:
        StreamToListenable([FirebaseAuth.instance.authStateChanges()]),
    redirect: (context, state) {
      if (FirebaseAuth.instance.currentUser == null &&
          !(state.fullPath?.startsWith("/login") ?? false)) {
        return "/login";
      }
      return null;
    },
    // refreshListenable: StreamToListenable([authenticationBloc.stream]),
    // redirect: (context, state) async {
    //   final prefs = await SharedPreferences.getInstance();
    //   final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    //   if (isLoggedIn && (state.fullPath?.startsWith("/login") ?? false)) {
    //     return "/home"; //if user is already logged in and trying to access /login, redirect to home
    //   }
    //   // if (!isLoggedIn && (state.fullPath?.startsWith("/login") ?? false)) {
    //   //   return null;
    //   // }
    //   if (!isLoggedIn && !(state.fullPath?.startsWith("/login") ?? false)) {
    //     return "/login"; //if user is not logged in and tries to access other page, redirect to login
    //   }
    //   return null;
    // },
    routes: [
      GoRoute(
          path: '/login',
          name: RouteName.login,
          builder: (BuildContext context, GoRouterState state) {
            return const LandingPage();
          }),
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
              // return TransactionsPage(transactions: Transaction.mockTransactions());
              return const TransactionsPage();
            },
            // routes: [
            //   GoRoute(
            //     path: 'detail',
            //     name: RouteName.transactionDetails,
            //     parentNavigatorKey: rootNavigatorKey,
            //     builder: (BuildContext context, GoRouterState state) {
            //       final transaction = state.extra as Transaction;
            //       return TransactionDetails(transaction: transaction);
            //     },
            //   ),
            //   GoRoute(
            //     path: 'new',
            //     name: RouteName.newTransaction,
            //     parentNavigatorKey: rootNavigatorKey,
            //     builder: (BuildContext context, GoRouterState state) {
            //       return NewTransaction(
            //         onAddTransaction: (newTransaction) {
            //           context.pop();
            //         },
            //       );
            //     },
            //   )
            // ]
          ),
        ],
      ),
    ],
  );
}
