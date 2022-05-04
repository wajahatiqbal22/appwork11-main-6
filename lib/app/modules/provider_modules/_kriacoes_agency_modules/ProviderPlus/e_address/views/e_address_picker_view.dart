import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import '../../../../../../models/address_model.dart';
import '../../../../../customer_modules/global_widgets/block_button_widget.dart';
import '../../../../../customer_modules/global_widgets/text_field_widget.dart';
import '../../../../../../routes/app_routes.dart';
import '../../../../../../services/auth_service.dart';
import '../../../../../../services/settings_service.dart';

class AddressPlusPickerView extends StatelessWidget {
  AddressPlusPickerView();

  @override
  Widget build(BuildContext context) {
    return PlacePicker(
      apiKey: Get.find<SettingsService>().setting.value.googleMapsKey!,
      hintText: "kriacoes_agency_module_provider_plus_address_picker_hint".tr,
      searchingText: "kriacoes_agency_module_provider_plus_please_wait".tr,
      initialPosition: Get.find<SettingsService>().address.value.getLatLng(),
      enableMapTypeButton: false,
      enableMyLocationButton: true,
      useCurrentLocation: true,
      selectInitialPosition: true,
      usePlaceDetailSearch: true,
      forceSearchOnZoomChanged: true,
      selectedPlaceWidgetBuilder: (_, selectedPlace, state, isSearchBarFocused) {
        if (isSearchBarFocused) {
          return SizedBox();
        }
        Address _address = Address(address: selectedPlace?.formattedAddress ?? '');
        return FloatingCard(
          height: 300,
          elevation: 0,
          bottomPosition: 0.0,
          leftPosition: 0.0,
          rightPosition: 0.0,
          color: Colors.transparent,
          child: state == SearchingState.Searching
              ? Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                child: Column(
//            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
                TextFieldWidget(
                  labelText: "kriacoes_agency_module_provider_plus_address_picker_description_label".tr,
                  hintText: "kriacoes_agency_module_provider_plus_address_picker_description_hint".tr,
                  validator: (input) => input!.length == 0 ? "kriacoes_agency_module_provider_plus_address_picker_description_validator".tr : null,
                  initialValue: _address.description,
                  onChanged: (input) => _address.description = input,
                  iconData: Icons.description_outlined,
                  isFirst: true,
                  isLast: false,
                ),
                TextFieldWidget(
                  labelText: "kriacoes_agency_module_provider_plus_address_picker_address".tr,
                  hintText: "kriacoes_agency_module_provider_plus_address_picker_address_hint".tr,
                  initialValue: _address.address,
                  onChanged: (input) => _address.address = input,
                  iconData: Icons.place_outlined,
                  isFirst: false,
                  isLast: true,
                ),

                Row(
                  children: [

                    MaterialButton(
                      onPressed: () async {
                        Navigator.pop(Get.context!);
                        //Get.back();
                        //await Get.offAndToNamed(Routes.E_PROVIDER_PLUS_ADDRESS_CREATE);
                      },
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      color: Get.theme.colorScheme.secondary.withOpacity(0.5),
                      child: Text("kriacoes_agency_module_provider_plus_address_picker_button_cancel".tr, style: Get.textTheme.bodyText2!.merge(TextStyle(color: Get.theme.primaryColor))),
                      elevation: 0,
                    ),

                    SizedBox(width: 10),

                    Expanded(
                      child: MaterialButton(
                        onPressed: () async {
                            Get.find<SettingsService>().address.update((val) {
                              val!.description = _address.description;
                              val.address = _address.address;
                              val.latitude = selectedPlace!.geometry!.location.lat;
                              val.longitude = selectedPlace.geometry!.location.lng;
                              val.userId = Get.find<AuthService>().user.value.id;
                            });
                            Navigator.pop(Get.context!);
                            //await Get.offAndToNamed(Routes.E_PROVIDER_PLUS_ADDRESS_CREATE);
                        },
                        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        color: Get.theme.accentColor,
                        child: Text("kriacoes_agency_module_provider_plus_address_picker_button".tr, style: Get.textTheme.bodyText2!.merge(TextStyle(color: Get.theme.primaryColor))),
                        elevation: 0,
                      ),
                    ),
                  ],
                ).paddingSymmetric(vertical: 0, horizontal: 20),
                SizedBox(height: 10),
            ],
          ),
              ),
        );
      },
    );
  }
}
