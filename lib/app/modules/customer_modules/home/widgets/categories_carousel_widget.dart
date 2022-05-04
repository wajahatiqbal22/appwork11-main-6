import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../routes/app_routes.dart';
import '../controllers/home_controller.dart';

class CategoriesCarouselWidget extends GetWidget<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 230,
      //  margin: EdgeInsets.only(bottom: 15),
      child: Obx(() {
        return GridView.builder(
            physics: NeverScrollableScrollPhysics(),
            primary: false,
            shrinkWrap: false,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
            ),
            //scrollDirection: Axis.horizontal,
            itemCount: controller.homeCategories.length,
            itemBuilder: (_, index) {
              var _category = controller.categories.elementAt(index);
              return InkWell(
                onTap: () {
                  Get.toNamed(Routes.CATEGORY, arguments: _category);
                },
                child: Column(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        child: (_category.image!.url!
                                .toLowerCase()
                                .endsWith('.svg')
                            ? SvgPicture.network(
                                _category.image!.url!,
                                color: _category.color,
                              )
                            : CachedNetworkImage(
                                height: 40,
                                width: 40,
                                //   fit: BoxFit.fitWidth,
                                imageUrl: _category.image!.url!,
                                placeholder: (context, url) => Image.asset(
                                  'assets/img/loading.gif',
                                  fit: BoxFit.cover,
                                ),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error_outline),
                              )),
                      ),
                    ),
                    SizedBox(height: 5),
                    Expanded(
                      child: Text(
                        _category.name!,
                        maxLines: 2,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              );
            });
      }),
    );
  }
}
