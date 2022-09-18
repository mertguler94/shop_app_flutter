import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../providers/orders.dart' as ord;

class OrderItem extends StatefulWidget {
  final ord.OrderItem order;

  const OrderItem(this.order, {Key? key}) : super(key: key);

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: Column(children: [
        ListTile(
          title: Text('\$${widget.order.amount.toStringAsFixed(2)}'),
          subtitle: Text(
              DateFormat('dd/MM/yyyy hh:mm').format(widget.order.dateTime)),
          trailing: IconButton(
              onPressed: (() {
                setState(() {
                  _expanded = !_expanded;
                });
              }),
              icon: _expanded
                  ? const Icon(Icons.expand_less)
                  : const Icon(Icons.expand_more)),
        ),
        if (_expanded)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
            height: min(widget.order.products.length * 20.0 + 10.0, 100.0),
            child: ListView.builder(
              itemBuilder: ((context, i) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.order.products[i].title,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${widget.order.products[i].quantity}x \$${widget.order.products[i].price}',
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                );
              }),
              itemCount: widget.order.products.length,
            ),
          )
      ]),
    );
  }
}
