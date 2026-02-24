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
    String logoAsset;
    switch (method.type) {
      case PaymentType.visa:
        logoAsset = 'assets/images/visacard.jpg';
        break;
      case PaymentType.mastercard:
        logoAsset = 'assets/images/mastercard.jpg';
        break;
      default:
        return Container(); // No logo for other types
    }
    return Image.asset(logoAsset, width: 60);
  }

  @override
  Widget build(BuildContext context) {
    if (method.type != PaymentType.visa && method.type != PaymentType.mastercard) {
      // Fallback to a simpler design for non-card types if needed
      return Container(
         padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
        child: Text('Payment Method: ${method.type.name}'),
      );
    }

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
            ),
            Positioned.fill(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.0),
                  gradient: LinearGradient(
                    colors: [Colors.black.withOpacity(0.6), Colors.black.withOpacity(0.2)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Credit Card',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                        _getCardLogo(),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _formatCardNumberForDisplay(method.cardNumber),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            letterSpacing: 2,
                            fontFamily: 'monospace',
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              method.cardHolderName,
                              style: const TextStyle(color: Colors.white, fontSize: 16),
                            ),
                            Text(
                              method.expiryDate,
                              style: const TextStyle(color: Colors.white, fontSize: 16),
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
              )
          ],
        ),
      ),
    );
  }
}
