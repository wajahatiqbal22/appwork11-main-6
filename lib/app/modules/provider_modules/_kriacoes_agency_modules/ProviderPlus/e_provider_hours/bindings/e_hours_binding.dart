import 'package:get/get.dart';
import '../controllers/e_hours_form_controller.dart';

class EHoursBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EHoursFormController>(
      () => EHoursFormController(),
    );
  }
}
