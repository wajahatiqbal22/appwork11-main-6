import 'package:get/get.dart';
import 'package:home_services/common/api_exception.dart';

import '../models/booking_model.dart';
import '../models/payment_method_model.dart';
import '../models/payment_model.dart';
import '../models/wallet_model.dart';
import '../models/wallet_transaction_model.dart';
import '../providers/laravel_providers/laravel_provider.dart';

class PaymentRepository {
  late LaravelApiClient _laravelApiClient;

  PaymentRepository(LaravelApiClient client) {
    _laravelApiClient = client; // Get.find<LaravelApiClient>();
  }

  Future<List<PaymentMethod>> getMethods() {
    try {
      return _laravelApiClient.getPaymentMethods();
    } on ApiException catch (e) {
      throw e.message;
    }
  }

  Future<List<Wallet>> getWallets() {
    try {
      return _laravelApiClient.getWallets();
    } on ApiException catch (e) {
      throw e.message;
    }
  }

  Future<List<WalletTransaction>> getWalletTransactions(Wallet wallet) {
    try {
      return _laravelApiClient.getWalletTransactions(wallet);
    } on ApiException catch (e) {
      throw e.message;
    }
  }

  Future<Wallet> createWallet(Wallet wallet) {
    try {
      return _laravelApiClient.createWallet(wallet);
    } on ApiException catch (e) {
      throw e.message;
    }
  }

  Future<Wallet> updateWallet(Wallet wallet) {
    try {
      return _laravelApiClient.updateWallet(wallet);
    } on ApiException catch (e) {
      throw e.message;
    }
  }

  Future<bool> deleteWallet(Wallet wallet) {
    try {
      return _laravelApiClient.deleteWallet(wallet);
    } on ApiException catch (e) {
      throw e.message;
    }
  }

  Future<Payment> create(Booking booking) {
    try {
      return _laravelApiClient.createPayment(booking);
    } on ApiException catch (e) {
      throw e.message;
    }
  }

  Future<Payment> createWalletPayment(Booking booking, Wallet wallet) {
    try {
      return _laravelApiClient.createWalletPayment(booking, wallet);
    } on ApiException catch (e) {
      throw e.message;
    }
  }

  String getPayPalUrl(Booking booking) {
    try {
      return _laravelApiClient.getPayPalUrl(booking);
    } on ApiException catch (e) {
      throw e.message;
    }
  }

  String getRazorPayUrl(Booking booking) {
    try {
      return _laravelApiClient.getRazorPayUrl(booking);
    } on ApiException catch (e) {
      throw e.message;
    }
  }

  String getStripeUrl(Booking booking) {
    try {
      return _laravelApiClient.getStripeUrl(booking);
    } on ApiException catch (e) {
      throw e.message;
    }
  }

  String getPayStackUrl(Booking booking) {
    try {
      return _laravelApiClient.getPayStackUrl(booking);
    } on ApiException catch (e) {
      throw e.message;
    }
  }

  String getFlutterWaveUrl(Booking booking) {
    try {
      return _laravelApiClient.getFlutterWaveUrl(booking);
    } on ApiException catch (e) {
      throw e.message;
    }
  }

  String getStripeFPXUrl(Booking booking) {
    try {
      return _laravelApiClient.getStripeFPXUrl(booking);
    } on ApiException catch (e) {
      throw e.message;
    }
  }

  Future<Payment> update(Payment payment) {
    try {
      return _laravelApiClient.updatePayment(payment);
    } on ApiException catch (e) {
      throw e.message;
    }
  }
 /* Future<Payment> update(Payment payment) {
    return _laravelApiClient.updatePayment(payment);
  }*/
}
