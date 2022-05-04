import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home_services/app/models/booking_model.dart';
import 'package:home_services/app/models/message_model.dart';
import 'package:home_services/app/modules/customer_modules/bookings/controllers/booking_controller.dart';
import 'package:home_services/app/modules/customer_modules/bookings/controllers/bookings_controller.dart';
import 'package:home_services/app/modules/provider_modules/bookings/controllers/booking_controller.dart';
import 'package:home_services/app/modules/provider_modules/messages/controllers/messages_controller.dart';
import 'package:home_services/app/modules/provider_modules/root/controllers/root_controller.dart';
import 'package:home_services/app/services/settings_service.dart';
import '../modules/customer_modules/messages/controllers/messages_controller.dart';
import '../modules/customer_modules/root/controllers/root_controller.dart';

import '../../common/ui.dart';
import '../routes/app_routes.dart';
import 'auth_service.dart';

class FireBaseMessagingService extends GetxService {
  Future<FireBaseMessagingService> init() async {
    FirebaseMessaging.instance
        .requestPermission(sound: true, badge: true, alert: true);
    await fcmOnLaunchListeners();
    await fcmOnResumeListeners();
    await fcmOnMessageListeners();
    return this;
  }

  Future fcmOnMessageListeners() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final _settingsService = Get.find<SettingsService>();
      if (_settingsService.isConsumer()) {
        if (Get.isRegistered<RootController>()) {
          Get.find<RootController>().getNotificationsCount();
        }
      } else {
        if (Get.isRegistered<PRootController>()) {
          Get.find<PRootController>().getNotificationsCount();
        }
      }

      if (message.data['id'] == "App\\Notifications\\NewMessage") {
        _newMessageNotification(message);
      } else {
        _bookingNotification(message);
      }
    });
  }

  Future fcmOnLaunchListeners() async {
    RemoteMessage? message =
        await FirebaseMessaging.instance.getInitialMessage();
    if (message != null) {
      _notificationsBackground(message);
    }
  }

  Future fcmOnResumeListeners() async {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _notificationsBackground(message);
    });
  }

  void _notificationsBackground(RemoteMessage message) {
    if (message.data['id'] == "App\\Notifications\\NewMessage") {
      _newMessageNotificationBackground(message);
    } else {
      _newBookingNotificationBackground(message);
    }
  }

  void _newBookingNotificationBackground(message) {
    final _settingsService = Get.find<SettingsService>();
    if (_settingsService.isConsumer()) {
      if (Get.isRegistered<RootController>()) {
        Get.toNamed(Routes.BOOKING,
            arguments: new Booking(id: message.data['bookingId']));
      }
    } else {
      if (Get.isRegistered<PRootController>()) {
        Get.toNamed(Routes.PBOOKING,
            arguments: new Booking(id: message.data['bookingId']));
      }
    }
  }

  void _newMessageNotificationBackground(RemoteMessage message) {
    final _settingsService = Get.find<SettingsService>();
    if (_settingsService.isConsumer()) {
      if (message.data['messageId'] != null) {
        Get.toNamed(Routes.CHAT,
            arguments: new Message([], id: message.data['messageId']));
      }
    } else {
      if (message.data['messageId'] != null) {
        Get.toNamed(Routes.PCHAT,
            arguments: new Message([], id: message.data['messageId']));
      }
    }
  }

  Future<void> setDeviceToken() async {
    Get.find<AuthService>().user.value.deviceToken =
        await FirebaseMessaging.instance.getToken();
  }

  void _bookingNotification(RemoteMessage message) {
    final _settingsService = Get.find<SettingsService>();
    if (Get.currentRoute == Routes.ROOT) {
      Get.find<BookingsController>().refreshBookings();
    }
    if (Get.currentRoute == Routes.BOOKING) {
      Get.find<BookingController>().refreshBooking();
    }
    if (Get.currentRoute == Routes.PBOOKING) {
      Get.find<PBookingController>().refreshBooking();
    }
    RemoteNotification? notification = message.notification;
    Get.showSnackbar(Ui.notificationSnackBar(
      title: notification!.title!,
      message: notification.body!,
      mainButton: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        width: 52,
        height: 52,
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          child: CachedNetworkImage(
            width: double.infinity,
            fit: BoxFit.cover,
            imageUrl: message.data != null ? message.data['icon'] : "",
            placeholder: (context, url) => Image.asset(
              'assets/img/loading.gif',
              fit: BoxFit.cover,
              width: double.infinity,
            ),
            errorWidget: (context, url, error) => Icon(Icons.error_outline),
          ),
        ),
      ),
      onTap: (getBar) async {
        if (message.data['bookingId'] != null) {
           Get.back();
          if (_settingsService.isConsumer()) {
            if (message.data['messageId'] != null) {
              Get.toNamed(Routes.BOOKING,
                  arguments: new Booking(id: message.data['bookingId']));
            }
          } else {
            if (message.data['messageId'] != null) {
              Get.toNamed(Routes.PBOOKING,
                  arguments: new Booking(id: message.data['bookingId']));
            }
          }
        }
      },
    ));
  }

  void _newMessageNotification(RemoteMessage message) {
    final _settingsService = Get.find<SettingsService>();
    RemoteNotification? notification = message.notification;
    if (_settingsService.isConsumer()) {
      if (Get.find<MessagesController>().initialized) {
        Get.find<MessagesController>().refreshMessages();
      }
    } else {
      if (Get.find<PMessagesController>().initialized) {
        Get.find<PMessagesController>().refreshMessages();
      }
    }

    if (Get.currentRoute != Routes.CHAT) {
      Get.showSnackbar(Ui.notificationSnackBar(
        title: notification!.title!,
        message: notification.body!,
        mainButton: Container(
          margin: const EdgeInsets.symmetric(horizontal: 8.0),
          width: 42,
          height: 42,
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(42)),
            child: CachedNetworkImage(
              width: double.infinity,
              fit: BoxFit.cover,
              imageUrl: message.data != null ? message.data['icon'] : "",
              placeholder: (context, url) => Image.asset(
                'assets/img/loading.gif',
                fit: BoxFit.cover,
                width: double.infinity,
              ),
              errorWidget: (context, url, error) => Icon(Icons.error_outline),
            ),
          ),
        ),
        onTap: (getBar) async {
          if (message.data['messageId'] != null) {
             Get.back();
            Get.toNamed(Routes.CHAT,
                arguments: new Message([], id: message.data['messageId']));
          }
        },
      ));
    } else if (Get.currentRoute != Routes.PCHAT) {
      Get.showSnackbar(Ui.notificationSnackBar(
        title: notification!.title!,
        message: notification.body!,
        mainButton: Container(
          margin: const EdgeInsets.symmetric(horizontal: 8.0),
          width: 42,
          height: 42,
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(42)),
            child: CachedNetworkImage(
              width: double.infinity,
              fit: BoxFit.cover,
              imageUrl: message.data != null ? message.data['icon'] : "",
              placeholder: (context, url) => Image.asset(
                'assets/img/loading.gif',
                fit: BoxFit.cover,
                width: double.infinity,
              ),
              errorWidget: (context, url, error) => Icon(Icons.error_outline),
            ),
          ),
        ),
        onTap: (getBar) async {
          if (message.data['messageId'] != null) {
             Get.back();
            Get.toNamed(Routes.PCHAT,
                arguments: new Message([], id: message.data['messageId']));
          }
        },
      ));
    }
  }
}
