import 'package:flutter/foundation.dart';
import '../models/payment_method.dart';

class PaymentProvider with ChangeNotifier {
  final List<PaymentMethod> _savedMethods = [];

  List<PaymentMethod> get savedMethods => List.unmodifiable(_savedMethods);

  void addPaymentMethod(PaymentMethod method) {
    _savedMethods.add(method);
    notifyListeners();
  }

  void removePaymentMethod(String id) {
    _savedMethods.removeWhere((m) => m.id == id);
    notifyListeners();
  }
}
