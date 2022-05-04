import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home_services/common/ui.dart';
import '../../../../../customer_modules/global_widgets/text_field_widget.dart';
import '../../../../../../routes/app_routes.dart';
import '../../../../../../services/auth_service.dart';
import '../../../../../../services/settings_service.dart';
import '../../providers/global_widgets/horizontal_stepper_widget.dart';
import '../../providers/global_widgets/step_widget.dart';
import '../../ui/ux.dart';
import '../controllers/e_address_form_controller.dart';

class EAddressFormView extends GetView<EAddressFormController> {

  @override
  Widget build(BuildContext context) {
    print(controller.eAddress.value);
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Get.theme.primaryColor),
            onPressed: () {
              Get.toNamed(Routes.PROOT, arguments: 0);
            },
          ),
        title: Text(
          "kriacoes_agency_module_provider_plus_bar_title_address".tr,
          style: context.textTheme.headline4!.merge(TextStyle(color: Get.theme.primaryColor)),
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
          borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          boxShadow: [
            BoxShadow(color: Get.theme.focusColor.withOpacity(0.1), blurRadius: 10, offset: Offset(0, -5)),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: MaterialButton(
                onPressed: () {
                  if(Get.find<SettingsService>().address.value.latitude == null || Get.find<SettingsService>().address.value.latitude == 0){
//                      Navigator.pop(context);
                    Get.toNamed(Routes.E_PROVIDER_PLUS_SETTINGS_ADDRESS_PICKER);
                  }else{
                    controller.createEAddressForm();
                  }
                },
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                color: Get.theme.colorScheme.secondary,
                child:  Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 6,
                  children: [
                    Text("kriacoes_agency_module_provider_plus_address_button_save".tr,
                        style: Get.textTheme.bodyText2!.merge(TextStyle(color: Get.theme.primaryColor))),
                    Icon(
                      Icons.check,
                      color: Get.theme.primaryColor,
                      size: 20,
                    ),
                  ],
                ),
                elevation: Get.find<SettingsService>().address.value.latitude == null ? 0 : 5,
              ),
            ),
          ],
        ).paddingSymmetric(vertical: 15, horizontal: 20),
      ),
      body: Form(
        key: controller.eAddressForm,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 15),
              //Steps
              HorizontalStepperWidget(
                steps: [
                  StepWidget(
                    height: 32,
                    width: 32,
                    title: Text("kriacoes_agency_module_provider_plus_address_step".tr, style: Get.textTheme.headline5!.merge(TextStyle(color: Get.theme.colorScheme.secondary, fontSize: 14)) ),
                    index: Pulse(infinite: true, child:Text("1", style: TextStyle(color: Get.theme.primaryColor))),
                  ),
                  StepWidget(
                    height: 20,
                    width: 20,
                    title: Text(
                        "kriacoes_agency_module_provider_plus_provider_step".tr,
                        style: TextStyle(fontSize: 10)
                    ),
                    color: Get.theme.focusColor,
                    index: Text("2", style: TextStyle(color: Get.theme.primaryColor)),
                  ),
                  StepWidget(
                    height: 20,
                    width: 20,
                    title: Text(
                        "kriacoes_agency_module_provider_plus_hours_step".tr,
                        style: TextStyle(fontSize: 10)
                    ),
                    color: Get.theme.focusColor,
                    index: Text("3", style: TextStyle(color: Get.theme.primaryColor)),
                  ),
                ],
              ),
              Text("kriacoes_agency_module_provider_plus_title_address".tr, style: Get.textTheme.headline5).paddingOnly(top: 10, bottom: 0, right: 20, left: 20),
              // Text("kriacoes_agency_module_provider_plus_subtitle_address".tr, style: Get.textTheme.caption).paddingSymmetric(horizontal: 20, vertical: 0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 20),
                  Container( alignment: AlignmentDirectional.center,
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            Stack(
                              children: <Widget>[
                                ElasticIn(
                                    delay: Duration(milliseconds: 500),
                                    child:
                                    Container(
//                                      width: 150,
                                      height: 130,
                                      /*decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(20),
                                          gradient: LinearGradient(begin: Alignment.bottomLeft, end: Alignment.topRight, colors: [
                                            Colors.blueGrey.withOpacity(1),
                                            Colors.blueGrey.withOpacity(0.2),
                                          ])),*/
                                      child: Pulse(
                                          infinite: true,
                                          child: Image.asset("assets/img/location.jpeg")/*Icon(
                                            Icons.add_location_alt_outlined ,
                                            color: Theme.of(context).shadowColor,
                                            size: 90,
                                          )*/),
                                    )
                                ),
                                Positioned(
                                  right: -30,
                                  bottom: -50,
                                  child: Container(
                                    width: 100,
                                    height: 100,
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.15),
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
                                      color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(150),
                                    ),
                                  ),
                                )
                              ],
                            )
                          ]
                      )
                  ),

                  SizedBox(height: 50),

                  Row(
                    children: [
                      SizedBox(height: 5),
                      Opacity(
                        opacity: 0.5,
                        child:
                        AutoSizeText(
                          "kriacoes_agency_module_provider_plus_subtitle_address".tr,
                          style: Get.textTheme.bodyText2,
                          maxLines: 3,
                        ),
                      ),
                    ],
                  ).paddingSymmetric(vertical: 15, horizontal: 20),

                  SizedBox(height: 20),
                  //Check address
                  Row(
                    children: [

                      MaterialButton(
                        onPressed: () {
                          Get.toNamed(Routes.E_PROVIDER_PLUS_SETTINGS_ADDRESS_PICKER);
                        },
                        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        color: Get.theme.colorScheme.secondary.withOpacity(0.2),
                        child:  Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: 6,
                          children: [
                            Text("kriacoes_agency_module_provider_plus_address_picker_button_change".tr,
                                style: Get.textTheme.bodyText2!.merge(TextStyle(color: Get.theme.colorScheme.secondary))),
                            Icon(
                              Icons.my_location,
                              color: Get.theme.colorScheme.secondary,
                              size: 20,
                            ),
                          ],
                        ),
                        elevation: 0,
                      ),

                      // MaterialButton(
                      //   onPressed: () async {
                      //     Get.toNamed(Routes.E_PROVIDER_PLUS_SETTINGS_ADDRESS_PICKER);
                      //   },
                      //   padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                      //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      //   color: Get.theme.colorScheme.secondary.withOpacity(0.5),
                      //   child: Text("kriacoes_agency_module_provider_plus_address_picker_button_change".tr, style: Get.textTheme.bodyText2.merge(TextStyle(color: Get.theme.primaryColor))),
                      //   elevation: 0,
                      // ),
                      SizedBox(width: 10),
                      Expanded(
                        child: MaterialButton(
                          onPressed: () async {
                            controller.loadFormAddressData();
                          },
                          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          color: Get.theme.colorScheme.secondary,
                          child: Text("kriacoes_agency_module_provider_plus_address_picker_button_address".tr, style: Get.textTheme.bodyText2!.merge(TextStyle(color: Get.theme.primaryColor))),
                          elevation: 0,
                        ),
                      ),
                    ],
                  ).paddingSymmetric(vertical: 0, horizontal: 20),
                  //Check address

                  TextFormField(
                    onSaved: (input) {
                      controller.eAddress.value.description = Get.find<SettingsService>().address.value.description;
                      controller.eAddress.value.latitude = Get.find<SettingsService>().address.value.latitude;
                      controller.eAddress.value.longitude = Get.find<SettingsService>().address.value.longitude;
                      controller.eAddress.value.address = Get.find<SettingsService>().address.value.address;
                      controller.eAddress.value.userId = Get.find<AuthService>().user.value.id;
                      controller.eAddress.value.isDefault = true;
                    },
                    enabled: false,
                    decoration: Ui.getInputDecoration(
                    ),
                  ),

                  // GestureDetector(
                  //   onTap: () {},
                  //   child:
                  //       TextFieldWidget(
                  //         onSaved: (input) {
                  //           controller.eAddress.value.description = Get.find<SettingsService>().address.value.description;
                  //           controller.eAddress.value.latitude = Get.find<SettingsService>().address.value.latitude;
                  //           controller.eAddress.value.longitude = Get.find<SettingsService>().address.value.longitude;
                  //           controller.eAddress.value.address = Get.find<SettingsService>().address.value.address;
                  //           controller.eAddress.value.userId = Get.find<AuthService>().user.value.id;
                  //           controller.eAddress.value.isDefault = true;
                  //         },
                  //         isEnabled: false,
                  //         //validator: (input) => input.length < 3 ? "kriacoes_agency_module_provider_plus_address_warning".tr : null,
                  //         //initialValue: controller.eAddress.value.description ?? "kriacoes_agency_module_provider_plus_address_description_default".tr,
                  //         //iconData: Icons.text_snippet_outlined,
                  //         //labelText: "kriacoes_agency_module_provider_plus_address_description_label".tr,
                  //         //style: TextStyle(color: Colors.grey),
                  //         //isFirst: true,
                  //         //isLast: false,
                  //       ),
                  //
                  //     ),

                      // GestureDetector(
                      //     onTap: () {
                      //       //Navigator.pop(context);
                      //       Get.toNamed(Routes
                      //           .E_PROVIDER_PLUS_SETTINGS_ADDRESS_PICKER);
                      //     },
                      //     child:
                      //
                      //     TextFieldWidget(
                      //       onSaved: (input) {
                      //         controller.eAddress.value.address = Get.find<SettingsService>().address.value.address;
                      //         controller.eAddress.value.userId = Get.find<AuthService>().user.value.id;
                      //         controller.eAddress.value.isDefault = true;
                      //       },
                      //       isEnabled: false,
                      //       initialValue: controller.eAddress.value.address, // Get.find<SettingsService>().address.value.address,
                      //       validator: (input) =>
                      //       input.length < 3 ? "kriacoes_agency_module_provider_plus_address_warning".tr : null,
                      //       keyboardType: TextInputType.multiline,
                      //       iconData: Icons.business_sharp,
                      //       labelText: "kriacoes_agency_module_provider_plus_address_address_label".tr,
                      //       style: TextStyle(color: Colors.grey),
                      //       isFirst: false,
                      //       isLast: true,
                      //     ),
                      //
                      // ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  showExitDialog() {
    // set up the buttons
    Widget cancelButton = MaterialButton(
      child: Text("kriacoes_agency_module_provider_plus_cancel".tr),
      onPressed:  () {
        Navigator.of(Get.context!).pop();
      },
    );
    Widget continueButton = MaterialButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      color: Get.theme.colorScheme.secondary,
      child: Text("kriacoes_agency_module_provider_plus_yes_logout".tr, style: Get.textTheme.subtitle1!.merge(TextStyle(color: Get.theme.primaryColor))),
      onPressed: () async {
        await Get.find<AuthService>().removeCurrentUser();
        await Get.offNamedUntil(Routes.LOGIN, (Route route) {
          if (route.settings.name == Routes.LOGIN) {
            return true;
          }
          return false;
        });
      },
    );
    AlertDialog alert = AlertDialog(
      title: Opacity(
        opacity: 0.5,
        child: AutoSizeText(
          "kriacoes_agency_module_provider_plus_want_exit".tr,
          style: Get.textTheme.headline4,
          maxLines: 1,
        ),
      ),
      content: Opacity(
        opacity: 0.6,
        child: Text(
          Get.find<AuthService>().user.value.name! + "kriacoes_agency_module_provider_plus_exit_message".tr,
          style: Get.textTheme.headline4!.merge(TextStyle(fontSize: 12)),
        ),
      ),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    showDialog(
      context: Get.context!,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
