import 'package:flutter/material.dart';
import 'package:snap_todo/widgets/List_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:splashscreen/splashscreen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SnapTodo',
      home: ShowSplash(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class ShowSplash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 3,
      navigateAfterSeconds: new ListGrid(),
      title: new Text(
        'SnapTodo',
        textScaleFactor: 2,
        style: TextStyle(fontWeight: FontWeight.w800),
      ),
      image: new Image.asset('assets/brand_logo.png'),
      loadingText: Text("Loading"),
      photoSize: 100.0,
      loaderColor: Colors.black,
    );
  }
}
