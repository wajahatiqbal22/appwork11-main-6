import 'package:get/get.dart';
import 'package:home_services/common/api_exception.dart';

import '../models/custom_page_model.dart';
import '../providers/laravel_providers/laravel_provider.dart';

class CustomPageRepository {
  late LaravelApiClient _laravelApiClient;

  CustomPageRepository(LaravelApiClient client) {
    this._laravelApiClient = client; // Get.find<LaravelApiClient>();
  }

  Future<List<CustomPage>> all() {
    try {
      return _laravelApiClient.getCustomPages();
    } on ApiException catch (e) {
      throw e.message;
    }
  }

  Future<CustomPage> get(String id) {
    try {
      return _laravelApiClient.getCustomPageById(id);
    } on ApiException catch (e) {
      throw e.message;
    }
  }
}
