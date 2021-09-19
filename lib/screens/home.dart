import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:study/screens/wrapper.dart';
import 'package:study/services/auth.dart';
import 'dart:async';
import 'package:study/widgets/button_widget.dart';
import 'package:study/widgets/popup_widget.dart';
import 'package:study/screens/profile.dart';

class Home extends StatefulWidget {
  const Home({ Key? key }) : super(key: key);
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  static const countdownDuration = Duration(minutes: 60);
  Duration duration = Duration();
  Timer? timer;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  var firebaseUser = FirebaseAuth.instance.currentUser;
  String? name;
  int? time;
  int? points;

  bool isCountdown = false;

  getSingle() async {
    DocumentSnapshot userdocument = await FirebaseFirestore.instance
        .collection('users')
        .doc(firebaseUser!.uid)
        .get();
    print('${userdocument.data()}');
    name = userdocument['name'];
    time = userdocument['time'];
    points = userdocument['points'];
  }

  @override
  void initState(){
    super.initState();
    getSingle();
    // startTimer();
    reset();
  }

  void reset(){
    if(isCountdown){
      setState(() => duration = countdownDuration);
    }else{
      setState(() => duration = Duration());
    }
  }

  void addTime(){
    final addSeconds = isCountdown? -1 : 1;
    
    setState(() {
      final seconds = duration.inSeconds + addSeconds;

      if (seconds < 0) {
        timer?.cancel();
      } else {
        duration = Duration(seconds: seconds);
      }
      
    });
  }

  void startTimer({bool resets = true}){
    if (resets) {
      reset();
    } 
    
    timer = Timer.periodic(Duration(seconds: 1), (_) => addTime());
  }

  void stopTimer({bool resets = true}){
    if(resets){
      reset();
    }

    setState(() => timer?.cancel());
  }

  

  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text("Your Session"),
      //   centerTitle: true,
      //   backgroundColor: Color.fromRGBO(179, 230, 181, 0.8),
      // ),
      appBar: AppBar(
            title: Text('Your Session'),
            //centerTitle: true,
            leading: IconButton(
              icon: Icon(Icons.person),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => Profile()),);
              },
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.timer),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Home()),);
                },
              ),
              IconButton(
                icon: Icon(Icons.logout),
                onPressed: () async {
                  await _auth.signOut();
                },
              )
            ],
            //backgroundColor: Colors.purple,
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color.fromRGBO(179, 230, 181, 1), Color.fromRGBO(150, 230, 181, 1)],
                  begin: Alignment.bottomRight,
                  end: Alignment.topLeft,
                ),
              ),
            ),
        ),
      backgroundColor: Color.fromRGBO(44, 84, 55, 1),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildTime(),
            const SizedBox(height: 80),
            buildButtons(),
          ],
        ),
      ),
    );
  }

  Widget buildTime(){
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        buildTimeCard(time: hours, header: 'HOURS'),
        const SizedBox(width:8),
        buildTimeCard(time: minutes, header: 'MINUTES'),
        const SizedBox(width:8),
        buildTimeCard(time: seconds, header: 'SECONDS'),
        
      ],

    );

    // return Text(
    //   '$minutes:$seconds',
    //   style: TextStyle(fontSize: 80),
    // );
  }

  Widget buildButtons(){
    final isRunning = timer == null ? false : timer!.isActive;
    final isCompleted = duration.inSeconds == 0;
    return isRunning || !isCompleted
      ? Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ButtonWidget(
              text: isRunning ? 'PAUSE' : 'RESUME',
              onClicked: () {
                if(isRunning){
                  stopTimer(resets: false);
                }else{
                  startTimer(resets: false);
                }
              },
            ),
            const SizedBox(width:12),
            ButtonWidget(
              text: 'END SESSION',
              onClicked: () {
                String twoDigits(int n) => n.toString().padLeft(2, '0');
                String elapsed = twoDigits(duration.inHours) + ":" + twoDigits(duration.inMinutes.remainder(60)) + ":" + twoDigits(duration.inSeconds.remainder(60));
                String message = "You've studied for " + elapsed + "!";
                int elapsedtime = duration.inSeconds;
                int gainedpoints = (duration.inSeconds/2).round();
                var collection = FirebaseFirestore.instance.collection('users');
                collection 
                    .doc(firebaseUser!.uid) 
                    .update({'time' : time!+elapsedtime, 'points': points!+gainedpoints}) 
                    .then((_) => print('Success'))
                    .catchError((error) => print('Failed: $error'));
                showDialog(
                  context: context,
                  builder: (BuildContext context) => PopupWidget(title: 'Session ended.', content: message)
                );
                stopTimer();
              },
            ),
          ],
      )
    : ButtonWidget(
      text: 'START', 
      onClicked: () {
        startTimer();
      },
      );
  }

  Widget buildTimeCard({required String time, required String header}) => 
    Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20)
          ),
          child: Text(
            time,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontSize: 72,
              ),
            ),
          ),
          const SizedBox(height:24),
          Text(header),
        ],
    );
}