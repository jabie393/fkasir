import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OrderHistoryItem extends StatelessWidget {
  final Map<String, dynamic> order;

  const OrderHistoryItem({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tanggal: ${order['date']}',
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            ...order['products'].map<Widget>((product) {
              return Text(
                '- ${product['name']} x${product['quantity']}',
                style: const TextStyle(fontSize: 14, color: Colors.black54),
              );
            }).toList(),
            const SizedBox(height: 8),
            Text(
              'Total Harga: ${NumberFormat("#,###", "id_ID").format(order['totalPrice'])}',
              style: const TextStyle(fontSize: 15, color: Colors.black),
            ),
            const SizedBox(height: 4),
            Text(
              '+ Pembayaran: ${NumberFormat("#,###", "id_ID").format(order['paymentAmount'])}',
              style: const TextStyle(fontSize: 14, color: Colors.green),
            ),
            const SizedBox(height: 4),
            Text(
              '- Kembalian: ${NumberFormat("#,###", "id_ID").format(order['change'])}',
              style: const TextStyle(fontSize: 14, color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}
