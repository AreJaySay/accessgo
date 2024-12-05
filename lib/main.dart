import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pass_slip_management/credentials/welcome.dart';
import 'package:pass_slip_management/models/location.dart';
import 'package:pass_slip_management/screens/home/success_scan.dart';
import 'package:pass_slip_management/services/apis/auth.dart';
import 'package:pass_slip_management/services/geolocator.dart';
import 'package:pass_slip_management/services/routes.dart';
import 'package:pass_slip_management/utils/palettes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer = FirebaseAnalyticsObserver(analytics: analytics);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      title: "Access Go",
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final Routes _routes = new Routes();

  @override
  void initState() {
    // TODO: implement initState
    geolocatorServices.requestPermission().then((value)async{
      setState(() {
        locationModel.latitude = "${value.latitude}";
        locationModel.longitude = "${value.longitude}";
      });
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var email = prefs.getString('email');
      var pass = prefs.getString('password');
      int timer = prefs.getString('timer') == null ? 0 : int.parse(prefs.getString('timer')!);
      if(email == null && pass == null){
        _routes.navigator_pushreplacement(context, Welcome());
      }else{
        authServices.login(context, email: email!, pass: pass!, isManuall: false, timer: timer);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image(
              width: 350,
              image: AssetImage("assets/logos/accessgo.png"),
            ),
            CircularProgressIndicator(color: palettes.blue,)
          ],
        ),
      ),
    );
  }
}
