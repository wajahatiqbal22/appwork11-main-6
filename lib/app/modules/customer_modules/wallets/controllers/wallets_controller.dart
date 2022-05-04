import 'package:get/get.dart';
import '../../../../providers/laravel_providers/laravel_provider.dart';

import '../../../../../common/ui.dart';
import '../../../../models/wallet_model.dart';
import '../../../../models/wallet_transaction_model.dart';
import '../../../../repositories/payment_repository.dart';

class WalletsController extends GetxController {
  final wallets = <Wallet>[].obs;
  final walletTransactions = <WalletTransaction>[].obs;
  final selectedWallet = new Wallet().obs;
  late PaymentRepository _paymentRepository;
  final isLoading = true.obs;

  WalletsController() {
    _paymentRepository = new PaymentRepository(Get.find<CustomerApiClient>());
  }

  @override
  void onInit() async {
    await refreshWallets();
    super.onInit();
  }

  Future refreshWallets({bool? showMessage}) async {
    isLoading.value = true;
    await getWallets();
    initSelectedWallet();
    await getWalletTransactions();
    isLoading.value = false;
    if (showMessage == true) {
      Get.showSnackbar(Ui.SuccessSnackBar(
          message: "List of wallets refreshed successfully".tr));
    }
  }

  Future getWallets() async {
    try {
      wallets.assignAll(await _paymentRepository.getWallets());
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  Future getWalletTransactions() async {
    try {
      walletTransactions.assignAll(
          await _paymentRepository.getWalletTransactions(selectedWallet.value));
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  void initSelectedWallet() {
    if (!selectedWallet.value.hasData && wallets.isNotEmpty) {
      selectedWallet.value = wallets.elementAt(0);
    }
  }
}
