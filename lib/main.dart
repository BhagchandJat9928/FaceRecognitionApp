import 'package:camera/camera.dart';
import 'package:demoproject/FaceRecognition.dart';
import 'package:demoproject/home.dart';
import 'package:flutter/material.dart';
import 'package:path_provider_ex/path_provider_ex.dart';

List<CameraDescription> cameras = [];
List<StorageInfo> storages = [];

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  storages = await PathProviderEx.getStorageInfo();
  print(storages.length);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Colors.red,
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: FaceRecognition(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    );
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 5), () {
      Navigator.of(context).push(PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => const Home(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, 1.0);
          const end = Offset.zero;
          final tween = Tween(begin: begin, end: end);

          const curves = Curves.fastOutSlowIn;
          final curvedAnimation =
              CurvedAnimation(parent: animation, curve: curves);
          return SlideTransition(
            position: tween.animate(curvedAnimation),
            child: child,
          );
        },
      ));
    });

    return Container(
      color: Colors.lightBlueAccent,
      child: Center(
        child: AnimatedIcon(
          icon: AnimatedIcons.home_menu,
          color: Colors.purple,
          progress: controller,
        ),
      ),
    );
  }
}
