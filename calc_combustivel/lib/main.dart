import 'package:calccombustivel/widgets/loading-button.widget.dart';
import 'package:calccombustivel/widgets/submit-form.dart';
import 'package:calccombustivel/widgets/sucess.widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'widgets/logo.widget.dart';
import 'widgets/input.widget.dart';
import 'package:calccombustivel/admob_flutter.dart';
import 'page/home.page.dart';


void main() {
  runApp(MyApp());

}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Alcool ou Gasolina',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(),
    );
  }
}



