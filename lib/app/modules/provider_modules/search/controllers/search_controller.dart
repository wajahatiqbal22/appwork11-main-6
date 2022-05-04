import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../common/ui.dart';
import '../../../../providers/laravel_providers/laravel_provider.dart';
import '../../../../models/category_model.dart';
import '../../../../models/e_service_model.dart';
import '../../../../repositories/category_repository.dart';
import '../../../../repositories/e_service_repository.dart';

class PSearchController extends GetxController {
  final heroTag = "".obs;
  final categories = <Category>[].obs;
  final selectedCategories = <String>[].obs;
  late TextEditingController textEditingController;

  final eServices = <EService>[].obs;
  late EServiceRepository _eServiceRepository;
  late CategoryRepository _categoryRepository;

  PSearchController() {
    _eServiceRepository = new EServiceRepository(Get.find<ProviderApiClient>());
    _categoryRepository = new CategoryRepository(Get.find<ProviderApiClient>());
    textEditingController = new TextEditingController();
  }

  @override
  void onInit() async {
    await refreshSearch();
    super.onInit();
  }

  @override
  void onReady() {
    heroTag.value = Get.arguments as String;
    super.onReady();
  }

  Future refreshSearch({bool? showMessage}) async {
    await getCategories();
    await searchEServices();
    if (showMessage == true) {
      Get.showSnackbar(Ui.SuccessSnackBar(message: "List of services refreshed successfully".tr));
    }
  }

  Future searchEServices({String? keywords}) async {
    try {
      if (selectedCategories.isEmpty) {
        eServices.assignAll(await _eServiceRepository.search(keywords??"", categories.map((element) => element.id!).toList()));
      } else {
        eServices.assignAll(await _eServiceRepository.search(keywords??"", selectedCategories.toList()));
      }

    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  Future getCategories() async {
    try {
      categories.assignAll(await _categoryRepository.getAllParents());
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  bool isSelectedCategory(Category category) {
    return selectedCategories.contains(category.id);
  }

  void toggleCategory(bool value, Category category) {
    if (value) {
      selectedCategories.add(category.id!);
    } else {
      selectedCategories.removeWhere((element) => element == category.id);
    }
  }
}
