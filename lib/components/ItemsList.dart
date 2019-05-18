
import 'package:firebase_auth_app/model/Item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ItemsList extends StatelessWidget {
  ItemsList();

  @override
  Widget build(BuildContext context) {
    var list =
        Provider.of<List<Item>>(context);
    return ListView.builder(
        itemCount: list.length,
        itemBuilder: (_, int index) {
          final Item item = list[index];
          return DismissibleItem(item, Key(item.id));
        });
  }
}

class DismissibleItem extends StatelessWidget {
  final Item item;
  final Key key;

  DismissibleItem(this.item, this.key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      direction: DismissDirection.endToStart,
      key: key,
      background: Container(
        alignment: AlignmentDirectional.centerEnd,
        color: Colors.red,
        child: Padding(
          padding: EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
          child: Icon(
            Icons.delete,
            color: Colors.white,
          ),
        ),
      ),
      onDismissed: (direction) async {
        try {
          var result = await this.item.deleteItem();
          if (result != null) {}
        } catch (e) {
          print(e);
          //_showErrorMessage(e);
        }
      },
      child: ListTile(
        title: Text(item.subject ?? '<No message retrieved>'),
        subtitle: Text('Due Date ${item.dueDate}'),
        onTap: () => {},
      ),
    );
  }
}
