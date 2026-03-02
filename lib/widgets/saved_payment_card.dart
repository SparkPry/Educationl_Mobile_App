import 'package:education_app/models/payment_method.dart';
import 'package:flutter/material.dart';

class SavedPaymentCard extends StatelessWidget {
  final PaymentMethod method;
  final bool isSelected;

  const SavedPaymentCard({
    super.key,
    required this.method,
    this.isSelected = false,
  });

  String _formatCardNumberForDisplay(String fullNumber) {
    if (fullNumber.length < 4) {
      return fullNumber;
    }
    String lastFour = fullNumber.substring(fullNumber.length - 4);
    return '**** **** **** $lastFour';
  }

  Widget _getCardLogo() {
    String logoAsset = '';
    switch (method.type) {
      case PaymentType.visa:
        logoAsset = 'assets/images/visacard.jpg';
        break;
      case PaymentType.mastercard:
        logoAsset = 'assets/images/mastercard.jpg';
        break;
      case PaymentType.paypal:
        logoAsset = 'assets/images/paypal.jpg';
        break;
      default:
        return Container(); // No logo for other types
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: Image.asset(
        logoAsset,
        width: 60,
        errorBuilder: (context, error, stack) => const SizedBox(width: 60, height: 40),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (method.type != PaymentType.visa &&
        method.type != PaymentType.mastercard &&
        method.type != PaymentType.paypal) {
      // Fallback to a simpler design for non-card types (like ABA)
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
            const Icon(Icons.account_balance, color: Colors.red, size: 28),
            const SizedBox(width: 16),
            Text(
              'ABA Account: ${method.cardNumber}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      );
    }

    final bool isPaypal = method.type == PaymentType.paypal;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: isSelected ? Border.all(color: Colors.blue, width: 2) : null,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.0),
        child: Stack(
          children: [
            Image.asset(
              'assets/images/card.jpg',
              fit: BoxFit.cover,
              width: double.infinity,
              height: 200,
              errorBuilder: (context, error, stack) =>
                  Container(color: Colors.grey, width: double.infinity, height: 200),
            ),
            Positioned.fill(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.0),
                  gradient: LinearGradient(
                    colors: isPaypal
                        ? [
                          const Color(0xFF003087).withOpacity(0.9),
                          const Color(0xFF0070BA).withOpacity(0.7),
                        ]
                        : [
                          Colors.black.withOpacity(0.6),
                          Colors.black.withOpacity(0.2),
                        ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            isPaypal ? 'PayPal Account' : 'Credit Card',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        _getCardLogo(),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isPaypal
                              ? method.cardNumber
                              : _formatCardNumberForDisplay(method.cardNumber),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: isPaypal ? 18 : 20,
                            letterSpacing: isPaypal ? 0 : 2,
                            fontFamily: 'monospace',
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              method.cardHolderName,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (!isPaypal)
                              Text(
                                method.expiryDate,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            if (isSelected)
              const Positioned(
                top: 10,
                right: 10,
                child: Icon(Icons.check_circle, color: Colors.white, size: 28),
              ),
          ],
        ),
      ),
    );
  }
}
