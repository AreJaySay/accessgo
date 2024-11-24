import 'package:flutter/material.dart';
import 'package:pass_slip_management/credentials/login/login.dart';
import 'package:pass_slip_management/credentials/register/register.dart';
import 'package:pass_slip_management/services/routes.dart';
import 'package:pass_slip_management/utils/palettes.dart';
import 'package:pass_slip_management/widgets/material_button.dart';
import 'package:pass_slip_management/widgets/powered_by.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class Welcome extends StatefulWidget {
  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  final Buttons _buttons = new Buttons();
  final Routes _routes = new Routes();
  bool _animateLogo = false;
  bool _showText = false;
  bool _showButtons = false;
  bool _showPowered = false;

  @override
  void initState() {
    // TODO: implement initState
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _animateLogo = true;
      });
    });
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        _showText = true;
      });
    });
    Future.delayed(const Duration(seconds: 4), () {
      setState(() {
        _showButtons = true;
      });
    });
    Future.delayed(const Duration(seconds: 5), () {
      setState(() {
        _showPowered = true;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            children: [
              AnimatedContainer(
                width: 350,
                duration: Duration (seconds: 1),
                margin: EdgeInsets.only(top: _animateLogo ? 30 : 250),
                child: Image(
                  width: 350,
                  image: AssetImage("assets/logos/accessgo.png"),
                ),
              ),
              AnimatedOpacity(
                opacity: _showText ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 500),
                child: Column(
                  children: [
                    Text("WELCOME BACK",style: TextStyle(fontFamily: "bold",fontSize: 22,color: palettes.darkblue),),
                    Text("We are glad to see you again!",style: TextStyle(fontFamily: "regular",fontSize: 16,color: palettes.darkblue),),
                  ],
                ),
              ),
              SizedBox(
                height: 40,
              ),
              AnimatedOpacity(
                opacity: _showButtons ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 500),
                child: Column(
                  children: [
                    ZoomTapAnimation(
                        end: 0.99,
                        child: Container(
                          width: double.infinity,
                          height: 55,
                          decoration:BoxDecoration(
                              border: Border.all(color: palettes.darkblue,width: 2),
                              borderRadius: BorderRadius.circular(1000)
                          ),
                          child: Center(child: Text("Sign in",style: TextStyle(color: palettes.darkblue,fontFamily: "semibold",fontSize: 16),)),
                        ),
                        onTap:(){
                          _routes.navigator_push(context, Login());
                        }
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    _buttons.button(text: "Sign up", ontap: (){
                      _routes.navigator_push(context, Register());
                    }, isValidate: true, radius: 1000),
                  ],
                ),
              ),
              Spacer(),
              AnimatedOpacity(
                opacity: _showPowered ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 500),
                child: Column(
                  children: [
                    PoweredBy(),
                    SizedBox(
                      height: 30,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
