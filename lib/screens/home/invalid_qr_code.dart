import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pass_slip_management/services/routes.dart';

import '../../widgets/material_button.dart';
import '../landing.dart';

class InvalidQrCode extends StatefulWidget {
  @override
  State<InvalidQrCode> createState() => _InvalidQrCodeState();
}

class _InvalidQrCodeState extends State<InvalidQrCode> {
  final Buttons _buttons = new Buttons();
  final Routes _routes = new Routes();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image(
                width: 150,
                color: Colors.grey,
                image: AssetImage("assets/icons/invalid_qr.png"),
              ),
              SizedBox(
                height: 30,
              ),
              Text("INVALID QR CODE",style: TextStyle(color: Colors.grey,fontFamily: "bold"),),
              SizedBox(
                height: 5,
              ),
              Text("Please use a valid qr code and try to scan again.",style: TextStyle(color: Colors.grey,fontFamily: "regular"),),
              SizedBox(
                height: 70,
              ),
              _buttons.button(text: "Go home", ontap: (){
                _routes.navigator_pushreplacement(context, Landing(), transitionType: PageTransitionType.fade);
              }, isValidate: true, radius: 1000),
            ],
          ),
        ),
      ),
    );
  }
}
