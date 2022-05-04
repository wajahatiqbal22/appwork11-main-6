import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../routes/app_routes.dart';
import '../../../../../../services/auth_service.dart';
import '../../ui/ux.dart';
import '../global_controllers/e_welcome_controller.dart';

class EWelcomeView extends GetView<EWelcomeController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title:
          Text(
            "kriacoes_agency_module_provider_plus_bar_title_welcome".tr,
            style: context.textTheme.headline4!.merge(TextStyle(color: Get.theme.primaryColor)),
          ),
          centerTitle: true,
          automaticallyImplyLeading: false,
          backgroundColor: Get.theme.colorScheme.secondary,
          elevation: 5,
          actions: [
            new IconButton(
              padding: EdgeInsets.symmetric(horizontal: 20),
              icon: new Icon(
               // Icons.power_settings_new,
                Icons.logout,
                color: Colors.red,
                size: 28,
              ),
              onPressed: () {
                controller.logout();
              },
            ),
          ],
        ),

        bottomNavigationBar: Container(
          padding: EdgeInsets.symmetric(vertical: 0),
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
                child: ElasticIn(
                    delay: Duration(milliseconds: 1200),
                    child: MaterialButton(
                      onPressed: () {
                        Navigator.pop(Get.context!);
                        Get.offAndToNamed(Routes.E_PROVIDER_PLUS_ADDRESS_CREATE);
                      },
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      color: Get.theme.colorScheme.secondary,
                      child: Text("kriacoes_agency_module_provider_plus_lets_go".tr, style: Get.textTheme.bodyText2!.merge(TextStyle(color: Get.theme.primaryColor))),
                      elevation: 0,
                    )
                ),
              ),
            ],
          ).paddingSymmetric(vertical: 15, horizontal: 20),
        ),
        body: Form(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 40),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      alignment: AlignmentDirectional.center,
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
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
                                          borderRadius: BorderRadius.circular(20),
                                          gradient: LinearGradient(begin: Alignment.bottomLeft, end: Alignment.topRight, colors: [
                                            Colors.green.withOpacity(1),
                                            Colors.green.withOpacity(0.2),
                                          ])),
                                      child: Pulse(
                                        infinite: true,
                                        child: Icon(
                                          Icons.add_business_sharp,
                                          color: Theme.of(context).scaffoldBackgroundColor,
                                          size: 90,
                                        ),
                                      )
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
                          ),
                          SizedBox(height: 20),
                          ElasticIn(
                              delay: Duration(milliseconds: 600),
                              child: Text(
                                "kriacoes_agency_module_provider_plus_thank_you".tr,
                                textAlign: TextAlign.center,
                                style: Get.textTheme.headline3,
                              )
                          ),
                          SizedBox(height: 10),
                          Opacity(
                            opacity: 0.5,
                            child: ElasticIn(
                              delay: Duration(milliseconds: 700),
                              child: Text(
                                Get.find<AuthService>().user.value.name! + "kriacoes_agency_module_provider_plus_welcome_employe".tr,
                                style: Get.textTheme.headline4,
                              ),
                            ),
                          ),
                          SizedBox(height: 25),
                          Opacity(
                            opacity: 0.5,
                            child: ElasticIn(
                              delay: Duration(milliseconds: 900),
                              child:
                              Text(
                                "kriacoes_agency_module_provider_plus_register_provider".tr,
                                style: Get.textTheme.bodyText2,
                              ),
                            ),
                          ),
                          SizedBox(height: 15),
                          Opacity(
                            opacity: 0.5,
                            child: ElasticIn(
                              delay: Duration(milliseconds: 900),
                              child:
                              Text(
                                "kriacoes_agency_module_provider_plus_register_wait_warning".tr,
                                style: Get.textTheme.bodyText2,
                              ),
                            ),
                          ),
                          SizedBox(height: 15),
                          Opacity(
                            opacity: 0.5,
                            child: ElasticIn(
                              delay: Duration(milliseconds: 900),
                              child:
                              Text(
                                "kriacoes_agency_module_provider_plus_register_info".tr + "("+"kriacoes_agency_module_provider_plus_provider_menu".tr + ")",
                                style: Get.textTheme.bodyText2,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        )
    );
  }
}