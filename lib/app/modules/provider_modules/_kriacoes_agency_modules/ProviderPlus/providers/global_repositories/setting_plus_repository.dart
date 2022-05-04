import 'package:get/get.dart';
import '../../../../../../models/address_model.dart';
import '../../../../../../models/setting_model.dart';
import '../../../../../../providers/laravel_providers/laravel_provider.dart';

class SettingPlusRepository {
  late ProviderApiClient _laravelApiClient;

  SettingPlusRepository() {
    this._laravelApiClient = Get.find<ProviderApiClient>();
  }

  Future<Setting> get() {
    return _laravelApiClient.getSettings();
  }

  Future<List<Address>> getAddresses() {
    return _laravelApiClient.getAddresses();
  }
}
