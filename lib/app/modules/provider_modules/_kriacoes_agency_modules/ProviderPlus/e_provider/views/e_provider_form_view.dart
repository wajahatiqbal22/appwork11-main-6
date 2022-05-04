import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../../common/ui.dart';
import '../../../../../../routes/app_routes.dart';
import '../../../../../../services/auth_service.dart';
import '../../../../../customer_modules/global_widgets/text_field_widget.dart';
//import '../../../../../provider_modules/global_widgets/text_field_widget.dart';
import '../../../../../provider_modules/global_widgets/select_dialog.dart';
import '../../../../global_widgets/select_dialog.dart';
import '../../providers/global_widgets/horizontal_stepper_widget.dart';
import '../../providers/global_widgets/step_widget.dart';
import '../../providers/global_widgets/tab_bar_widget.dart';
import '../../ui/ux.dart';
import '../controllers/e_provider_form_controller.dart';
import '../models/tax_plus_model.dart';

class EProviderFormView extends GetView<EProviderFormController> {
  @override
  Widget build(BuildContext context) {
    print("print:${controller.eEProviderPlus.value}");
    return Scaffold(
        appBar: AppBar(
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back_ios, color: Get.theme.primaryColor),
            onPressed: () async {
              Get.back();
            },
          ),
          title: Text(
            "kriacoes_agency_module_provider_plus_bar_title_provider".tr,
            style: context.textTheme.headline4!.merge(TextStyle(color: Get.theme.primaryColor)),
          ),
          centerTitle: true,
          backgroundColor: Get.theme.colorScheme.secondary,
          elevation: 5,
          actions: [
            new IconButton(
              padding: EdgeInsets.symmetric(horizontal: 20),
              icon: new Icon(
                Icons.power_settings_new,
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
                    if(controller.eEProviderPlus.value.type == null){
                        controller.emptyType();
                      }else if(controller.eEProviderPlus.value.taxes == null){
                        controller.emptyTaxes();
                      }else{
                        controller.createEProviderForm();
                      }
                    },
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  color: Get.theme.colorScheme.secondary,
                  child: Text("kriacoes_agency_module_provider_plus_become_provider_button".tr, style: Get.textTheme.bodyText2!.merge(TextStyle(color: Get.theme.primaryColor))),
                  elevation: 5,
                ),
              ),
            ],
          ).paddingSymmetric(vertical: 15, horizontal: 20),
        ),
        body: Form(
          key: controller.eProviderForm,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HorizontalStepperWidget(
                  steps: [
                    StepWidget(
                      height: 20,
                      width: 20,
                      title: Text(
                          "kriacoes_agency_module_provider_plus_address_step".tr,
                          style: TextStyle(fontSize: 10)
                      ),
                      color: Get.theme.focusColor,
                      index: Text("1", style: TextStyle(color: Get.theme.primaryColor)),
                    ),
                    StepWidget(
                      height: 32,
                      width: 32,
                      title: Text("kriacoes_agency_module_provider_plus_provider_step".tr, style: Get.textTheme.headline5!.merge(TextStyle(color: Get.theme.colorScheme.secondary, fontSize: 14)) ),
                      index: Pulse( infinite: true, child:Text("2", style: TextStyle(color: Get.theme.primaryColor))),
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
                //Text("kriacoes_agency_module_provider_plus_provider_images".tr, style: Get.textTheme.headline5).paddingOnly(top: 25, bottom: 0, right: 22, left: 22),
                //Text("kriacoes_agency_module_provider_plus_provider_images_help".tr, style: Get.textTheme.caption).paddingSymmetric(horizontal: 22, vertical: 5),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [

                    // ImagesFieldWidget(
                    //   label: "kriacoes_agency_module_provider_plus_images".tr,
                    //   field: 'image',
                    //   tag: controller.eProviderForm.hashCode.toString(),
                    //   uploadCompleted: (uuid) {
                    //     controller.eEProviderPlus.update((val) {
                    //       val.images = val.images ?? [];
                    //       val.images.add(new Media(id: uuid));
                    //     });
                    //   },
                    //   reset: (uuids) {
                    //     controller.eEProviderPlus.update((val) {
                    //       val.images.clear();
                    //     });
                    //   },
                    // ),

                    Text("kriacoes_agency_module_provider_plus_provider_financial".tr, style: Get.textTheme.headline5).paddingOnly(top: 10, bottom: 0, right: 22, left: 22),
                    Text("kriacoes_agency_module_provider_plus_provider_financial_message".tr, style: Get.textTheme.caption).paddingSymmetric(horizontal: 22, vertical: 5),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                      margin: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 0),
                      decoration: BoxDecoration(
                          color: Get.theme.primaryColor,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          boxShadow: [
                            BoxShadow(color: Get.theme.focusColor.withOpacity(0.1), blurRadius: 10, offset: Offset(0, 5)),
                          ],
                          border: Border.all(color: Get.theme.focusColor.withOpacity(0.05))),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  SizedBox(width: 0),
                                  Expanded(child: Text("kriacoes_agency_module_provider_plus_provider_label".tr, style: Get.textTheme.bodyText1)),
                                ],
                              ),
                              SizedBox(height: 5),
                              Obx(() {
                                if (controller.eProviderTypes.isEmpty) {
                                  return TabBarLoadingWidget();
                                } else {
                                  return TabBarWidget(
                                    initialSelectedId: null,
                                    tag: 'eProviderTypes',
                                    tabs: List.generate(controller.eProviderTypes.length, (index) {
                                      final _etypes = controller.eProviderTypes.elementAt(index);
                                      return ChipWidget(
                                        tag: 'eProviderTypes',
                                        text: _etypes.name!,
                                        id: _etypes,
                                        onSelected: (id) {
                                          //Get.showSnackbar(Ui.SuccessSnackBar(message: "kriacoes_agency_module_provider_plus_success_message_one".tr + _etypes.name + "kriacoes_agency_module_provider_plus_success_message_two".tr));
                                          controller.eEProviderPlus.value.type = _etypes.id;
                                        },
                                      );
                                    }),
                                  );
                                }
                              }
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Obx(() {
                      if (controller.eProviderTaxes.length > 1)
                        return Container(
                          padding: EdgeInsets.only(top: 8, bottom: 10, left: 20, right: 20),
                          margin: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                          decoration: BoxDecoration(
                              color: Get.theme.primaryColor,
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              boxShadow: [
                                BoxShadow(color: Get.theme.focusColor.withOpacity(0.1), blurRadius: 10, offset: Offset(0, 5)),
                              ],
                              border: Border.all(color: Get.theme.focusColor.withOpacity(0.05))),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      "kriacoes_agency_module_provider_plus__provider_taxes_label".tr,
                                      style: Get.textTheme.bodyText1,
                                      textAlign: TextAlign.start,
                                    ),
                                  ),
                                  MaterialButton(
                                    onPressed: () async {
                                      final selectedValue = await showDialog<TaxPlus>(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (BuildContext context) {
                                          return SelectDialog(
                                            title: "kriacoes_agency_module_provider_plus__provider_taxes_label_dialog".tr,
                                            submitText: "kriacoes_agency_module_provider_plus__provider_taxes_submit".tr,
                                            //cancelText: "kriacoes_agency_module_provider_plus__provider_taxes_cancel".tr,
                                            items: controller.getSelectTax(),
                                          );
                                        },
                                      );
                                      controller.eEProviderPlus.update((val) {
                                        val!.taxes = selectedValue;
                                      });
                                    },
                                    shape: StadiumBorder(),
                                    color: Get.theme.colorScheme.secondary.withOpacity(0.1),
                                    child: Text("kriacoes_agency_module_provider_plus__provider_taxes_select".tr, style: Get.textTheme.subtitle1),
                                    elevation: 0,
                                    hoverElevation: 0,
                                    focusElevation: 0,
                                    highlightElevation: 0,
                                  ),
                                ],
                              ),
                              Obx(() {
                                if (controller.eEProviderPlus.value.taxes == null) {
                                  return Padding(
                                    padding: EdgeInsets.symmetric(vertical: 20),
                                    child: Text(
                                      "kriacoes_agency_module_provider_plus__provider_taxes_hint".tr,
                                      style: Get.textTheme.caption,
                                    ),
                                  );
                                } else {
                                  return buildTaxes(controller.eEProviderPlus.value.taxes!);
                                }
                              })
                            ],
                          ),
                        );
                      else {
                        return SizedBox();
                      }
                    }),

                    Text("kriacoes_agency_module_provider_plus_provider_details".tr, style: Get.textTheme.headline5).paddingOnly(top: 0, bottom: 0, right: 22, left: 22),
                    Text("kriacoes_agency_module_provider_plus_provider_details_help".tr, style: Get.textTheme.caption).paddingSymmetric(horizontal: 22, vertical: 5),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextFieldWidget(
                          onSaved: (input) {
                            controller.eEProviderPlus.value.name = input;
                            controller.eEProviderPlus.value.users = Get.find<AuthService>().user.value;
                            controller.eEProviderPlus.value.featured = true;
                          },
                          validator: (input) => input!.length < 3 ? "kriacoes_agency_module_provider_plus_provider_name_validator".tr : null,
                          iconData: Icons.business_center_outlined,
                          hintText: "kriacoes_agency_module_provider_plus_provider_name_hint".tr,
                          labelText: "kriacoes_agency_module_provider_plus_provider_name_label".tr,
                          isFirst: true,
                          isLast: false,
                        ),
                        TextFieldWidget(
                          onSaved: (input) {
                            controller.eEProviderPlus.value.description = input;
                          },
                          //validator: (input) => input.length < 3 ? "kriacoes_agency_module_provider_plus_provider_description_validator".tr : null,
                          keyboardType: TextInputType.multiline,
                          iconData: Icons.text_snippet_outlined,
                          hintText: "kriacoes_agency_module_provider_plus_provider_description_hint".tr,
                          labelText: "kriacoes_agency_module_provider_plus_provider_description_label".tr,
                          isFirst: false,
                          isLast: false,
                        ),
                        TextFieldWidget(
                          keyboardType: TextInputType.phone,
                          onSaved: (input) {
                            if (input!.startsWith("00")) {input = "+" + input.substring(2);}
                             controller.eEProviderPlus.value.phoneNumber = input;
                          },
                          labelText: "kriacoes_agency_module_provider_plus_provider_phone_label".tr,
                          hintText: "kriacoes_agency_module_provider_plus_provider_phone_hint".tr,
                          // validator: (input) {
                          //   return !input.startsWith('\+') && !input.startsWith('00') ? "kriacoes_agency_module_provider_plus_provider_phone_validator".tr : null;
                          // },
                          iconData: Icons.phone_android_outlined,
                          isLast: false,
                          isFirst: false,
                        ),
                        TextFieldWidget(
                          keyboardType: TextInputType.phone,
                          onSaved: (input) {
                            if (input!.startsWith("00")) {input = "+" + input.substring(2);}
                             controller.eEProviderPlus.value.mobileNumber = input;
                          },
                          labelText: "kriacoes_agency_module_provider_plus_provider_mobilenumber_label".tr,
                          hintText: "kriacoes_agency_module_provider_plus_provider_mobilenumber_hint".tr,
                          // validator: (input) {
                          //   return !input.startsWith('\+') && !input.startsWith('00') ? "kriacoes_agency_module_provider_plus_provider_mobilenumber_validator".tr : null;
                          // },
                          iconData: Icons.phone_android_outlined,
                          isLast: false,
                          isFirst: false,
                        ),
                        TextFieldWidget(
                          keyboardType: TextInputType.phone,
                          onSaved: (input) {
                            controller.eEProviderPlus.value.availabilityRange = double.parse(input!);
                          },
                          validator: (input) => input!.length < 2 ? "kriacoes_agency_module_provider_plus_provider_range_validator".tr : null,
                          //initialValue: controller.eEProviderPlus.value.name,
                          iconData: Icons.map_outlined,
                          hintText: "kriacoes_agency_module_provider_plus_provider_range_hint".tr,
                          labelText: "kriacoes_agency_module_provider_plus_provider_range_label".tr,
                          isFirst: false,
                          isLast: true,
                        ),

                        //Addresses
                        // Container(
                        //   padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                        //   margin: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 0),
                        //   decoration: BoxDecoration(
                        //       color: Get.theme.primaryColor,
                        //       borderRadius: BorderRadius.all(Radius.circular(10)),
                        //       boxShadow: [
                        //         BoxShadow(color: Get.theme.focusColor.withOpacity(0.1), blurRadius: 10, offset: Offset(0, 5)),
                        //       ],
                        //       border: Border.all(color: Get.theme.focusColor.withOpacity(0.05))),
                        //   child: Column(
                        //     crossAxisAlignment: CrossAxisAlignment.stretch,
                        //     children: [
                        //       Column(
                        //         crossAxisAlignment: CrossAxisAlignment.start,
                        //         children: [
                        //           Row(
                        //             children: [
                        //               SizedBox(width: 0),
                        //               Expanded(child: Text("Address".tr, style: Get.textTheme.bodyText1)),
                        //             ],
                        //           ),
                        //           SizedBox(height: 10),
                        //           Obx(() {
                        //             if (controller.eProviderAddresses.isEmpty) {
                        //               return TabBarLoadingWidget();
                        //             } else {
                        //               return TabBarWidget(
                        //                 initialSelectedId: "0",
                        //                 tag: 'eProviderAddresses',
                        //                 tabs: List.generate(controller.eProviderAddresses.length, (index) {
                        //                   final _eaddresses = controller.eProviderAddresses.elementAt(index);
                        //                   return ChipWidget(
                        //                     tag: 'eProviderAddresses',
                        //                     text: _eaddresses.description,
                        //                     id: _eaddresses,
                        //                     onSelected: (id) {
                        //                       Get.showSnackbar(Ui.SuccessSnackBar(message: "kriacoes_agency_module_provider_plus_success_message_one".tr + _eaddresses.id + "kriacoes_agency_module_provider_plus_success_message_two".tr));
                        //                       //controller.addresses.value = id.description;
                        //                       controller.eEProviderPlus.value.addresses = _eaddresses;
                        //                     },
                        //                   );
                        //                 }),
                        //               );
                        //             }
                        //           }
                        //           ),
                        //         ],
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        //Addresses



                        // Container(
                        //   padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        //   margin: EdgeInsets.only(left: 20, right: 20, top: 0, bottom: 20),
                        //   decoration: BoxDecoration(
                        //       color: Get.theme.primaryColor,
                        //       borderRadius: BorderRadius.all(Radius.circular(10)),
                        //       boxShadow: [
                        //         BoxShadow(color: Get.theme.focusColor.withOpacity(0.1), blurRadius: 10, offset: Offset(0, 5)),
                        //       ],
                        //       border: Border.all(color: Get.theme.focusColor.withOpacity(0.05))),
                        //   child: Column(
                        //     crossAxisAlignment: CrossAxisAlignment.stretch,
                        //     children: [
                        //       Obx(() {
                        //         return ListTileTheme(
                        //           contentPadding: EdgeInsets.all(0.0),
                        //           horizontalTitleGap: 0,
                        //           dense: true,
                        //           textColor: Get.theme.hintColor,
                        //           child: ListBody(
                        //             children: [
                        //               CheckboxListTile(
                        //                 value: controller.eEProviderPlus.value.featured ?? false,
                        //                 selected: controller.eEProviderPlus.value.featured ?? false,
                        //                 title: Text("kriacoes_agency_module_provider_plus_featured".tr),
                        //                 activeColor: Get.theme.colorScheme.secondary,
                        //                 controlAffinity: ListTileControlAffinity.trailing,
                        //                 onChanged: (checked) {
                        //                   controller.eEProviderPlus.update((val) {
                        //                     val.featured = checked;
                        //                   });
                        //                 },
                        //               ),
                        //             ],
                        //           ),
                        //         );
                        //       }),
                        //     ],
                        //   ),
                        // ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        )
    );
  }

  Widget buildTaxes(TaxPlus _eTaxes) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 4),
        child: _eTaxes.type == 'percent'
            ? Text("(" + _eTaxes.name! + ") - "+ _eTaxes.value.toString() + '%', style: Get.textTheme.bodyText1)
            : Ui.getPrice(
          _eTaxes.value!,
          style: Get.textTheme.bodyText2!,
        ),
        decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20))),
      ),
    );
  }

  // Widget buildAddress(Address _eAddress) {
  //   return Padding(
  //     padding: EdgeInsets.symmetric(vertical: 10),
  //     child: Container(
  //       padding: EdgeInsets.symmetric(vertical: 4),
  //       child: Text(_eAddress.address ?? '', style: Get.textTheme.bodyText2),
  //       decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20))),
  //     ),
  //   );
  // }

}
