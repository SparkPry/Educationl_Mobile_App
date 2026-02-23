import 'package:flutter/material.dart';
import 'package:education_app/utils/app_colors.dart';
import 'package:education_app/models/payment_method.dart';
import 'package:education_app/providers/payment_provider.dart';
import 'package:provider/provider.dart';
import 'add_payment_screen.dart'; 
import 'package:education_app/models/course_model.dart';
import 'e_receipt_screen.dart';

class PaymentScreen extends StatefulWidget {
  final Course course;

  const PaymentScreen({super.key, required this.course});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  PaymentMethod? _selectedSavedMethod;
  PaymentType? _selectedNewType;

  // Placeholder for payment logos - In a real app, these would be proper assets.
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
    return Icon(iconData, color: color, size: 30);
  }

  @override
  Widget build(BuildContext context) {
    final paymentProvider = Provider.of<PaymentProvider>(context);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          'Select payment method',
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                'Preferred method with secure transactions.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 30),
            
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
                  .map((method) => _buildSavedMethodItem(method))
                  .toList(),
              const SizedBox(height: 24),
            ],

            const Text(
              'Select Payment Method',
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
                  _buildPaymentOption('Pay with Mastercard', PaymentType.mastercard),
                  const SizedBox(height: 12),
                  _buildPaymentOption('Pay with PayPal', PaymentType.paypal),
                  const SizedBox(height: 12),
                  _buildPaymentOption('Pay with Apple Pay', PaymentType.applepay),
                  const SizedBox(height: 12),
                  _buildPaymentOption('Pay with ABA', PaymentType.aba),
                ],
              ),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: (_selectedSavedMethod == null && _selectedNewType == null)
                    ? null
                    : () {
                        if (_selectedSavedMethod != null) {
                          // Re-using saved payment
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => EReceiptScreen(course: widget.course),
                            ),
                          );
                        } else if (_selectedNewType != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => AddPaymentScreen(
                                course: widget.course,
                                paymentType: _selectedNewType!,
                              ),
                            ),
                          );
                        }
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
                  style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSavedMethodItem(PaymentMethod method) {
    final isSelected = _selectedSavedMethod?.id == method.id;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedSavedMethod = method;
          _selectedNewType = null;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryColor.withOpacity(0.05) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primaryColor : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
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
            if (isSelected)
              const Icon(Icons.check_circle, color: AppColors.primaryColor)
            else
              const Icon(Icons.circle_outlined, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentOption(String label, PaymentType type) {
    final isSelected = _selectedNewType == type;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedNewType = type;
          _selectedSavedMethod = null;
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
            _buildPaymentLogo(type),
            const SizedBox(width: 15),
            Expanded(
              child: Text(
                label,
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
              )
            else
              const Icon(Icons.circle_outlined, color: Colors.grey, size: 24),
          ],
        ),
      ),
    );
  }
}
