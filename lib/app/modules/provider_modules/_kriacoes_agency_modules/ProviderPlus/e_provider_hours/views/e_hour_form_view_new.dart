import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../customer_modules/global_widgets/text_field_widget.dart';
import '../controllers/e_hours_form_controller.dart';
import '../../providers/global_widgets/horizontal_stepper_widget.dart';
import '../../providers/global_widgets/step_widget.dart';
import '../../ui/ux.dart';

class EHoursFormViewNew extends GetView<EHoursFormController> {
  @override
  Widget build(BuildContext context) {
    print(controller.eHours.value);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "kriacoes_agency_module_provider_plus_bar_title_hour".tr,
          style: context.textTheme.headline4!
              .merge(TextStyle(color: Get.theme.primaryColor)),
        ),
        centerTitle: true,
        backgroundColor: Get.theme.colorScheme.secondary,
        elevation: 5,
        actions: [
          new IconButton(
            padding: EdgeInsets.symmetric(horizontal: 20),
            icon: new Icon(
              Icons.logout,
              color: Colors.redAccent,
              size: 28,
            ),
            onPressed: () {
              controller.logout();
            },
          ),
        ],
        automaticallyImplyLeading: false,
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Get.theme.primaryColor,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          boxShadow: [
            BoxShadow(
                color: Get.theme.focusColor.withOpacity(0.1),
                blurRadius: 10,
                offset: Offset(0, -5)),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: MaterialButton(
                onPressed: () {
                  controller.createEHoursForm();
                },
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                color: Get.theme.colorScheme.secondary,
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 6,
                  children: [
                    Text(
                        "kriacoes_agency_module_provider_plus_save_hour_button"
                            .tr,
                        style: Get.textTheme.bodyText2!
                            .merge(TextStyle(color: Get.theme.primaryColor))),
                    Icon(
                      Icons.check,
                      color: Get.theme.primaryColor,
                      size: 20,
                    ),
                  ],
                ),
                elevation: 5,
              ),
            ),
          ],
        ).paddingSymmetric(vertical: 15, horizontal: 20),
      ),
      body: Form(
        key: controller.eHoursForm,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 15),
              HorizontalStepperWidget(
                steps: [
                  StepWidget(
                    height: 20,
                    width: 20,
                    title: Text(
                        "kriacoes_agency_module_provider_plus_address_step".tr,
                        style: TextStyle(fontSize: 10)),
                    color: Get.theme.focusColor,
                    index: Text("2",
                        style: TextStyle(color: Get.theme.primaryColor)),
                  ),
                  StepWidget(
                    height: 20,
                    width: 20,
                    title: Text(
                        "kriacoes_agency_module_provider_plus_provider_step".tr,
                        style: TextStyle(fontSize: 10)),
                    color: Get.theme.focusColor,
                    index: Text("2",
                        style: TextStyle(color: Get.theme.primaryColor)),
                  ),
                  StepWidget(
                    height: 32,
                    width: 32,
                    title: Text(
                        "kriacoes_agency_module_provider_plus_hours_step".tr,
                        style: Get.textTheme.headline5!.merge(TextStyle(
                            color: Get.theme.colorScheme.secondary,
                            fontSize: 14))),
                    index: Pulse(
                        infinite: true,
                        child: Text("3",
                            style: TextStyle(color: Get.theme.primaryColor))),
                  ),
                ],
              ),
              Text("kriacoes_agency_module_provider_plus_bar_title_hour".tr,
                  style: Get.textTheme.headline5)
                  .paddingOnly(top: 10, bottom: 0, right: 20, left: 20),
              Text(
                  "kriacoes_agency_module_provider_plus_subtitle_availability_hours"
                      .tr,
                  style: Get.textTheme.caption)
                  .paddingSymmetric(horizontal: 20, vertical: 0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                      alignment: AlignmentDirectional.center,
                      padding:
                      EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            Stack(
                              children: <Widget>[
                                ElasticIn(
                                    delay: Duration(milliseconds: 500),
                                    child: Container(
                                      width: 130,
                                      height: 130,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                          BorderRadius.circular(20),
                                          gradient: LinearGradient(
                                              begin: Alignment.bottomLeft,
                                              end: Alignment.topRight,
                                              colors: [
                                                Colors.orange.withOpacity(1),
                                                Colors.orange.withOpacity(0.2),
                                              ])),
                                      child: Pulse(
                                          infinite: true,
                                          child: Icon(
                                            Icons.access_time,
                                            color: Theme.of(context)
                                                .scaffoldBackgroundColor,
                                            size: 90,
                                          )),
                                    )),
                                Positioned(
                                  right: -30,
                                  bottom: -50,
                                  child: Container(
                                    width: 100,
                                    height: 100,
                                    decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .scaffoldBackgroundColor
                                          .withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(150),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  left: -20,
                                  top: -50,
                                  child: Container(
                                    width: 120,
                                    height: 120,
                                    decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .scaffoldBackgroundColor
                                          .withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(150),
                                    ),
                                  ),
                                )
                              ],
                            )
                          ])),
                  TextFieldWidget(
                    onSaved: (input) {
                      controller.eHours.value.startAt =
                          controller.eHours.value.startAt;
                      controller.eHours.value.endAt =
                          controller.eHours.value.endAt;
                      controller.eHours.value.provider =
                          controller.eProviders.first.id;
                      controller.eHours.value.data = input;
                    },
                    labelText:
                    "kriacoes_agency_module_provider_plus_bar_hour_data".tr,
                    isFirst: true,
                    isLast: false,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    decoration: BoxDecoration(
                      color: Get.theme.primaryColor,
                      boxShadow: [
                        BoxShadow(
                            color: Get.theme.focusColor.withOpacity(0.1),
                            blurRadius: 10,
                            offset: Offset(0, 5)),
                      ],
                      border: Border.all(
                          color: Get.theme.focusColor.withOpacity(0.05)),
                    ),
                    child: Column(
                      children: [
                        Obx(() {
                          return Row(
                            children: [
                              Expanded(
                                  child: Text(
                                      controller.eHours.value.startAt != null
                                          ? "kriacoes_agency_module_provider_plus_start_hour"
                                          .tr +
                                          controller.eHours.value.startAt!
                                          : "kriacoes_agency_module_provider_plus_start_hour_empty"
                                          .tr,
                                      style: Get.textTheme.headline3!
                                          .merge(TextStyle(fontSize: 14)))),
                              SizedBox(width: 10),
                              MaterialButton(
                                elevation: 0,
                                onPressed: () {
                                  controller.showStartTimePicker(context: context);
                                },
                                shape: StadiumBorder(),
                                color: Get.theme.colorScheme.secondary,
                                child: Text(
                                    "kriacoes_agency_module_provider_plus_hour_choose"
                                        .tr,
                                    style: Get.textTheme.subtitle1!.merge(
                                        TextStyle(
                                            color: Get.theme.primaryColor))),
                              ),
                            ],
                          );
                        }),
                        Divider(thickness: 1.3, height: 30),
                        Obx(() {
                          return Row(
                            children: [
                              Expanded(
                                child: Text(
                                    controller.eHours.value.endAt != null
                                        ? "kriacoes_agency_module_provider_plus_end_hour"
                                        .tr +
                                        controller.eHours.value.endAt!
                                        : "kriacoes_agency_module_provider_plus_end_hour_empty"
                                        .tr,
                                    style: Get.textTheme.headline3!
                                        .merge(TextStyle(fontSize: 14))),
                              ),
                              SizedBox(width: 10),
                              MaterialButton(
                                onPressed: () {
                                  controller.showEndTimePicker(context: context);
                                },
                                shape: StadiumBorder(),
                                color: Get.theme.colorScheme.secondary,
                                child: Text(
                                    "kriacoes_agency_module_provider_plus_hour_choose"
                                        .tr,
                                    style: Get.textTheme.subtitle1!.merge(
                                        TextStyle(
                                            color: Get.theme.primaryColor))),
                                elevation: 0,
                              ),
                            ],
                          );
                        }),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(20),
                    margin: EdgeInsets.only(bottom: 20, left: 20, right: 20),
                    decoration: BoxDecoration(
                        color: Get.theme.primaryColor,
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20)),
                        boxShadow: [
                          BoxShadow(
                              color: Get.theme.focusColor.withOpacity(0.1),
                              blurRadius: 10,
                              offset: Offset(0, 5)),
                        ],
                        border: Border.all(
                            color: Get.theme.focusColor.withOpacity(0.05))),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                            "kriacoes_agency_module_provider_plus_bar_hour_select_day"
                                .tr,
                            style: Get.textTheme.headline3!
                                .merge(TextStyle(fontSize: 14))),
                        SizedBox(height: 10),
                        Obx(() {
                          return ListTileTheme(
                            contentPadding: EdgeInsets.all(0.0),
                            horizontalTitleGap: 0,
                            dense: true,
                            textColor: Get.theme.hintColor,
                            child: ListBody(
                              children: [
                                RadioListTile(
                                  activeColor: Get.theme.colorScheme.secondary,
                                  value: "sunday",
                                  groupValue: controller.eHours.value.day,
                                  title: Text(
                                      "kriacoes_agency_module_provider_plus_day_sunday"
                                          .tr),
                                  controlAffinity:
                                  ListTileControlAffinity.trailing,
                                  onChanged: (checked) {
                                    controller.eHours.update((val) {
                                      val!.day = "sunday";
                                      controller.eHours.value.day = "sunday";
                                    });
                                  },
                                ),
                                RadioListTile(
                                  activeColor: Get.theme.colorScheme.secondary,
                                  value: "monday",
                                  groupValue: controller.eHours.value.day,
                                  title: Text(
                                      "kriacoes_agency_module_provider_plus_day_monday"
                                          .tr),
                                  controlAffinity:
                                  ListTileControlAffinity.trailing,
                                  onChanged: (checked) {
                                    controller.eHours.update((val) {
                                      val!.day = "monday";
                                      controller.eHours.value.day = "monday";
                                    });
                                  },
                                ),
                                RadioListTile(
                                  activeColor: Get.theme.colorScheme.secondary,
                                  value: "tuesday",
                                  groupValue: controller.eHours.value.day,
                                  title: Text(
                                      "kriacoes_agency_module_provider_plus_day_tuesday"
                                          .tr),
                                  controlAffinity:
                                  ListTileControlAffinity.trailing,
                                  onChanged: (checked) {
                                    controller.eHours.update((val) {
                                      val!.day = "tuesday";
                                      controller.eHours.value.day = "tuesday";
                                    });
                                  },
                                ),
                                RadioListTile(
                                  activeColor: Get.theme.colorScheme.secondary,
                                  value: "wednesday",
                                  groupValue: controller.eHours.value.day,
                                  title: Text(
                                      "kriacoes_agency_module_provider_plus_day_wednesday"
                                          .tr),
                                  controlAffinity:
                                  ListTileControlAffinity.trailing,
                                  onChanged: (checked) {
                                    controller.eHours.update((val) {
                                      val!.day = "wednesday";
                                      controller.eHours.value.day = "wednesday";
                                    });
                                  },
                                ),
                                RadioListTile(
                                  activeColor: Get.theme.colorScheme.secondary,
                                  value: "thursday",
                                  groupValue: controller.eHours.value.day,
                                  title: Text(
                                      "kriacoes_agency_module_provider_plus_day_thursday"
                                          .tr),
                                  controlAffinity:
                                  ListTileControlAffinity.trailing,
                                  onChanged: (checked) {
                                    controller.eHours.update((val) {
                                      val!.day = "thursday";
                                      controller.eHours.value.day = "thursday";
                                    });
                                  },
                                ),
                                RadioListTile(
                                  activeColor: Get.theme.colorScheme.secondary,
                                  value: "friday",
                                  groupValue: controller.eHours.value.day,
                                  title: Text(
                                      "kriacoes_agency_module_provider_plus_day_friday"
                                          .tr),
                                  controlAffinity:
                                  ListTileControlAffinity.trailing,
                                  onChanged: (checked) {
                                    controller.eHours.update((val) {
                                      val!.day = "friday";
                                      controller.eHours.value.day = "friday";
                                    });
                                  },
                                ),
                                RadioListTile(
                                  activeColor: Get.theme.colorScheme.secondary,
                                  value: "saturday",
                                  groupValue: controller.eHours.value.day,
                                  title: Text(
                                      "kriacoes_agency_module_provider_plus_day_saturday"
                                          .tr),
                                  controlAffinity:
                                  ListTileControlAffinity.trailing,
                                  onChanged: (checked) {
                                    controller.eHours.update((val) {
                                      val!.day = "saturday";
                                      controller.eHours.value.day = "saturday";
                                    });
                                  },
                                ),
                              ],
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
