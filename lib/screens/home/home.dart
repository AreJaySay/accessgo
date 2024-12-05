import 'dart:async';
import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:pass_slip_management/functions/loaders.dart';
import 'package:pass_slip_management/models/location.dart';
import 'package:pass_slip_management/screens/home/form.dart';
import 'package:pass_slip_management/screens/home/history.dart';
import 'package:pass_slip_management/screens/home/invalid_qr_code.dart';
import 'package:pass_slip_management/screens/home/success_scan.dart';
import 'package:pass_slip_management/services/apis/location.dart';
import 'package:pass_slip_management/services/routes.dart';
import 'package:pass_slip_management/services/stream/reviewing_request.dart';
import 'package:pass_slip_management/utils/snackbars/snackbar_message.dart';
import 'package:pass_slip_management/widgets/material_button.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

import '../../models/auth.dart';
import '../../services/geolocator.dart';
import '../../utils/palettes.dart';

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final Buttons _buttons = new Buttons();
  final ScreenLoaders _screenLoaders = new ScreenLoaders();
  final Routes _routes = new Routes();
  final SnackbarMessage _snackbarMessage = new SnackbarMessage();
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;
  bool _isFlashOn = false;
  bool _isPlay = false;
  bool _isNavigate = false;

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
        if(!_isNavigate){
          if(result!.code!.split("/")[1] != "${authModel.loggedUser!["firstname"]} ${authModel.loggedUser!["lastname"]}"){
            _routes.navigator_push(context, InvalidQrCode());
          }else{
            _screenLoaders.functionLoader(context);
            locationServices.addLocation().whenComplete((){
              Navigator.of(context).pop(null);
              _routes.navigator_push(context, SuccessScan(date: result!.code!.split("/")[0]));
            });
          }
          _isNavigate = true;
        }
      });
    });
  }

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  @override
  void dispose() {
    controller?.dispose();
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
        title: Text("Qr code scanner",style: TextStyle(fontFamily: "bold",fontSize: 17),),
        actions: [
          IconButton(
            icon: Icon(Icons.history),
            onPressed: (){
              _routes.navigator_push(context, RequestHistory());
            },
          )
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: Stack(
              children: [
                QRView(
                  key: qrKey,
                  onQRViewCreated: _onQRViewCreated,
                  overlay: QrScannerOverlayShape(
                    borderColor: palettes.blue,
                    borderWidth: 4,
                    borderRadius: 5
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(25),
                            topRight: Radius.circular(25)
                        )
                    ),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: palettes.darkblue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(1000)
                      ),
                      child: IconButton(
                        icon: _isFlashOn ? Icon(Icons.flash_off, color: palettes.darkblue,) : Icon(Icons.flash_on, color: palettes.darkblue,),
                        onPressed: ()async{
                          setState(() {
                            _isFlashOn = !_isFlashOn;
                          });
                          await controller!.toggleFlash();
                        },
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: palettes.darkblue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(1000)
                      ),
                      child: IconButton(
                        icon: _isPlay ? Icon(Icons.play_arrow, color: palettes.darkblue) : Icon(Icons.pause, color: palettes.darkblue),
                        onPressed: () async{
                          setState(() {
                            _isPlay = !_isPlay;
                          });
                          if(!_isPlay){
                            await controller!.resumeCamera();
                          }else{
                            await controller!.pauseCamera();
                          }
                        },
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: palettes.darkblue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(1000)
                      ),
                      child: IconButton(
                        icon: Icon(Icons.flip_camera_android, color: palettes.darkblue),
                        onPressed: () async{
                          await controller!.flipCamera();
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 40,
                ),
                _buttons.button(text: "Request Pass", ontap: (){
                  _routes.navigator_push(context, RequestForm());
                }, isValidate: true, radius: 1000),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 50,
          )
        ],
      )
    );
  }
}
