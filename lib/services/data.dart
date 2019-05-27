import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import '../model/Item.dart';

class DataService {
  // final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _db = Firestore.instance;

  Stream<List<Item>> getItemsSnapshot() {
    
    try {
      var snaps = _db.collection('items').snapshots();
      snaps.handleError((e) {
        print(e);
        return Stream.empty();
      });

      return snaps.map(
          (list) => list.documents.map((doc) => Item.fromSnap(doc)).toList());
    } catch (e) {
      return Stream.empty();
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

  Future<ItemOwner> getUserById(String userId) async {
    var itemOwner = await _db.collection('users').document(userId).get();

    if (itemOwner.exists != null) {
      return Future(() => ItemOwner.fromSnap(itemOwner));
    } else {
      return Future<ItemOwner>.value(null);
    }
  }
}
