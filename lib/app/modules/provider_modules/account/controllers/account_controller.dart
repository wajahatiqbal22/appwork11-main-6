import 'package:get/get.dart';

import '../../root/controllers/root_controller.dart';

class PAccountController extends GetxController {
  @override
  void onInit() {
    Get.find<PRootController>().getNotificationsCount();
    super.onInit();
  }

}
