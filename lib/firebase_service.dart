import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crud/item_model.dart';

class FirebaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String collectionName = 'items';

  Stream<List<Item>> getItems() {
    return _db.collection(collectionName).snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Item.fromFirestore(doc)).toList());
  }

  Future<void> addItem(Item item) {
    return _db.collection(collectionName).add(item.toMap());
  }

  Future<void> updateItem(Item item) {
    return _db.collection(collectionName).doc(item.id).update(item.toMap());
  }

  Future<void> deleteItem(String id) {
    return _db.collection(collectionName).doc(id).delete();
  }

  // Function to add a subcollection within an item document
  Future<void> addSubcollection(String itemId, SubItem subitem) {
    return _db
        .collection(collectionName)
        .doc(itemId)
        .collection('subitems')
        .add(subitem.toMap());
  }

  // Function to update a subcollection document
  Future<void> updateSubitem(String itemId, SubItem subitem) {
    return _db
        .collection(collectionName)
        .doc(itemId)
        .collection('subitems')
        .doc(subitem.id)
        .update(subitem.toMap());
  }

  // Function to delete a subcollection document
  Future<void> deleteSubitem(String itemId, String subitemId) {
    return _db
        .collection(collectionName)
        .doc(itemId)
        .collection('subitems')
        .doc(subitemId)
        .delete();
  }

  // Function to get subitems of an item
  Stream<List<SubItem>> getSubitems(String itemId) {
    return _db
        .collection(collectionName)
        .doc(itemId)
        .collection('subitems')
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => SubItem.fromFirestore(doc)).toList());
  }
}
