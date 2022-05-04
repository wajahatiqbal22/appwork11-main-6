import 'package:get/get.dart';

import '../controllers/language_controller.dart';
import '../controllers/settings_controller.dart';
import '../controllers/theme_mode_controller.dart';

class PSettingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PSettingsController>(
      () => PSettingsController(),
    );
    Get.lazyPut<PThemeModeController>(
      () => PThemeModeController(),
    );
    Get.lazyPut<PLanguageController>(
      () => PLanguageController(),
    );
  }
}
