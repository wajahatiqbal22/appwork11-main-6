import 'package:home_services/app/models/option_model.dart';
import 'package:home_services/common/api_exception.dart';

import '../models/e_service_model.dart';
import '../models/favorite_model.dart';
import '../models/option_group_model.dart';
import '../models/review_model.dart';
import '../providers/laravel_providers/laravel_provider.dart';

class EServiceRepository {
  late LaravelApiClient _laravelApiClient;

  EServiceRepository(LaravelApiClient client) {
    this._laravelApiClient = client; // Get.find<LaravelApiClient>();
  }

  Future<List<EService>> getAllWithPagination(String categoryId, {int? page}) {
    try {
      return _laravelApiClient.getAllEServicesWithPagination(categoryId, page!);
    } on ApiException catch (e) {
      throw e.message;
    }
  }

  Future<List<EService>> search(String keywords, List<String> categories,
      {int page = 1}) {
    try {
      return _laravelApiClient.searchEServices(keywords, categories, page);
    } on ApiException catch (e) {
      throw e.message;
    }
  }

  Future<List<Favorite>> getFavorites() {
    try {
      return _laravelApiClient.getFavoritesEServices();
    } on ApiException catch (e) {
      throw e.message;
    }
  }

  Future<Favorite> addFavorite(Favorite favorite) {
    try {
      return _laravelApiClient.addFavoriteEService(favorite);
    } on ApiException catch (e) {
      throw e.message;
    }
  }

  Future<bool> removeFavorite(Favorite favorite) {
    try {
      return _laravelApiClient.removeFavoriteEService(favorite);
    } on ApiException catch (e) {
      throw e.message;
    }
  }

  Future<List<EService>> getRecommended() {
    try {
      return _laravelApiClient.getRecommendedEServices();
    } on ApiException catch (e) {
      throw e.message;
    }
  }

  Future<List<EService>> getFeatured(String categoryId, {int? page}) {
    try {
      return _laravelApiClient.getFeaturedEServices(categoryId, page!);
    } on ApiException catch (e) {
      throw e.message;
    }
  }

  Future<List<EService>> getPopular(String categoryId, {int? page}) {
    try {
      return _laravelApiClient.getPopularEServices(categoryId, page!);
    } on ApiException catch (e) {
      throw e.message;
    }
  }

  Future<List<EService>> getMostRated(String categoryId, {int? page}) {
    try {
      return _laravelApiClient.getMostRatedEServices(categoryId, page!);
    } on ApiException catch (e) {
      throw e.message;
    }
  }

  Future<List<EService>> getAvailable(String categoryId, {int? page}) {
    try {
      return _laravelApiClient.getAvailableEServices(categoryId, page!);
    } on ApiException catch (e) {
      throw e.message;
    }
  }

  Future<EService> get(String id) {
    try {
      return _laravelApiClient.getEService(id);
    } on ApiException catch (e) {
      throw e.message;
    }
  }

  Future<List<Review>> getReviews(String eServiceId) {
    try {
      return _laravelApiClient.getEServiceReviews(eServiceId);
    } on ApiException catch (e) {
      throw e.message;
    }
  }

  Future<List<OptionGroup>> getOptionGroups(String eServiceId) {
    try {
      return _laravelApiClient.getEServiceOptionGroups(eServiceId);
    } on ApiException catch (e) {
      throw e.message;
    }
  }

  Future<EService> create(EService eService) {
    try {
      return _laravelApiClient.createEService(eService);
    } on ApiException catch (e) {
      throw e.message;
    }
  }

  Future<EService> update(EService eService) {
    try {
      return _laravelApiClient.updateEService(eService);
    } on ApiException catch (e) {
      throw e.message;
    }
  }

  Future<bool> delete(String eServiceId) {
    try {
      return _laravelApiClient.deleteEService(eServiceId);
    } on ApiException catch (e) {
      throw e.message;
    }
  }

  Future<List<OptionGroup>> getAllOptionGroups() {
    try {
      return _laravelApiClient.getOptionGroups();
    } on ApiException catch (e) {
      throw e.message;
    }
  }

  Future<Option> createOption(Option option) {
    try {
      return _laravelApiClient.createOption(option);
    } on ApiException catch (e) {
      throw e.message;
    }
  }

  Future<Option> updateOption(Option option) {
    try {
      return _laravelApiClient.updateOption(option);

    } on ApiException catch (e) {
      throw e.message;
    }
  }

  Future<bool> deleteOption(String optionId) {
    try {
      return _laravelApiClient.deleteOption(optionId);
    } on ApiException catch (e) {
      throw e.message;
    }
  }
}
