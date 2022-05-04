import 'dart:io';

import '../../common/api_exception.dart';

import '../providers/laravel_providers/laravel_provider.dart';

class UploadRepository {
  late LaravelApiClient _laravelApiClient;

  UploadRepository(LaravelApiClient client) {
    this._laravelApiClient = client; // Get.find<LaravelApiClient>();
  }

  Future<String>? image(File image, String field) {
    try {
      return _laravelApiClient.uploadImage(image, field);
    } on ApiException catch (e) {
      throw e.message;
    }
  }

  Future<bool> delete(String uuid) {
    try {
      return _laravelApiClient.deleteUploaded(uuid);
    } on ApiException catch (e) {
      throw e.message;
    }
  }

  Future<bool> deleteAll(List<String> uuids) {
    try {
      return _laravelApiClient.deleteAllUploaded(uuids);
    } on ApiException catch (e) {
      throw e.message;
    }
  }
}
