import 'package:flutter/material.dart';
import './app.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(SafeArea(child:const HealthApp()));
}
