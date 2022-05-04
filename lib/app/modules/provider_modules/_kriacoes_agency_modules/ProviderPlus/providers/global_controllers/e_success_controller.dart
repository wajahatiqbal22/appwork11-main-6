import 'package:get/get.dart';
import '../../../../../../routes/app_routes.dart';

class ESuccessController extends GetxController {

  ESuccessController() {}

  @override
  void onInit() async {
    super.onInit();
  }

  @override
  void onReady() async {
    super.onReady();
  }

  Future<void> finish() async {
    await Get.offAndToNamed(Routes.PROOT, arguments: 0);
  }

}
