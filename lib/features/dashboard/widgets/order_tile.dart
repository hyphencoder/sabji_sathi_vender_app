import 'package:flutter/material.dart';

import '../models/order_model.dart';

class OrderTile extends StatelessWidget {
  const OrderTile({super.key, required this.order});

  final OrderModel order;

  Color _statusColor() {
    switch (order.status) {
      case 'Delivered':
        return Colors.green;
      case 'Pending':
        return Colors.orange;
      case 'Processing':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(child: Text(order.customerName[0])),
      title: Text(order.customerName),
      subtitle: Text(order.id),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            "₹${order.amount.toStringAsFixed(0)}",
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: _statusColor().withOpacity(.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              order.status,
              style: TextStyle(
                fontSize: 11,
                color: _statusColor(),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
