import 'package:get/get.dart';

import '../../search/controllers/search_controller.dart';
import '../controllers/e_service_controller.dart';
import '../controllers/e_service_form_controller.dart';
import '../controllers/e_services_controller.dart';
import '../controllers/options_form_controller.dart';

class PEServicesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PEServicesController>(
      () => PEServicesController(),
    );
    Get.lazyPut<PEServiceController>(
      () => PEServiceController(),
    );
    Get.lazyPut<PEServiceFormController>(
      () => PEServiceFormController(),
    );
    Get.lazyPut<POptionsFormController>(
      () => POptionsFormController(),
    );
    Get.lazyPut<PSearchController>(
      () => PSearchController(),
    );
  }
}
