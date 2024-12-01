import 'package:omniwallet/blocs/authentication/bloc/authentication_bloc.dart';
import 'package:omniwallet/pages/router_pages/home_page.dart';
import 'package:omniwallet/pages/router_pages/profile_page.dart';
import 'package:omniwallet/pages/router_pages/tracking_page.dart';
import 'package:omniwallet/pages/router_pages/transactions_page.dart';
import 'package:omniwallet/widgets/scaffold_with_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../model/transaction.dart';
import '../pages/router_pages/new_transaction.dart';
import '../pages/router_pages/transaction_details.dart';

class RouteName {
  static const home = "home";
  static const profile = "profile";
  static const tracking = "tracking";
  static const transaction = "transaction";
  static const transactionDetails = "transactionDetails";
  static const newTransaction = "newTransaction";
}

final GlobalKey<NavigatorState> rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: "Root");
final GlobalKey<NavigatorState> shellNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: "Shell");

GoRouter routerDemo() {
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
            path: '/profile',
            name: RouteName.profile,
            builder: (BuildContext context, GoRouterState state) {
              return const ProfilePage();
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
