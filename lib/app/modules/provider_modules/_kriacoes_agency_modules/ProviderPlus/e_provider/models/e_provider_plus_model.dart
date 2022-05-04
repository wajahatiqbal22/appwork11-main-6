import 'dart:core';

import '../../../../../../../common/uuid.dart';
import '../../../../../../models/address_model.dart';
import '../../../../../../models/user_model.dart';
import 'tax_plus_model.dart';
import '../../../../../../../common/uuid.dart';
import '../../../../../../models/review_model.dart';
import '../../../../../../models/availability_hour_model.dart';
import '../../../../../../models/media_model.dart';
import '../../../../../../models/parents/model.dart';
import 'tax_plus_model.dart';

class EProviderPlus extends Model {
  String? id;
  String? name;
  String? description;
  List<Media>? images;
  String? phoneNumber;
  String? mobileNumber;
  String? type;
  String? employe;
  List<AvailabilityHour>? availabilityHours;
  double? availabilityRange;
  bool? available;
  bool? featured;
  double? rate;
  List<Review>? reviews;
  int? totalReviews;
  bool? verified;
  int? bookingsInProgress;
  TaxPlus? taxes;
  User? users;
  //User userId;
  Address? addresses;

  EProviderPlus(
      {this.id,
      this.name,
      this.description,
      this.images,
      this.phoneNumber,
      this.mobileNumber,
      this.type,
      this.availabilityHours,
      this.availabilityRange,
      this.available,
      this.featured,
      this.employe,
      this.rate,
      this.reviews,
      this.totalReviews,
      this.verified,
      //this.users,
      this.bookingsInProgress});

  EProviderPlus.fromJson(Map<String, dynamic> json) {
    super.fromJson(json);
    name = transStringFromJson(json, 'name');
    description = transStringFromJson(json, 'description');
    images = mediaListFromJson(json, 'images');
    phoneNumber = stringFromJson(json, 'phone_number');
    mobileNumber = stringFromJson(json, 'mobile_number');
    type = transStringFromJson(json, 'e_provider_type');
    availabilityHours = listFromJson(json, 'availability_hours', (v) => AvailabilityHour.fromJson(v));
    availabilityRange = doubleFromJson(json, 'availability_range');
    available = boolFromJson(json, 'available');
    featured = boolFromJson(json, 'featured');
    taxes = objectFromJson(json, 'taxes', (v) => TaxPlus.fromJson(v));
    rate = doubleFromJson(json, 'rate');
    reviews = listFromJson(json, 'e_provider_reviews', (v) => Review.fromJson(v));
    totalReviews = reviews!.isEmpty ? intFromJson(json, 'total_reviews') : reviews!.length;
    verified = boolFromJson(json, 'verified');
    bookingsInProgress = intFromJson(json, 'bookings_in_progress');
    users = objectFromJson(json, 'users', (v) => User.fromJson(v));
    ///userId = objectFromJson(json, 'users', (v) => User.fromJson(v));
    //addresses = objectFromJson(json, 'addresses', (v) => Address.fromJson(v));
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['name'] = this.name;
    if (this.images != null) {
      data['image'] = this.images!.where((element) => Uuid.isUuid(element.id!)).map((v) => v.id).toList();
    }
    data['description'] = this.description;
    data['e_provider_type_id'] = this.type;
    data['phone_number'] = this.phoneNumber;
    data['mobile_number'] = this.mobileNumber;
    data['availability_range'] = this.availabilityRange;
    data['taxes'] = this.taxes;
    data['available'] = this.available;
    data['featured'] = this.featured;
    if (this.images != null) {
      data['image'] = this.images!.where((element) => Uuid.isUuid(element.id!)).map((v) => v.id).toList();
    }
    return data;
  }

  String get firstImageUrl => this.images?.first.url ?? '';
  String get firstImageThumb => this.images?.first.thumb ?? '';
  String get firstImageIcon => this.images?.first.icon ?? '';

  @override
  bool get hasData {
    return id != null && name != null && description != null;
  }

  Map<String, List<String>> groupedAvailabilityHours() {
    Map<String, List<String>> result = {};
    this.availabilityHours!.forEach((element) {
      if (result.containsKey(element.day)) {
        result[element.day]!.add(element.startAt! + ' - ' + element.endAt!);
      } else {
        result[element.day!] = [element.startAt! + ' - ' + element.endAt!];
      }
    });
    return result;
  }

  List<String> getAvailabilityHoursData(String day) {
    List<String> result = [];
    this.availabilityHours!.forEach((element) {
      if (element.day == day) {
        result.add(element.data!);
      }
    });
    return result;
  }

  @override
  bool operator ==(Object? other) =>
      identical(this, other) ||
      super == other &&
          other is EProviderPlus &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          description == other.description &&
          images == other.images &&
          phoneNumber == other.phoneNumber &&
          mobileNumber == other.mobileNumber &&
          type == other.type &&
          availabilityRange == other.availabilityRange &&
          available == other.available &&
          featured == other.featured &&
          rate == other.rate &&
          reviews == other.reviews &&
          totalReviews == other.totalReviews &&
          verified == other.verified &&
          //users == other.users &&
          bookingsInProgress == other.bookingsInProgress;

  @override
  int get hashCode =>
      super.hashCode ^
      id.hashCode ^
      name.hashCode ^
      description.hashCode ^
      images.hashCode ^
      phoneNumber.hashCode ^
      mobileNumber.hashCode ^
      type.hashCode ^
      availabilityRange.hashCode ^
      available.hashCode ^
      featured.hashCode ^
      rate.hashCode ^
      reviews.hashCode ^
      totalReviews.hashCode ^
      verified.hashCode ^
      //users.hashCode ^
      bookingsInProgress.hashCode;
}