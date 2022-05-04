import 'dart:convert';

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

import '../models/e_service_model.dart';
import '../routes/app_routes.dart';
import 'package:get/get.dart';
class DynamicLinkService {

 static Future handleDynamicLinks() async {
    // 1. Get the initial dynamic link if the app is opened with a dynamic link
    final PendingDynamicLinkData? data =
    await FirebaseDynamicLinks.instance.getInitialLink();

    // 2. handle link that has been retrieved
   // _handleDeepLink(data!);

    // 3. Register a link callback to fire if the app is opened up from the background
    // using a dynamic link.
    FirebaseDynamicLinks.instance.onLink.listen((event) {
      print("handle:");
      print(event.link.path);
      print(event.link.queryParameters);
      var argumentsEService = json.decode(event.link.queryParameters["data"].toString()) as Map<String, dynamic>;

      Get.toNamed(Routes.E_SERVICE, arguments: {'eService': EService.fromJson(argumentsEService),
        'heroTag': event.link.queryParameters["heroTag"]});

    }).onError((error){
      print(error);
    });
  }

  static void _handleDeepLink(PendingDynamicLinkData data) {
    final Uri deepLink = data.link;
    final String path=deepLink.path;
    var params = deepLink.queryParameters['title'];
    var paramsName = deepLink.queryParameters["postname"];
    if (deepLink != null) {
      print('_handleDeepLink | deeplink: $deepLink');
      print('_handleDeepLink | deeplink: $path');
      print('_handleDeepLink | deeplink: $params');
      print('_handleDeepLink | deeplink: $paramsName');
      print(deepLink.queryParameters);
      if(path.contains("post"))
        {
        }
    }
  }


 static Future<String> createFirstPostLink(EService title,String heroTag,bool isShort,String serviceName) async {

   final DynamicLinkParameters parameters = DynamicLinkParameters(
     uriPrefix: 'https://whoisavailable.page.link',
     link: Uri.parse('https://whoisavailable.page.link/service?data=${json.encode(title)}'
         '&heroTag=$heroTag'),
     androidParameters: AndroidParameters(
       packageName: 'com.whoisavailable',
     ),
     // NOT ALL ARE REQUIRED ===== HERE AS AN EXAMPLE =====
     iosParameters: IOSParameters (
       bundleId: 'com.whoisavailable',
       minimumVersion: '1.0.1',
       appStoreId: '123456789',
     ),
     googleAnalyticsParameters: GoogleAnalyticsParameters(
       campaign: 'example-promo',
       medium: 'social sharing',
       source: 'orkut',
     ),
     socialMetaTagParameters: SocialMetaTagParameters(
       title: "Who's Available",
       description: serviceName,
     ),
   );

    Uri dynamicUrl;
   if(isShort){
   final ShortDynamicLink shortDynamicLink = await FirebaseDynamicLinks.instance.buildShortLink(parameters);
   dynamicUrl=shortDynamicLink.shortUrl;
   }
   else{
     dynamicUrl= await FirebaseDynamicLinks.instance.buildLink(parameters);
   }
   print(dynamicUrl);
   return dynamicUrl.toString();
 }
}