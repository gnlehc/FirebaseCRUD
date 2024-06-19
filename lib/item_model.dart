import 'package:cloud_firestore/cloud_firestore.dart';

class Item {
  String? id;
  String? name;
  int? quantity;

  Item({this.id, this.name, this.quantity});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'quantity': quantity,
    };
  }

  factory Item.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Item(
      id: doc.id,
      name: data['name'],
      quantity: data['quantity'],
    );
  }
}

class SubItem {
  String id;
  String name;
  int quantity;

  SubItem({
    required this.id,
    required this.name,
    required this.quantity,
  });

  factory SubItem.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return SubItem(
      id: doc.id,
      name: data['name'] ?? '',
      quantity: data['quantity'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'quantity': quantity,
    };
  }
}
