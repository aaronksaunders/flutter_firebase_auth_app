import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_app/components/MessageSnack.dart';
import 'package:firebase_auth_app/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import 'Home.dart';

enum FormType { LOGIN, REGISTER }

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  // state variables
  String _email, _password, _firstName, _lastName;
  String _pageTitle = "Account Login";
  FormType _formType = FormType.LOGIN;
  bool _loading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
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

  void submit(BuildContext context) async {
    if (validate()) {
      try {
        setState(() {
          _loading = true;
        });
        //final auth = Provider.of(context).auth;
        if (_formType == FormType.LOGIN) {
          // Login user using firebase API
          await AuthService().loginUser(email: _email, password: _password);
        } else {
          // Create New User user using firebase API
          await AuthService().createUser(
              email: _email,
              firstName: _firstName,
              lastName: _lastName,
              password: _password);
        }

        setState(() {
          _loading = false;
        });

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              settings: RouteSettings(name: "HomePage"),
              builder: (BuildContext context) => HomePage()),
        );
      } catch (e) {
        MessageSnack().showErrorMessage(
            e,
            _scaffoldKey,
            () => {
                  setState(() {
                    _loading = false;
                  })
                });
      } finally {}
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
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(_pageTitle),
      ),
      body: ModalProgressHUD(
          child: Center(
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
                            child: Column(children: buildButtons(context)))
                      ],
                ),
              ),
            ),
          ),
          inAsyncCall: _loading),
    );
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
      return base +
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
    } else {
      return base;
    }
  }

  List<Widget> buildButtons(BuildContext context) {
    if (_formType == FormType.LOGIN) {
      return [
        RaisedButton(
          key: new Key('login'),
          child: Align(alignment: Alignment.center, child: Text('Login')),
          onPressed: () => submit(context),
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
          onPressed: () => submit(context),
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
