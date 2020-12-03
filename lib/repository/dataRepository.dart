import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:TodoApp/models/item.dart';
import 'package:TodoApp/models/financeItem.dart';

class DataRepository {
  final CollectionReference todoCollection =
      Firestore.instance.collection('todo');
  final CollectionReference financeCollection =
      Firestore.instance.collection('finance');

  //This step listens for updates automatically
  Stream<QuerySnapshot> getTodoStream() {
    return todoCollection.snapshots();
  }

  Stream<QuerySnapshot> getFinanceStream() {
    return financeCollection.snapshots();
  }

  //Add a new To do and Finance Item
  Future<DocumentReference> addTodoItem(Item item) {
    return todoCollection.add(item.toJson());
  }

  Future<DocumentReference> addFinanceItem(FinanceItem financeItem) {
    return financeCollection.add(financeItem.toJson());
  }

  //Update Item class and FinanceItem class
  updateTodoItem(Item item) async {
    await todoCollection
        .document(item.reference.documentID)
        .updateData(item.toJson());
  }

  updateFinanceItem(FinanceItem financeItem) async {
    await financeCollection
        .document(financeItem.reference.documentID)
        .updateData(financeItem.toJson());
  }
}
