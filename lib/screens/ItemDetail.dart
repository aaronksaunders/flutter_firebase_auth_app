import 'dart:async';

import 'package:firebase_auth_app/components/ItemDetailForm.dart';
import 'package:firebase_auth_app/components/MessageSnack.dart';
import 'package:firebase_auth_app/model/Item.dart';
import 'package:firebase_auth_app/services/data.dart';
import 'package:flutter/material.dart';

import 'AddItem.dart';

class ItemDetailPage extends StatefulWidget {
  ItemDetailPage({this.itemId});

  final String itemId;

  @override
  _ItemDetailPageState createState() => _ItemDetailPageState();
}

class _ItemDetailPageState extends State<ItemDetailPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String pageTitle = "";
  Item currentItem;
  Future<ItemOwner> itemUser;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    loadItem();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(pageTitle),
        actions: <Widget>[EditButton(currentItem, loadItem)],
      ),
      body: new ItemDetailForm(itemUser: itemUser, currentItem: currentItem),
    );
  }

  void loadItem() async {
    try {
      var value = await DataService().getItemById(widget.itemId);

      setState(() {
        pageTitle = value.subject;
        currentItem = value;
        itemUser = DataService().getUserById(value.owner);
      });
    } catch (e) {
      MessageSnack().showErrorMessage(e, _scaffoldKey);
    }
  }
}

class EditButton extends StatelessWidget {
  final Item currentItem;
  final Function completion;

  const EditButton(
    this.currentItem,
    this.completion, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new IconButton(
        icon: new Icon(Icons.edit),
        onPressed: () async {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddItemPage(this.currentItem),
              settings: RouteSettings(name: "AddItemPage"),
              fullscreenDialog: true,
            ),
          ).then((value) {
            this.completion();
          });
          return true;
        });
  }
}
