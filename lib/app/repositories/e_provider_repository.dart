import '../../common/api_exception.dart';

import '../models/award_model.dart';
import '../models/e_provider_model.dart';
import '../models/e_service_model.dart';
import '../models/experience_model.dart';
import '../models/gallery_model.dart';
import '../models/review_model.dart';
import '../models/user_model.dart';
import '../providers/laravel_providers/laravel_provider.dart';

class EProviderRepository {
  late LaravelApiClient _laravelApiClient;

  EProviderRepository(LaravelApiClient client) {
    this._laravelApiClient = client; // Get.find<LaravelApiClient>();
  }

  Future<EProvider> get(String eProviderId) {
    try {
      return _laravelApiClient.getEProvider(eProviderId);
   } on ApiException catch (e) {
      throw e.message;
    }
  }

  Future<Review> getReview(String reviewId) {
    try {
      return _laravelApiClient.getEProviderReview(reviewId);
   } on ApiException catch (e) {
      throw e.message;
    }
  }

  Future<List<Review>> getReviews(String eProviderId) {
    try {
      return _laravelApiClient.getEProviderReviews(eProviderId);
    } on ApiException catch (e) {
      throw e.message;
    }
  }

  Future<List<Gallery>> getGalleries(String eProviderId) {
    try {
      return _laravelApiClient.getEProviderGalleries(eProviderId);
    } on ApiException catch (e) {
      throw e.message;
    }
  }

  Future<List<Award>> getAwards(String eProviderId) {
    try {
      return _laravelApiClient.getEProviderAwards(eProviderId);
    } on ApiException catch (e) {
      throw e.message;
    }
  }

  Future<List<Experience>> getExperiences(String eProviderId) {
    try {
      return _laravelApiClient.getEProviderExperiences(eProviderId);
    } on ApiException catch (e) {
      throw e.message;
    }
  }

  Future<List<EService>> getEServices(String eProviderId, {int? page}) {
    try {
      return _laravelApiClient.getEProviderEServices(eProviderId, page!);
    } on ApiException catch (e) {
      throw e.message;
    }
  }

  Future<List<User>> getEmployees(String eProviderId) {
    try {
      return _laravelApiClient.getEProviderEmployees(eProviderId);
    } on ApiException catch (e) {
      throw e.message;
    }
  }

  Future<List<EService>> getPopularEServices(String eProviderId, {int? page}) {
    try {
      return _laravelApiClient.getEProviderPopularEServices(eProviderId, page!);
    } on ApiException catch (e) {
      throw e.message;
    }
  }

  Future<List<EService>> getMostRatedEServices(String eProviderId, {int? page}) {
    try {
      return _laravelApiClient.getEProviderMostRatedEServices(eProviderId, page!);
   } on ApiException catch (e) {
      throw e.message;
    }
  }

  Future<List<EService>> getAvailableEServices(String eProviderId, {int? page}) {
    try {
      return _laravelApiClient.getEProviderAvailableEServices(eProviderId, page!);
    } on ApiException catch (e) {
      throw e.message;
    }
  }

  Future<List<EService>> getFeaturedEServices(String eProviderId, {int? page}) {
    try {
      return _laravelApiClient.getEProviderFeaturedEServices(eProviderId, page!);
    } on ApiException catch (e) {
      throw e.message;
    }
  }

  Future<List<EProvider>> getAll() {
    try {
      return _laravelApiClient.getEProviders();
    } on ApiException catch (e) {
      throw e.message;
    }
  }

}
