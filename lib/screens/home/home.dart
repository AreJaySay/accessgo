import 'package:flutter/material.dart';
import 'package:pass_slip_management/functions/loaders.dart';
import 'package:pass_slip_management/services/routes.dart';
import 'package:pass_slip_management/services/stream/reviewing_request.dart';
import 'package:pass_slip_management/widgets/material_button.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

import '../../utils/palettes.dart';

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final Buttons _buttons = new Buttons();
  final ScreenLoaders _screenLoaders = new ScreenLoaders();
  final Routes _routes = new Routes();

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
        title: Text("Request Qr Code",style: TextStyle(fontFamily: "bold",fontSize: 17),),
      ),
      body: StreamBuilder<String>(
        stream: reviewingRequest.subject,
        builder: (context, snapshot) {
          return !snapshot.hasData?
          Center(
            child: CircularProgressIndicator(color: palettes.blue,),
          ) :
          snapshot.data! == "reviewing" ?
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image(
                  width: 300,
                  image: AssetImage("assets/gif/reviewing_request.gif"),
                ),
                Text("Reviewing request...",style: TextStyle(fontFamily: "semibold",fontSize: 18),),
                SizedBox(
                  height: 5,
                ),
                Text("We are now reviewing your request, \nit will not take long. Thank you!",style: TextStyle(fontFamily: "regular"),textAlign: TextAlign.center,)
              ],
            ),
          ) :  snapshot.data! == "accepted" ?
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(text: 'Your request is',style: TextStyle(fontFamily: "reguar",fontSize: 16),),
                        TextSpan(text: ' accepted!',style: TextStyle(fontFamily: "semibold",fontSize: 16,color: Colors.green),),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 3,
                          blurRadius: 2,
                          offset: Offset(0, 0), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 35,vertical: 35),
                      child: PrettyQrView.data(
                        data: 'https://www.youtube.com/watch?v=3Njvr6-OVao&rco=1',
                        decoration: const PrettyQrDecoration(
                          image: PrettyQrDecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage('assets/logos/app_logo.jpg'),
                            position: PrettyQrDecorationImagePosition.embedded
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text("Scan this qr code before time is running out, \nit is valid until 1 hour.",textAlign: TextAlign.center,style: TextStyle(fontFamily: "regular"),)
                ],
              ),
            ),
          ) :
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20,vertical: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Image(
                  width: 250,
                  color: Colors.grey,
                  image: AssetImage("assets/icons/qr_placeholder.png"),
                ),
                Column(
                  children: [
                    _buttons.button(text: "Request", ontap: (){
                      _screenLoaders.functionLoader(context);
                      Future.delayed(const Duration(seconds: 10), () {
                        Navigator.of(context).pop(null);
                        reviewingRequest.update(data: "reviewing");
                      });
                      Future.delayed(const Duration(seconds: 20), () {
                        reviewingRequest.update(data: "accepted");
                      });
                    }, isValidate: true, radius: 1000),
                    SizedBox(
                      height: 5,
                    ),
                    Text("or",style: TextStyle(fontFamily: "regular")),
                    SizedBox(
                      height: 5,
                    ),
                    ZoomTapAnimation(
                        end: 0.99,
                        child: Container(
                          width: double.infinity,
                          height: 55,
                          decoration:BoxDecoration(
                              border: Border.all(color: palettes.darkblue,width: 2),
                              borderRadius: BorderRadius.circular(1000)
                          ),
                          child: Center(child: Text("Schedule",style: TextStyle(color: palettes.darkblue,fontFamily: "semibold",fontSize: 16),)),
                        ),
                        onTap:(){

                        }
                    ),
                  ],
                )
              ],
            ),
          );
        }
      ),
    );
  }
}
