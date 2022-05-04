import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../../common/ui.dart';
import '../../../../models/category_model.dart';
import '../../../../routes/app_routes.dart';

class CategoryListItemWidget extends StatelessWidget {
  final Category category;
  final String heroTag;
  final bool expanded;

  CategoryListItemWidget({Key? key, required this.category, required this.heroTag, required this.expanded}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
      decoration: BoxDecoration(
        color: Get.theme.primaryColor,
        borderRadius: BorderRadius.all(Radius.circular(10)),
        boxShadow: [
          BoxShadow(color: Get.theme.focusColor.withOpacity(0.1), blurRadius: 10, offset: Offset(0, 5)),
        ],
      ),
      child: Theme(
        data: Get.theme.copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          trailing: category.subCategories!.length > 0 ? null : Icon(null),
          //initiallyExpanded: this.expanded,
          expandedCrossAxisAlignment: CrossAxisAlignment.stretch,
          title: InkWell(
              highlightColor: Colors.transparent,
              splashColor: Theme.of(context).accentColor.withOpacity(0.08),
              onTap: () {
                Get.toNamed(Routes.CATEGORY, arguments: category);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    width: 40,
                    height: 40,
                    child: (category.image!.url!.toLowerCase().endsWith('.svg')
                        ? SvgPicture.network(
                            category.image!.url!,
                            //color: category.color,
                            height: 50,
                          )
                        : CachedNetworkImage(
                            fit: BoxFit.cover,
                            imageUrl: category.image!.url!,
                            placeholder: (context, url) => Image.asset(
                              'assets/img/loading.gif',
                              fit: BoxFit.cover,
                            ),
                            errorWidget: (context, url, error) => Icon(Icons.error_outline),
                          )),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      category.name!,
                      overflow: TextOverflow.fade,
                      softWrap: false,
                      style: Get.textTheme.bodyText2,
                    ),
                  ),

                ],
              )),
          children: List.generate(category.subCategories?.length ?? 0, (index) {
            var _category = category.subCategories!.elementAt(index);
            return GestureDetector(
              onTap: () {
                Get.toNamed(Routes.CATEGORY, arguments: _category);
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 25, vertical: 8),
                child: Text(_category.name!, style: Get.textTheme.bodyText1),
                decoration: BoxDecoration(
                  color: Get.theme.scaffoldBackgroundColor.withOpacity(0.8),
                  border: Border(top: BorderSide(color: Get.theme.scaffoldBackgroundColor.withOpacity(0.3))),
                ),
              ),
            );
          }),

        ),
      ),
    );
  }
}
