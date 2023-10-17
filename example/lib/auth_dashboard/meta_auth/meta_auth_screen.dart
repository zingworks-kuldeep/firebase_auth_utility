import 'package:flutter/material.dart';

class MetaAuthScreen extends StatefulWidget {
  const MetaAuthScreen({Key? key}) : super(key: key);

  @override
  State<MetaAuthScreen> createState() => _MetaAuthScreenState();
}

class _MetaAuthScreenState extends State<MetaAuthScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Meta Auth')),
      body: Center(
          child: Column(
        children: [],
      )),
    );
  }
}
