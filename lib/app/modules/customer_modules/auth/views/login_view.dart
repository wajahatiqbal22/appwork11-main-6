import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:get/get.dart';

import '../../../../../common/helper.dart';
import '../../../../../common/ui.dart';
import '../../../../models/setting_model.dart';
import '../../../../routes/app_routes.dart';
import '../../../../services/settings_service.dart';
import '../../global_widgets/block_button_widget.dart';
import '../../global_widgets/circular_loading_widget.dart';
import '../../global_widgets/text_field_widget.dart';
import '../../root/controllers/root_controller.dart';
import '../controllers/auth_controller.dart';

class LoginView extends GetView<AuthController> {
  final Setting _settings = Get.find<SettingsService>().setting.value;

  @override
  Widget build(BuildContext context) {
    controller.loginFormKey = new GlobalKey<FormState>();
    return WillPopScope(
      onWillPop: Helper().onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "".tr,
            style: Get.textTheme.headline6!
                .merge(TextStyle(color: context.theme.primaryColor)),
          ),
          centerTitle: true,
          backgroundColor: Get.theme.accentColor,

          elevation: 0,
          // leading: new IconButton(
          //   icon: new Icon(Icons.arrow_back_ios, color: Get.theme.primaryColor),
          //   onPressed: () => {Get.find<RootController>().changePageOutRoot(0)},
          // ),
        ),
        body: Form(
          key: controller.loginFormKey,
          child: ListView(
            primary: true,
            children: [
              Stack(
                alignment: AlignmentDirectional.bottomCenter,
                children: [
                  Container(
                    height: 200,
                    width: Get.width,
                    decoration: BoxDecoration(
                      color: Get.theme.accentColor,
                      borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(10)),
                      boxShadow: [
                        BoxShadow(
                            color: Get.theme.focusColor.withOpacity(0.2),
                            blurRadius: 10,
                            offset: Offset(0, 5)),
                      ],
                    ),
                    margin: EdgeInsets.only(bottom: 15),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Container(
                            /*decoration: Ui.getBoxDecoration(
                              radius: 14,
                              border: Border.all(
                                  width: 5, color: Get.theme.primaryColor),
                            ),*/
                            child: ClipRRect(
                              borderRadius:
                              BorderRadius.all(Radius.circular(10)),
                              child: Image.asset(
                                'assets/icon/icon.png',
                                fit: BoxFit.cover,
                                width: 75,
                                height: 75,
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            _settings.appName!,
                            style: Get.textTheme.headline6!.merge(TextStyle(
                                color: Get.theme.primaryColor, fontSize: 24)),
                          ),
                          SizedBox(height: 5),
                          Text(
                            "Services on demand".tr,
                            style: Get.textTheme.caption!.merge(
                                TextStyle(color: Get.theme.primaryColor)),
                            textAlign: TextAlign.center,
                          ),
                          // Text("Fill the following credentials to login your account", style: Get.textTheme.caption.merge(TextStyle(color: Get.theme.primaryColor))),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              TextFieldWidget(
                labelText: "Email Address".tr,
                hintText: "jessi@gmail.com".tr,
                initialValue: controller.currentUser.value.email,
                onSaved: (input) =>
                controller.currentUser.value.email = input,
                validator: (input) => !input!.contains('@')
                    ? "Should be a valid email".tr
                    : null,
                iconData: Icons.alternate_email,
              ),
              Obx(() {
                return TextFieldWidget(
                  labelText: "Password".tr,
                  hintText: "123456".tr,
                  initialValue: controller.currentUser.value.password,
                  onSaved: (input) =>
                  controller.currentUser.value.password = input,
                  validator: (input) => input!.length < 3
                      ? "Should be more than 3 characters".tr
                      : null,
                  obscureText: controller.hidePassword.value,
                  iconData: Icons.lock_outline,
                  keyboardType: TextInputType.visiblePassword,
                  suffixIcon: IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      controller.hidePassword.value =
                      !controller.hidePassword.value;
                    },
                    color: Theme.of(context).focusColor,
                    icon: Icon(controller.hidePassword.value
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined),
                  ),
                );
              }),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Get.toNamed(Routes.FORGOT_PASSWORD);
                    },
                    child: Text("Forgot Password?".tr),
                  ),
                ],
              ).paddingSymmetric(horizontal: 20),
              Obx(() {
                if (controller.loading.isTrue)
                  return CircularLoadingWidget(height: 300);
                else {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SignInButton(
                            Buttons.Google,
                            mini: false,
                            onPressed: () {
                              controller.signInWithGoogle();
                            },
                          ),
                          SignInButton(
                            Buttons.Facebook,
                            mini: true,
                            onPressed: () {
                              controller.signInWithFacebook();
                            },
                          )
                        ],
                      ).paddingAll(7.0),
                      BlockButtonWidget(
                        onPressed: () {
                          controller.login();
                        },
                        color: Get.theme.accentColor,
                        text: Text(
                          "Login as Customer".tr,
                          style: Get.textTheme.button!
                              .merge(TextStyle(color: Get.theme.primaryColor)),
                        ),
                      ).paddingSymmetric(vertical: 5, horizontal: 80),
                      BlockButtonWidget(
                        onPressed: () {
                          Get.offAndToNamed(Routes.PLOGIN);
                        },
                        color: Get.theme.accentColor,
                        text: Text(
                          "Switch to Service Provider".tr,
                          style: Get.textTheme.button!
                              .merge(TextStyle(color: Get.theme.primaryColor)),
                        ),
                      ).paddingSymmetric(vertical: 2, horizontal: 80),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: TextButton(
                              onPressed: () {
                                Get.offAllNamed(Routes.REGISTER);
                              },
                              child: Text(
                                "You don't have an account? Register Now".tr,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ],
                      ).paddingSymmetric(vertical: 5),
                    ],
                  );
                }
              }),
            ],
          ),
        ),
      ),
    );
  }
}
