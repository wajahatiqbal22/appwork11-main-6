import 'package:get/get.dart';

import '../../../../../common/ui.dart';
import '../../../../providers/laravel_providers/laravel_provider.dart';
import '../../../../models/address_model.dart';
import '../../../../models/category_model.dart';
import '../../../../models/e_service_model.dart';
import '../../../../models/slide_model.dart';
import '../../../../repositories/category_repository.dart';
import '../../../../repositories/e_service_repository.dart';
import '../../../../repositories/slider_repository.dart';
import '../../../../services/settings_service.dart';
import '../../root/controllers/root_controller.dart';

class HomeController extends GetxController {
  late SliderRepository _sliderRepo;
  late CategoryRepository _categoryRepository;
  late EServiceRepository _eServiceRepository;

  final addresses = <Address>[].obs;
  final slider = <Slide>[].obs;
  final currentSlide = 0.obs;

  final eServices = <EService>[].obs;
  final categories = <Category>[].obs;
  final homeCategories = <Category>[].obs;
  final featured = <Category>[].obs;

  HomeController() {
    _sliderRepo = new SliderRepository(Get.find<CustomerApiClient>());
    _categoryRepository = new CategoryRepository(Get.find<CustomerApiClient>());
    _eServiceRepository = new EServiceRepository(Get.find<CustomerApiClient>());
  }

  @override
  Future<void> onInit() async {
    await refreshHome();
    super.onInit();
  }

  Future refreshHome({bool showMessage = false}) async {
    try {
      await getSlider();
      await getCategories();
      await getFeatured();
      await getRecommendedEServices();
      Get.find<RootController>().getNotificationsCount();
    } catch (e) {
      print(e);
    }
    if (showMessage) {
      Get.showSnackbar(
          Ui.SuccessSnackBar(message: "Home page refreshed successfully".tr));
    }
  }

  Address get currentAddress {
    return Get.find<SettingsService>().address.value;
  }

  Future getSlider() async {
    try {
      slider.assignAll(await _sliderRepo.getHomeSlider());
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  Future getCategories() async {
    try {
      categories.assignAll(await _categoryRepository.getAllParents());
      for (int i = 0; i <= 7; i++) {
        homeCategories.add(categories[i]);
      }
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  Future getFeatured() async {
    try {
      featured.assignAll(await _categoryRepository.getFeatured());
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  Future getRecommendedEServices() async {
    try {
      eServices.assignAll(await _eServiceRepository.getRecommended());
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }
}
