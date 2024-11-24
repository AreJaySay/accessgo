import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pass_slip_management/utils/palettes.dart';

class PhotoPicker extends StatefulWidget {
  @override
  _PhotoPickerState createState() => _PhotoPickerState();
}

class _PhotoPickerState extends State<PhotoPicker> {

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: double.infinity,
        height: 180,
        padding: EdgeInsets.only(top: 30,left: 20,right: 20),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20)
            )
        ),
        child: Column(
          children: [
            GestureDetector(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    color: palettes.blue,
                    borderRadius: BorderRadius.circular(50)
                ),
                height: 55,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.camera_alt_outlined,color: Colors.white,),
                    SizedBox(
                      width: 10,
                    ),
                    Text("Take a photo",style: TextStyle(fontFamily: "OpenSans-medium",color: Colors.white,fontSize: 15.5),)
                  ],
                ),
              ),
              onTap: ()async{
                try {
                  final image = await ImagePicker().pickImage(source: ImageSource.camera);
                  if(image == null) return;
                  Navigator.of(context).pop(File(image.path));
                } on PlatformException catch(e) {
                  print('Failed to pick image: $e');
                }
              },
            ),
            SizedBox(
              height: 15,
            ),
            GestureDetector(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(color: palettes.blue
                    )
                ),
                height: 55,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.image_outlined,color: palettes.blue,size: 27,),
                    SizedBox(
                      width: 10,
                    ),
                    Text("Choose from gellery",style: TextStyle(fontFamily: "OpenSans-medium",fontSize: 15.5,color: palettes.blue,))
                  ],
                ),
              ),
              onTap: ()async{
                try {
                  final image = await ImagePicker().pickImage(source: ImageSource.gallery);
                  if(image == null) return;
                  Navigator.of(context).pop(File(image.path));
                } on PlatformException catch(e) {
                  print('Failed to pick image: $e');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
