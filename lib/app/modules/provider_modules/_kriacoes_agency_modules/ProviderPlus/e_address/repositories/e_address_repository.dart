import 'package:get/get.dart';
import '../../../../../../models/address_model.dart';
import '../../../../../../providers/laravel_providers/laravel_provider.dart';
import '../../../../../../models/address_model.dart';

class EAddressRepository {
  late LaravelApiClient _laravelApiClient;

  EAddressRepository() {
    this._laravelApiClient = Get.find<ProviderApiClient>();
  }

  Future<Address> create(Address eAddress) {
    return _laravelApiClient.createEAddress(eAddress);
  }
}
