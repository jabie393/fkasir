import 'package:flutter/material.dart';

class OrderHistoryProvider with ChangeNotifier {
  List<Map<String, dynamic>> _orderHistory = [];

  List<Map<String, dynamic>> get orderHistory => _orderHistory;

  void addOrder(Map<String, dynamic> order) {
    _orderHistory.add(order);
    notifyListeners(); // Memberitahukan listener untuk memperbarui UI
  }
}
