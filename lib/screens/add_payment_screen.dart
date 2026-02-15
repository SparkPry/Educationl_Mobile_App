import 'package:education_app/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'e_receipt_screen.dart';
import 'package:education_app/models/course_model.dart';

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
  final Course course;

  const AddPaymentScreen({super.key, required this.course});

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

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => EReceiptScreen(course: widget.course),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
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
    final price = widget.course.discountPrice ?? widget.course.price;

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
                        _CreditCardPreview(),
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total: \$${price.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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

/// =============================
/// CARD PREVIEW (UNCHANGED UI)
/// =============================
class _CreditCardPreview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        gradient: const LinearGradient(
          colors: [AppColors.primaryColor, AppColors.primaryColor],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Credit', style: TextStyle(color: Colors.white70)),
              Text(
                'Check',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Icon(Icons.memory, color: Colors.white, size: 40),
              Spacer(),
              Icon(Icons.wifi_tethering, color: Colors.white),
            ],
          ),
          SizedBox(height: 20),
          Text(
            '5432   1098   7654   3210',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              letterSpacing: 2,
            ),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'EXPIRY',
                style: TextStyle(color: Colors.white70, fontSize: 10),
              ),
              SizedBox(width: 8),
              Text(
                '12/28',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'JOHN DOE',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Icon(Icons.payment, color: Colors.white, size: 40),
            ],
          ),
        ],
      ),
    );
  }
}
