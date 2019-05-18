// import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import '../model/Item.dart';


class DataService {
  // final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _db = Firestore.instance;

  Stream<List<Item>> getItemsSnapshot() {
    return _db.collection('items').snapshots().map(
        (list) => list.documents.map((doc) => Item.fromSnap(doc)).toList());
  }
}
