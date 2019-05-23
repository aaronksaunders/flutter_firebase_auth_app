import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth_app/model/Item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';

class AddItemPage extends StatefulWidget {
  final Future<Item> currentItem;

  AddItemPage([this.currentItem]);

  @override
  _AddItemPageState createState() => _AddItemPageState();
}

class _AddItemPageState extends State<AddItemPage> {
  final formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _controller = TextEditingController();
  SnackBar snackBar;

  String _subject, _body, _dueDate = " ";
  Item _currentItem = null;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    Provider.of<FirebaseAnalytics>(context)
        .setCurrentScreen(screenName: "AddItemPage")
        .then((v) => {});
  }

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
            child: FutureBuilder<Item>(
                // if we are editing then we were passed in a future object to
                // load, otherwise create a blank item
                future: widget.currentItem ?? new Future<Item>(() => Item()),
                builder: (context, snapshot) {
                  return Column(
                    children: buildInputs(snapshot) +
                        [
                          Padding(
                            padding:
                                EdgeInsets.only(left: 20, right: 20, top: 30),
                            child: Column(
                              children: buildButtons(context),
                            ),
                          )
                        ],
                  );
                }),
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

  List<Widget> buildInputs(AsyncSnapshot<Item> snap) {
    // if i have no data yet, then exit
    if (snap.hasData == false) return [];

    // if we have data then set the dueDate text from the data
    _controller.text = snap.data.dueDate;

    // if we have id then set it, we will use this to determine
    // if we need to save or create the item
    _currentItem = snap.data;

    return <Widget>[
      TextFormField(
        decoration: InputDecoration(labelText: 'Subject'),
        initialValue: snap.data.subject,
        onSaved: (value) => _subject = value,
        validator: (value) {
          if (value.isEmpty) {
            return 'Please enter some text, Subject Cannot Be Empty';
          }
        },
      ),
      TextFormField(
        minLines: 3,
        maxLines: 3,
        initialValue: snap.data.body,
        decoration: InputDecoration(labelText: 'Body'),
        onSaved: (value) => _body = value,
        validator: (value) {
          if (value.isEmpty) {
            return 'Please enter some text, Body Cannot Be Empty';
          }
        },
      ),
      Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 320,
              child: TextFormField(
                controller: _controller,
                enabled: false,
                enableInteractiveSelection: false,
                decoration: InputDecoration(labelText: 'Due Date'),
                onSaved: (value) => _dueDate = value,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter some text, Subject Cannot Be Empty';
                  }
                },
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
        var i = new Item(subject: _subject, body: _body, dueDate: _dueDate);

        // if I have _currentItem, then set some properties
        try {
          if (_currentItem.id != null) {
            await i.updateItem(_currentItem);
          } else {
            await i.saveItem();
          }
        } catch (e) {
          print(e);
        }
        snackBar = SnackBar(
          content: Text('Item Added Successfully!'),
          duration: Duration(seconds: 10),
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
          Navigator.pop(
            context,
          );
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

  //
  // @todo - convert string date to date time for display when editing
  // the item
  //
  Future _selectDate() async {
    DateTime picked = await showDatePicker(
        context: context,
        initialDate:
            _controller.text != null ? new DateTime.now() : new DateTime.now(),
        firstDate: new DateTime(2019),
        lastDate: new DateTime(2022));

    if (picked != null) {
      _controller.text = picked.toString();
      setState(() => _dueDate = picked.toString());
    }
  }
}
