import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../routes/app_routes.dart';
import '../../profile/bindings/profile_binding.dart';
import '../../profile/views/profile_view.dart';
import '../bindings/settings_binding.dart';
import '../views/language_view.dart';
import '../views/theme_mode_view.dart';

class PSettingsController extends GetxController {
  var currentIndex = 0.obs;
  final pages = <String>[Routes.PPROFILE, Routes.PSETTINGS_LANGUAGE, Routes.PSETTINGS_THEME_MODE];

  void changePage(int index) {
    currentIndex.value = index;
    Get.toNamed(pages[index], id: 1);
  }

  Route? onGenerateRoute(RouteSettings settings) {
    if (settings.name == Routes.PPROFILE)
      return GetPageRoute(
        settings: settings,
        page: () => PProfileView(hideAppBar: true),
        binding: PProfileBinding(),
      );

    if (settings.name == Routes.PSETTINGS_LANGUAGE)
      return GetPageRoute(
        settings: settings,
        page: () => PLanguageView(hideAppBar: true),
        binding: PSettingsBinding(),
      );

    if (settings.name == Routes.PSETTINGS_THEME_MODE)
      return GetPageRoute(
        settings: settings,
        page: () => PThemeModeView(hideAppBar: true),
        binding: PSettingsBinding(),
      );

    return null;
  }

  @override
  void onInit() {
    super.onInit();
  }
}
