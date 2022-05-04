import 'package:get/get.dart';

import '../controllers/help_controller.dart';
import '../controllers/privacy_controller.dart';

class PHelpPrivacyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PPrivacyController>(
      () => PPrivacyController(),
    );
    Get.lazyPut<PHelpController>(
      () => PHelpController(),
    );
    Get.lazyPut<PHelpController>(
      () => PHelpController(),
    );
  }
}
