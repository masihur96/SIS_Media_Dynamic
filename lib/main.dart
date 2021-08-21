import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:provider/provider.dart';
import 'package:sis_media_admin_pannel_dynamic/database/provider/public_provider.dart';
import 'package:sis_media_admin_pannel_dynamic/pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await firebase_core.Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => PublicProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'FirebaseApp',
        theme: ThemeData(
            primarySwatch: Colors.yellow, backgroundColor: Colors.white),
        home: HomePage(),
      ),
    );
  }
}
