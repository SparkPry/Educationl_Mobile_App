import 'package:education_app/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'screens/add_payment_screen.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String? _selectedPaymentMethod;

  // Placeholder for payment logos - In a real app, these would be proper assets.
  Widget _buildPaymentLogo(String method) {
    IconData iconData;
    Color color;
    switch (method) {
      case 'Visa':
        iconData = Icons.credit_card;
        color = Colors.blue;
        break;
      case 'Mastercard':
        iconData = Icons.credit_card; // Using generic icon for now
        color = Colors.orange;
        break;
      case 'PayPal':
        iconData = Icons.payment; // Using generic icon for now
        color = Colors.indigo;
        break;
      case 'Apple Pay':
        iconData = Icons.apple;
        color = Colors.black;
        break;
      case 'Stripe':
        iconData = Icons.payments; // Using generic icon for now
        color = AppColors.primaryColor;
        break;
      case 'ABA':
        iconData = Icons.account_balance; // Using a relevant icon for a bank
        color = Colors.red; // Assuming a distinct color for ABA
        break;
      default:
        iconData = Icons.help_outline;
        color = Colors.grey;
    }
    return Icon(iconData, color: color, size: 30);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          'Select payment method',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Preferred method with secure transactions.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            Expanded(
              child: Center(
                child: Container(
                  width: double.infinity,
                  constraints: const BoxConstraints(
                    maxWidth: 400,
                  ), // Max width for responsiveness
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 5,
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildPaymentOption('Visa'),
                      const SizedBox(height: 15),
                      _buildPaymentOption('Mastercard'),
                      const SizedBox(height: 15),
                      _buildPaymentOption('PayPal'),
                      const SizedBox(height: 15),
                      _buildPaymentOption('Apple Pay'),
                      const SizedBox(height: 15),
                      _buildPaymentOption('ABA'),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AddPaymentScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: const Text(
                  'Continue',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 15),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Go Back',
                style: TextStyle(fontSize: 16, color: AppColors.primaryColor),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentOption(String method) {
    final isSelected = _selectedPaymentMethod == method;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPaymentMethod = method;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryColor.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: isSelected ? AppColors.primaryColor : Colors.grey.shade300,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            _buildPaymentLogo(method),
            const SizedBox(width: 15),
            Expanded(
              child: Text(
                'Pay with $method',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: Colors.black87,
                ),
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: AppColors.primaryColor,
                size: 24,
              ),
          ],
        ),
      ),
    );
  }
}
