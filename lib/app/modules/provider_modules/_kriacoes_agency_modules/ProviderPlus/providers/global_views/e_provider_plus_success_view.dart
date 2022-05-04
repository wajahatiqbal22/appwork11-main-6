import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../services/auth_service.dart';
import '../../ui/ux.dart';
import '../global_controllers/e_success_controller.dart';

class ESuccessView extends GetView<ESuccessController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.close, color: Get.theme.primaryColor),
            onPressed: () {
              controller.finish();
            },
          ),
          title: Text(
            "kriacoes_agency_module_provider_plus_success".tr,
            style: context.textTheme.headline4!.merge(TextStyle(color: Get.theme.primaryColor)),
          ),
          centerTitle: true,
          automaticallyImplyLeading: false,
          backgroundColor: Get.theme.colorScheme.secondary,
          elevation: 5,
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
                child: MaterialButton(
                  onPressed: () {
                    controller.finish();
                  },
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  color: Get.theme.colorScheme.secondary,
                  child: Text("kriacoes_agency_module_provider_plus_logout".tr, style: Get.textTheme.bodyText2!.merge(TextStyle(color: Get.theme.primaryColor))),
                  elevation: 0,
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
                SizedBox(height: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      alignment: AlignmentDirectional.center,
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 60),
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
                                    width: 130,
                                    height: 130,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        gradient: LinearGradient(begin: Alignment.bottomLeft, end: Alignment.topRight, colors: [
                                          Colors.lightBlue.withOpacity(1),
                                          Colors.lightBlue.withOpacity(0.2),
                                        ])),
                                    child: Pulse(
                                        infinite: true,
                                        child: Icon(
                                          Icons.info,
                                          color: Theme.of(context).scaffoldBackgroundColor,
                                          size: 90,
                                        )),
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
                          SizedBox(height: 40),
                          Text(
                            "kriacoes_agency_module_provider_plus_thank_you_success".tr,
                            textAlign: TextAlign.center,
                            style: Get.textTheme.headline3,
                          ),
                          SizedBox(height: 10),
                          Opacity(
                            opacity: 0.3,
                            child: Text(
                              Get.find<AuthService>().user.value.name! + "kriacoes_agency_module_provider_plus_success_message".tr,
                              textAlign: TextAlign.center,
                              style: Get.textTheme.headline4,
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