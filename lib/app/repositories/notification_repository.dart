import 'package:get/get.dart';
import 'package:home_services/common/api_exception.dart';

import '../models/notification_model.dart';
import '../models/user_model.dart';
import '../providers/laravel_providers/laravel_provider.dart';

class NotificationRepository {
  late LaravelApiClient _laravelApiClient;

  NotificationRepository(LaravelApiClient client) {
    this._laravelApiClient = client; // Get.find<LaravelApiClient>();
  }

  Future<List<Notification>> getAll() {
    try {
      return _laravelApiClient.getNotifications();
   } on ApiException catch (e) {
      throw e.message;
    }
  }

  Future<int> getCount() {
    try {
      return _laravelApiClient.getNotificationsCount();
    } on ApiException catch (e) {
      throw e.message;
    }
  }

  Future<Notification> remove(Notification notification) {
    try {
      return _laravelApiClient.removeNotification(notification);
    } on ApiException catch (e) {
      throw e.message;
    }
  }

  Future<Notification> markAsRead(Notification notification) {
    try {
      return _laravelApiClient.markAsReadNotification(notification);
    } on ApiException catch (e) {
      throw e.message;
    }
  }

  Future<bool> sendNotification(List<User> users, User from, String type, String text) {
    try {
      return _laravelApiClient.sendNotification(users, from, type, text);
    } on ApiException catch (e) {
      throw e.message;
    }
  }
}
