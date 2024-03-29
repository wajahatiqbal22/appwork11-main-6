import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../providers/laravel_providers/laravel_provider.dart';

import '../../../../../common/ui.dart';
import '../../../../models/media_model.dart';
import '../../../../models/user_model.dart';
import '../../../../repositories/user_repository/user_repository.dart';
import '../../../../services/auth_service.dart';
import '../../global_widgets/phone_verification_bottom_sheet_widget.dart';

class PProfileController extends GetxController {
  var user = new User().obs;
  var avatar = new Media().obs;
  final hidePassword = true.obs;
  final oldPassword = "".obs;
  final newPassword = "".obs;
  final confirmPassword = "".obs;
  final smsSent = "".obs;
  GlobalKey<FormState> profileForm=GlobalKey<FormState>();
  late UserRepository _userRepository;

  PProfileController() {
    _userRepository = ProviderUserRepository();
  }

  @override
  void onInit() {
    user.value = Get.find<AuthService>().user.value;
    avatar.value = new Media(thumb: user.value.avatar!.thumb);
    super.onInit();
  }

  Future refreshProfile({bool? showMessage}) async {
    await getUser();
    if (showMessage == true) {
      Get.showSnackbar(Ui.SuccessSnackBar(message: "List of faqs refreshed successfully".tr));
    }
  }

  void saveProfileForm() async {
    Get.focusScope!.unfocus();
    if (profileForm.currentState!.validate()) {
      try {
        profileForm.currentState!.save();
        user.value.deviceToken = null;
        user.value.password = newPassword.value == confirmPassword.value ? newPassword.value : null;
        user.value.avatar!.id = avatar.value.id;
        await _userRepository.sendCodeToPhone();
        Get.bottomSheet(
          PhoneVerificationBottomSheetWidget(),
          isScrollControlled: false,
        );
      } catch (e) {
        Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
      } finally {}
    } else {
      Get.showSnackbar(Ui.ErrorSnackBar(message: "There are errors in some fields please correct them!".tr));
    }
  }

  Future<void> verifyPhone() async {
    try {
      await _userRepository.verifyPhone(smsSent.value);
      user.value = await _userRepository.update(user.value);
      Get.find<AuthService>().user.value = user.value;
      Get.back();
      Get.showSnackbar(Ui.SuccessSnackBar(message: "Profile saved successfully".tr));
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  void resetProfileForm() {
    avatar.value = new Media(thumb: user.value.avatar!.thumb);
    profileForm.currentState!.reset();
  }

  Future getUser() async {
    try {
      user.value = await _userRepository.getCurrentUser();
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }
}
