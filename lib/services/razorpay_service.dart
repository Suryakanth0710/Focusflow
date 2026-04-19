import 'dart:async';

import 'package:razorpay_flutter/razorpay_flutter.dart';

class RazorpayService {
  RazorpayService._();
  static final RazorpayService instance = RazorpayService._();

  final Razorpay _razorpay = Razorpay();

  /// Opens Razorpay checkout and resolves with success/failure.
  Future<bool> openCheckout({required String email, required String contact}) {
    final completer = Completer<bool>();

    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, (PaymentSuccessResponse _) {
      if (!completer.isCompleted) completer.complete(true);
    });

    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, (PaymentFailureResponse _) {
      if (!completer.isCompleted) completer.complete(false);
    });

    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, (ExternalWalletResponse _) {
      if (!completer.isCompleted) completer.complete(false);
    });

    _razorpay.open({
      'key': 'rzp_test_replace_with_live_key',
      'amount': 49900,
      'name': 'FocusFlow Premium',
      'description': 'Unlock premium productivity features',
      'prefill': {'email': email, 'contact': contact},
    });

    return completer.future;
  }

  void dispose() => _razorpay.clear();
}
