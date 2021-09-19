import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:study/screens/wrapper.dart';
import 'package:study/services/auth.dart';
// import 'package:study/utils/user_preferences.dart';
import 'package:study/model/user.dart';
import 'dart:async';
import 'package:study/screens/home.dart';
import 'package:study/widgets/countup_widget.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  var firebaseUser = FirebaseAuth.instance.currentUser;
  final firestoreInstance = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? name;
  int? time;
  int? points;
  String? email;

  getSingle() async {
    DocumentSnapshot userdocument = await FirebaseFirestore.instance
        .collection('users')
        .doc(firebaseUser!.uid)
        .get();
    print('${userdocument.data()}');
    name = userdocument['name'];
    time = userdocument['time'];
    points = userdocument['points'];
    setState(() {
      this.name = name;
      this.time = time;
      this.points = points;
    });
  }

  @override
  void initState() {
    super.initState();
    getSingle();
    // getEmail();
  }

  @override
  Widget build(BuildContext context) {
    // final user = UserPreferences.myUser;

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Profile'),
        //centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.person),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Profile()),
            );
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.timer),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => Home()),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await _auth.signOut().then((res) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => Wrapper()),
                );
              });
            },
          )
        ],
        //backgroundColor: Colors.purple,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromRGBO(179, 230, 181, 1),
                Color.fromRGBO(150, 230, 181, 1)
              ],
              begin: Alignment.bottomRight,
              end: Alignment.topLeft,
            ),
          ),
        ),
      ),
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: [
          const SizedBox(height: 100),
          buildName(),
          const SizedBox(height: 40),
          buildPoints(),
        ],
      ),
    );
  }

  Widget buildName() => Column(
        children: [
          Text(
            name ?? 'username',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 48),
          ),
          const SizedBox(height: 4),
          Text(
            email ?? '',
            style: TextStyle(color: Colors.grey),
          )
        ],
      );

  Widget buildPoints() => Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Total time studied: ",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              ),
              Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(20)),
                  child: Countup(
                    begin: 0,
                    end: time?.toDouble() ?? 0,
                    duration: Duration(seconds: 3),
                    separator: ',',
                    style: TextStyle(fontSize: 24, color: Colors.white),
                  )),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Total points: ",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              ),
              Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(20)),
                  child: Countup(
                    begin: 0,
                    end: points?.toDouble() ?? 0,
                    duration: Duration(seconds: 3),
                    separator: ',',
                    style: TextStyle(fontSize: 24, color: Colors.white),
                  )),
            ],
          ),
        ],
      );
}
