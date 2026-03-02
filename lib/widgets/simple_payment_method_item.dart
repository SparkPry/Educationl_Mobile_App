import 'package:flutter/material.dart';
import 'package:education_app/models/payment_method.dart';
import 'package:education_app/utils/app_colors.dart';

class SimplePaymentMethodItem extends StatelessWidget {
  final PaymentMethod method;
  final bool isSelected;
  final VoidCallback? onTap;

  const SimplePaymentMethodItem({
    super.key,
    required this.method,
    this.isSelected = false,
    this.onTap,
  });

  Widget _buildPaymentLogo(PaymentType type) {
    IconData iconData;
    Color color;

    String methodStr = type.name.toLowerCase();

    if (methodStr.contains('paypal')) {
      iconData = Icons.payment;
      color = Colors.indigo;
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
    return GestureDetector(
      onTap: onTap,
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
              child: Text(
                '${method.type.name.toUpperCase()}', // Displaying type name for simplicity
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
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
}
