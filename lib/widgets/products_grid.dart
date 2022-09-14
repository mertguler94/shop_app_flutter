import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/product_item.dart';
import '../providers/products.dart';

class ProductsGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final products = productsData.items;

    return GridView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: products.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemBuilder: ((context, index) => ChangeNotifierProvider.value(
              value: products[index],
              // when the data is not related with context, we can use .value constructor and provide the object.
              // create: ((context) => products[index]),
              child: ProductItem(
                  // do not need below code anymore, since provider is going to be used for passing data.
                  // products[index].id,
                  // products[index].title,
                  // products[index].imageUrl,
                  ),
            )));
  }
}
