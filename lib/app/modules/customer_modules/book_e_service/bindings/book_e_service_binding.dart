import 'package:get/get.dart';
import '../controllers/time_slot_controller.dart';
import '../controllers/book_e_service_controller.dart';

class BookEServiceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BookEServiceController>(
      () => BookEServiceController(),
    );
    Get.lazyPut<TimeSlotController>(() => TimeSlotController());
  }
}
