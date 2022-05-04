import 'package:fialogs/fialogs.dart';
import 'package:get/get.dart';
import 'package:restart_app/restart_app.dart';
import '../../../../../../services/auth_service.dart';

class EWelcomeController extends GetxController {

  @override
  void onInit() async {
    super.onInit();
  }

  @override
  void onReady() async {
    super.onReady();
  }

  Future<void> logout() async {
    warningDialog(
      Get.context!,
      "Do you want to exit?".tr,
      "You can start over at the next login via the menu".tr,
      positiveButtonText: "Yes".tr,
      positiveButtonAction: () async {
        await Get.find<AuthService>().removeCurrentUser();
        Restart.restartApp();
      },
      negativeButtonText: "No".tr,
      negativeButtonAction: () {},
      hideNeutralButton: true,
      closeOnBackPress: false,
    );
  }

}
