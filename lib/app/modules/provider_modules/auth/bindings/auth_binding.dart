import 'package:get/get.dart';

import '../controllers/auth_controller.dart';

class PAuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PAuthController>(
      () => PAuthController(),
    );
  }
}
