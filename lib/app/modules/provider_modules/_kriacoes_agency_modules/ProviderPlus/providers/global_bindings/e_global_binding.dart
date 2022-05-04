import 'package:get/get.dart';
import '../global_controllers/e_success_controller.dart';
import '../global_controllers/e_welcome_controller.dart';

class EGlobalBinding extends Bindings {
  @override
  void dependencies() {

    Get.lazyPut<EWelcomeController>(
      () => EWelcomeController(),
    );

    Get.lazyPut<ESuccessController>(
          () => ESuccessController(),
    );

  }
}
