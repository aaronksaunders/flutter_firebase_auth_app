import 'package:flutter/material.dart';

class MessageSnack {
  void showInfoMessage(_message, _scaffoldKey, [void Function() _onClose]) {
    _showMessage(_message, false, _scaffoldKey, _onClose);
  }

  void showErrorMessage(_error, _scaffoldKey, [void Function() _onClose]) {
    _showMessage(_error.message, true, _scaffoldKey, _onClose);
  }

  void _showMessage(_message, _isError, _scaffoldKey,
      [void Function() _onClose]) {
    // if one is open, close it
    _scaffoldKey.currentState
        .hideCurrentSnackBar(reason: SnackBarClosedReason.action);

    SnackBar snackBar = SnackBar(
      key: new Key('error_Snackbar'),
      content: Text(_message, key: new Key('error_message')),
      duration: Duration(seconds: 5),
      backgroundColor: _isError ? Colors.redAccent : Colors.grey,
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
      if (_onClose != null) _onClose();
    });
  }
}
