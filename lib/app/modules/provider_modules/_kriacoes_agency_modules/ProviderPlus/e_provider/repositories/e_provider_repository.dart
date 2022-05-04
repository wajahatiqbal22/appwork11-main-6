import 'package:get/get.dart';
import '../../../../../../models/address_model.dart';
import '../../../../../../models/e_provider_model.dart';
import '../../../../../../providers/laravel_providers/laravel_provider.dart';
import '../../../../../../models/e_provider_type_model.dart';
import '../models/tax_plus_model.dart';
import '../models/e_provider_plus_model.dart';

class EProviderRepository {
  late LaravelApiClient _laravelApiClient;

  EProviderRepository() {
    this._laravelApiClient = Get.find<ProviderApiClient>();
  }

  Future<EProviderPlus> create(EProviderPlus eEProvider) {
    return _laravelApiClient.createEProvider(eEProvider);
  }

  Future<List<EProviderType>> getAllEProviderTypes() {
    return _laravelApiClient.getEProviderTypes();
  }

  Future<List<Address>> getAllEProviderAddress() {
    return _laravelApiClient.getProviderAddress();
  }

  Future<List<TaxPlus>> getAllTaxes() {
    return _laravelApiClient.getAllTaxes();
  }

  Future<List<TaxPlus>> getAllEProviderTaxes() {
    return _laravelApiClient.getEProviderTaxes();
  }

  Future<List<EProvider>> getAll() {
    return _laravelApiClient.getEProviders();
  }

}
