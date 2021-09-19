import 'package:flutter/material.dart';

class PopupWidget extends StatelessWidget {
  final String title;
  final String content;
  final List<Widget> actions;

  PopupWidget({
    Key? key,
    required this.title,
    required this.content,
    this.actions = const [],
  }):super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        this.title,
        style: Theme.of(context).textTheme.headline3,
      ),
      actions: this.actions,
      content: Text(
        this.content,
        style: Theme.of(context).textTheme.bodyText1,
      ),
    );
  }
}