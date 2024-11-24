import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pass_slip_management/functions/loaders.dart';
import 'package:pass_slip_management/functions/logout.dart';
import 'package:pass_slip_management/models/auth.dart';
import 'package:pass_slip_management/models/register.dart';
import 'package:pass_slip_management/services/apis/auth.dart';
import 'package:pass_slip_management/utils/palettes.dart';
import 'package:path/path.dart' as p;
import '../../functions/image_picker.dart';
import '../../utils/snackbars/snackbar_message.dart';
import '../../widgets/material_button.dart';

class Profile extends StatefulWidget {
  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final Buttons _buttons = new Buttons();
  ImagePicker imagePicker = ImagePicker();
  final ScreenLoaders _screenLoaders = new ScreenLoaders();
  final SnackbarMessage _snackbarMessage = new SnackbarMessage();
  final TextEditingController _fname = new TextEditingController();
  final TextEditingController _lname = new TextEditingController();
  final TextEditingController _email = new TextEditingController();
  final TextEditingController _phone = new TextEditingController();
  final TextEditingController _address = new TextEditingController();
  bool _keyboardVisible = false;
  String? gender;
  final List<String> _genderChoice = [
    "Male",
    "Female",
  ];
  File? _file;
  String? imageUrl;

  Future upload({required File file}) async {
    // UPLOAD CLOUD STORAGE
    var imageFile = File(file.path);
    String fileName = p.basename(imageFile.path);
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference ref =
    storage.ref().child("profile");

    // GET URL
    UploadTask uploadTask = ref.putFile(imageFile);
    await uploadTask.whenComplete(() async {
      var url = await ref.getDownloadURL();
      print("URL$url");
    }).catchError((onError) {
      print("ERROR URL $onError");
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    KeyboardVisibilityController().onChange.listen((event) {
      Future.delayed(Duration(milliseconds:  100), () {
        setState(() {
          _keyboardVisible = event;
        });
      });
    });
    _fname.text = authModel.loggedUser!["firstname"];
    _lname.text = authModel.loggedUser!["lastname"];
    _email.text = authModel.loggedUser!["email"];
    _phone.text = authModel.loggedUser!["phone number"];
    gender = authModel.loggedUser!["gender"];
    _address.text = authModel.loggedUser!["address"];
    registerModel.fname = authModel.loggedUser!["firstname"];
    registerModel.lname = authModel.loggedUser!["lastname"];
    registerModel.email = authModel.loggedUser!["email"];
    registerModel.phone = authModel.loggedUser!["phone number"];
    registerModel.gender = authModel.loggedUser!["gender"];
    registerModel.address = authModel.loggedUser!["address"];
    registerModel.password = authModel.loggedUser!["password"];
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: palettes.darkblue,
        automaticallyImplyLeading: false,
        centerTitle: true,
        elevation: 1,
        shadowColor: Colors.grey.shade50,
        title: Text("Profile",style: TextStyle(fontFamily: "bold",fontSize: 17),),
        actions:[
          IconButton(
            icon: Icon(Icons.check),
            onPressed:()async{
              _screenLoaders.functionLoader(context);
              DatabaseReference ref = FirebaseDatabase.instance.ref("users");
              FirebaseDatabase.instance.ref().child('users').orderByChild("email").equalTo(authModel.email).onChildAdded.forEach((event){
                ref.update(registerModel.toMap(key: event.snapshot.key!)).whenComplete((){
                  setState(() {
                    authModel.loggedUser!["firstname"] = _fname.text;
                    authModel.loggedUser!["lastname"] = _lname.text;
                    authModel.loggedUser!["email"] = _email.text;
                    authModel.loggedUser!["phone number"] = _phone.text;
                    authModel.loggedUser!["gender"] = gender;
                    authModel.loggedUser!["address"] = _address.text;
                  });
                  Navigator.of(context).pop(null);
                  _snackbarMessage.snackbarMessage(context, message: "Profile details updated.");
                });
              });
            }
          ),
          IconButton(
              icon: Icon(Icons.logout),
              onPressed:(){
                logout.logout(context);
              }
          )
        ],
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(vertical: 40,horizontal: 20),
        children: [
          Center(
            child: Stack(
              children: [
                GestureDetector(
                  child: Container(
                    width: 130,
                    height: 130,
                    decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        border: Border.all(color: palettes.darkblue,width: 3),
                        borderRadius: BorderRadius.circular(1000),
                        image: _file != null ?
                        DecorationImage(
                            fit: BoxFit.cover,
                            image: FileImage(_file!)
                        ) :
                        DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage("https://wallpapers.com/images/hd/cool-profile-picture-n8lf8k6jzs6ex36l.jpg")
                        )
                    ),
                  ),
                  onTap: () async{
                    await showModalBottomSheet(
                        context: context, builder: (context){
                      return PhotoPicker();
                    }).then((value){
                      upload(file: value);
                      setState(() {
                        _file = value;
                      });
                    });
                  },
                ),
                Container(
                    width: 130,
                    height: 130,
                    alignment: Alignment.bottomRight,
                    child: Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: palettes.blue,
                        borderRadius: BorderRadius.circular(1000),
                        border: Border.all(color: Colors.white),
                      ),
                      child: Icon(Icons.edit,color: Colors.white,size: 22,),
                    )
                )
              ],
            ),
          ),
          SizedBox(
            height: 35,
          ),
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
            height: 30,
          ),
        ],
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
