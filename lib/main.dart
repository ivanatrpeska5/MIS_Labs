import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mis_labs/page/home_page.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'domain/notifications.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Notifications.init();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Lab3 201090',
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        initialRoute: HomePage.id,
        routes: {
          HomePage.id: (context) => HomePage(),
          // LoginPage.id: (context) => const LoginPage(),
          // RegisterPage.id: (context) => const RegisterPage(),
        });
  }
}