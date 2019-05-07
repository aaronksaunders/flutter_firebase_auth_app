import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_app/components/LoadingCircle.dart';
import 'package:firebase_auth_app/model/Item.dart';
import 'package:flutter/material.dart';

class ItemsList extends StatelessWidget {
  ItemsList();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Item.getSnapshot(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) return LoadingCircle();

        final itemDocs = snapshot.data.documents;

        return ListView.builder(
          itemCount: itemDocs.length,
          itemBuilder: (_, int index) {
            final Item item = Item.fromFirebase(itemDocs[index]);
            return ListTile(
              title: Text(item.subject ?? '<No message retrieved>'),
              subtitle: Text('Due Date ${item.dueDate}'),
              onTap: () => {FirebaseAuth.instance.signOut()},
            );
          },
        );
      },
    );
  }
}
