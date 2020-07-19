import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_app/model/Item.dart';
import 'package:firebase_auth_app/services/auth.dart';
import 'package:flutter/material.dart';

class ItemDetailForm extends StatelessWidget {
  const ItemDetailForm({
    Key key,
    @required this.itemUser,
    @required this.currentItem,
  }) : super(key: key);

  final String itemUser;
  final Item currentItem;

  String _renderName(FirebaseUser owner) {
//    return '${data.firstName} ${data.lastName}';
    return owner.displayName;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder<FirebaseUser>(
          future: AuthService().getUser,
          builder: (context, snapshot) {
            if (snapshot.hasData == true && currentItem != null) {
              var itemOwner = snapshot.data;

              return Padding(
                padding: const EdgeInsets.all(14.0),
                child: Center(
                  child: Column(
                    children: <Widget>[
                      Text(
                        currentItem.body,
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          currentItem.dueDate,
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      Text(
                        currentItem != null ? _renderName(itemOwner) : "",
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }),
    );
  }
}
