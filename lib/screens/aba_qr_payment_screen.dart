import 'dart:async';
import 'package:education_app/models/course_model.dart';
import 'package:education_app/screens/e_receipt_screen.dart';
import 'package:education_app/utils/app_colors.dart';
import 'package:flutter/material.dart';

class AbaQrPaymentScreen extends StatefulWidget {
  final Course course;

  const AbaQrPaymentScreen({super.key, required this.course});

  @override
  State<AbaQrPaymentScreen> createState() => _AbaQrPaymentScreenState();
}

class _AbaQrPaymentScreenState extends State<AbaQrPaymentScreen> {
  late Timer _timer;
  int _countdown = 10;
  bool _showButton = false;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdown == 0) {
        setState(() {
          _timer.cancel();
          _showButton = true;
        });
      } else {
        setState(() {
          _countdown--;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pay with ABA QR'),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Scan the QR code to pay',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Image.asset('assets/images/DaraQR.jpg'),
              const SizedBox(height: 30),
              if (!_showButton)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Awaiting payment confirmation ',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    Text(
                      '$_countdown',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primaryColor),
                    ),
                  ],
                ),
              if (_showButton)
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => EReceiptScreen(course: widget.course, paymentMethodDetail: 'ABA QR')),
                      (route) => route.isFirst,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
                  ),
                  child: const Text('Go to Course'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
