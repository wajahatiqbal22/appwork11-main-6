import 'package:get/get.dart';
import 'package:home_services/common/api_exception.dart';

import '../models/category_model.dart';
import '../providers/laravel_providers/laravel_provider.dart';

class CategoryRepository {
  late LaravelApiClient _laravelApiClient;

  CategoryRepository(LaravelApiClient client) {
    this._laravelApiClient = client; // Get.find<LaravelApiClient>();
  }

  Future<List<Category>> getAll() {
    try {
      return _laravelApiClient.getAllCategories();
    } on ApiException catch (e) {
      throw e.message;
    }
  }

  Future<List<Category>> getAllParents() {
    try {
      return _laravelApiClient.getAllParentCategories();
    } on ApiException catch (e) {
      throw e.message;
    }
  }

  Future<List<Category>> getAllWithSubCategories() {
    try {
      return _laravelApiClient.getAllWithSubCategories();
    } on ApiException catch (e) {
      throw e.message;
    }
  }

  Future<List<Category>> getSubCategories(String categoryId) {
    try {
      return _laravelApiClient.getSubCategories(categoryId);
    } on ApiException catch (e) {
      throw e.message;
    }
  }

  Future<List<Category>> getFeatured() {
    try {
      return _laravelApiClient.getFeaturedCategories();
    } on ApiException catch (e) {
      throw e.message;
    }
  }
}
