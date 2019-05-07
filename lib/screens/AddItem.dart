import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_app/model/Item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

class AddItemPage extends StatefulWidget {
  @override
  _AddItemPageState createState() => _AddItemPageState();
}

enum FormType { LOGIN, REGISTER }

class _AddItemPageState extends State<AddItemPage> {
  final formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _controller = TextEditingController();
  SnackBar snackBar;

  String _subject, _body, _dueDate = " ";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
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
                        child: Column(children: buildButtons(context)))
                  ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> buildButtons(BuildContext context) {
    return <Widget>[
      RaisedButton(
        child: Align(alignment: Alignment.center, child: Text('Save Item')),
        onPressed: () => submit(context),
      ),
      // RaisedButton(
      //   child: Align(alignment: Alignment.center, child: Text('Cancel')),
      //   onPressed: () {},
      // ),
    ];
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
            // Container(
            //     height: 25,
            //     padding: EdgeInsets.all(0),
            //     width: 320, // how to calculate this??
            //     decoration: new BoxDecoration(
            //       border: new Border(
            //         bottom: BorderSide(width: 1.5, color: Colors.grey),
            //       ),
            //     ),
            //     child: Text(_dueDate)),
            Container(
              width: 320,
              child: TextFormField(
                controller: _controller,
                enabled: false,
                enableInteractiveSelection: false,
                decoration: InputDecoration(labelText: 'Due Date'),
                onSaved: (value) => _dueDate = value,
              ),
            ),
            IconButton(
                onPressed: _selectDate,
                icon: new Icon(FontAwesome.getIconData("calendar"))),
          ],
        ),
      )
    ];
  }

  void submit(BuildContext context) async {
    if (validate()) {
      try {
        //final auth = Provider.of(context).auth;
        var i = new Item(_subject, _body, _dueDate);
        var result = await i.saveItem();
        if (result != null) {
          print(result);
        } else {
          print("error");
        }
        snackBar = SnackBar(
          content: Text('Item Added Successfully!'),
          duration: Duration(seconds: 30),
          action: SnackBarAction(
            label: 'Close',
            onPressed: () {
              // Some code to undo the change!
              _scaffoldKey.currentState
                  .hideCurrentSnackBar(reason: SnackBarClosedReason.action);
            },
          ),
        );

        // Find the Scaffold in the Widget tree and use it to show a SnackBar!
        _scaffoldKey.currentState.showSnackBar(snackBar).closed.then((reason) {
          // snackbar is now closed, close window
          Navigator.pop(context);
        });
      } catch (e) {
        print(e);
      }
    }
  }

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

  Future _selectDate() async {
    DateTime picked = await showDatePicker(
        context: context,
        initialDate: new DateTime.now(),
        firstDate: new DateTime(2016),
        lastDate: new DateTime(2020));

    if (picked != null) {
      _controller.text = picked.toString();
      setState(() => _dueDate = picked.toString());
    }
  }
}
