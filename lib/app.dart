import 'package:flutter/material.dart';
import 'package:study/model/user.dart';
import 'package:study/model/userFB.dart';
import 'package:study/services/auth.dart';
import 'package:provider/provider.dart';
import 'package:study/screens/wrapper.dart';
import 'style.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamProvider<UserFB?>.value(
      value: AuthService().user,
      initialData: null,
      catchError: (_, __) => null,
      child: MaterialApp(
        home: Wrapper(),
      ),
    );
  }
}
