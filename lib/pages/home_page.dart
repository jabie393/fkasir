import 'package:flutter/material.dart';
import 'cashier_page.dart'; // Import CashierPage

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Colors.grey[400]!], // Lighter gradient
            stops: const [0.0, 1.0],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                width: 100, // Increased size
                height: 100, // Increased size
                child: Image(
                    image: AssetImage(
                        'assets/images/fkasirlogo.png')), // Ensure logo is visible
              ),
              const SizedBox(height: 10),
              const Text(
                'Welcome to F Kasir',
                style: TextStyle(
                  color: Colors.black, // Changed to blue for contrast
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                'Your reliable cashier solution',
                style: TextStyle(
                  color:
                      Colors.blueGrey, // Changed to a darker shade for contrast
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Navigate to the Cashier Page
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const CashierPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black, // Button color
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 5, // Added shadow
                ),
                child: const Text(
                  'Get Started',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18, // Increased font size
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
