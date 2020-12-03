import 'package:cloud_firestore/cloud_firestore.dart';

class FinanceItem {
  String title;
  double value;

  DocumentReference reference;

  FinanceItem(this.title, this.value, {this.reference});

  factory FinanceItem.fromSnapshot(DocumentSnapshot snapshot) {
    FinanceItem newFinanceItem = FinanceItem.fromJson(snapshot.data);
    newFinanceItem.reference = snapshot.reference;
    return newFinanceItem;
  }

  factory FinanceItem.fromJson(Map<String, dynamic> json) =>
      _FinanceItemFromJson(json);

  Map<String, dynamic> toJson() => _FinanceItemToJson(this);
  @override
  String toString() => "FinanceItem<$title>";
}

FinanceItem _FinanceItemFromJson(Map<String, dynamic> json) {
  return FinanceItem(json['title'] as String, json['value'] as double);
}

Map<String, dynamic> _FinanceItemToJson(FinanceItem instance) =>
    <String, dynamic>{'title': instance.title, 'value': instance.value};
