import 'package:get/get.dart';

import '../controllers/notifications_controller.dart';

class PNotificationsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PNotificationsController>(
      () => PNotificationsController(),
    );
  }
}
