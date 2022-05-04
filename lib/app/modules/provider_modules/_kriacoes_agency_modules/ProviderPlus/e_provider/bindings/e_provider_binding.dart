import 'package:get/get.dart';
import '../controllers/e_provider_form_controller.dart';

class EProviderPlusBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EProviderFormController>(
      () => EProviderFormController(),
    );
  }
}
