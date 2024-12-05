import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pass_slip_management/models/auth.dart';
import 'package:pass_slip_management/screens/landing.dart';
import 'package:pass_slip_management/services/geolocator.dart';
import 'package:pass_slip_management/utils/palettes.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../services/routes.dart';
import '../../widgets/material_button.dart';

class SuccessScan extends StatefulWidget {
  final String date;
  final int timer;
  SuccessScan({required this.date, this.timer = 180});
  @override
  State<SuccessScan> createState() => _SuccessScanState();
}

class _SuccessScanState extends State<SuccessScan> with TickerProviderStateMixin {
  AnimationController? _controller;
  Timer? timer;

  Future _getLocation()async{
   await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high)
        .then((position) {
      DatabaseReference ref = FirebaseDatabase.instance.ref("locations");
      FirebaseDatabase.instance.ref().child('locations').orderByChild("email").equalTo(authModel.loggedUser!["email"]).onChildAdded.forEach((event){
        ref.update({
          "${event.snapshot.key!}/latitude": "${position.latitude}",
          "${event.snapshot.key!}/longitude": "${position.longitude}",
        });
      });
    });
  }

  @override
  void dispose() {
    _controller!.dispose();
    timer?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    timer = Timer.periodic(Duration(seconds: 30), (Timer t) => _getLocation());
    _controller = AnimationController(
        vsync: this,
        duration: Duration(
            seconds:
            widget.timer)
    );
    _controller!.forward();

    if(widget.date != ""){
      Future.delayed(const Duration(milliseconds: 0), () {
        DatabaseReference ref = FirebaseDatabase.instance.ref("requests");
        FirebaseDatabase.instance.ref().child('requests').orderByChild("date").equalTo(widget.date).onChildAdded.forEach((event)async{
          await ref.update({
            "${event.snapshot.key!}/expiration": "${DateTime.now().add(Duration(minutes: 3))}",
          });
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Countdown(
            data: widget.date,
            animation: StepTween(
              begin: widget.timer, // THIS IS A USER ENTERED NUMBER
              end: 0,
            ).animate(_controller!),
          ),
        ),
      ),
    );
  }
}

class Countdown extends AnimatedWidget {
  Countdown({this.animation, this.data}) : super(listenable: animation!);
  final Buttons _buttons = new Buttons();
  final Routes _routes = new Routes();
  Animation<int>? animation;
  String? data;
  bool isUpdate = false;

  Future _saveTimer()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('timer', "${animation!.value}");
  }

  @override
  build(BuildContext context) {
    Duration clockTimer = Duration(seconds: animation!.value);

    String timerText = '${clockTimer.inMinutes.remainder(60).toString()}:${clockTimer.inSeconds.remainder(60).toString().padLeft(2, '0')}';

    if(timerText == "0:00"){
      if(!isUpdate){
        DatabaseReference ref = FirebaseDatabase.instance.ref("requests");
        FirebaseDatabase.instance.ref().child('requests').orderByChild("date").equalTo(data).onChildAdded.forEach((event)async{
          await ref.update({
            "${event.snapshot.key!}/status": "Expired",
          });
          isUpdate = true;
        });
        FirebaseDatabase.instance.ref().child('locations').orderByChild("email").equalTo(authModel.loggedUser!["email"]).onChildAdded.forEach((event)async{
          DatabaseReference ref = FirebaseDatabase.instance.ref("locations/${event.snapshot.key!}");
          await ref.remove();
        });
      }
    }

    _saveTimer();

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          children: [
            timerText == "0:00" ?
            Image(
              width: 170,
              color: Colors.redAccent,
              image: NetworkImage("https://static.thenounproject.com/png/1241405-200.png"),
            ) :
            Image(
              width: 150,
              image: NetworkImage("https://www.qrcode-tiger.com/static/img/Components/Icon/png/approved.png"),
            ),
            SizedBox(
              height: 20,
            ),
            Text(timerText == "0:00" ? "YOUR QR CODE HAS ALREADY BEEN EXPIRED!" : "YOUR QR CODE SUCCESSFULLY \nSCAN!",style: TextStyle(color: palettes.blue,fontFamily: "bold",fontSize: 18),textAlign: TextAlign.center,),
          ],
        ),
        Column(
          children: [
            Text("You're pass slip will expire in",style: TextStyle(fontFamily: "semibold"),),
            Text(
              "$timerText",
              style: TextStyle(
                fontSize: 120,
                color: palettes.darkblue,
              ),
            ),
            Text("It cannot be used again after the timer end.",style: TextStyle(fontFamily: "semibold"),),
          ],
        ),
        SizedBox(),
        _buttons.button(text: "Go to home", ontap: (){
          if(timerText == "0:00"){
            _routes.navigator_pushreplacement(context, Landing(), transitionType: PageTransitionType.fade);
          }
        }, isValidate: timerText == "0:00", radius: 1000),
        SizedBox(),
        SizedBox(),
      ],
    );
  }
}