import 'parents/model.dart';

class TimeslotModel extends Model {
  int? serviceDuration;
  int? cleanup;
  int? status;
  int? eProviderId;
  int? recurring;
  String? start;
  String? end;
  String? date;
  List<String>? booked;
  TimeslotModel({
    this.serviceDuration,
    this.cleanup,
    this.status,
    this.eProviderId,
    this.start,
    this.end,
    this.date,
    this.booked,
    this.recurring,
  });

  TimeslotModel.fromJson(Map<String, dynamic> json) {
    super.fromJson(json);
    serviceDuration = intFromJson(json, 'service_duration');
    cleanup = intFromJson(json, 'cleanup');
    status = intFromJson(json, 'status');
    eProviderId = intFromJson(json, 'e_provider_id');
    recurring = intFromJson(json, 'recurring');
    start = stringFromJson(json, 'start');
    end = stringFromJson(json, 'end');
    date = stringFromJson(json, 'date');
    booked = json['booked'] != null ? List.from(json['booked']) : [];
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['service_duration'] = this.serviceDuration;
    data['cleanup'] = this.cleanup;
    data['status'] = this.status;
    data['e_provider_id'] = this.eProviderId;
    data['start'] = this.start;
    data['end'] = this.end;
    data['date'] = this.date;
    data['recurring'] = this.recurring;
    if (booked != null) data['booked'] = this.booked;
    return data;
  }

  @override
  String toString() {
    return 'TimeslotModel(serviceDuration: $serviceDuration, cleanup: $cleanup, status: $status, eProviderId: $eProviderId, start: $start, end: $end, date: $date, booked: $booked)';
  }
}
