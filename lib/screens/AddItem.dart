import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:firebase_auth_app/components/MessageSnack.dart';
import 'package:firebase_auth_app/model/Item.dart';
import 'package:flutter_icons/flutter_icons.dart';

class AddItemPage extends StatefulWidget {
  final Item currentItem;

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
  Item _currentItem;

  _printLatestValue() {
    setState(() {
      print("text _controller Value: ${_controller.text}");
      if (_dueDate != " ") {
        _controller.text = _dueDate;
      }
    });
  }

  @override
  void initState() {
    super.initState();

    // Start listening to changes.
    _controller.addListener(_printLatestValue);
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    _controller.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var snapshot = widget.currentItem ?? Item();

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
              children: buildInputs(snapshot) +
                  [
                    Padding(
                      padding: EdgeInsets.only(left: 20, right: 20, top: 30),
                      child: Column(
                        children: buildButtons(context),
                      ),
                    )
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

  List<Widget> buildInputs(Item snap) {
    // if we have data then set the dueDate text from the data
    _controller.text = snap.dueDate;

    // if we have id then set it, we will use this to determine
    // if we need to save or create the item
    _currentItem = snap;

    return <Widget>[
      TextFormField(
        decoration: InputDecoration(labelText: 'Subject'),
        initialValue: snap.subject,
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
        initialValue: snap.body,
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

        if (_currentItem.id != null) {
          await i.updateItem(_currentItem);
        } else {
          await i.saveItem();
        }

        MessageSnack().showInfoMessage('Item Added Successfully!', _scaffoldKey,
            () => Navigator.pop(context));
      } catch (error) {
        MessageSnack().showErrorMessage(error, _scaffoldKey);
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
      setState(() {
//        _dueDate = picked.toString();
        _dueDate = intl.DateFormat('yMMMd').format(picked).toString();
        _controller.text = _dueDate;
      });
    }
  }
}
