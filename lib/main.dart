import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth_app/model/Item.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
//final FirebaseApp _app = FirebaseApp.instance;
//final Firestore firestore = Firestore(app: _app);

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: MyHomePage(title: 'Flutter Firebase Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // helper to make sure we are logged on before rendering the UI
  Future<FirebaseUser> checkUser() async {
    try {
      var user = await _auth.signInWithEmailAndPassword(
          email: 'bs@mail.com', password: 'password');
      print(" Current User $user");
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: new FutureBuilder<FirebaseUser>(
        future: checkUser(), // a Future<User> or null
        builder: (BuildContext context, AsyncSnapshot<FirebaseUser> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return ItemsList(firestore: Firestore.instance);
            default:
              return LoadingCircle();
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {},
        tooltip: 'Add Item',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class LoadingCircle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: CircularProgressIndicator(),
        alignment: Alignment(0.0, 0.0),
      ),
    );
  }
}

class ItemsList extends StatelessWidget {
  ItemsList({this.firestore});

  final Firestore firestore;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Item.getSnapshot(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) return LoadingCircle();

        final itemDocs = snapshot.data.documents;

        return ListView.builder(
          itemCount: itemDocs.length,
          itemBuilder: (_, int index) {
            final Item item = Item.fromFirebase(itemDocs[index]);
            return ListTile(
              title: Text(item.subject ?? '<No message retrieved>'),
              subtitle: Text('Due Date ${item.dueDate}'),
            );
          },
        );
      },
    );
  }
}
