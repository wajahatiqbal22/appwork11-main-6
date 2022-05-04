import 'package:get/get.dart';
import '../controllers/e_address_form_controller.dart';

class EAddressBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EAddressFormController>(
      () => EAddressFormController(),
    );
  }
}
