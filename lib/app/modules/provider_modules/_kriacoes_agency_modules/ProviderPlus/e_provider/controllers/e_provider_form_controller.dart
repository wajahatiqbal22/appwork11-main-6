import 'package:fialogs/fialogs.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../models/user_model.dart';
import '../../../../home/controllers/home_controller.dart';
import '../../../../../../routes/app_routes.dart';
import '../repositories/e_provider_repository.dart';
import 'package:restart_app/restart_app.dart';
import '../../providers/global_repositories/setting_plus_repository.dart';
import '../../../../global_widgets/select_dialog.dart';
import '../../../../../../routes/app_routes.dart';
import '../../../../../customer_modules/global_widgets/tab_bar_widget.dart';
import '../../../../../../../common/ui.dart';
import '../../../../../../services/auth_service.dart';
import '../../../../../../services/settings_service.dart';
import '../repositories/e_provider_repository.dart';
import '../../../../../../models/e_provider_type_model.dart';
import '../../../../../../models/address_model.dart';
import '../models/tax_plus_model.dart';
import '../models/e_provider_plus_model.dart';

class EProviderFormController extends GetxController {
  final eEProvider = EProviderPlus().obs;
  final addresses = <Address>[].obs;
  final eEProviderPlus = EProviderPlus().obs;
  final eEProviderPlus2 = EProviderPlus().obs;
  final eProviderTypes = <EProviderType>[].obs;
  final eProviderAddresses = <Address>[].obs;
  final eProviderTaxes = <TaxPlus>[].obs;
  //GlobalKey<FormState> eProviderForm = GlobalKey<FormState>();
  GlobalKey<FormState> eProviderForm = new GlobalKey<FormState>(debugLabel: 'eProviderForm');
  late EProviderRepository _eEProviderRepository;
  SettingPlusRepository? _settingRepository;

  Address get currentAddress => Get.find<SettingsService>().address.value;

  EProviderFormController() {
    _eEProviderRepository = new EProviderRepository();
    _settingRepository = SettingPlusRepository();
  }


  @override
  void onInit() async {
    super.onInit();
    var arguments = Get.arguments as Map<String, dynamic>;
    if (arguments != null) {
      eEProviderPlus.value = arguments['eEProvider'] as EProviderPlus;
      eEProviderPlus2.value = arguments['eEProvider'] as EProviderPlus;
    }
    await getAddresses();
    await getEProvidersTypes();
    //await getEProvidersAddresses();
    await getEProvidersTaxes();
  }

  @override
  void onReady() async {
    super.onReady();
  }

  Future getAddresses() async {
    try {
      if (Get.find<AuthService>().isAuth) {
        addresses.assignAll(await _settingRepository!.getAddresses());
        eEProviderPlus2.value.type=addresses[0].id;
        print("eprovider plus:${eEProviderPlus2.value}");
        if (!currentAddress.isUnknown()) {
          addresses.remove(currentAddress);
          addresses.insert(0, currentAddress);
        }
        if (Get.isRegistered<TabBarController>(tag: 'addresses')) {
          Get.find<TabBarController>(tag: 'addresses').selectedId.value = addresses.elementAt(0).id!;
        }}

    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  Future getEProvidersTypes() async {
    print("eProvider id:${eEProviderPlus.value.id}");
    try {
      if (Get.find<AuthService>().isAuth) {
        eProviderTypes.assignAll(await _eEProviderRepository.getAllEProviderTypes());
      }
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  // Future getEProvidersAddresses() async {
  //   try {
  //     if (Get.find<AuthService>().isAuth) {
  //       eProviderAddresses.assignAll(await _eEProviderRepository.getAllEProviderAddress());
  //     }
  //   } catch (e) {
  //     Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
  //   }
  // }

  Future getEProvidersTaxes() async {
    try {
      if (Get.find<AuthService>().isAuth) {
        eProviderTaxes.assignAll(await _eEProviderRepository.getAllEProviderTaxes());
      }
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  Future getTaxes() async {
    try {
      eProviderTaxes.assignAll(await _eEProviderRepository.getAllTaxes());
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  List<SelectDialogItem<TaxPlus>> getSelectTax() {
    return eProviderTaxes.map((element) {
      return SelectDialogItem(element, element.name!);
    }).toList();
  }

  List<SelectDialogItem<Address>> getSelectAddress() {
    return eProviderAddresses.map((element) {
      return SelectDialogItem(element, element.description!);
    }).toList();
  }

  void resetForm() async {
    Get.toNamed(Routes.E_PROVIDER_PLUS_ADDRESS_CREATE);
  }

  void createEProviderForm() async {

    Get.focusScope!.unfocus();

    progressDialog(
      Get.context!,
      backgroundColor: Get.theme.colorScheme.secondary.withOpacity(0.2),
      contentWidget: Text("kriacoes_agency_module_provider_plus_please_wait".tr, style: Theme.of(Get.context!).textTheme.bodyText2,
      ), progressDialogType: ProgressDialogType.LINEAR,
    );

    // if((eProviderForm.toString()).isEmpty){
    // Navigator.pop(Get.context);
    // warningDialog(
    //   Get.context,
    //   "KADEBUGLOG",
    //       eEProviderPlus.value.type.toString()+"\n" +
    //       eEProviderPlus.value.taxes.toString()+"\n" +
    //       eEProviderPlus.value.name.toString()+"\n" +
    //       eEProviderPlus.value.description.toString()+"\n" +
    //       eEProviderPlus.value.phoneNumber.toString()+"\n" +
    //       eEProviderPlus.value.mobileNumber.toString()+"\n" +
    //       eEProviderPlus.value.availabilityRange.toString()+"\n",
    //   positiveButtonText: "Yes".tr,
    //   positiveButtonAction: () {},
    //   negativeButtonText: "No".tr,
    //   negativeButtonAction: () {},
    //   hideNeutralButton: true,
    //   closeOnBackPress: false,
    // );
    //
    // }

    if (eProviderForm.currentState!.validate()) {
      try {
        eProviderForm.currentState!.save();
        await _eEProviderRepository.create(eEProviderPlus.value);
        goHours(eProviderPlus: eEProviderPlus2.value);
      } catch (e) {
        print("error while creating providers:$e");
        if(e.toString().contains("SQLSTATE[23000]")){
          goHours();
        }else{
          Navigator.pop(Get.context!);
          Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
        }

      } finally {}
    } else {
      Navigator.pop(Get.context!);
      Get.showSnackbar(Ui.ErrorSnackBar(message: "kriacoes_agency_module_provider_plus_error_fields".tr));
    }
  }

  void emptyType(){
    Get.showSnackbar(Ui.ErrorSnackBar(message: "The e provider type id field is required!".tr));
  }

  void emptyTaxes(){
    Get.showSnackbar(Ui.ErrorSnackBar(message: "Tax field is required!".tr));
  }

  void createEProviderFormx() async {
    Get.focusScope!.unfocus();

    progressDialog(
      Get.context!,
      backgroundColor: Get.theme.colorScheme.secondary.withOpacity(0.2),
      contentWidget: Text("kriacoes_agency_module_provider_plus_please_wait".tr, style: Theme.of(Get.context!).textTheme.bodyText2,
      ), progressDialogType: ProgressDialogType.LINEAR,
    );

      if (eProviderForm.currentState!.validate()) {

        try {
          eProviderForm.currentState!.save();
          await _eEProviderRepository.create(eEProviderPlus.value);
          goHours();
        } catch (e) {
          if (e.toString().contains("SQLSTATE[23000]")) {
            goHours();
          }
         else
           if(e.toString().contains("Exception: array_search() expects parameter 2 to be array, null given")){
            Navigator.pop(Get.context!);
            Get.showSnackbar(Ui.ErrorSnackBar(message: "Tax field is required!".tr));
          }

          else if(e.toString().contains("The e provider type id field is required.")){
            Navigator.pop(Get.context!);
            Get.showSnackbar(Ui.ErrorSnackBar(message: "The e provider type id field is required!".tr));
          }
          else{
            Navigator.pop(Get.context!);
            Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
          }

        } finally {

        }
      } else {
        Navigator.pop(Get.context!);
        Get.showSnackbar(Ui.ErrorSnackBar(message: "kriacoes_agency_module_provider_plus_error_fields".tr));
      }
    //DEBUG
    //Navigator.pop(Get.context);
    //Get.showSnackbar(Ui.ErrorSnackBar(message: eEProviderPlus.toString()));
  }

  void goHours({EProviderPlus? eProviderPlus}){
    Navigator.pop(Get.context!);
    //Get.find<PHomeController>().refreshHome();
    Get.offAndToNamed(Routes.E_PROVIDER_PLUS_HOURS,arguments: eProviderPlus);
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
