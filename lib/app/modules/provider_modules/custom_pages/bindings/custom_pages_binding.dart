import 'package:get/get.dart';

import '../controllers/custom_pages_controller.dart';

class PCustomPagesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PCustomPagesController>(
      () => PCustomPagesController(),
    );
  }
}
