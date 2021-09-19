import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:study/model/user.dart';

class DatabaseService {
  final String? uid;
  DatabaseService({this.uid});

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  Future<void> updateUserData(String name, int time, int points) async {
    return await userCollection.doc(uid).set({
      'name': name,
      'time': time,
      'points': points,
    });
  }

  List<UserData> _userData(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return UserData(
          name: doc['name'] ?? '',
          email: doc['email'] ?? '',
          time: doc['time'] ?? 0,
          points: doc['points'] ?? 0);
    }).toList();
  }

  Stream<List<UserData>> get users {
    return userCollection.snapshots().map(_userData);
  }
}
