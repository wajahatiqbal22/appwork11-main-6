import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
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

class RegisterView extends GetView<AuthController> {
  final Setting _settings = Get.find<SettingsService>().setting.value;

  @override
  Widget build(BuildContext context) {
    controller.registerFormKey = new GlobalKey<FormState>();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Register".tr,
          style: Get.textTheme.headline6!
              .merge(TextStyle(color: context.theme.primaryColor)),
        ),
        centerTitle: true,
        backgroundColor: Get.theme.accentColor,
        elevation: 0,
      ),
      body: Form(
        key: controller.registerFormKey,
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
                  margin: EdgeInsets.only(bottom: 10),
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
                            borderRadius: BorderRadius.all(Radius.circular(10)),
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
                          style: Get.textTheme.caption!
                              .merge(TextStyle(color: Get.theme.primaryColor)),
                          textAlign: TextAlign.center,
                        ),
                        // Text("Fill the following credentials to login your account", style: Get.textTheme.caption.merge(TextStyle(color: Get.theme.primaryColor))),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Obx(() {
              if (controller.loading.isTrue) {
                return CircularLoadingWidget(height: 300);
              } else {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SignInButton(
                          Buttons.Google,
                          mini: false,
                          text: 'Continue with Google',
                          onPressed: () {
                            controller.registerWithGoogle();
                          },
                        ),
                        SignInButton(
                          Buttons.Facebook,
                          mini: true,
                          onPressed: () {
                            controller.registerWithFacebook();
                          },
                        )
                      ],
                    ).paddingAll(5.0),
                    TextFieldWidget(
                      labelText: "Full Name".tr,
                      hintText: "John Doe".tr,
                      initialValue: controller.currentUser.value.name,
                      onSaved: (input) =>
                      controller.currentUser.value.name = input,
                      validator: (input) => input!.length < 3
                          ? "Should be more than 3 characters".tr
                          : null,
                      iconData: Icons.person_outline,
                      isFirst: true,
                      isLast: false,
                    ),
                    TextFieldWidget(
                      labelText: "Email Address".tr,
                      hintText: "johndoe@gmail.com".tr,
                      initialValue: controller.currentUser.value.email,
                      onSaved: (input) =>
                      controller.currentUser.value.email = input,
                      validator: (input) => !input!.contains('@')
                          ? "Should be a valid email".tr
                          : null,
                      iconData: Icons.alternate_email,
                      isFirst: false,
                      isLast: false,
                    ),
                    TextFieldWidget(
                      labelText: "Phone Number".tr,
                      hintText: "+1 223 665 7896".tr,
                      initialValue: controller.currentUser.value.phoneNumber,
                      onSaved: (input) {
                        if (input!.startsWith("00")) {
                          input = "+" + input.substring(2);
                        }
                         controller.currentUser.value.phoneNumber = input;
                      },
                      validator: (input) {
                        return !input!.startsWith('\+') &&
                            !input.startsWith('00')
                            ? "Should be valid mobile number with country code"
                            : null;
                      },
                      iconData: Icons.phone_android_outlined,
                      isLast: false,
                      isFirst: false,
                    ),
                    Obx(() {
                      return TextFieldWidget(
                        labelText: "Password".tr,
                        hintText: "••••••••••••".tr,
                        initialValue: controller.currentUser.value.password,
                        onSaved: (input) =>
                        controller.currentUser.value.password = input,
                        validator: (input) => input!.length < 3
                            ? "Should be more than 3 characters".tr
                            : null,
                        obscureText: controller.hidePassword.value,
                        iconData: Icons.lock_outline,
                        keyboardType: TextInputType.visiblePassword,
                        isLast: true,
                        isFirst: false,
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
                  ],
                );
              }
            })
          ],
        ),
      ),
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            direction: Axis.vertical,
            children: [
              SizedBox(
                width: Get.width,
                child: BlockButtonWidget(
                  onPressed: () {
                    controller.register();
                    //Get.offAllNamed(Routes.PHONE_VERIFICATION);
                  },
                  color: Get.theme.accentColor,
                  text: Text(
                    "Register Now".tr,
                    style: Get.textTheme.headline6!
                        .merge(TextStyle(color: Get.theme.primaryColor)),
                  ),
                ).paddingOnly(top: 10, bottom: 5, right: 20, left: 20),
              ),
              TextButton(
                onPressed: () {
                  Get.offAllNamed(Routes.LOGIN);
                },
                child: Text("Already have an account?".tr),
              ).paddingOnly(bottom: 5),
            ],
          ),
        ],
      ),
    );
  }
}
