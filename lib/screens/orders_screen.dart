import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/orders.dart' show Orders;
import '../widgets/order_item.dart';
import '../widgets/app_drawer.dart';

class OrdersScreen extends StatefulWidget {
  static const routeName = '/orders';

  const OrdersScreen({Key? key}) : super(key: key);

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  // Commented out because FutureBuilder widget is going to be used instead of this.

  // var _isInit = true;
  // var _isLoading = false;

  // @override
  // void didChangeDependencies() {

  //   super.didChangeDependencies();
  //   if (_isInit) {
  //     setState(() {
  //       _isLoading = true;
  //     });
  //     Provider.of<Orders>(context, listen: false).fetchAndSetOrders().then((_) {
  //       setState(() {
  //         _isLoading = false;
  //       });
  //     });
  //   }
  //   _isInit = false;
  // }

  late Future _ordersFuture;

  Future _obtainOrdersFuture() {
    return Provider.of<Orders>(context, listen: false).fetchAndSetOrders();
  }

  @override
  void initState() {
    super.initState();
    _ordersFuture = _obtainOrdersFuture();
  }

  @override
  Widget build(BuildContext context) {
    // final orderData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Orders'),
      ),
      drawer: const AppDrawer(),
      body: FutureBuilder(
        future: _ordersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            if (snapshot.error != null) {
              return const Center(child: Text('An error occurred!'));
            } else {
              return Consumer<Orders>(
                builder: (context, orderData, child) => ListView.builder(
                    itemBuilder: ((context, i) =>
                        OrderItem(orderData.orders[i])),
                    itemCount: orderData.orders.length),
              );
            }
          }
        },
      ),
    );
  }
}



// _isLoading
//           ? const Center(
//               child: CircularProgressIndicator(),
//             )
//           : ListView.builder(
//               itemBuilder: ((context, i) => OrderItem(orderData.orders[i])),
//               itemCount: orderData.orders.length)