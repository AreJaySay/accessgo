import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:pass_slip_management/credentials/login/login.dart';
import 'package:pass_slip_management/functions/loaders.dart';
import 'package:pass_slip_management/models/register.dart';
import 'package:pass_slip_management/services/apis/auth.dart';
import 'package:pass_slip_management/services/network.dart';
import 'package:http/http.dart' as http;
import '../../services/routes.dart';
import '../../utils/palettes.dart';
import '../../utils/snackbars/snackbar_message.dart';
import '../../widgets/material_button.dart';

class Register extends StatefulWidget {
  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final Buttons _buttons = new Buttons();
  final ScreenLoaders _screenLoaders = new ScreenLoaders();
  final Routes _routes = new Routes();
  final SnackbarMessage _snackbarMessage = new SnackbarMessage();
  final TextEditingController _fname = new TextEditingController();
  final TextEditingController _lname = new TextEditingController();
  final TextEditingController _email = new TextEditingController();
  final TextEditingController _phone = new TextEditingController();
  final TextEditingController _address = new TextEditingController();
  final TextEditingController _confirm = new TextEditingController();
  final TextEditingController _pass = new TextEditingController();
  bool _showPass = true;
  String _passCheck = "";
  bool _showConfirmPass = true;
  String _passConfirmCheck = "";
  bool _keyboardVisible = false;
  String? gender;
  final List<String> _genderChoice = [
    "Male",
    "Female",
  ];
  List? _users;

  Future checkUserExist()async{
    try{
      final url = Uri.parse('${networkUtils.networkUtils}/users.json');
      await http.get(
        url,
      ).then((data)async{
        var respo = json.decode(data.body);
        if(data.statusCode == 200){
          print(respo.values);
          setState(() {
            _users = respo.values.toList();
          });
        }
      });
    }catch(e){
      print("ERROR CHECK $e");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    checkUserExist();
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
    _fname.dispose();
    _lname.dispose();
    _phone.dispose();
    _email.dispose();
    _address.dispose();
    _pass.dispose();
    _confirm.dispose();
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
          body: ListView(
            children: <Widget>[
              Padding(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("CREATE YOUR \nACCOUNT!",style: TextStyle(fontFamily: "extrabold",fontSize: 20,color: palettes.darkblue),),
                    Text("Please enter your correct and exact details.",style: TextStyle(fontFamily: "regular",color: Colors.grey.shade700),),
                  ],
                ),
                padding: EdgeInsets.symmetric(horizontal: 20,vertical: 30),
              ),
              Container(
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
                      decoration: _decoration(hint: "Firstname"),
                      controller: _fname,
                      onChanged: (text){
                        setState(() {
                          registerModel.fname = text;
                        });
                      },
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    TextField(
                      style: TextStyle(fontFamily: "regular"),
                      decoration: _decoration(hint: "Lastname"),
                      controller: _lname,
                      onChanged: (text){
                        setState(() {
                          registerModel.lname = text;
                        });
                      },
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    TextField(
                      style: TextStyle(fontFamily: "regular"),
                      decoration: _decoration(hint: "Email"),
                      controller: _email,
                      onChanged: (text){
                        setState(() {
                          registerModel.email = text;
                        });
                      },
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    TextField(
                      style: TextStyle(fontFamily: "regular"),
                      decoration: _decoration(hint: "Phone number"),
                      keyboardType: TextInputType.number,
                      maxLength: 11,
                      controller: _phone,
                      onChanged: (text){
                        setState(() {
                          registerModel.phone = text;
                        });
                      },
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Container(
                      height: 65,
                      padding: EdgeInsets.only(left: 18,right: 10),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10)
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          iconEnabledColor: palettes.darkblue,
                          iconDisabledColor: Colors.grey.shade300,
                          icon: const Icon(Icons.arrow_drop_down),
                          isExpanded: true,
                          dropdownColor: Colors.white,
                          value: gender,
                          hint: Text(
                            "Gender",
                            style: TextStyle(fontFamily: "regular",color: Colors.grey.shade800),
                          ),
                          items: _genderChoice
                              .map(
                                (e) => DropdownMenuItem<String>(
                              value: e,
                              child: Text(
                                e,
                                style: TextStyle(
                                   fontFamily: "regular"
                                ),
                              ),
                            ),
                          )
                              .toList(),
                          onChanged: (String? value) {
                            setState(() {
                              gender = value;
                              registerModel.gender = value!;
                            });
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    TextField(
                      style: TextStyle(fontFamily: "regular"),
                      decoration: _decoration(hint: "Address"),
                      controller: _address,
                      onChanged: (text){
                        setState(() {
                          registerModel.address = text;
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
                      onChanged: (text){
                        setState(() {
                          _passCheck = text;
                          registerModel.password = text;
                        });
                      },
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    TextField(
                      obscureText: _showConfirmPass,
                      style: TextStyle(fontFamily: "regular"),
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Confirm password",
                          contentPadding: EdgeInsets.all(20),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                              borderRadius: BorderRadius.circular(10)
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: palettes.darkblue),
                              borderRadius: BorderRadius.circular(10)
                          ),
                          suffixIcon: _passConfirmCheck == "" ? SizedBox() : IconButton(
                            icon: _showConfirmPass ? Icon(Icons.visibility,color: palettes.darkblue,) : Icon(Icons.visibility_off,color: palettes.darkblue),
                            onPressed: (){
                              setState(() {
                                _showConfirmPass = !_showConfirmPass;
                              });
                            },
                          )
                      ),
                      controller: _confirm,
                      onChanged: (text){
                        setState(() {
                          _passConfirmCheck = text;
                        });
                      },
                    ),
                    SizedBox(
                      height: 70,
                    ),
                    _buttons.button(text: "Sign up", ontap: (){
                      setState(() {
                        if(_fname.text.isEmpty || _lname.text.isEmpty || _email.text.isEmpty || _phone.text.isEmpty || gender == null || _address.text.isEmpty || _pass.text.isEmpty || _confirm.text.isEmpty){
                          _snackbarMessage.snackbarMessage(context, message: "All field is required." ,is_error: true);
                        }else if(!_email.text.contains("@")){
                          _snackbarMessage.snackbarMessage(context, message: "Enter a valid email address." ,is_error: true);
                        }
                        // else if(_users != null){
                        //   if(_users!.where((s) => s["email"] == _email.text).toList().isNotEmpty){
                        //     print("EXIST");
                        //     _snackbarMessage.snackbarMessage(context, message: "Email address already been used." ,is_error: true);
                        //   }
                        // }
                        else{
                          FocusScope.of(context).unfocus();
                          _screenLoaders.functionLoader(context);
                          authServices.register().whenComplete((){
                            Navigator.of(context).pop(null);
                            _routes.navigator_pushreplacement(context, Login());
                          });
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
                        Text("Already have an account?",style: TextStyle(fontFamily: "regular"),),
                        TextButton(
                          onPressed: (){
                            _routes.navigator_pushreplacement(context, Login());
                          },
                          child: Text("Sign in",style: TextStyle(color: palettes.darkblue,fontFamily: "semibold"),),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  InputDecoration _decoration({required String hint}){
    return InputDecoration(
      counterText: "",
      border: InputBorder.none,
      hintText: hint,
      hintStyle: TextStyle(fontFamily: "regular"),
      contentPadding: EdgeInsets.all(20),
      enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.circular(10)
      ),
      focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: palettes.darkblue),
          borderRadius: BorderRadius.circular(10)
      ),
    );
  }
}
