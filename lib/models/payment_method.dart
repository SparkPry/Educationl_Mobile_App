enum PaymentType { visa, mastercard, paypal, aba }

class PaymentMethod {
  final String id;
  final String cardHolderName;
  final String cardNumber;
  final String expiryDate;
  final String cvv;
  final PaymentType type;
  final String? streetAddress;
  final String? city;
  final String? zipCode;
  final String? country;
  final String? phoneNumber;

  PaymentMethod({
    required this.id,
    required this.cardHolderName,
    required this.cardNumber,
    required this.expiryDate,
    required this.cvv,
    required this.type,
    this.streetAddress,
    this.city,
    this.zipCode,
    this.country,
    this.phoneNumber,
  });

  String get lastFourDigits {
    if (cardNumber.length < 4) return cardNumber;
    return cardNumber.substring(cardNumber.length - 4);
  }
}
