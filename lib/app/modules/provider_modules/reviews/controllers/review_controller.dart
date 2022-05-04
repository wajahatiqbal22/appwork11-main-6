import 'package:get/get.dart';
import '../../../../providers/laravel_providers/laravel_provider.dart';

import '../../../../../common/ui.dart';
import '../../../../models/review_model.dart';
import '../../../../repositories/e_provider_repository.dart';

class PReviewController extends GetxController {
  final review = Review().obs;
  late EProviderRepository _eProviderRepository;

  PReviewController() {
    _eProviderRepository = new EProviderRepository(Get.find<ProviderApiClient>());
  }

  @override
  void onInit() {
    review.value = Get.arguments as Review;
    super.onInit();
  }

  @override
  void onReady() async {
    await refreshReview();
    super.onReady();
  }

  Future refreshReview({bool showMessage = false}) async {
    await getReview();
    if (showMessage) {
      Get.showSnackbar(Ui.SuccessSnackBar(message: "Reviews refreshed successfully".tr));
    }
  }

  Future getReview() async {
    try {
      review.value = await _eProviderRepository.getReview(review.value.id!);
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }
}
