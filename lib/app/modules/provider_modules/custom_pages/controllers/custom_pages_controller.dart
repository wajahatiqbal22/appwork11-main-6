import 'package:get/get.dart';
import '../../../../providers/laravel_providers/laravel_provider.dart';

import '../../../../../common/ui.dart';
import '../../../../models/custom_page_model.dart';
import '../../../../repositories/custom_page_repository.dart';

class PCustomPagesController extends GetxController {
  final customPage = CustomPage().obs;
  late CustomPageRepository _customPageRepository;

  PCustomPagesController() {
    _customPageRepository = CustomPageRepository(Get.find<ProviderApiClient>());
  }

  @override
  void onInit() {
    customPage.value = Get.arguments as CustomPage;
    super.onInit();
  }

  @override
  void onReady() async {
    await refreshCustomPage();
    super.onReady();
  }

  @override
  void onClose() {}

  Future<void> refreshCustomPage({bool showMessage = false}) async {
    await getCustomPage();
    if (showMessage) {
      Get.showSnackbar(Ui.SuccessSnackBar(message: "Page refreshed successfully".tr));
    }
  }

  Future<void> getCustomPage() async {
    try {
      customPage.value = await _customPageRepository.get(customPage.value.id!);
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }
}
