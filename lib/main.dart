//@dart=2.9
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'app/providers/firebase_provider.dart';
import 'app/providers/laravel_providers/laravel_provider.dart';
import 'app/routes/theme1_app_pages.dart';
import 'app/services/auth_service.dart';
import 'app/services/deep_link_service.dart';
import 'app/services/firebase_messaging_service.dart';
import 'app/services/global_service.dart';
import 'app/services/settings_service.dart';
import 'app/services/translation_service.dart';
    
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Get.log('starting services ...');
  await GetStorage.init();
  await Get.putAsync(() => TranslationService().init());
  await Get.putAsync(() => GlobalService().init());
  await Firebase.initializeApp();
  await Get.putAsync(() => AuthService().init());
  await Get.putAsync(() => FireBaseMessagingService().init());
  await Get.putAsync(() => CustomerApiClient().init());
  await Get.putAsync(() => ProviderApiClient().init());
  await Get.putAsync(() => FirebaseProvider().init());
  final _settingService = await Get.putAsync(() => SettingsService().init());

  Get.log('All services started...');
  DynamicLinkService.handleDynamicLinks();
  runApp(
      GetMaterialApp(
        title: Get.find<SettingsService>().setting.value.appName,
        initialRoute: _settingService.isConsumer()
            ? Theme1AppPages.INITIAL
            : Theme1AppPages.PINITIAL,
        getPages: Theme1AppPages.routes,
        localizationsDelegates: [GlobalMaterialLocalizations.delegate],
        supportedLocales: Get.find<TranslationService>().supportedLocales(),
        translationsKeys: Get.find<TranslationService>().translations,
        locale: Get.find<SettingsService>().getLocale(),
        fallbackLocale: Get.find<TranslationService>().fallbackLocale,
        debugShowCheckedModeBanner: false,
        defaultTransition: Transition.cupertino,
        themeMode: Get.find<SettingsService>().getThemeMode(),
        theme: Get.find<SettingsService>().getLightTheme(),
        darkTheme: Get.find<SettingsService>().getDarkTheme(),
        builder: (context, child) => GestureDetector(
            onTap: () =>
                WidgetsBinding.instance.focusManager.primaryFocus?.unfocus(),
            behavior: HitTestBehavior.translucent,
            child: child)),
  );
}
