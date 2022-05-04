/*
 * Copyright (c) 2020 .
 */

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../common/ui.dart';
import '../../../../models/e_provider_model.dart';
import '../../../../providers/laravel_providers/laravel_provider.dart';
import '../../../../models/custom_page_model.dart';
import '../../../../repositories/custom_page_repository.dart';
import '../../../../repositories/notification_repository.dart';
import '../../../../repositories/e_provider_repository.dart';
import '../../../../routes/app_routes.dart';
import '../../account/views/account_view.dart';
import '../../home/controllers/home_controller.dart';
import '../../home/views/home_view.dart';
import '../../messages/controllers/messages_controller.dart';
import '../../messages/views/messages_view.dart';
import '../../reviews/views/reviews_view.dart';

class PRootController extends GetxController {
  final currentIndex = 0.obs;
  final notificationsCount = 0.obs;
  final customPages = <CustomPage>[].obs;

  final eProviders = <EProvider>[].obs;

  late NotificationRepository _notificationRepository;
  late CustomPageRepository _customPageRepository;
  late EProviderRepository _eProviderRepository;

  PRootController() {
    _notificationRepository =
        new NotificationRepository(Get.find<ProviderApiClient>());
    _customPageRepository =
        new CustomPageRepository(Get.find<ProviderApiClient>());
    _eProviderRepository =
    new EProviderRepository(Get.find<ProviderApiClient>());
  }

  @override
  void onInit() async {
    await getCustomPages();
    getEProviders();
    if (Get.arguments != null && Get.arguments is int) {
      changePageInRoot(Get.arguments as int);
    } else {
      changePageInRoot(0);
    }
    super.onInit();
  }

  List<Widget> pages = [
    PHomeView(),
    ReviewsView(),
    PMessagesView(),
    PAccountView(),
  ];

  Widget get currentPage => pages[currentIndex.value];

  /**
   * change page in route
   * */
  void changePageInRoot(int _index) {
    currentIndex.value = _index;
  }

  void changePageOutRoot(int _index) {
    currentIndex.value = _index;
    Get.offNamedUntil(Routes.PROOT, (Route route) {
      if (route.settings.name == Routes.PROOT) {  
        return true;
      }
      return false;
    }, arguments: _index);
  }

  Future<void> changePage(int _index) async {
    if (Get.currentRoute == Routes.PROOT) {
      changePageInRoot(_index);
    } else {
      changePageOutRoot(_index);
    }
    await refreshPage(_index);
  }

  Future<void> refreshPage(int _index) async {
    switch (_index) {
      case 0:
        {
          await Get.find<PHomeController>().refreshHome();
          break;
        }
      case 2:
        {
          await Get.find<PMessagesController>().refreshMessages();
          break;
        }
    }
  }

  void getNotificationsCount() async {
    notificationsCount.value = await _notificationRepository.getCount();
  }

  Future<void> getCustomPages() async {
    customPages.assignAll(await _customPageRepository.all());
  }

  Future getEProviders() async {

    try {
      eProviders.assignAll(await _eProviderRepository.getAll());
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }



}
