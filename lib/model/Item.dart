import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Item {
  String subject;
  String body;
  String dueDate;
  String owner;
  String id;

  Item({this.subject, this.body, this.owner, this.dueDate, this.id});

  factory Item.fromSnap(DocumentSnapshot itemSnap) {
    return Item(
        subject: itemSnap.data['content']['subject'],
        body: itemSnap.data['content']['body'],
        dueDate: itemSnap.data['content']['dueDate'],
        owner: itemSnap.data['owner'] ?? '',
        id: itemSnap.documentID ?? null);
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


  Future deleteItem() {
    return Firestore.instance.collection('items').document(this.id).delete();
  }
}



class ItemOwner {
  String email;
  String firstName;
  String lastName;
  String id;

  ItemOwner({this.email, this.firstName, this.lastName, this.id});

  factory ItemOwner.fromSnap(DocumentSnapshot itemSnap) {
    return ItemOwner(
        email: itemSnap.data['email'],
        firstName: itemSnap.data['firstName'],
        lastName: itemSnap.data['lastName'],
        id: itemSnap.documentID ?? null);
  }

  // Future saveItem() async {
  //   var user = await FirebaseAuth.instance.currentUser();
  //   if (user == null) {
  //     return new Future(null);
  //   }
  //   var itemMap = {
  //     'content': {
  //       'dueDate': this.dueDate,
  //       'body': this.body,
  //       'subject': this.subject
  //     },
  //     'created': new DateTime.now().millisecondsSinceEpoch,
  //     'updated': new DateTime.now().millisecondsSinceEpoch,
  //   };
  //   itemMap['owner'] = user.uid;
  //   var response = Firestore.instance.collection('items').add(itemMap);
  //   return response;
  // }


  // Future deleteItem() {
  //   return Firestore.instance.collection('items').document(this.id).delete();
  // }
}
