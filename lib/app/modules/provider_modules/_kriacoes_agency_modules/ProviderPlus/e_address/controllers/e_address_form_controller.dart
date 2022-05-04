import 'package:fialogs/fialogs.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restart_app/restart_app.dart';

import '../../../../../../../common/ui.dart';
import '../../../../../../models/address_model.dart';
import '../../../../../../routes/app_routes.dart';
import '../../../../../../services/auth_service.dart';
import '../../../../../../services/settings_service.dart';
//import '../../../../../customer_modules/global_widgets/tab_bar_widget.dart';
import '../../providers/global_repositories/setting_plus_repository.dart';
import '../../providers/global_widgets/tab_bar_widget.dart';
import '../repositories/e_address_repository.dart';


class EAddressFormController extends GetxController {
  final eAddress = Address().obs;
  //GlobalKey<FormState> eAddressForm = GlobalKey<FormState>();
  GlobalKey<FormState> eAddressForm = new GlobalKey<FormState>(debugLabel: 'eAddressForm');
  late EAddressRepository _eAddressRepository;
  late SettingPlusRepository _settingRepository;
  final addresses = <Address>[].obs;

  Address get currentAddress => Get.find<SettingsService>().address.value;

  EAddressFormController() {
    _eAddressRepository = new EAddressRepository();
    _settingRepository = SettingPlusRepository();
  }

  @override
  void onInit() async {
    super.onInit();
    //await loadFormAddressData();
    var arguments = Get.arguments as Map<String, dynamic>;
    if (arguments != null) {
      eAddress.value = arguments['eAddress'] as Address;
    }
    await getAddresses();
    //await loadFormAddressData();
  }

  @override
  void onReady() async {
    super.onReady();
  }

  void CheckDescription(){
    Get.showSnackbar(Ui.ErrorSnackBar(message: "kriacoes_agency_module_provider_plus_address_picker_description_validator".tr));
  }

  Future refreshAddress() async {
    await getAddresses();
    //await loadFormAddressData();
  }

  Future getAddresses() async {
    try {
      if (Get.find<AuthService>().isAuth) {
        addresses.assignAll(await _settingRepository.getAddresses());
        if (!currentAddress.isUnknown()) {
          addresses.remove(currentAddress);
          addresses.insert(0, currentAddress);
        }
        if (Get.isRegistered<TabBarController>(tag: 'addresses')) {
          Get.find<TabBarController>(tag: 'addresses').selectedId.value = addresses.elementAt(0).id!;
        }
      }
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  void createEAddressForm() async {
    Get.focusScope!.unfocus();
    progressDialog(
      Get.context!,
      backgroundColor: Get.theme.colorScheme.secondary.withOpacity(0.2),
      contentWidget: Text("kriacoes_agency_module_provider_plus_please_wait".tr, style: Theme.of(Get.context!).textTheme.bodyText2,
      ), progressDialogType: ProgressDialogType.LINEAR,
    );
    if (eAddressForm.currentState!.validate()) {
      try {
        eAddressForm.currentState!.save();
        await _eAddressRepository.create(eAddress.value);
        Navigator.pop(Get.context!);
        Get.offAndToNamed(Routes.E_PROVIDER_PLUS_CREATE);
      } catch (e) {
        Navigator.pop(Get.context!);
        Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
      } finally {}
    } else {
      Navigator.pop(Get.context!);
      Get.showSnackbar(Ui.ErrorSnackBar(message: "kriacoes_agency_module_provider_plus_error_fields".tr));
    }
  }

  Future<Null> loadFormAddressData() async {
    // if(Get.find<SettingsService>().address.value.address != null){
    //
    // }else{
    //
    // }
    Get.showSnackbar(Ui.SuccessSnackBar(message: "kriacoes_agency_module_provider_plus_address_description_label".tr + ": " + Get.find<SettingsService>().address.value.description! + "\n" + "kriacoes_agency_module_provider_plus_address_description_default".tr + ": " + Get.find<SettingsService>().address.value.address!));
  }

  Future<void> logout() async {
    warningDialog(
      Get.context!,
      "Do you want to exit?".tr,
      "You can start over at the next login via the menu".tr,
      positiveButtonText: "Yes".tr,
      positiveButtonAction: () async {
        await Get.find<AuthService>().removeCurrentUser();
        Restart.restartApp();
      },
      negativeButtonText: "No".tr,
      negativeButtonAction: () {},
      hideNeutralButton: true,
      closeOnBackPress: false,
    );
  }

}
