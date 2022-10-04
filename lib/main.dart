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
        ChangeNotifierProvider(create: ((context) => Products())),
        ChangeNotifierProvider(create: ((context) => Cart())),
        ChangeNotifierProvider(create: ((context) => Orders())),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.purple)
              .copyWith(secondary: Colors.deepOrange),
          fontFamily: 'Lato',
        ),
        home: const AuthScreen(),
        routes: {
          ProductDetailScreen.routeName: ((context) =>
              const ProductDetailScreen()),
          CartScreen.routeName: ((context) => const CartScreen()),
          OrdersScreen.routeName: ((context) => const OrdersScreen()),
          UserProductsScreen.routeName: ((context) =>
              const UserProductsScreen()),
          EditProductScreen.routeName: ((context) => const EditProductScreen())
        },
      ),
    );
  }
}
