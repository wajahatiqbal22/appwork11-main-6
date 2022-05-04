import 'package:get/get.dart';
import '../../../../providers/laravel_providers/laravel_provider.dart';

import '../../../../../common/ui.dart';
import '../../../../models/favorite_model.dart';
import '../../../../repositories/e_service_repository.dart';

class FavoritesController extends GetxController {
  final favorites = <Favorite>[].obs;
  late EServiceRepository _eServiceRepository;

  FavoritesController() {
    _eServiceRepository = new EServiceRepository(Get.find<CustomerApiClient>());
  }

  @override
  void onInit() async {
    await refreshFavorites();
    super.onInit();
  }

  Future refreshFavorites({bool? showMessage}) async {
    await getFavorites();
    if (showMessage == true) {
      Get.showSnackbar(Ui.SuccessSnackBar(message: "List of Services refreshed successfully".tr));
    }
  }

  Future getFavorites() async {
    try {
      favorites.assignAll(await _eServiceRepository.getFavorites());
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }
}