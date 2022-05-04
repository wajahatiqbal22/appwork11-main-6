import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_keyhash/flutter_facebook_keyhash.dart';
import 'package:get/get.dart';
import 'package:home_services/app/models/media_model.dart';
import 'package:home_services/app/modules/provider_modules/global_widgets/block_button_widget.dart';
import 'package:home_services/app/modules/provider_modules/global_widgets/text_field_widget.dart';
import 'package:home_services/app/modules/provider_modules/root/controllers/root_controller.dart';
import 'package:home_services/app/services/settings_service.dart';

import '../../../../../common/api_exception.dart';
import '../../../../../common/ui.dart';
import '../../../../models/user_model.dart';
import '../../../../providers/laravel_providers/laravel_provider.dart';
import '../../../../repositories/user_repository/user_repository.dart';
import '../../../../routes/app_routes.dart';
import '../../../../services/auth_service.dart';
import '../../../../services/firebase_messaging_service.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebaseUser;

class PAuthController extends GetxController {
  final Rx<User> currentUser = Get.find<AuthService>().user;
  GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> registerFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> forgotPasswordFormKey = GlobalKey<FormState>();
  final hidePassword = true.obs;
  final loading = false.obs;
  final smsSent = ''.obs;
  late UserRepository _userRepository;
  GlobalKey<FormState> phoneFormKey = GlobalKey<FormState>();

  PAuthController() {
    print("key hash");
    _userRepository = ProviderUserRepository();
    printKeyHash();
  }
  void printKeyHash() async {
    String? key = await FlutterFacebookKeyhash.getFaceBookKeyHash ??
        'Unknown platform version';
    print(key);
  }

  void login() async {
    Get.focusScope!.unfocus();
    if (loginFormKey.currentState!.validate()) {
      loginFormKey.currentState!.save();
      loading.value = true;
      try {
        await Get.find<FireBaseMessagingService>().setDeviceToken();
        currentUser.value = await _userRepository.login(currentUser.value);
        await _userRepository.signInWithEmailAndPassword(
            currentUser.value.email!, currentUser.value.apiToken!);
        loading.value = false;
        Get.find<SettingsService>().setUserType(false);
        await Get.offAndToNamed(Routes.PROOT, arguments: 0);
      } catch (e) {
        Get.showSnackbar(Ui.ErrorSnackBar(
            message: e
                    .toString()
                    .contains("These credentials do not match our records")
                ? "Please enter a valid credentials"
                : e.toString()));
      } finally {
        loading.value = false;
      }
    }
  }

  void signInWithGoogle() async {
    loading.value = true;
    try {
      await Get.find<FireBaseMessagingService>().setDeviceToken();
      final credential = await _userRepository.signInWithGoogle();

      currentUser.value =
          await _userRepository.login(User.fromUserCredential(credential));
      Get.find<SettingsService>().setUserType(false);
      await Get.offAndToNamed(Routes.PROOT, arguments: 0);
    } catch (e) {
      print(e);
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    } finally {
      loading.value = false;
    }
  }

  void signInWithFacebook() async {
    loading.value = true;
    try {
      await Get.find<FireBaseMessagingService>().setDeviceToken();
      final credential = await _userRepository.signInWithFacebook();
      print(credential.user!.email);
      print(User.fromUserCredential(credential));
      currentUser.value =
          await _userRepository.login(User.fromUserCredential(credential));
      Get.find<SettingsService>().setUserType(false);
      await Get.offAndToNamed(Routes.PROOT, arguments: 0);
    } catch (e) {
      print(e);
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    } finally {
      loading.value = false;
    }
  }

  void registerWithGoogle() async {
    loading.value = true;
    try {
      await Get.find<FireBaseMessagingService>().setDeviceToken();
      final credential = await _userRepository.signInWithGoogle();
      sociallogin(credential, Get.context!);
    } catch (e) {
      print(e);
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    } finally {
      loading.value = false;
    }
  }

  void registerWithFacebook() async {
    loading.value = true;
    try {
      await Get.find<FireBaseMessagingService>().setDeviceToken();
      final credential = await _userRepository.signInWithFacebook();
      print(credential.user);
      if (credential.user!.email.toString() == "null") {
        throw ApiException("Unable to get your email");
      } else {
        sociallogin(credential, Get.context!);
      }
/*
      currentUser.value =
          await _userRepository.register(User.fromUserCredential(credential));
      Get.find<SettingsService>().setUserType(false);
      await Get.offAndToNamed(Routes.PROOT, arguments: 0);
*/
    } catch (e) {
      print(e);
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    } finally {
      loading.value = false;
    }
  }

  void signInWithApple() async {
    loading.value = true;
    try {
      await Get.find<FireBaseMessagingService>().setDeviceToken();
      final credential = await _userRepository.signInWithApple();

      currentUser.value =
          await _userRepository.login(User.fromUserCredential(credential));
      Get.find<SettingsService>().setUserType(false);
      await Get.offAndToNamed(Routes.PROOT, arguments: 0);
    } catch (e) {
      print(e);
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    } finally {
      loading.value = false;
    }
  }

  void registerWithApple() async {
    loading.value = true;
    try {
      await Get.find<FireBaseMessagingService>().setDeviceToken();
      final credential = await _userRepository.signInWithApple();
      currentUser.value =
          await _userRepository.register(User.fromUserCredential(credential));
      Get.find<SettingsService>().setUserType(false);
      await Get.offAndToNamed(Routes.PROOT, arguments: 0);
    } catch (e) {
      print(e);
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    } finally {
      loading.value = false;
    }
  }

  void register() async {
    Get.focusScope!.unfocus();
    if (registerFormKey.currentState!.validate()) {
      registerFormKey.currentState!.save();
      loading.value = true;
      try {
        await _userRepository.sendCodeToPhone();
        loading.value = false;
        await Get.toNamed(Routes.PPHONE_VERIFICATION);
      } catch (e) {
        print(e.toString());
        Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
      } finally {
        loading.value = false;
      }
    }
  }

  Future<void> verifyPhone() async {
    try {
      loading.value = true;
      await _userRepository.verifyPhone(smsSent.value);
      await Get.find<FireBaseMessagingService>().setDeviceToken();
      print(currentUser.value.email.toString());
      currentUser.value = await _userRepository.register(currentUser.value);
      print("current user value:${currentUser.value}");
      await _userRepository.signUpWithEmailAndPassword(
          currentUser.value.email!, currentUser.value.apiToken!);
      loading.value = false;
      Get.offAndToNamed(Routes.E_PROVIDER_PLUS_WELCOME);
    } catch (e) {
      print("invalid is here");
      print(e.toString().replaceRange(0, 14, '').split(']')[1]);
      if (e.toString().contains(
              "The verification ID used to create the phone auth credential is invalid") ||
          e.toString().contains(
              "The sms verification code used to create the phone auth credential is invalid. Please resend the verification code sms and be sure use the verification code provided by the user")) {
      } else if (e.toString().contains("The email has already been taken")) {
        await Get.find<AuthService>().removeCurrentUser();
        Get.toNamed(Routes.PREGISTER);
      } else {
        await Get.find<AuthService>().removeCurrentUser();
        Get.toNamed(Routes.PREGISTER);
      }
      Get.showSnackbar(Ui.ErrorSnackBar(
          message: (e.toString().contains(
                      "The verification ID used to create the phone auth credential is invalid") ||
                  e.toString().contains(
                      "The sms verification code used to create the phone auth credential is invalid. Please resend the verification code sms and be sure use the verification code provided by the user"))
              ? "Please enter valid code"
              : (e.toString().contains("The email has already been taken") &&
                      e
                          .toString()
                          .contains("The phone number has already been taken"))
                  ? "Email and Phone number already registered"
                  : e.toString().contains("The email has already been taken")
                      ? "Email already registered"
                      : e.toString().contains(
                              "The phone number has already been taken")
                          ? "Phone number already registered"
                          : e.toString().contains("firebase")
                              ? e
                                  .toString()
                                  .replaceRange(0, 14, '')
                                  .split(']')[1]
                              : e.toString()));
      loading.value = false;
    } finally {
      loading.value = false;
    }
  }

  void sendResetLink() async {
    Get.focusScope!.unfocus();
    if (forgotPasswordFormKey.currentState!.validate()) {
      forgotPasswordFormKey.currentState!.save();
      loading.value = true;
      try {
        await _userRepository.sendResetLinkEmail(currentUser.value);
        loading.value = false;
        Get.showSnackbar(Ui.SuccessSnackBar(
            message:
                "The Password reset link has been sent to your email: ".tr +
                    currentUser.value.email!));
        Timer(Duration(seconds: 5), () {
          Get.offAndToNamed(Routes.PLOGIN);
        });
      } catch (e) {
        Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
      } finally {
        loading.value = false;
      }
    }
  }

  Future<void> sociallogin(usernew, context) async {
    loading.value = true;
    CollectionReference emailsRef =
        FirebaseFirestore.instance.collection('users');

    DocumentSnapshot emailsSnap = await emailsRef.doc("data").get();
    List<dynamic> emails = [];
    if (emailsSnap.exists) {
      emails = emailsSnap["emails"] ?? [];
    }

    if (!emails.contains(usernew.user.email)) {
      FirebaseFirestore.instance.collection("users").doc("data").update({
        "emails": FieldValue.arrayUnion([usernew.user.email])
      });
      showModalBottomSheet(
          context: context,
          builder: (context) {
            return Container(
              child: Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: SingleChildScrollView(
                  child: Container(
                    child: Form(
                      key: phoneFormKey,
                      child: Column(
                        children: [
                          TextFieldWidget(
                            labelText: "Phone Number".tr,
                            hintText: "+1 223 665 7896".tr,
                            initialValue: currentUser.value.phoneNumber,
                            onSaved: (input) {
                              if (input!.startsWith("00")) {
                                input = "+" + input.substring(2);
                              }
                              currentUser.value =
                                  User.fromUserCredential(usernew);
                              currentUser.value.phoneNumber = input;
                              print("user number is:$input}");
                              print(currentUser.value.phoneNumber);
                              print(currentUser.value.email);
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                direction: Axis.vertical,
                                children: [
                                  SizedBox(
                                    width: Get.width,
                                    child: BlockButtonWidget(
                                      onPressed: () async {
                                        try {
                                          if (phoneFormKey.currentState!
                                              .validate()) {
                                            phoneFormKey.currentState!.save();
                                            print(Get.find<AuthService>()
                                                .user
                                                .value
                                                .email);
                                            print(Get.find<AuthService>()
                                                .user
                                                .value
                                                .phoneNumber!);
                                            Navigator.pop(context);
                                            await _userRepository
                                                .sendCodeToPhone();
                                            // usernew.user!.delete();
                                            loading.value = false;
                                            await Get.toNamed(
                                                Routes.PPHONE_VERIFICATION);
                                          }
                                        } catch (e) {
                                          print("error 11");
                                          print(e);
                                          Get.showSnackbar(Ui.ErrorSnackBar(
                                              message: e.toString()));
                                        } finally {
                                          loading.value = false;
                                        }
                                      },
                                      color: Get.theme.accentColor,
                                      text: Text(
                                        "Complete".tr,
                                        style: Get.textTheme.headline6!.merge(
                                            TextStyle(
                                                color: Get.theme.primaryColor)),
                                      ),
                                    ).paddingOnly(
                                        top: 15,
                                        bottom: 5,
                                        right: 20,
                                        left: 20),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).whenComplete(() {
        print("bottomsheet closed");
      }).onError((error, stackTrace) {
        print("closed on error");
      });
    } else {
      // Get.focusScope.unfocus();
      try {
        loading.value = true;
        var newuser = firebaseUser.FirebaseAuth.instance.currentUser;
        var user = User(
            name: newuser!.displayName,
            phoneNumber: newuser.phoneNumber,
            email: newuser.email,
            apiToken: newuser.refreshToken,
            password: newuser.uid,
            verifiedPhone: true,
            avatar: Media(
              url: newuser.photoURL,
              thumb: newuser.photoURL,
            ));
        currentUser.value = await _userRepository.login(user);
        await Get.find<PRootController>().changePage(0);
      } catch (e) {
        loading.value = true;
        print("user login error " + e.toString());
        if (e.toString().contains("The email has already been taken")) {
          // login();
        }
      }
    }
  }
}
