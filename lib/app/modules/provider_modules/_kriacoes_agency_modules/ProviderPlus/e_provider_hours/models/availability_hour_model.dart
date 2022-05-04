import 'dart:core';
import '../../../../../../models/parents/model.dart';

class ProviderAvailabilityHour extends Model {
  String? id;
  String? day;
  String? startAt;
  String? endAt;
  String? data;
  String? provider;
  bool? isSelected=false;
  ProviderAvailabilityHour({
    this.id,
    this.day,
    this.startAt,
    this.endAt,
    this.data,
    this.provider,
    this.isSelected
    });

  ProviderAvailabilityHour.fromJson(Map<String, dynamic> json) {
    super.fromJson(json);
    day = stringFromJson(json, 'day');
    startAt = stringFromJson(json, 'start_at');
    endAt = stringFromJson(json, 'end_at');
    data = transStringFromJson(json, 'data');
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['day'] = this.day;
    data['start_at'] = this.startAt;
    data['end_at'] = this.endAt;
    data['data'] = this.data;
    data['e_provider_id'] = this.provider;
    return data;
  }
}
