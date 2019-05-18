// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:firebase_auth_app/screens/Login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget buildTestableWidget(Widget widget) {
  // https://docs.flutter.io/flutter/widgets/MediaQuery-class.html
  return new MediaQuery(
      data: new MediaQueryData(), child: new MaterialApp(home: widget));
}

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // create a LoginPage
    LoginPage loginPage = new LoginPage();
    // add it to the widget tester
    await tester.pumpWidget(buildTestableWidget(loginPage));

    // tap on the login button
    Finder loginButton = find.byKey(Key('login'));
    expect(loginButton, findsOneWidget);
    await tester.tap(loginButton);

    // Verify that our error message is displayed.
await tester.pump(new Duration(milliseconds: 1000));
    await tester.pump();
    expect(find.text('The password is invalid or the user does not have a password.'), findsOneWidget, reason:'no error text found');

    await tester.pump();
    // expect(errorText.toString().contains('invalid'), true);
  });
}
