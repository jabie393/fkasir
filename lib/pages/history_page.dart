// ignore_for_file: use_key_in_widget_constructors

import 'package:fkasir/widgets/histsory_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/order_history_provider.dart';

class HistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final orderHistory = context.watch<OrderHistoryProvider>().orderHistory;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Riwayat Pesanan',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.grey[400],
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.grey[400]!, Colors.white],
          ),
        ),
        child: orderHistory.isEmpty
            ? const Center(
                child: Text(
                  'Belum ada riwayat pesanan.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: orderHistory.length,
                itemBuilder: (context, index) {
                  return OrderHistoryItem(order: orderHistory[index]);
                },
              ),
      ),
    );
  }
}
