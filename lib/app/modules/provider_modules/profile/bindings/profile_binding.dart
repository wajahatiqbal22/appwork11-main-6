import 'package:get/get.dart';

import '../controllers/profile_controller.dart';

class PProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PProfileController>(
      () => PProfileController(),
    );
  }
}
