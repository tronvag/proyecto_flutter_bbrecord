import 'package:flutter/material.dart';
import 'LoginScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


void main() => runApp(new MyApp());

class MyApp extends StatelessWidget { 
 @override
 Widget build(BuildContext context) {
 return new MaterialApp(
 title: 'BBrecord',
 theme: new ThemeData( 
 primarySwatch: Colors.lightBlue,
 ),
 home: new LoginScreen(),
 );
 }
}