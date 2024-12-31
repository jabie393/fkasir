import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProductItem extends StatelessWidget {
  final Map<String, dynamic> product;
  final Function(bool) onIncrement;
  final Function(bool) onDecrement;
  final Function(Map<String, dynamic>) onShowStockEmptyAlert;

  const ProductItem({
    super.key,
    required this.product,
    required this.onIncrement,
    required this.onDecrement,
    required this.onShowStockEmptyAlert,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                product['image'] ?? '',
                width: 60,
                height: 60,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product['name'] ?? '',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    product['category'] ?? '',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          product['price'] ?? '',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Stok: ${product['stock']}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.remove_circle_outline,
                    color: Colors.red,
                    size: 20,
                  ),
                  onPressed:
                      product['quantity'] > 0 ? () => onDecrement(false) : null,
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    "${product['quantity']}",
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.add_circle_outline,
                    color: Colors.green,
                    size: 20,
                  ),
                  onPressed: product['stock'] > 0
                      ? () => onIncrement(true)
                      : () => onShowStockEmptyAlert(product),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CheckoutButton extends StatelessWidget {
  final int totalPrice;
  final List<Map<String, dynamic>> selectedProducts;
  final Function() onCheckout;

  const CheckoutButton({
    super.key,
    required this.totalPrice,
    required this.selectedProducts,
    required this.onCheckout,
  });

  String formatPrice(int price) {
    final formatter = NumberFormat("#,###", "id_ID");
    return "Total Harga : Rp ${formatter.format(price)}";
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: totalPrice > 0 ? onCheckout : null,
      child: Container(
        margin: const EdgeInsets.all(20),
        height: 55,
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  formatPrice(totalPrice),
                  style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.shopping_cart_checkout_outlined,
                  color: Colors.white,
                ),
                onPressed: totalPrice > 0 ? onCheckout : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
