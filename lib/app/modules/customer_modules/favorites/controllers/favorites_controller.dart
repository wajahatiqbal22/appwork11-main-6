import 'package:get/get.dart';
import '../../../../providers/laravel_providers/laravel_provider.dart';

import '../../../../../common/ui.dart';
import '../../../../models/favorite_model.dart';
import '../../../../repositories/e_service_repository.dart';

class FavoritesController extends GetxController {
  final favorites = <Favorite>[].obs;
  final isLoading = true.obs;
  late EServiceRepository _eServiceRepository;

  FavoritesController() {
    _eServiceRepository = new EServiceRepository(Get.find<CustomerApiClient>());
  }

  @override
  void onInit() async {
    isLoading.value = true;
    await refreshFavorites();
    isLoading.value = false;
    super.onInit();
  }

  Future refreshFavorites({bool? showMessage}) async {
    isLoading.value = true;
    await getFavorites();
    isLoading.value = false;
    if (showMessage == true) {
      Get.showSnackbar(Ui.SuccessSnackBar(
          message: "List of Services refreshed successfully".tr));
    }
  }

  Future getFavorites() async {
    try {
      isLoading.value = true;
      favorites.assignAll(await _eServiceRepository.getFavorites());
      isLoading.value = false;
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }
}
