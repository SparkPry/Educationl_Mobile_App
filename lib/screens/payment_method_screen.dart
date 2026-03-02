import 'package:education_app/utils/app_colors.dart';
import 'package:education_app/widgets/saved_payment_card.dart';
import 'package:education_app/widgets/simple_payment_method_item.dart';
import 'package:flutter/material.dart';

import 'package:education_app/models/payment_method.dart';
import 'package:education_app/providers/payment_provider.dart';
import 'package:education_app/screens/add_payment_screen.dart';
import 'package:provider/provider.dart';

class PaymentMethodScreen extends StatefulWidget {
  const PaymentMethodScreen({super.key});

  @override
  State<PaymentMethodScreen> createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  PaymentType? _selectedNewType;

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
    } else if (methodStr.contains('aba')) {
      iconData = Icons.account_balance;
      color = Colors.red;
    } else {
      iconData = Icons.help_outline;
      color = Colors.grey;
    }

    return Icon(iconData, color: color, size: 28);
  }

  Widget _buildPaymentOption(String label, PaymentType type) {
    final bool isSelected = _selectedNewType == type;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedNewType = type;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryColor.withOpacity(0.05)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: isSelected ? AppColors.primaryColor : Colors.grey.shade300,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            _buildPaymentLogo(type),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ),
            Icon(
              isSelected ? Icons.check_circle : Icons.circle_outlined,
              color: isSelected ? AppColors.primaryColor : Colors.grey,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSavedMethod(BuildContext context, PaymentMethod method) {
    if (method.type == PaymentType.visa ||
        method.type == PaymentType.mastercard ||
        method.type == PaymentType.paypal) {
      return SavedPaymentCard(
        method: method,
        isSelected: false,
      );
    } else {
      return SimplePaymentMethodItem(
        method: method,
        isSelected: false,
        onTap: () {},
      );
    }
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
          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
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
                            .map((method) => _buildSavedMethod(context, method))
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
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            _buildPaymentOption('Pay with Visa', PaymentType.visa),
                            const SizedBox(height: 12),
                            _buildPaymentOption(
                              'Pay with Mastercard',
                              PaymentType.mastercard,
                            ),
                            const SizedBox(height: 12),
                            _buildPaymentOption('Pay with PayPal', PaymentType.paypal),
                            const SizedBox(height: 12),
                            _buildPaymentOption('Pay with ABA QR', PaymentType.aba),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
              // Continue Button
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _selectedNewType == null
                        ? null
                        : () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AddPaymentScreen(
                                  paymentType: _selectedNewType!,
                                ),
                              ),
                            );
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      disabledBackgroundColor: Colors.grey.shade300,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      'Continue',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
