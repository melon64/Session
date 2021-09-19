import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:firebase_database/firebase_database.dart';

class UserList extends StatefulWidget {
  const UserList({Key? key}) : super(key: key);

  @override
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  var firebaseUser = FirebaseAuth.instance.currentUser;
  final firestoreInstance = FirebaseFirestore.instance;
  String? name;
  int? time;

  getSingle() async {
    DocumentSnapshot userdocument = await FirebaseFirestore.instance
        .collection('users')
        .doc(firebaseUser!.uid)
        .get();
    // print('${userdocument.data()}');
    name = userdocument['name'];
    time = userdocument['time'];
  }

  @override
  void initState() {
    super.initState();
    getSingle();
  }

  @override
  Widget build(BuildContext context) {
    // var userInfo = getSingle();
    return Scaffold(
      // appBar: AppBar(
      //   title: Text("${user?.email ?? ''}"),
      // ),
      body: Container(
        child: Text(name ?? ''),
      ),
    );
  }
}
