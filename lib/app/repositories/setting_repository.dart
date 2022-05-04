import 'package:get/get.dart';
import 'package:home_services/common/api_exception.dart';

import '../models/address_model.dart';
import '../models/setting_model.dart';
import '../providers/laravel_providers/laravel_provider.dart';

class SettingRepository {
  late LaravelApiClient _laravelApiClient;

  SettingRepository(LaravelApiClient client) {
    this._laravelApiClient = client; // Get.find<LaravelApiClient>();
  }

  Future<Setting> get() {
    try {
      return _laravelApiClient.getSettings();
    } on ApiException catch (e) {
      throw e.message;
    }
  }

  Future<List<Address>> getAddresses() {
    try {
      return _laravelApiClient.getAddresses();
   } on ApiException catch (e) {
      throw e.message;
    }
  }
}
