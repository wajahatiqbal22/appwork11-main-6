import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../models/favorite_model.dart';
import '../../global_widgets/circular_loading_widget.dart';
import '../controllers/favorites_controller.dart';
import 'favorites_list_item_widget.dart';

class FavoritesListWidget extends GetView<FavoritesController> {
  final controller = Get.find<FavoritesController>();
  FavoritesListWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.isTrue) {
        return CircularLoadingWidget(height: 300);
      } else if (controller.favorites.isEmpty) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Text(
              "No Favourites",
              style: Get.theme.textTheme.headline3,
            ),
          ),
        );
      } else {
        return ListView.builder(
          padding: EdgeInsets.only(bottom: 10, top: 10),
          primary: false,
          shrinkWrap: true,
          itemCount: controller.favorites.length,
          itemBuilder: ((_, index) {
            var _favorite = controller.favorites.elementAt(index);
            return FavoritesListItemWidget(favorite: _favorite);
          }),
        );
      }
    });
  }
}
