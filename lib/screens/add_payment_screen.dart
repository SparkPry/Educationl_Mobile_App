import 'package:education_app/models/course_model.dart';
import 'package:education_app/models/payment_method.dart';
import 'package:education_app/providers/payment_provider.dart';
import 'package:education_app/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'e_receipt_screen.dart';

/// =============================
/// CARD NUMBER FORMATTER
/// =============================
class CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String digits = newValue.text.replaceAll(' ', '');

    if (digits.length > 16) {
      digits = digits.substring(0, 16);
    }

    final buffer = StringBuffer();
    for (int i = 0; i < digits.length; i++) {
      buffer.write(digits[i]);
      if ((i + 1) % 4 == 0 && i != digits.length - 1) {
        buffer.write(' ');
      }
    }

    final formatted = buffer.toString();

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

/// =============================
/// EXPIRY FORMATTER (MM/YY)
/// =============================
class ExpiryDateFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String digits = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    if (digits.length > 4) {
      digits = digits.substring(0, 4);
    }

    String formatted = digits;

    if (digits.length > 2) {
      formatted = digits.substring(0, 2) + '/' + digits.substring(2);
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

/// =============================
/// ADD PAYMENT SCREEN
/// =============================
class AddPaymentScreen extends StatefulWidget {
  final Course? course;
  final PaymentType paymentType;

  const AddPaymentScreen({super.key, this.course, required this.paymentType});

  @override
  State<AddPaymentScreen> createState() => _AddPaymentScreenState();
}

class _AddPaymentScreenState extends State<AddPaymentScreen> {
  bool _isLoading = false;

  bool _cardNumberError = false;
  bool _cardHolderError = false;
  bool _expiryError = false;
  bool _cvvError = false;

  final _cardNumberController = TextEditingController();
  final _cardHolderController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _cardNumberController.addListener(_updateCardPreview);
    _cardHolderController.addListener(_updateCardPreview);
    _expiryController.addListener(_updateCardPreview);
    _cvvController.addListener(_updateCardPreview);
  }

  void _updateCardPreview() {
    setState(() {}); // Trigger rebuild to update the card preview
  }

  String _getCardTypeFromNumber(String cardNumber) {
    cardNumber = cardNumber.replaceAll(' ', '');
    if (cardNumber.startsWith('4')) {
      return 'visa';
    } else if (cardNumber.startsWith('5')) {
      return 'mastercard';
    }
    return ''; // Default or unknown
  }

  Widget _getCardLogo() {
    String logoAsset = '';
    switch (widget.paymentType) {
      case PaymentType.visa:
        logoAsset = 'assets/images/visacard.jpg';
        break;
      case PaymentType.mastercard:
        logoAsset = 'assets/images/mastercard.jpg';
        break;
      case PaymentType.paypal:
      case PaymentType.aba:
        return Container(width: 60); // Do not display logo for these types
    }

    if (logoAsset.isNotEmpty) {
      return Image.asset(logoAsset, width: 60);
    }
    return Container(width: 60); // Default empty space
  }

  String _formatCardNumberForPreview(String rawNumber) {
    String digits = rawNumber.replaceAll(' ', '');
    String formatted = '';
    for (int i = 0; i < 16; i++) {
      if (i < digits.length) {
        formatted += digits[i];
      } else {
        formatted += 'x';
      }
      if ((i + 1) % 4 == 0 && i < 15) {
        formatted += ' ';
      }
    }
    return formatted;
  }

  OutlineInputBorder _border(Color color) {
    return OutlineInputBorder(
      borderRadius: const BorderRadius.all(Radius.circular(12)),
      borderSide: BorderSide(color: color, width: 1.5),
    );
  }

  void _handlePayment() {
    setState(() {
      _cardNumberError =
          _cardNumberController.text.replaceAll(' ', '').length != 16;

      _cardHolderError = _cardHolderController.text.trim().isEmpty;

      _expiryError = _expiryController.text.length != 5;

      _cvvError = _cvvController.text.length != 3;
    });

    if (_cardNumberError || _cardHolderError || _expiryError || _cvvError) {
      return;
    }

    setState(() => _isLoading = true);

    // Determine payment type from card number
    PaymentType type = widget.paymentType;
    String cardType = _getCardTypeFromNumber(_cardNumberController.text);
    if(cardType == 'visa') type = PaymentType.visa;
    if(cardType == 'mastercard') type = PaymentType.mastercard;


    // Save payment method
    final paymentMethod = PaymentMethod(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      cardHolderName: _cardHolderController.text,
      cardNumber: _cardNumberController.text.replaceAll(' ', ''),
      expiryDate: _expiryController.text,
      cvv: _cvvController.text,
      type: type,
    );

    Provider.of<PaymentProvider>(context, listen: false)
        .addPaymentMethod(paymentMethod);

    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        if (widget.course != null) {
          String detail = paymentMethod.type.name.toUpperCase();
          // if (paymentMethod.type == PaymentType.visa || paymentMethod.type == PaymentType.mastercard) {
          //   detail += ' ending in ${paymentMethod.lastFourDigits}';
          // }
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => EReceiptScreen(course: widget.course!, paymentMethodDetail: detail),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Payment method saved successfully!')),
          );
          Navigator.pop(context);
        }
      }
    });
  }

  @override
  void dispose() {
    _cardNumberController.removeListener(_updateCardPreview);
    _cardHolderController.removeListener(_updateCardPreview);
    _expiryController.removeListener(_updateCardPreview);
    _cvvController.removeListener(_updateCardPreview);
    _cardNumberController.dispose();
    _cardHolderController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  Widget _buildField({
    required String label,
    required String hint,
    required TextEditingController controller,
    required bool hasError,
    required VoidCallback onChanged,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          onChanged: (_) => onChanged(),
          decoration: InputDecoration(
            hintText: hint,
            border: _border(hasError ? Colors.red : Colors.grey.shade300),
            focusedBorder: _border(
              hasError ? Colors.red : AppColors.primaryColor,
            ),
            errorText: hasError ? "Invalid info" : null,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                      icon: const Icon(Icons.close, size: 30),
                      onPressed: _isLoading
                          ? null
                          : () => Navigator.pop(context),
                    ),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Dynamic Credit Card Preview
                        Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16.0),
                            child: Stack(
                              children: [
                                Image.asset(
                                  'assets/images/card.jpg',
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: 220, // Increased height for CVV
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
                                              _formatCardNumberForPreview(_cardNumberController.text),
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 22,
                                                letterSpacing: 2,
                                                fontFamily: 'monospace',
                                              ),
                                            ),
                                            const SizedBox(height: 15),
                                            Row(
                                              children: [
                                                Expanded(
                                                  flex: 3,
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      const Text("Card Holder", style: TextStyle(color: Colors.white70, fontSize: 12)),
                                                      Text(
                                                        _cardHolderController.text.isEmpty ? 'CARD HOLDER' : _cardHolderController.text.toUpperCase(),
                                                        style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                                                      ),
                                                    ],
                                                  )
                                                ),
                                                Expanded(
                                                  flex: 2,
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      const Text("Expires", style: TextStyle(color: Colors.white70, fontSize: 12)),
                                                      Text(
                                                        _expiryController.text.isEmpty ? 'MM/YY' : _expiryController.text,
                                                        style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 1,
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      const Text("CVV", style: TextStyle(color: Colors.white70, fontSize: 12)),
                                                      Text(
                                                         _cvvController.text.isEmpty ? 'xxx' : _cvvController.text,
                                                        style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                                                      ),
                                                    ],
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
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),

                        /// CARD NUMBER
                        _buildField(
                          label: "Card number",
                          hint: "xxxx xxxx xxxx xxxx",
                          controller: _cardNumberController,
                          hasError: _cardNumberError,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            CardNumberFormatter(),
                          ],
                          onChanged: () {
                            if (_cardNumberError) {
                              setState(() => _cardNumberError = false);
                            }
                            _updateCardPreview();
                          },
                        ),

                        const SizedBox(height: 16),

                        /// CARD HOLDER (letters only)
                        _buildField(
                          label: "Card holder name",
                          hint: "e.g. John Doe",
                          controller: _cardHolderController,
                          hasError: _cardHolderError,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                              RegExp(r'[a-zA-Z ]'),
                            ),
                          ],
                          onChanged: () {
                            if (_cardHolderError) {
                              setState(() => _cardHolderError = false);
                            }
                            _updateCardPreview();
                          },
                        ),

                        const SizedBox(height: 16),

                        Row(
                          children: [
                            /// EXPIRY
                            Expanded(
                              child: _buildField(
                                label: "Expiry date",
                                hint: "MM/YY",
                                controller: _expiryController,
                                hasError: _expiryError,
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  ExpiryDateFormatter(),
                                ],
                                onChanged: () {
                                  if (_expiryError) {
                                    setState(() => _expiryError = false);
                                  }
                                  _updateCardPreview();
                                },
                              ),
                            ),
                            const SizedBox(width: 16),

                            /// CVV
                            Expanded(
                              child: _buildField(
                                label: "CVV",
                                hint: "123",
                                controller: _cvvController,
                                hasError: _cvvError,
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(3),
                                ],
                                onChanged: () {
                                  if (_cvvError) {
                                    setState(() => _cvvError = false);
                                  }
                                   _updateCardPreview();
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                /// BOTTOM BAR
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 20.0,
                  ),
                  child: Row(
                    mainAxisAlignment: widget.course != null 
                        ? MainAxisAlignment.spaceBetween 
                        : MainAxisAlignment.center,
                    children: [
                      if (widget.course != null)
                        Text(
                          'Total: \$${(widget.course!.discountPrice ?? widget.course!.price).toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      if (widget.course == null)
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _handlePayment,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryColor,
                              shape: const StadiumBorder(),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 32,
                                vertical: 16,
                              ),
                              minimumSize: const Size(double.infinity, 56),
                            ),
                            child: const Text(
                              'Save Payment',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        )
                      else
                        ElevatedButton(
                          onPressed: _handlePayment,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryColor,
                            shape: const StadiumBorder(),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 16,
                            ),
                          ),
                          child: const Text(
                            'Continue',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }
}
