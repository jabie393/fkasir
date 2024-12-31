import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/order_history_provider.dart';
import '../widgets/checkout_widget.dart';
import 'history_page.dart'; // Import halaman history

class CheckoutPage extends StatefulWidget {
  final int totalPrice;
  final List<Map<String, dynamic>> selectedProducts;

  const CheckoutPage(
      {super.key, required this.totalPrice, required this.selectedProducts});

  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final TextEditingController paymentController = TextEditingController();
  bool _isProcessingPayment = false;
  String? _paymentError;

  String formatPrice(int price) {
    final formatter = NumberFormat("#,###", "id_ID");
    return "Rp ${formatter.format(price)}";
  }

  void _addOrderToHistory(BuildContext context, int paymentAmount, int change) {
    final newOrder = {
      'date': DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now()),
      'totalPrice': widget.totalPrice,
      'products': widget.selectedProducts,
      'paymentAmount': paymentAmount,
      'change': change,
    };

    // Menambahkan riwayat pesanan menggunakan Provider
    context.read<OrderHistoryProvider>().addOrder(newOrder);
  }

  void _showPaymentSuccessSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Pembayaran tercatat di History'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout',
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.grey[400],
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HistoryPage()),
              );
            },
            padding: const EdgeInsets.only(right: 16.0),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.grey[400]!, Colors.white],
            stops: const [0.0, 0.3],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: widget.selectedProducts.length,
                  itemBuilder: (context, index) {
                    final product = widget.selectedProducts[index];
                    return CheckoutProductItem(product: product);
                  },
                ),
              ),
              const SizedBox(height: 12),
              CheckoutTotalPrice(
                  totalPrice: widget.totalPrice, formatPrice: formatPrice),
              const SizedBox(height: 10),
              // Tombol bayar dengan status loading dan validasi input
              CheckoutPayButton(
                paymentController: paymentController,
                totalPrice: widget.totalPrice,
                formatPrice: formatPrice,
                isProcessing: _isProcessingPayment,
                isFormValid: _paymentError == null &&
                    int.tryParse(paymentController.text) != null &&
                    int.tryParse(paymentController.text)! >= widget.totalPrice,
                onPay: () async {
                  int paymentAmount = int.tryParse(paymentController.text) ?? 0;
                  if (paymentAmount < widget.totalPrice) {
                    setState(() {
                      _paymentError = 'Jumlah uang kurang dari total harga!';
                    });
                    return;
                  }

                  // Menutup dialog pembayaran begitu tombol bayar ditekan
                  Navigator.pop(context);

                  setState(() {
                    _isProcessingPayment = true;
                    _paymentError = null;
                  });

                  // Proses pembayaran
                  await Future.delayed(const Duration(seconds: 1));

                  int change = paymentAmount - widget.totalPrice;

                  setState(() {
                    _isProcessingPayment = false;
                  });

                  // Menambahkan pesanan ke riwayat dan menampilkan Snackbar
                  _addOrderToHistory(context, paymentAmount, change);
                  _showPaymentSuccessSnackbar(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
