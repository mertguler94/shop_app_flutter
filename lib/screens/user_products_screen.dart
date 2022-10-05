import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/app_drawer.dart';

import '../providers/products.dart';
import '../widgets/user_product_item.dart';
import '../screens/edit_product_screen.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/user-products';

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Products>(context, listen: false)
        .fetchAndSetProducts(true);
  }

  const UserProductsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final productsData = Provider.of<Products>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: [
          IconButton(
              onPressed: (() {
                Navigator.of(context).pushNamed(EditProductScreen.routeName);
              }),
              icon: const Icon(Icons.add))
        ],
      ),
      body: FutureBuilder(
          future: _refreshProducts(context),
          builder: ((context, snapshot) => snapshot.connectionState ==
                  ConnectionState.waiting
              ? const Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                  onRefresh: (() => _refreshProducts(context)),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Consumer<Products>(
                      builder: (context, productsData, _) => ListView.builder(
                        itemCount: productsData.items.length,
                        itemBuilder: ((context, i) => Column(
                              children: [
                                UserProductItem(
                                    productsData.items[i].id,
                                    productsData.items[i].title,
                                    productsData.items[i].imageUrl),
                                const Divider(thickness: 1.5),
                              ],
                            )),
                      ),
                    ),
                  )))),
      drawer: const AppDrawer(),
    );
  }
}
