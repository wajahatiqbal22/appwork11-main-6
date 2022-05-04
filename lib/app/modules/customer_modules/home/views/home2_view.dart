import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home_services/app/modules/customer_modules/root/controllers/root_controller.dart';
import 'package:home_services/app/modules/provider_modules/availability/views/availability_view.dart';

import '../../../../../common/ui.dart';
import '../../../../models/slide_model.dart';
import '../../../../providers/laravel_providers/laravel_provider.dart';
import '../../../../routes/app_routes.dart';
import '../../../../services/settings_service.dart';
import '../../global_widgets/address_widget.dart';
import '../../global_widgets/home_search_bar_widget.dart';
import '../../global_widgets/notifications_button_widget.dart';
import '../controllers/home_controller.dart';
import '../widgets/categories_carousel_widget.dart';
import '../widgets/featured_categories_widget.dart';
import '../widgets/recommended_carousel_widget.dart';
import '../widgets/slide_item_widget.dart';

class Home2View extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
          onRefresh: () async {
            Get.find<CustomerApiClient>().forceRefresh();
            await controller.refreshHome(showMessage: true);
            Get.find<CustomerApiClient>().unForceRefresh();
          },
          child: CustomScrollView(
            primary: true,
            shrinkWrap: false,
            slivers: <Widget>[
              SliverAppBar(
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                expandedHeight: 300,
                elevation: 0.5,
                floating: true,
                iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
                title: Text(
                  Get.find<SettingsService>().setting.value.appName!,
                  style: Get.textTheme.headline6,
                ),
                centerTitle: true,
                automaticallyImplyLeading: false,
                leading: new IconButton(
                  icon: new Icon(Icons.sort, color: Colors.black87),
                  onPressed: () => {Scaffold.of(context).openDrawer()},
                ),
                actions: [NotificationsButtonWidget()],
                bottom: HomeSearchBarWidget(),
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.parallax,
                  background: Obx(() {
                    return Stack(
                      alignment: controller.slider.isEmpty
                          ? AlignmentDirectional.center
                          : Ui.getAlignmentDirectional(controller.slider
                          .elementAt(controller.currentSlide.value)
                          .textPosition!),
                      children: <Widget>[
                        CarouselSlider(
                          options: CarouselOptions(
                            autoPlay: true,
                            autoPlayInterval: Duration(seconds: 7),
                            height: 360,
                            viewportFraction: 1.0,
                            onPageChanged: (index, reason) {
                              controller.currentSlide.value = index;
                            },
                          ),
                          items: controller.slider.map((Slide slide) {
                            return SlideItemWidget(slide: slide);
                          }).toList(),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(
                              vertical: 70, horizontal: 20),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: controller.slider.map((Slide slide) {
                              return Container(
                                width: 20.0,
                                height: 5.0,
                                margin: EdgeInsets.symmetric(
                                    vertical: 20.0, horizontal: 2.0),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                    color: controller.currentSlide.value ==
                                        controller.slider.indexOf(slide)
                                        ? slide.indicatorColor
                                        : slide.indicatorColor!
                                        .withOpacity(0.4)),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    );
                  }),
                ).marginOnly(bottom: 42),
              ),
              SliverToBoxAdapter(
                child: Wrap(
                  children: [
                    AddressWidget(),
                    Padding(
                      padding:
                      EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                      child: Row(
                        children: [
                          Expanded(
                              child: Text("Services".tr,
                                  style: Get.textTheme.headline5)),
                          MaterialButton(
                            onPressed: () {
                              Get.toNamed(Routes.CATEGORIES);
                            },
                            shape: StadiumBorder(),
                            color: Get.theme.accentColor.withOpacity(0.1),
                            child: Text("View All".tr,
                                style: Get.textTheme.subtitle1),
                            elevation: 0,
                          ),
                        ],
                      ),
                    ),
                    CategoriesCarouselWidget(),
                     /*Container(
                      color: Get.theme.primaryColor,
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                       child: Row(
                      children: [
                          Expanded(child: Text("Recommended for you".tr, style: Get.textTheme.headline5)),
                           MaterialButton(
                            onPressed: () {
                               Get.toNamed(Routes.CATEGORIES);
                             },
                            shape: StadiumBorder(),
                             color: Get.theme.accentColor.withOpacity(0.1),
                             child: Text("View All".tr, style: Get.textTheme.subtitle1),
                             elevation: 0,
                           ),
                        ],
                      ),
                    ),*/
                    //RecommendedCarouselWidget(),
                    SizedBox(
                      height: 10,
                    ),
//                    FeaturedCategoriesWidget(),
                  Column(
                    children: [
                      InkWell(
                          onTap:() async {
//                            await Get.find<RootController>().changePage(3);
                          }
                          ,child: heading("Refer and Earn","assets/img/referf.JPG")),
                      SizedBox(
                        height: 8,
                      ),

                      InkWell(
                          onTap:(){
//                            Get.to(());

                            //  Get.to(page);
                          }
                          ,child: heading("Become a provider","assets/img/refer.JPG")),

                    ],
                  )
                  ],
                ),
              ),
            ],
          )),
    );
  }
  Widget heading(String text,String img){
    return Container(
      alignment: Alignment.centerLeft,
      padding:
      EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
              Text(text.tr,
              style: Get.textTheme.headline5),
          SizedBox(
            height: 10,
          ),

          Container(
              alignment: Alignment.center,

              child: Image.asset(img))
            ],
      ),
    );
  }
}
