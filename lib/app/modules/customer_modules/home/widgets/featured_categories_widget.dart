import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'services_small_carousel_widget.dart';

import '../../../../routes/app_routes.dart';
import '../../global_widgets/circular_loading_widget.dart';
import '../controllers/home_controller.dart';

class FeaturedCategoriesWidget extends GetWidget<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.featured.isEmpty) {
        return CircularLoadingWidget(height: 300);
      }
      return Column(
        children: List.generate(controller.featured.length, (index) {
          var _category = controller.featured.elementAt(index);
          return Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: Row(
                  children: [
                    Expanded(child: Text(_category.name!, style: Get.textTheme.headline5)),
                    MaterialButton(
                      onPressed: () {
                        Get.toNamed(Routes.CATEGORY, arguments: _category);
                      },
                      shape: StadiumBorder(),
                      color: Get.theme.accentColor.withOpacity(0.1),
                      child: Text("View All".tr, style: Get.textTheme.subtitle1),
                      elevation: 0,
                    ),
                  ],
                ),
              ),
              Obx(() {
                Get.log(_category.toString());
                if (controller.featured.elementAt(index).eServices!.isEmpty) {
                  return Text('loading...');
                }
                //print(controller.featured.elementAt(index));

                return ServicesSmallCarouselWidget(services: controller.featured.elementAt(index).eServices!);
              }),
            ],
          );
        }),
      );
    });
  }
}
