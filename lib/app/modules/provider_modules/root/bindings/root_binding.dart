import 'package:get/get.dart';

import '../../account/controllers/account_controller.dart';
import '../../bookings/controllers/booking_controller.dart';
import '../../home/controllers/home_controller.dart';
import '../../messages/controllers/messages_controller.dart';
import '../../reviews/controllers/review_controller.dart';
import '../../reviews/controllers/reviews_controller.dart';
import '../../search/controllers/search_controller.dart';
import '../controllers/root_controller.dart';

class PRootBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PRootController>(
      () => PRootController(),
    );
    Get.put(PHomeController(), permanent: true);
    Get.lazyPut<PBookingController>(
      () => PBookingController(),
    );
    Get.lazyPut<PReviewsController>(
      () => PReviewsController(),
    );
    Get.lazyPut<PReviewController>(
      () => PReviewController(),
    );
    Get.lazyPut<PMessagesController>(
      () => PMessagesController(),
      fenix: true,
    );
    Get.lazyPut<PAccountController>(
      () => PAccountController(),
    );
    Get.lazyPut<PSearchController>(
      () => PSearchController(),
    );
  }
}
