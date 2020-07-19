import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth_app/services/auth.dart';
import 'package:firebase_auth_app/model/Item.dart';

class DataService {
  final Firestore _db = Firestore.instance;

  Stream<List<Item>> getItemsSnapshot() async* {
    var user = await AuthService().getUser;
    try {
      var snaps = _db
          .collection('items')
          .where('owner', isEqualTo: user.uid)
          .snapshots();
      snaps.handleError((e) {
        print(e);
        return Stream.empty();
      });

      yield* snaps.map(
          (list) => list.documents.map((doc) => Item.fromSnap(doc)).toList());
    } catch (e) {
      yield* Stream.empty();
    }
  }

  Future<Item> getItemById(String itemId) async {
    var item = await _db.collection('items').document(itemId).get();

    if (item.exists != null) {
      return Future(() => Item.fromSnap(item));
    } else {
      return Future<Item>.value(null);
    }
  }

//  Future<ItemOwner> getUserById(String userId) async {
//    var itemOwner = await _db.collection('users').document(userId).get();

//    if (itemOwner.exists != null) {
//      return Future(() => ItemOwner.fromSnap(itemOwner));
//    } else {
//      return Future<ItemOwner>.value(null);
//    }
//  }
}
