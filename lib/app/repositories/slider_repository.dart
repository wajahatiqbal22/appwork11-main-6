import 'package:get/get.dart';
import 'package:home_services/common/api_exception.dart';

import '../models/slide_model.dart';
import '../providers/laravel_providers/laravel_provider.dart';

class SliderRepository {
  late LaravelApiClient _laravelApiClient;

  SliderRepository(LaravelApiClient client) {
    this._laravelApiClient = client; // Get.find<LaravelApiClient>();
  }

  Future<List<Slide>> getHomeSlider() {
    try {
      return _laravelApiClient.getHomeSlider();
    } on ApiException catch (e) {
      throw e.message;
    }
  }
}
