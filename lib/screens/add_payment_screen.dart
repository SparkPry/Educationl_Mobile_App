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

  // Billing Address Controllers
  final _streetController = TextEditingController();
  final _cityController = TextEditingController();
  final _postcodeController = TextEditingController();
  final _phoneController = TextEditingController();

  String? _selectedCountry;
  int _selectedCountryIndex = 0;

  final List<String> _countries = [
    'Cambodia',
    'Vietnam',
    'Thailand',
    'Singapore',
    'Malaysia',
    'USA',
    'UK',
    'Canada',
    'Australia',
    'Japan',
  ];

  final List<Map<String, String>> _countryCodes = [
    {'code': '+855', 'flag': '🇰🇭'}, // Cambodia
    {'code': '+84', 'flag': '🇻🇳'}, // Vietnam
    {'code': '+66', 'flag': '🇹🇭'}, // Thailand
    {'code': '+65', 'flag': '🇸🇬'}, // Singapore
    {'code': '+60', 'flag': '🇲🇾'}, // Malaysia
    {'code': '+1', 'flag': '🇺🇸'}, // USA
    {'code': '+44', 'flag': '🇬🇧'}, // UK
    {'code': '+1', 'flag': '🇨🇦'}, // Canada
    {'code': '+61', 'flag': '🇦🇺'}, // Australia
    {'code': '+81', 'flag': '🇯🇵'}, // Japan
  ];

  @override
  void initState() {
    super.initState();
    _selectedCountry = _countries[0];
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
        logoAsset = 'assets/images/paypal.jpg';
        break;
      case PaymentType.aba:
        return Container(width: 60); // Do not display logo for ABA
    }

    if (logoAsset.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.asset(logoAsset, width: 60),
      );
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
      if (widget.paymentType == PaymentType.paypal) {
        _cardNumberError = _cardNumberController.text.trim().isEmpty;
        _cardHolderError = _cardHolderController.text.trim().isEmpty;
        _expiryError = false;
        _cvvError = false;
      } else {
        _cardNumberError =
            _cardNumberController.text.replaceAll(' ', '').length != 16;
        _cardHolderError = _cardHolderController.text.trim().isEmpty;
        _expiryError = _expiryController.text.length != 5;
        _cvvError = _cvvController.text.length != 3;
      }
    });

    if (_cardNumberError || _cardHolderError || _expiryError || _cvvError) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all required details correctly.'),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    // Determine payment type from card number
    PaymentType type = widget.paymentType;
    String cardType = _getCardTypeFromNumber(_cardNumberController.text);
    if (cardType == 'visa') type = PaymentType.visa;
    if (cardType == 'mastercard') type = PaymentType.mastercard;

    // Save payment method
    final paymentMethod = PaymentMethod(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      cardHolderName: _cardHolderController.text,
      cardNumber: _cardNumberController.text.replaceAll(' ', ''),
      expiryDate: _expiryController.text,
      cvv: _cvvController.text,
      type: type,
    );

    Provider.of<PaymentProvider>(context, listen: false).addPaymentMethod(
      paymentMethod,
    );

    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        if (widget.course != null) {
          String detail = paymentMethod.type.name.toUpperCase();

          // Get phone number
          final countryCode = _countryCodes[_selectedCountryIndex]['code']!;
          final phoneNumber = _phoneController.text.trim();
          final fullPhone =
              phoneNumber.isEmpty ? null : '$countryCode $phoneNumber';

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => EReceiptScreen(
                course: widget.course!,
                paymentMethodDetail: detail,
                phoneNumber: fullPhone,
                country: _selectedCountry,
              ),
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
    _streetController.dispose();
    _cityController.dispose();
    _postcodeController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Widget _buildField({
    required String label,
    required String hint,
    required TextEditingController controller,
    required bool hasError,
    VoidCallback? onChanged,
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
          onChanged: (_) => onChanged?.call(),
          decoration: InputDecoration(
            hintText: hint,
            border: _border(hasError ? Colors.red : Colors.grey.shade300),
            focusedBorder: _border(
              hasError ? Colors.red : AppColors.primaryColor,
            ),
            errorText: hasError ? "Invalid info" : null,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPhoneField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Phone Number',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300, width: 1.5),
          ),
          child: Row(
            children: [
              const SizedBox(width: 12),
              DropdownButtonHideUnderline(
                child: DropdownButton<int>(
                  value: _selectedCountryIndex,
                  items: _countryCodes.asMap().entries.map((entry) {
                    final int index = entry.key;
                    final Map<String, String> country = entry.value;
                    return DropdownMenuItem<int>(
                      value: index,
                      child: Text(
                        '${country['flag']} ${country['code']}',
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (newIndex) {
                    if (newIndex != null) {
                      setState(() {
                        _selectedCountryIndex = newIndex;
                      });
                    }
                  },
                ),
              ),
              const SizedBox(
                height: 30,
                child: VerticalDivider(color: Colors.grey, thickness: 1),
              ),
              Expanded(
                child: TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 12,
                    ),
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    hintText: '000 000 000',
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, size: 30, color: Colors.black),
          onPressed: _isLoading ? null : () => Navigator.pop(context),
        ),
        title: const Text(
          'Add Payment Method',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        // Dynamic Credit Card Preview
                        Container(
                          margin: const EdgeInsets.only(bottom: 24),
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
                                        colors:
                                            widget.paymentType ==
                                                    PaymentType.paypal
                                                ? [
                                                  const Color(
                                                    0xFF003087,
                                                  ).withOpacity(
                                                    0.9,
                                                  ), // PayPal Blue
                                                  const Color(
                                                    0xFF0070BA,
                                                  ).withOpacity(
                                                    0.7,
                                                  ), // PayPal lighter blue
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              widget.paymentType ==
                                                      PaymentType.paypal
                                                  ? 'PayPal Account'
                                                  : 'Credit Card',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            _getCardLogo(),
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              widget.paymentType ==
                                                      PaymentType.paypal
                                                  ? (_cardNumberController
                                                          .text
                                                          .isEmpty
                                                      ? 'associated-email@example.com'
                                                      : _cardNumberController
                                                          .text)
                                                  : _formatCardNumberForPreview(
                                                    _cardNumberController.text,
                                                  ),
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize:
                                                    widget.paymentType ==
                                                            PaymentType.paypal
                                                        ? 18
                                                        : 22,
                                                letterSpacing:
                                                    widget.paymentType ==
                                                            PaymentType.paypal
                                                        ? 0
                                                        : 2,
                                                fontFamily: 'monospace',
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            const SizedBox(height: 15),
                                            Row(
                                              children: [
                                                Expanded(
                                                  flex: 3,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        widget.paymentType ==
                                                                PaymentType
                                                                    .paypal
                                                            ? "Owner Name"
                                                            : "Card Holder",
                                                        style: const TextStyle(
                                                          color: Colors.white70,
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                      Text(
                                                        _cardHolderController
                                                                .text
                                                                .isEmpty
                                                            ? (widget.paymentType ==
                                                                    PaymentType
                                                                        .paypal
                                                                ? 'FULL NAME'
                                                                : 'CARD HOLDER')
                                                            : _cardHolderController
                                                                .text
                                                                .toUpperCase(),
                                                        style: const TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                if (widget.paymentType !=
                                                    PaymentType.paypal) ...[
                                                  Expanded(
                                                    flex: 2,
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        const Text(
                                                          "Expires",
                                                          style: TextStyle(
                                                            color:
                                                                Colors.white70,
                                                            fontSize: 12,
                                                          ),
                                                        ),
                                                        Text(
                                                          _expiryController
                                                                  .text
                                                                  .isEmpty
                                                              ? 'MM/YY'
                                                              : _expiryController
                                                                  .text,
                                                          style: const TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 1,
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        const Text(
                                                          "CVV",
                                                          style: TextStyle(
                                                            color:
                                                                Colors.white70,
                                                            fontSize: 12,
                                                          ),
                                                        ),
                                                        Text(
                                                          _cvvController
                                                                  .text
                                                                  .isEmpty
                                                              ? 'xxx'
                                                              : _cvvController
                                                                  .text,
                                                          style: const TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
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

                        Text(
                          widget.paymentType == PaymentType.paypal
                              ? "Account Details"
                              : "Card Details",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),

                        /// CARD NUMBER / EMAIL
                        _buildField(
                          label:
                              widget.paymentType == PaymentType.paypal
                                  ? "PayPal email"
                                  : "Card number",
                          hint:
                              widget.paymentType == PaymentType.paypal
                                  ? "example@email.com"
                                  : "xxxx xxxx xxxx xxxx",
                          controller: _cardNumberController,
                          hasError: _cardNumberError,
                          keyboardType:
                              widget.paymentType == PaymentType.paypal
                                  ? TextInputType.emailAddress
                                  : TextInputType.number,
                          inputFormatters:
                              widget.paymentType == PaymentType.paypal
                                  ? []
                                  : [
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

                        /// CARD HOLDER / OWNER NAME
                        _buildField(
                          label:
                              widget.paymentType == PaymentType.paypal
                                  ? "Account owner name"
                                  : "Card holder name",
                          hint: "Enter your name",
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

                        if (widget.paymentType != PaymentType.paypal) ...[
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
                                  hint: "xxx",
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

                        const SizedBox(height: 32),
                        const Text(
                          "Billing Address",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),

                        _buildField(
                          label: "Street Address",
                          hint: "Enter your street",
                          controller: _streetController,
                          hasError: false,
                        ),
                        const SizedBox(height: 16),

                        _buildField(
                          label: "City",
                          hint: "Enter your city",
                          controller: _cityController,
                          hasError: false,
                        ),
                        const SizedBox(height: 16),

                        const Text(
                          "Country/Region",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.grey.shade300,
                              width: 1.5,
                            ),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _selectedCountry,
                              isExpanded: true,
                              items: _countries.map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (newValue) {
                                setState(() {
                                  _selectedCountry = newValue;
                                });
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        _buildField(
                          label: "Postcode",
                          hint: "Enter postcode",
                          controller: _postcodeController,
                          hasError: false,
                          keyboardType: TextInputType.number,
                        ),
                        const SizedBox(height: 16),

                        _buildPhoneField(),
                        const SizedBox(height: 32),
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
                    mainAxisAlignment:
                        widget.course != null
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
