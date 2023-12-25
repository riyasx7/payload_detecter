import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:payload_detecter/Navigation/naviagtorMaintance.dart';

import 'package:payload_detecter/Navigation/navigatorPage.dart';
import 'package:payload_detecter/Providers/LoginProvider.dart';
import 'package:payload_detecter/Providers/controller.dart';

import 'package:payload_detecter/Providers/wagonController.dart';

import 'package:payload_detecter/webapp.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: webapp.apiKey,
            appId: webapp.appId,
            messagingSenderId: webapp.messagingSenderId,
            projectId: webapp.projectId,
            measurementId: webapp.measurementId,
            storageBucket: webapp.storageBucket,
            authDomain: webapp.authDomainId));
  } else {
    try {
      await Firebase.initializeApp();
    } catch (e) {
      print("Firebase initialization error: $e");
    }
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Portable Weighing Bridge',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.blue,
      ),
      home: MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (context) => LoginProvider(),
            ),
            ChangeNotifierProvider(
              create: (context) => Controller(),
            ),
            ChangeNotifierProvider(
              create: (context) => wagonController(),
            ),
          ],
          child: NavigatorPage()),
    );
  }
}
