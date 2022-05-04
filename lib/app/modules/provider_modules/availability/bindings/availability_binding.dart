import 'package:get/get.dart';
import 'package:home_services/app/modules/provider_modules/availability/controllers/availability_controller.dart';

class AvailabilityBinding implements Bindings {
@override
void dependencies() {
  Get.lazyPut<AvailabilityController>(() => AvailabilityController(
  ));
  }
}