import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum FormType { LOGIN, REGISTER }

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  var _showModal = false;

  String _email, _password, _firstName, _lastName;
  String _pageTitle = "Account Login";
  FormType _formType = FormType.LOGIN;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Provider.of<FirebaseAnalytics>(context)
        .setCurrentScreen(screenName: "LoginPage")
        .then((v) => {});
  }

  bool validate() {
    final form = formKey.currentState;
    print('{$_email}, $_password, $_firstName, $_lastName');
    form.save();
    if (form.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  _showErrorMessage(_error) {
    // if one is open, close it
    _scaffoldKey.currentState
        .hideCurrentSnackBar(reason: SnackBarClosedReason.action);

    SnackBar snackBar = SnackBar(
      key: new Key('errorSnackbar'),
      content: Text(_error.message, key: new Key('errormessage')),
      duration: Duration(seconds: 30),
      backgroundColor: Colors.redAccent,
      action: SnackBarAction(
        label: 'Close',
        textColor: Colors.white,
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
    });
  }

  void submit() async {
    if (validate()) {
      setState(() {
        _showModal = true;
      });
      try {
        //final auth = Provider.of(context).auth;
        if (_formType == FormType.LOGIN) {
          FirebaseUser user =
              await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: _email,
            password: _password,
          );

          print('Signed in ${user.uid}');
        } else {
          FirebaseUser user = await FirebaseAuth.instance
              .createUserWithEmailAndPassword(
                  email: _email, password: _password);

          print('Registered ${user.uid}');
        }

        setState(() {
          _showModal = false;
        });
      } catch (e) {
        setState(() {
          _showModal = false;
        });
        print(e);
        _showErrorMessage(e);
      }
    }
  }

  void switchFormState(String state) {
    formKey.currentState.reset();

    if (state == 'register') {
      setState(() {
        _formType = FormType.REGISTER;
        _pageTitle = 'Account Registration';
      });
    } else {
      setState(() {
        _formType = FormType.LOGIN;
        _pageTitle = 'Account Login';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Provider(
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text(_pageTitle),
        ),
        body: Center(
          child: Form(
            key: formKey,
            child: Container(
              padding: EdgeInsets.all(20),
              child: Column(
                children: buildInputs(_formType) +
                    [
                      Padding(
                          padding:
                              EdgeInsets.only(left: 20, right: 20, top: 30),
                          child: Column(children: buildButtons())),
                    ],
              ),
            ),
          ),
        ),
      ),
      builder: (BuildContext context) {},
    );
  }

  _buildLoader() {
    var modal = new Stack(
      children: [
        new Opacity(
          opacity: 0.3,
          child: const ModalBarrier(dismissible: false, color: Colors.grey),
        ),
        new Center(
          child: new CircularProgressIndicator(),
        ),
      ],
    );
    return modal;
  }

  List<Widget> buildInputs(FormType formType) {
    var base = <Widget>[
      TextFormField(
        decoration: InputDecoration(labelText: 'Email'),
        onSaved: (value) => _email = value,
      ),
      TextFormField(
        //validator: PasswordValidator.validate,
        decoration: InputDecoration(labelText: 'Password'),
        obscureText: true,
        onSaved: (value) => _password = value,
      ),
    ];

    if (formType == FormType.REGISTER) {
      base = base +
          <Widget>[
            TextFormField(
              decoration: InputDecoration(labelText: 'First Name'),
              onSaved: (value) => _firstName = value,
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'LastName'),
              onSaved: (value) => _lastName = value,
            )
          ];
    }

    if (_showModal == true) base.add(_buildLoader());
    return base;
  }

  List<Widget> buildButtons() {
    if (_formType == FormType.LOGIN) {
      return [
        RaisedButton(
          key: new Key('login'),
          child: Align(alignment: Alignment.center, child: Text('Login')),
          onPressed: submit,
        ),
        RaisedButton(
          key: new Key('goto-register'),
          child: Align(
              alignment: Alignment.center, child: Text('Register Account')),
          onPressed: () {
            switchFormState('register');
          },
        ),
      ];
    } else {
      return [
        RaisedButton(
          key: new Key('create-account'),
          child:
              Align(alignment: Alignment.center, child: Text('Create Account')),
          onPressed: submit,
        ),
        RaisedButton(
          key: new Key('go-back'),
          child: Align(alignment: Alignment.center, child: Text('Back')),
          onPressed: () {
            switchFormState('login');
          },
        )
      ];
    }
  }
}
