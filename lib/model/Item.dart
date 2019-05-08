import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Item {
  String subject;
  String body;
  String dueDate;
  String owner;
  String id;

  Item(
    this.subject,
    this.body,
    //this.owner,
    this.dueDate,
  );

  Item.fromFirebase(DocumentSnapshot itemSnap) {
    this.subject = itemSnap.data['content']['subject'];
    this.body = itemSnap.data['content']['body'];
    this.dueDate = itemSnap.data['content']['dueDate'];
    this.owner = itemSnap.data['owner'];
    this.id = itemSnap.documentID;
  }

  Future saveItem() async {
    var user = await FirebaseAuth.instance.currentUser();
    if (user == null) {
      return new Future(null);
    }
    var itemMap = {
      'content': {
        'dueDate': this.dueDate,
        'body': this.body,
        'subject': this.subject
      },
      'created': new DateTime.now().millisecondsSinceEpoch,
      'updated': new DateTime.now().millisecondsSinceEpoch,
    };
    itemMap['owner'] = user.uid;
    var response = Firestore.instance.collection('items').add(itemMap);
    return response;
  }

  static getSnapshot() {
    return Firestore.instance.collection('items').snapshots();
  }

  Future deleteItem() {
    return Firestore.instance.collection('items').document(this.id).delete();
  }
}
