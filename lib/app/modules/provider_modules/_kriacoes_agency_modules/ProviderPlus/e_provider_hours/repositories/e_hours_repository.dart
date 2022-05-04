import 'package:get/get.dart';
import '../../../../../../providers/laravel_providers/laravel_provider.dart';
import '../models/availability_hour_model.dart';


class EHoursRepository {
 late LaravelApiClient _laravelApiClient;

  EHoursRepository() {
    this._laravelApiClient = Get.find<ProviderApiClient>();
  }

  Future<ProviderAvailabilityHour> create(ProviderAvailabilityHour eHours) {
    return _laravelApiClient.createEHours(eHours);
  }

}
