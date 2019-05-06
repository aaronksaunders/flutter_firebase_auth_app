import 'package:cloud_firestore/cloud_firestore.dart';

class Item {
  String subject;
  String body;
  String dueDate;
  String owner;
  String id;

  Item(
    this.subject,
    this.body,
    this.owner,
    this.dueDate,
  );

  Item.fromFirebase(DocumentSnapshot itemSnap) {
    this.subject = itemSnap.data['content']['subject'];
    this.body = itemSnap.data['content']['body'];
    this.dueDate = itemSnap.data['content']['dueDate'];
    this.owner = itemSnap.data['owner'];
    this.id = itemSnap.documentID;
  }

  static getSnapshot() {
    return Firestore.instance.collection('items').snapshots();
  }
}
