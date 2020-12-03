import 'package:cloud_firestore/cloud_firestore.dart';

class Item {
  String title;
  bool done;

  DocumentReference reference;

  Item(this.title, {this.done, this.reference});

  factory Item.fromSnapshot(DocumentSnapshot snapshot) {
    Item newItem = Item.fromJson(snapshot.data);
    newItem.reference = snapshot.reference;
    return newItem;
  }

  factory Item.fromJson(Map<String, dynamic> json) => _ItemFromJson(json);

  Map<String, dynamic> toJson() => _ItemToJson(this);
  @override
  String toString() => "Item<$title>";
}

Item _ItemFromJson(Map<String, dynamic> json) {
  return Item(json['title'] as String, done: json['done'] as bool);
}

Map<String, dynamic> _ItemToJson(Item instance) =>
    <String, dynamic>{'title': instance.title, 'done': instance.done};
