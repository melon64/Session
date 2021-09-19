import 'package:flutter/material.dart';
import 'package:study/model/user.dart';
import 'package:study/model/userFB.dart';
import 'package:study/screens/authenticate/authenticate.dart';
import 'package:study/screens/home.dart';
import 'package:provider/provider.dart';
import 'package:study/screens/profile.dart';
import 'package:study/utils/user_preferences.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserFB?>(context);

    if (user == null) {
      return Authenticate();
    } else {
      return Home();
    }
  }
}
