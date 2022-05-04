import 'package:fialogs/fialogs.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restart_app/restart_app.dart';
import '../../../../../../services/auth_service.dart';
import '../../../../../../routes/app_routes.dart';
import '../../../../../../models/e_provider_model.dart';
import '../../e_provider/models/e_provider_plus_model.dart';
import '../../e_provider/repositories/e_provider_repository.dart';
import '../../../../../../../common/ui.dart';
import '../repositories/e_hours_repository.dart';
import '../models/availability_hour_model.dart';

class EHoursFormController extends GetxController {
  RxList<ProviderAvailabilityHour> eHoursList=<ProviderAvailabilityHour>[].obs;
  final eHours = ProviderAvailabilityHour().obs;
  final eProviders = <EProvider>[].obs;
  final scheduled = false.obs;
  final GlobalKey<FormState> eHoursForm = new GlobalKey<FormState>(debugLabel: 'eHoursForm');
  late EHoursRepository _eHoursRepository;
  late EProviderRepository _eProviderRepository;
  final hours = <ProviderAvailabilityHour>[].obs;

  EHoursFormController() {
    _eHoursRepository = new EHoursRepository();
    _eProviderRepository = new EProviderRepository();
    eHoursList.add(ProviderAvailabilityHour(
      day: "sunday",
      isSelected: false
    ));
    eHoursList.add(ProviderAvailabilityHour(
      day: "monday",
        isSelected: false
    ));
    eHoursList.add(ProviderAvailabilityHour(
      day: "tuesDay",
        isSelected: false
    ));
    eHoursList.add(ProviderAvailabilityHour(
      day: "wednesDay",
        isSelected: false
    ));
    eHoursList.add(ProviderAvailabilityHour(
      day: "thursDay",
        isSelected: false
    ));
    eHoursList.add(ProviderAvailabilityHour(
      day: "friday",
        isSelected: false
    ));
    eHoursList.add(ProviderAvailabilityHour(
      day: "saturday",
        isSelected: false
    ));

  }

  @override
  void onInit() async {
    super.onInit();
    if (Get.arguments != null) {
      var arguments = Get.arguments as EProviderPlus;
      print("arguments1234:${arguments.id}");
    }
    await getEProviders();
  }

  @override
  void onReady() async {
    super.onReady();
  }

  Future getEProviders() async {
    if (Get.arguments != null) {
      var arguments = Get.arguments as EProviderPlus;
      print("arguments1234:${arguments}");
      print("arguments1234:${arguments.type}");
    }
    try {
      eProviders.assignAll(await _eProviderRepository.getAll());
      print("eProviders:$eProviders");
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  void createEHoursForm() async {
    var arguments;
    if (Get.arguments != null) {
       arguments = Get.arguments as EProviderPlus;
      print("arguments1234:${arguments}");
      print("arguments1234:${arguments.type}");
    }
    bool isValidate=true;
    bool isSingleSelected=false;
    for(int i=0;i<eHoursList.length;i++)
      {
        if(eHoursList[i].isSelected!)
          {
            isSingleSelected=true;
            if(eHoursList[i].startAt==null && eHoursList[i].endAt==null)
              {
                Get.showSnackbar(Ui.ErrorSnackBar(message: ""
                    "Please Select ${eHoursList[i].day} Start and End Date".tr));
                isValidate=false;
                break;
              }
            else if(eHoursList[i].startAt==null)
              {
                Get.showSnackbar(Ui.ErrorSnackBar(message: ""
                    "Please Select ${eHoursList[i].day} Start Date".tr));
                isValidate=false;
                break;
              }
            else if(eHoursList[i].endAt==null)
            {
              Get.showSnackbar(Ui.ErrorSnackBar(message: ""
                  "Please Select ${eHoursList[i].day} End Date".tr));
              isValidate=false;
              break;
            }
          }
      }
//    eHoursForm.currentState!.save();

    if(isSingleSelected)
      {
       if(isValidate) {
         try {
           eHoursForm.currentState!.save();
           progressDialog(
             Get.context!,
             backgroundColor: Get.theme.colorScheme.secondary.withOpacity(0.2),
             contentWidget: Text(
               "kriacoes_agency_module_provider_plus_please_wait".tr,
               style: Theme
                   .of(Get.context!)
                   .textTheme
                   .bodyText2,
             ), progressDialogType: ProgressDialogType.LINEAR,
           );
           for (int i = 0; i < eHoursList.length; i++) {
             if (eHoursList[i].isSelected!) {
               print("this is current value:${eHoursList[i]}");
               eHoursList[i].provider = arguments.type;
               await _eHoursRepository.create(eHoursList[i]);
             }
           }
           Get.offAndToNamed(Routes.E_PROVIDER_PLUS_SUCCESS);
         } catch (e) {
           print(e);
           if(e.toString().contains("[302]")){
             Navigator.pop(Get.context!);
             Get.showSnackbar(Ui.ErrorSnackBar(message: "kriacoes_agency_module_provider_plus_availability_hours_day_error".tr));
             //Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
           }else{
             Navigator.pop(Get.context!);
             Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
           }
         }
    }
      }
    else{
      Get.showSnackbar(Ui.ErrorSnackBar(message: ""
          "Please Select AtLeast One Day".tr));

    }
/*    Get.focusScope!.unfocus();

 *//*   progressDialog(
      Get.context!,
      backgroundColor: Get.theme.colorScheme.secondary.withOpacity(0.2),
      contentWidget: Text("kriacoes_agency_module_provider_plus_please_wait".tr, style: Theme.of(Get.context!).textTheme.bodyText2,
      ), progressDialogType: ProgressDialogType.LINEAR,
    );*//*
    print("eHours Val 1");
    print(eHours.value);

    if (eHoursForm.currentState!.validate()) {

      try {
//        Navigator.pop(Get.context!);
        eHoursForm.currentState!.save();
        print("eHours Val");
        print(eHours.value);
        await _eHoursRepository.create(eHours.value);

        warningDialog(
          Get.context!,
          "kriacoes_agency_module_provider_plus_hour_dialog_title".tr,
          "kriacoes_agency_module_provider_plus_hour_dialog_message".tr,
          positiveButtonText: "kriacoes_agency_module_provider_plus_hour_dialog_btn_yes".tr,
          positiveButtonAction: () {
            eHoursForm.currentState!.reset();
          },
          negativeButtonText: "kriacoes_agency_module_provider_plus_hour_dialog_btn_no".tr,
          negativeButtonAction: () {
            Get.offAndToNamed(Routes.E_PROVIDER_PLUS_SUCCESS);
          },
          hideNeutralButton: true,
          closeOnBackPress: false,
        );

      } catch (e) {
        if(e.toString().contains("[302]")){
          Navigator.pop(Get.context!);
          Get.showSnackbar(Ui.ErrorSnackBar(message: "kriacoes_agency_module_provider_plus_availability_hours_day_error".tr));
          //Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
        }else{
          Navigator.pop(Get.context!);
          Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
        }
      } finally {}
    } else {
      print("its here1234");
      Navigator.pop(Get.context!);
      Get.showSnackbar(Ui.ErrorSnackBar(message: "kriacoes_agency_module_provider_plus_error_fields".tr));
    }*/
  }

  Future<Null> showStartTimePicker({required BuildContext context,int? index}) async {
    final initialEndTime = TimeOfDay(hour: 00, minute: 01);
    final newEndAtTime = await showTimePicker(

      context: context,
      helpText: "kriacoes_agency_module_provider_plus_start_hour_title".tr,
      cancelText: "kriacoes_agency_module_provider_plus_hour_cancel".tr,
      confirmText: "kriacoes_agency_module_provider_plus_hour_confirm".tr,
      hourLabelText: "kriacoes_agency_module_provider_plus_hour_label".tr,
      minuteLabelText: "kriacoes_agency_module_provider_plus_minute_label".tr,
      errorInvalidText: "kriacoes_agency_module_provider_plus_hour_invalid".tr,
      initialEntryMode: TimePickerEntryMode.dial,
      initialTime: initialEndTime,
      builder: (BuildContext? context, Widget? child) {
        return child!.paddingAll(10);
      },
    );

    if (newEndAtTime != null) {
      eHoursList[index!].startAt=
          newEndAtTime.hour.toString().padLeft(2, '0') +":"+ newEndAtTime.minute.toString().padLeft(2, '0');
      eHoursList.refresh();

    /*  eHours.update((val) {
        val!.startAt = newEndAtTime.hour.toString().padLeft(2, '0') +":"+ newEndAtTime.minute.toString().padLeft(2, '0');
      });*/
    }
  }

  Future<Null> showEndTimePicker({required BuildContext context, int? index}) async {
    final initialEndTime = TimeOfDay(hour: 23, minute: 59);
    final newEndAtTime = await showTimePicker(
      context: context,
      helpText: "kriacoes_agency_module_provider_plus_end_hour_title".tr,
      cancelText: "kriacoes_agency_module_provider_plus_hour_cancel".tr,
      confirmText: "kriacoes_agency_module_provider_plus_hour_confirm".tr,
      hourLabelText: "kriacoes_agency_module_provider_plus_hour_label".tr,
      minuteLabelText: "kriacoes_agency_module_provider_plus_minute_label".tr,
      errorInvalidText: "kriacoes_agency_module_provider_plus_hour_invalid".tr,
      initialEntryMode: TimePickerEntryMode.dial,
      initialTime: initialEndTime,
      builder: (BuildContext? context, Widget? child) {
        return child!.paddingAll(10);
      },
    );

    if (newEndAtTime != null) {
      eHoursList[index!].endAt=
          newEndAtTime.hour.toString().padLeft(2, '0') +":"+ newEndAtTime.minute.toString().padLeft(2, '0');
      eHoursList.refresh();
    /*   eHours.update((val) {
        val!.endAt = newEndAtTime.hour.toString().padLeft(2, '0') +":"+ newEndAtTime.minute.toString().padLeft(2, '0');
      });*/
    }
  }

  Future<void> logout() async {
    warningDialog(
      Get.context!,
      "Leave Avaliable Hours?".tr,
      "If you leave it will not be possible to register the time again through the app.".tr,
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
