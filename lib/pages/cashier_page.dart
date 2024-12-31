import 'package:fkasir/pages/history_page.dart';
import 'package:flutter/material.dart';
import 'checkout_page.dart';
import 'package:intl/intl.dart';
import '../widgets/cashier_widget.dart';

class CashierPage extends StatefulWidget {
  const CashierPage({super.key});

  @override
  State<CashierPage> createState() => _CashierPageState();
}

class _CashierPageState extends State<CashierPage> {
  final TextEditingController searchController = TextEditingController();

  // Daftar produk dengan tambahan stok
  final List<Map<String, dynamic>> products = [
    {
      'name': 'Makaroni',
      'category': 'Makanan',
      'price': 'Rp. 20.000',
      'image': 'assets/images/makaroni.jpeg',
      'quantity': 0,
      'stock': 20,
    },
    {
      'name': 'MilkShake',
      'category': 'Minuman',
      'price': 'Rp. 25.000',
      'image': 'assets/images/milkshake.jpeg',
      'quantity': 0,
      'stock': 15,
    },
    {
      'name': 'Ikan Bakar',
      'category': 'Makanan',
      'price': 'Rp. 220.000',
      'image': 'assets/images/ikanbakar.jpeg',
      'quantity': 0,
      'stock': 10,
    },
    {
      'name': 'Seblak',
      'category': 'Makanan',
      'price': 'Rp. 45.000',
      'image': 'assets/images/seblak.jpeg',
      'quantity': 0,
      'stock': 25,
    },
    {
      'name': 'Sop Buah',
      'category': 'Makanan',
      'price': 'Rp. 15.000',
      'image': 'assets/images/sopbuah.jpeg',
      'quantity': 0,
      'stock': 30,
    },
    {
      'name': 'Es Teler',
      'category': 'Minuman',
      'price': 'Rp. 14.000',
      'image': 'assets/images/esteler.jpeg',
      'quantity': 0,
      'stock': 20,
    }
  ];

  List<Map<String, dynamic>> filteredProducts = [];
  List<Map<String, dynamic>> selectedProducts = [];
  int totalPrice = 0;

  @override
  void initState() {
    super.initState();
    filteredProducts = products;
    searchController.addListener(_filterProducts);
  }

  void _filterProducts() {
    final query = searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        filteredProducts = products;
      } else {
        filteredProducts = products.where((product) {
          final name = product['name']?.toLowerCase() ?? '';
          final category = product['category']?.toLowerCase() ?? '';
          return name.contains(query) || category.contains(query);
        }).toList();
      }
    });
  }

  void _updateTotalPrice() {
    int newTotalPrice = 0;
    selectedProducts =
        products.where((product) => product['quantity'] > 0).toList();

    for (var product in selectedProducts) {
      final priceStr =
          product['price']?.replaceAll('Rp. ', '').replaceAll('.', '') ?? '0';
      int productPrice = int.tryParse(priceStr) ?? 0;
      newTotalPrice += (productPrice * product['quantity']).toInt();
    }

    setState(() {
      totalPrice = newTotalPrice;
    });
  }

  void _updateQuantity(Map<String, dynamic> product, bool isIncrement) {
    setState(() {
      if (isIncrement) {
        if (product['stock'] > 0) {
          product['quantity'] += 1;
          product['stock'] -= 1;
        } else {
          _showStockEmptyAlert(product);
        }
      } else {
        if (product['quantity'] > 0) {
          product['quantity'] -= 1;
          product['stock'] += 1;
        }
      }
      _updateTotalPrice();
    });
  }

  void _resetProductQuantities() {
    setState(() {
      for (var product in products) {
        if (product['quantity'] > 0) {
          product['quantity'] = 0;
        }
      }
      totalPrice = 0;
    });
  }

  void _showStockEmptyAlert(Map<String, dynamic> product) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return ScaleTransition(
          scale: CurvedAnimation(
            parent: ModalRoute.of(context)!.animation!,
            curve: Curves.elasticOut,
          ),
          child: Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.red[100],
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.error_outline,
                      size: 50,
                      color: Colors.red[700],
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Stok Habis',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Maaf, stok ${product['name']} sudah habis.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 45,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'OK',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  String formatPrice(int price) {
    final formatter = NumberFormat("#,###", "id_ID");
    return "Total Harga : Rp ${formatter.format(price)}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "F Kasir",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w300),
            ),
            Text(
              "Semoga harimu menyenangkan :)",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ],
        ),
        backgroundColor: Colors.grey[400],
        elevation: 0,
        centerTitle: false,
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
            colors: [
              Colors.grey[400]!,
              Colors.grey[100]!.withOpacity(0.5),
            ],
          ),
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 50, left: 20, right: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextSelectionTheme(
                    data: TextSelectionThemeData(
                      cursorColor: Colors.black,
                      selectionColor: Colors.blue.withOpacity(0.5),
                      selectionHandleColor: Colors.black,
                    ),
                    child: TextFormField(
                      controller: searchController,
                      decoration: InputDecoration(
                        hintText: 'Cari produk...',
                        hintStyle: const TextStyle(color: Colors.black),
                        prefixIcon:
                            const Icon(Icons.search, color: Colors.black),
                        // Mengatur border saat tidak fokus
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: const BorderSide(
                              color: Colors.black,
                              width: 2.0), // Ganti warna border di sini
                        ),
                        // Mengatur border saat fokus
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: const BorderSide(
                              color: Colors.white,
                              width: 2.0), // Ganti warna border di sini
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: ListView.builder(
                      itemCount: filteredProducts.length,
                      itemBuilder: (context, index) {
                        final product = filteredProducts[index];
                        return ProductItem(
                          product: product,
                          onIncrement: (isIncrement) =>
                              _updateQuantity(product, isIncrement),
                          onDecrement: (isDecrement) =>
                              _updateQuantity(product, isDecrement),
                          onShowStockEmptyAlert: _showStockEmptyAlert,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: CheckoutButton(
                totalPrice: totalPrice,
                selectedProducts: selectedProducts,
                onCheckout: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CheckoutPage(
                        totalPrice: totalPrice,
                        selectedProducts: selectedProducts,
                      ),
                    ),
                  );
                  if (result == true) {
                    _resetProductQuantities();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
