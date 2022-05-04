

import '../../../../../../models/parents/model.dart';

class TaxPlus extends Model {
  String? id;
  String? name;
  String? type;
  double? value;

  TaxPlus(this.id, this.name, this.type, this.value);

  TaxPlus.fromJson(Map<String, dynamic> json) {
    super.fromJson(json);
    name = transStringFromJson(json, 'name');
    type = stringFromJson(json, 'type');
    value = doubleFromJson(json, 'value');
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    return data;
  }
}
