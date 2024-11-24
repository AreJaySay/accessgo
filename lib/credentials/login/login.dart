import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:pass_slip_management/credentials/register/register.dart';
import 'package:pass_slip_management/models/auth.dart';
import 'package:pass_slip_management/screens/landing.dart';
import 'package:pass_slip_management/services/apis/auth.dart';
import 'package:pass_slip_management/utils/palettes.dart';
import 'package:pass_slip_management/utils/snackbars/snackbar_message.dart';

import '../../functions/loaders.dart';
import '../../services/routes.dart';
import '../../widgets/material_button.dart';

class Login extends StatefulWidget {
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final Buttons _buttons = new Buttons();
  final Routes _routes = new Routes();
  final ScreenLoaders _screenLoaders = new ScreenLoaders();
  final SnackbarMessage _snackbarMessage = new SnackbarMessage();
  final TextEditingController _email = new TextEditingController();
  final TextEditingController _pass = new TextEditingController();
  final FocusNode _passFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  String _passCheck = "";
  String _animationType = "idle";
  bool _showPass = true;
  bool _keyboardVisible = false;

  @override
  void initState() {
    _passFocusNode.addListener(() {
      if (_passFocusNode.hasFocus) {
        setState(() {
          _animationType = 'hands_up';
        });
      } else {
        setState(() {
          _animationType = 'hands_down';
        });
      }
    });
    KeyboardVisibilityController().onChange.listen((event) {
      Future.delayed(Duration(milliseconds:  100), () {
        setState(() {
          _keyboardVisible = event;
        });
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _email.dispose();
    _pass.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: (){
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          body: Column(
            children: <Widget>[
              Expanded(
                flex: _keyboardVisible ? 3 : 6,
                child: Stack(
                  children: [
                    _keyboardVisible ?
                    SizedBox() :
                    Padding(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("LOGIN TO YOUR \nACCOUNT!",style: TextStyle(fontFamily: "extrabold",fontSize: 20,color: palettes.darkblue),),
                          Text("Enter your email and passwod for verification.",style: TextStyle(fontFamily: "regular",color: Colors.grey.shade700),),
                        ],
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 20,vertical: 30),
                    ),
                    Padding(
                      child: FlareActor(
                        'assets/Teddy.flr',
                        alignment: Alignment.bottomCenter,
                        animation: _animationType,
                        callback: (animation) {
                          setState(() {
                            _animationType = 'idle';
                          });
                        },
                      ),
                        padding: EdgeInsets.zero
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 9,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20,vertical: _keyboardVisible ? 20 : 30),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30)
                    ),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 2,
                        blurRadius: 1,
                        offset: Offset(0, 0), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      TextField(
                        style: TextStyle(fontFamily: "regular"),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Email",
                          contentPadding: EdgeInsets.all(20),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                              borderRadius: BorderRadius.circular(10)
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: palettes.darkblue),
                              borderRadius: BorderRadius.circular(10)
                          ),
                        ),
                        controller: _email,
                        focusNode: _emailFocusNode,
                        onChanged: (text){
                          setState(() {
                            _animationType = "test";
                          });
                        },
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      TextField(
                        obscureText: _showPass,
                        style: TextStyle(fontFamily: "regular"),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Password",
                          contentPadding: EdgeInsets.all(20),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                              borderRadius: BorderRadius.circular(10)
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: palettes.darkblue),
                              borderRadius: BorderRadius.circular(10)
                          ),
                          suffixIcon: _passCheck == "" ? SizedBox() : IconButton(
                            icon: _showPass ? Icon(Icons.visibility,color: palettes.darkblue,) : Icon(Icons.visibility_off,color: palettes.darkblue),
                            onPressed: (){
                              setState(() {
                                _showPass = !_showPass;
                              });
                            },
                          )
                        ),
                        controller: _pass,
                        focusNode: _passFocusNode,
                        onChanged: (text){
                          setState(() {
                            _passCheck = text;
                          });
                        },
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          child: Text("Forgot password?",style: TextStyle(fontFamily: "semibold",color: palettes.blue),),
                          onPressed: (){},
                        ),
                      ),
                      Spacer(),
                      _buttons.button(text: "Sign in", ontap: (){
                        setState(() {
                          if(_email.text.isEmpty){
                            _snackbarMessage.snackbarMessage(context, message: "Email is required." ,is_error: true);
                          }else if(_pass.text.isEmpty){
                            _snackbarMessage.snackbarMessage(context, message: "Password is required." ,is_error: true);
                          }else{
                            FocusScope.of(context).unfocus();
                            if (_animationType == 'hands_up') {
                              _animationType = 'hands_down';
                            }
                            _screenLoaders.functionLoader(context);
                            authServices.login(context, email: _email.text, pass: _pass.text);
                          }
                        });
                      }, isValidate: true, radius: 1000),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text("Don't have an account?",style: TextStyle(fontFamily: "regular"),),
                          TextButton(
                            onPressed: (){
                              _routes.navigator_pushreplacement(context, Register());
                            },
                            child: Text("Sign up",style: TextStyle(color: palettes.darkblue,fontFamily: "semibold"),),
                          )
                        ],
                      ),
                      SizedBox(
                        height: _keyboardVisible ? 0 : 20,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}