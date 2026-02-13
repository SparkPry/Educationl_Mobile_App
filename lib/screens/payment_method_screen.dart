import 'package:flutter/material.dart';

class PaymentMethodScreen extends StatelessWidget {
  const PaymentMethodScreen({super.key});

  Widget _buildPaymentLogo(String method) {
    IconData iconData;
    Color color;

    switch (method) {
      case 'Visa':
        iconData = Icons.credit_card;
        color = Colors.blue;
        break;
      case 'Mastercard':
        iconData = Icons.credit_card;
        color = Colors.orange;
        break;
      case 'PayPal':
        iconData = Icons.payment;
        color = Colors.indigo;
        break;
      case 'Apple Pay':
        iconData = Icons.apple;
        color = Colors.black;
        break;
      case 'ABA':
        iconData = Icons.account_balance;
        color = Colors.red;
        break;
      default:
        iconData = Icons.help_outline;
        color = Colors.grey;
    }

    return Icon(iconData, color: color, size: 28);
  }

  Widget _buildPaymentOption(String method) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          _buildPaymentLogo(method),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              'Pay with $method',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
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
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              'Preferred method with secure transactions.',
              style: TextStyle(fontSize: 15, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildPaymentOption('Visa'),
                  const SizedBox(height: 16),
                  _buildPaymentOption('Mastercard'),
                  const SizedBox(height: 16),
                  _buildPaymentOption('PayPal'),
                  const SizedBox(height: 16),
                  _buildPaymentOption('Apple Pay'),
                  const SizedBox(height: 16),
                  _buildPaymentOption('ABA'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
