import 'package:flutter/material.dart';

import 'package:education_app/models/payment_method.dart';
import 'package:education_app/providers/payment_provider.dart';
import 'package:education_app/screens/add_payment_screen.dart';
import 'package:provider/provider.dart';

class PaymentMethodScreen extends StatelessWidget {
  const PaymentMethodScreen({super.key});

  Widget _buildPaymentLogo(dynamic method) {
    IconData iconData;
    Color color;

    String methodStr = method is PaymentType ? method.name : method.toString();
    methodStr = methodStr.toLowerCase();

    if (methodStr.contains('visa')) {
      iconData = Icons.credit_card;
      color = Colors.blue;
    } else if (methodStr.contains('mastercard')) {
      iconData = Icons.credit_card;
      color = Colors.orange;
    } else if (methodStr.contains('paypal')) {
      iconData = Icons.payment;
      color = Colors.indigo;
    } else if (methodStr.contains('apple')) {
      iconData = Icons.apple;
      color = Colors.black;
    } else if (methodStr.contains('aba')) {
      iconData = Icons.account_balance;
      color = Colors.red;
    } else {
      iconData = Icons.help_outline;
      color = Colors.grey;
    }

    return Icon(iconData, color: color, size: 28);
  }

  Widget _buildPaymentOption(BuildContext context, String label, PaymentType type) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AddPaymentScreen(paymentType: type),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          children: [
            _buildPaymentLogo(type),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildSavedMethod(PaymentMethod method) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          _buildPaymentLogo(method.type),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  method.cardHolderName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '**** **** **** ${method.lastFourDigits}',
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
          const Icon(Icons.check_circle, color: Colors.green),
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
          'Payment method',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Consumer<PaymentProvider>(
        builder: (context, paymentProvider, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (paymentProvider.savedMethods.isNotEmpty) ...[
                  const Text(
                    'Saved Methods',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...paymentProvider.savedMethods
                      .map((method) => _buildSavedMethod(method))
                      .toList(),
                  const SizedBox(height: 24),
                ],
                const Text(
                  'Add New Method',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 16),
                _buildPaymentOption(context, 'Pay with Visa', PaymentType.visa),
                const SizedBox(height: 16),
                _buildPaymentOption(
                  context,
                  'Pay with Mastercard',
                  PaymentType.mastercard,
                ),
                const SizedBox(height: 16),
                _buildPaymentOption(
                  context,
                  'Pay with PayPal',
                  PaymentType.paypal,
                ),
                const SizedBox(height: 16),
                _buildPaymentOption(
                  context,
                  'Pay with Apple Pay',
                  PaymentType.applepay,
                ),
                const SizedBox(height: 16),
                _buildPaymentOption(context, 'Pay with ABA', PaymentType.aba),
              ],
            ),
          );
        },
      ),
    );
  }
}
