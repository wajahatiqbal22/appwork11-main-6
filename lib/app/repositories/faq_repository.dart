import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:home_services/common/api_exception.dart';

import '../models/faq_category_model.dart';
import '../models/faq_model.dart';
import '../providers/laravel_providers/laravel_provider.dart';
import '../providers/mock_provider.dart';

class FaqRepository {
  late MockApiClient _apiClient;
  late LaravelApiClient _laravelApiClient;

  FaqRepository(LaravelApiClient client) {
    _laravelApiClient = client; // Get.find<LaravelApiClient>();
    this._apiClient = MockApiClient(httpClient: Dio());
  }

  Future<List<FaqCategory>> getCategoriesWithFaqs() {
    try {
      return _apiClient.getCategoriesWithFaqs();
    } on ApiException catch (e) {
      throw e.message;
    }
  }

  Future<List<FaqCategory>> getFaqCategories() {
    try {
      return _laravelApiClient.getFaqCategories();
    } on ApiException catch (e) {
      throw e.message;
    }
  }

  Future<List<Faq>> getFaqs(String categoryId) {
    try {
      return _laravelApiClient.getFaqs(categoryId);
    } on ApiException catch (e) {
      throw e.message;
    }
  }
}
