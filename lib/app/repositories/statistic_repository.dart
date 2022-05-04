import 'package:home_services/common/api_exception.dart';

import '../models/statistic.dart';
import '../providers/laravel_providers/laravel_provider.dart';

class StatisticRepository {
  late LaravelApiClient _laravelApiClient;

  StatisticRepository(LaravelApiClient client) {
    _laravelApiClient = client;
  }

  Future<List<Statistic>> getHomeStatistics() {
    try {
      return _laravelApiClient.getHomeStatistics();
    } on ApiException catch (e) {
      throw e.message;
    }
  }
}
