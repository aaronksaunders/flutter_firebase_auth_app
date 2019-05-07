import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter/material.dart';

enum FormType { LOGIN, REGISTER }

class AddItemPage extends StatefulWidget {
  @override
  _AddItemPageState createState() => _AddItemPageState();
}

class _AddItemPageState extends State<AddItemPage> {
  final formKey = GlobalKey<FormState>();

  String _subject, _body, _dueDate = " ";

  bool validate() {
    final form = formKey.currentState;
    form.save();
    if (form.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  void submit() async {
    if (validate()) {
      try {
        //final auth = Provider.of(context).auth;
      } catch (e) {
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Item Form Page'),
      ),
      body: Center(
        child: Form(
          key: formKey,
          child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              children: buildInputs() +
                  [
                    Padding(
                        padding: EdgeInsets.only(left: 20, right: 20, top: 30),
                        child: Column(children: buildButtons()))
                  ],
            ),
          ),
        ),
      ),
    );
  }

  Future _selectDate() async {
    DateTime picked = await showDatePicker(
        context: context,
        initialDate: new DateTime.now(),
        firstDate: new DateTime(2016),
        lastDate: new DateTime(2020));
    if (picked != null) setState(() => _dueDate = picked.toString());
  }

  List<Widget> buildInputs() {
    return <Widget>[
      TextFormField(
        decoration: InputDecoration(labelText: 'Subject'),
        onSaved: (value) => _subject = value,
      ),
      TextFormField(
        decoration: InputDecoration(labelText: 'Body'),
        onSaved: (value) => _body = value,
      ),
      Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
                height: 25,
                padding: EdgeInsets.all(0),
                width: 320, // how to calculate this??
                decoration: new BoxDecoration(
                  border: new Border(
                    bottom: BorderSide(width: 1.5, color: Colors.grey),
                  ),
                ),
                child: Text(_dueDate)),
            IconButton(
                onPressed: _selectDate,
                icon: new Icon(FontAwesome.getIconData("calendar"))),
          ],
        ),
      )
    ];
  }

  List<Widget> buildButtons() {
    return <Widget>[
      RaisedButton(
        child: Align(alignment: Alignment.center, child: Text('Save Item')),
        onPressed: submit,
      ),
      RaisedButton(
        child: Align(alignment: Alignment.center, child: Text('Cancel')),
        onPressed: () {},
      ),
    ];
  }
}
