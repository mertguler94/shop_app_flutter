import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './screens/product_detail_screen.dart';
import './screens/products_overview_screen.dart';
import './providers/products.dart';
import './providers/cart.dart';
import './providers/auth.dart';
import './screens/cart_screen.dart';
import './providers/orders.dart';
import './screens/orders_screen.dart';
import './screens/user_products_screen.dart';
import './screens/edit_product_screen.dart';
import './screens/auth_screen.dart';
import './screens/splash_screen.dart';

Future main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: ((context) => Auth())),
          ChangeNotifierProxyProvider<Auth, Products?>(
            create: ((context) => Products()),
            update: ((context, auth, previousProducts) {
              previousProducts?.authToken = auth.token;
              return previousProducts?..userId = auth.userId;
            }),
          ),
          ChangeNotifierProvider(create: ((context) => Cart())),
          ChangeNotifierProxyProvider<Auth, Orders?>(
            create: ((context) => Orders()),
            update: ((context, auth, previousOrders) {
              previousOrders?.authToken = auth.token!;
              return previousOrders?..userId = auth.userId;
            }),
          ),
        ],
        child: Consumer<Auth>(
            builder: ((context, auth, _) => MaterialApp(
                  debugShowCheckedModeBanner: false,
                  title: 'Flutter Demo',
                  theme: ThemeData(
                    colorScheme:
                        ColorScheme.fromSwatch(primarySwatch: Colors.purple)
                            .copyWith(secondary: Colors.deepOrange),
                    fontFamily: 'Lato',
                  ),
                  home: auth.isAuth
                      ? const ProductsOverviewScreen()
                      : FutureBuilder(
                          future: auth.tryAutoLogin(),
                          builder: ((context, authResult) =>
                              authResult.connectionState ==
                                      ConnectionState.waiting
                                  ? const SplashScreen()
                                  : const AuthScreen()),
                        ),
                  routes: {
                    ProductDetailScreen.routeName: ((context) =>
                        const ProductDetailScreen()),
                    CartScreen.routeName: ((context) => const CartScreen()),
                    OrdersScreen.routeName: ((context) => const OrdersScreen()),
                    UserProductsScreen.routeName: ((context) =>
                        const UserProductsScreen()),
                    EditProductScreen.routeName: ((context) =>
                        const EditProductScreen())
                  },
                ))));
  }
}
