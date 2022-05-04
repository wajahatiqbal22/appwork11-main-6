import 'package:get/get.dart';

import '../controllers/gallery_controller.dart';

class PGalleryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PGalleryController>(
      () => PGalleryController(),
    );
  }
}
