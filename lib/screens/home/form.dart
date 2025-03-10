import 'dart:ui' as ui;

import 'package:cupertino_calendar_picker/cupertino_calendar_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:intl/intl.dart';
import 'package:pass_slip_management/functions/loaders.dart';
import 'package:pass_slip_management/models/auth.dart';
import 'package:pass_slip_management/models/request.dart';
import 'package:pass_slip_management/services/apis/request.dart';
import 'package:pass_slip_management/utils/snackbars/snackbar_message.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';
import '../../utils/palettes.dart';
import '../../widgets/material_button.dart';

class RequestForm extends StatefulWidget {
  @override
  State<RequestForm> createState() => _RequestFormState();
}

class _RequestFormState extends State<RequestForm> {
  final TextEditingController _fname = new TextEditingController();
  final TextEditingController _official = new TextEditingController();
  final Buttons _buttons = new Buttons();
  final ScreenLoaders _screenLoaders = new ScreenLoaders();
  final TextEditingController _reason = new TextEditingController();
  final SnackbarMessage _snackbarMessage = new SnackbarMessage();
  GlobalKey<SfSignaturePadState> _signaturePadKey = GlobalKey();
  bool _keyboardVisible = false;
  Widget? _signWidget = SizedBox();
  Widget? _signWidgetOfficial = SizedBox();
  bool _hasSignature = false;
  String _type = "";
  String _purpose = "";
  String _startTime = "";
  String _endTime = "";

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != DateTime.now()) {
      setState(() {
        requestModel.date = "$picked";
      });
    }
  }

  Future _selectTime(BuildContext context, TimeOfDay currentTime, bool isStart) async {
    final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: currentTime, builder: (BuildContext context, Widget? child) {
      return MediaQuery(
        data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
        child: child!,
      );});

    if (pickedTime != null){
      DateTime tempDate = DateFormat("hh:mm").parse(pickedTime!.hour.toString() + ":" + pickedTime!.minute.toString());
      var dateFormat = DateFormat("h:mm a");
      setState(() {
        if(isStart){
          requestModel.start_time = dateFormat.format(tempDate);
        }else{
          requestModel.end_time = dateFormat.format(tempDate);
        }
      });
      return dateFormat.format(tempDate);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    _fname.text = "${authModel.loggedUser!["firstname"]} ${authModel.loggedUser!["lastname"]}";
    requestModel.date = "";
    requestModel.request_type = "";
    requestModel.start_time = "";
    requestModel.end_time = "";
    requestModel.purpose = "";
    requestModel.reason = "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: (){
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            foregroundColor: palettes.darkblue,
            centerTitle: true,
            elevation: 1,
            shadowColor: Colors.grey.shade50,
            title: Text("Request Form",style: TextStyle(fontFamily: "bold",fontSize: 17),),
          ),
          body: ListView(
            padding: EdgeInsets.symmetric(vertical: 15,horizontal: 15),
            children: [
              Text(" Personal Copy",style: TextStyle(fontFamily: "regular",fontStyle: FontStyle.italic,fontSize: 12),),
              Container(
                decoration: BoxDecoration(
                    border: Border(
                      left: BorderSide(color: Colors.black87),
                      right: BorderSide(color: Colors.black87),
                      bottom: BorderSide(color: Colors.black87),
                    )
                ),
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(color: Colors.black87),
                              top: BorderSide(color: Colors.black87)
                          )
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 60,
                            height: 25,
                            decoration: BoxDecoration(
                                border: Border(
                                    right: BorderSide(color: Colors.black87)
                                )
                            ),
                          ),
                          Expanded(
                            child: Text(" Individual Pass Slip / Time Adjustment Slip",style: TextStyle(fontFamily: "bold",fontSize: 13),),
                          )
                        ],
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      height: 20,
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(color: Colors.black87),
                          )
                      ),
                      child: Text(" To be filled up by the requesting employee",style: TextStyle(fontFamily: "regular",fontStyle: FontStyle.italic,fontSize: 12),),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 10
                        ),
                        Expanded(
                          flex: 4,
                          child: GestureDetector(
                            onTap: ()async{
                              await showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Row(
                                      children: [
                                        Text("Add Signature",style: TextStyle(fontFamily: "semibold",fontSize: 18),),
                                        Spacer(),
                                        IconButton(
                                          icon: Icon(Icons.refresh),
                                          onPressed: (){
                                            setState(() {
                                              _fname.text = "";
                                              _signaturePadKey.currentState!.clear();
                                              _hasSignature = false;
                                            });
                                          },
                                        )
                                      ],
                                    ),
                                    backgroundColor: Colors.white,
                                    content: Container(
                                      height: 200,
                                      width: double.infinity,
                                      child: Column(
                                        children: [
                                          // Container(
                                          //   decoration: BoxDecoration(
                                          //       border: Border.all(color: Colors.black87)
                                          //   ),
                                          //   child: TextField(
                                          //     controller: _fname,
                                          //     decoration: InputDecoration(
                                          //       border: InputBorder.none,
                                          //       hintText: "Enter fullname"
                                          //     ),
                                          //     style: TextStyle(fontFamily: "regular"),
                                          //   ),
                                          //   padding: EdgeInsets.symmetric(horizontal: 10),
                                          // ),
                                          // SizedBox(
                                          //   height: 20,
                                          // ),
                                          Expanded(
                                            child: Stack(
                                              children: [
                                                Container(
                                                  color: Colors.grey.shade200,
                                                ),
                                                SfSignaturePad(
                                                  key: _signaturePadKey,
                                                  minimumStrokeWidth: 1,
                                                  maximumStrokeWidth: 3,
                                                  strokeColor: Colors.black,
                                                  backgroundColor: Colors.transparent,
                                                  onDraw: (_,date){
                                                    print(date);
                                                    setState(() {
                                                      _hasSignature = true;
                                                    });
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    actions: [
                                      TextButton(
                                        child: Text("Cancel",style: TextStyle(color: Colors.blueGrey),),
                                        onPressed: (){
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      TextButton(
                                        child: Text("Confirm",style: TextStyle(color: palettes.blue),),
                                        onPressed: ()async{
                                          if(_fname.text.isNotEmpty && _hasSignature){
                                            final data = await _signaturePadKey.currentState!.toImage(pixelRatio: 3.0);
                                            final bytes = await data.toByteData(format: ui.ImageByteFormat.png);
                                            setState(() {
                                              setState(() {
                                                _signWidget = Image.memory(bytes!.buffer.asUint8List(),width: double.infinity,);
                                              });
                                            });
                                            Navigator.of(context).pop();
                                          }
                                        },
                                      )
                                    ],
                                  );
                                },
                              );
                            },
                            child: Stack(
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: double.infinity,
                                      height: 30,
                                      alignment: Alignment.bottomLeft,
                                      decoration: BoxDecoration(
                                          border: Border(
                                            bottom: BorderSide(color: Colors.black87),
                                          )
                                      ),
                                      child: Text(_fname.text,style: TextStyle(fontFamily: "semibold",fontSize: 13.5),),
                                      padding: EdgeInsets.symmetric(vertical: 5),
                                    ),
                                    Text("Printed Name of employee and signature\nPermission is requested to:",style: TextStyle(fontFamily: "regular",fontSize: 12),),
                                  ],
                                ),
                                SizedBox(
                                  height: 50,
                                  child: _signWidget!,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Padding(
                            padding: EdgeInsets.only(left: 20,right: 10),
                            child: GestureDetector(
                              onTap: (){
                                _selectDate(context);
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: double.infinity,
                                    height: 30,
                                    decoration: BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(color: Colors.black87),
                                        )
                                    ),
                                    alignment: Alignment.centerLeft,
                                    child: Text(requestModel.date == "" ? "" : DateFormat("MM/dd/yyyy").format(DateTime.parse(requestModel.date)),style: TextStyle(fontFamily: "semibold",fontSize: 13.5),),
                                  ),
                                  Text("Date\n",style: TextStyle(fontFamily: "regular",fontSize: 12),),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 30,
                        ),
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: Checkbox(
                            activeColor: palettes.darkblue,
                            checkColor: Colors.white,
                            value: _type == "Leave office",
                            onChanged: (val){
                              setState(() {
                                _type = "Leave office";
                                requestModel.request_type = "leave_office";
                              });
                            },
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Text("Leave the Office Premises\nduring office from:",style: TextStyle(fontFamily: "regular",fontSize: 13),),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        SizedBox(
                          width: 50,
                        ),
                        Text("Intended time of Departure",style: TextStyle(fontFamily: "regular",fontSize: 13),),
                        GestureDetector(
                          onTap: (){
                            _selectTime(context, TimeOfDay.now(),true).then((time){
                              setState(() {
                                _startTime = time;
                              });
                            });
                          },
                          child: Container(
                            width: 80,
                            height: 20,
                            decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(color: Colors.black87),
                                )
                            ),
                            child: Text(_type == "Leave office" ? _startTime : "",style: TextStyle(fontFamily: "semibold",fontSize: 13.5),textAlign: TextAlign.center,),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        SizedBox(
                          width: 50,
                        ),
                        Text("To intended time of arrival  ",style: TextStyle(fontFamily: "regular",fontSize: 13),),
                        GestureDetector(
                          onTap: (){
                            print("time");
                            _selectTime(context, _startTime == "" ? TimeOfDay.now() : TimeOfDay(hour: int.parse(_startTime.split(":")[0]), minute: int.parse(_startTime.split(":")[1].split(" ")[0])), false).then((time){
                              setState(() {
                                _endTime = time;
                              });
                            });
                          },
                          child: Container(
                            width: 80,
                            height: 20,
                            decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(color: Colors.black87),
                                )
                            ),
                            child: Text(_type == "Leave office" ? _endTime : "",style: TextStyle(fontFamily: "semibold",fontSize: 13.5),textAlign: TextAlign.center,),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 30,
                        ),
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: Checkbox(
                            activeColor: palettes.darkblue,
                            checkColor: Colors.white,
                            value: _type == "Deviate",
                            onChanged: (val){
                              setState(() {
                                _type = "Deviate";
                                requestModel.request_type = "deviate";
                              });
                            },
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Text("Deviate from my fixed time of arrival",style: TextStyle(fontFamily: "regular",fontSize: 13),),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 50,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text("From: ",style: TextStyle(fontFamily: "regular",fontSize: 13),),
                                GestureDetector(
                                  onTap: (){
                                    _selectTime(context, TimeOfDay.now(),true).then((time){
                                      setState(() {
                                        _startTime = time;
                                      });
                                    });
                                  },
                                  child: Container(
                                    width: 70,
                                    height: 20,
                                    decoration: BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(color: Colors.black87),
                                        )
                                    ),
                                    child: Text(_type == "Deviate" ? _startTime : "",style: TextStyle(fontFamily: "semibold",fontSize: 13.5),textAlign: TextAlign.center,),
                                  ),
                                ),
                              ],
                            ),
                            Text("           (Fixed Time)",style: TextStyle(fontFamily: "regular",fontStyle: FontStyle.italic,fontSize: 11),),
                          ],
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text("To: ",style: TextStyle(fontFamily: "regular",fontSize: 13),),
                            GestureDetector(
                              onTap: (){
                                _selectTime(context, _startTime == "" ? TimeOfDay.now() : TimeOfDay(hour: int.parse(_startTime.split(":")[0]), minute: int.parse(_startTime.split(":")[1].split(" ")[0])),false).then((time){
                                  setState(() {
                                    _endTime = time;
                                  });
                                });
                              },
                              child: Container(
                                width: 70,
                                height: 20,
                                decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(color: Colors.black87),
                                    )
                                ),
                                child: Text(_type == "Deviate" ? _endTime : "",style: TextStyle(fontFamily: "semibold",fontSize: 13.5),textAlign: TextAlign.center,),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      height: 30,
                      margin: EdgeInsets.symmetric(horizontal: 30),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black87)
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text("Purpose",style: TextStyle(fontFamily: "regular",fontSize: 13),),
                          Row(
                            children: [
                              SizedBox(
                                width: 20,
                                height: 20,
                                child: Checkbox(
                                  activeColor: palettes.darkblue,
                                  checkColor: Colors.white,
                                  value: _purpose == "official",
                                  onChanged: (val){
                                    setState(() {
                                      _purpose = "official";
                                      requestModel.purpose = "official";
                                    });
                                  },
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text("Official",style: TextStyle(fontFamily: "regular",fontSize: 13),)
                            ],
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: 20,
                                height: 20,
                                child: Checkbox(
                                  activeColor: palettes.darkblue,
                                  checkColor: Colors.white,
                                  value: _purpose == "personal",
                                  onChanged: (val){
                                    setState(() {
                                      _purpose = "personal";
                                      requestModel.purpose = "personal";
                                    });
                                  },
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text("Personal",style: TextStyle(fontFamily: "regular",fontSize: 13),)
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    _purpose == "official" ?
                    Stack(
                      children: [
                        GestureDetector(
                          onTap: ()async{
                            await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Row(
                                  children: [
                                    Text("Add Signature & fullname",style: TextStyle(fontFamily: "semibold",fontSize: 18),),
                                    Spacer(),
                                    IconButton(
                                      icon: Icon(Icons.refresh),
                                      onPressed: (){
                                        setState(() {
                                          _official.text = "";
                                          _signaturePadKey.currentState!.clear();
                                          _hasSignature = false;
                                        });
                                      },
                                    )
                                  ],
                                ),
                                backgroundColor: Colors.white,
                                content: Container(
                                  height: 300,
                                  width: double.infinity,
                                  child: Column(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                            border: Border.all(color: Colors.black87)
                                        ),
                                        child: TextField(
                                          controller: _official,
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText: "Enter official name"
                                          ),
                                          onChanged: (text){
                                            setState(() {
                                              requestModel.official_name = text;
                                            });
                                          },
                                          style: TextStyle(fontFamily: "regular"),
                                        ),
                                        padding: EdgeInsets.symmetric(horizontal: 10),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Expanded(
                                        child: Stack(
                                          children: [
                                            Container(
                                              color: Colors.grey.shade200,
                                            ),
                                            SfSignaturePad(
                                              key: _signaturePadKey,
                                              minimumStrokeWidth: 1,
                                              maximumStrokeWidth: 3,
                                              strokeColor: Colors.black,
                                              backgroundColor: Colors.transparent,
                                              onDraw: (_,date){
                                                print(date);
                                                setState(() {
                                                  _hasSignature = true;
                                                });
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    child: Text("Cancel",style: TextStyle(color: Colors.blueGrey),),
                                    onPressed: (){
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  TextButton(
                                    child: Text("Confirm",style: TextStyle(color: palettes.blue),),
                                    onPressed: ()async{
                                      if(_official.text.isNotEmpty && _hasSignature){
                                        final data = await _signaturePadKey.currentState!.toImage(pixelRatio: 3.0);
                                        final bytes = await data.toByteData(format: ui.ImageByteFormat.png);
                                        setState(() {
                                          setState(() {
                                            _signWidgetOfficial = Image.memory(bytes!.buffer.asUint8List(),width: double.infinity,);
                                          });
                                        });
                                        Navigator.of(context).pop();
                                      }
                                    },
                                  )
                                ],
                              );
                            },
                            );
                          },
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  SizedBox(
                                    width: 30,
                                  ),
                                  Text("For official: ",style: TextStyle(fontFamily: "regular",fontSize: 13),),
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                          border: Border(
                                            bottom: BorderSide(color: Colors.black87),
                                          )
                                      ),
                                      child: Text(_official.text,style: TextStyle(fontFamily: "semibold",fontSize: 13.5),),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 30,
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Center(
                                child: Text("                  Signature over printed name",style: TextStyle(fontFamily: "regular",fontSize: 12),),
                              ),
                            ],
                          ),
                        ),
                        Center(
                          child: SizedBox(
                            height: 50,
                            width: 50,
                            child: _signWidgetOfficial!,
                          ),
                        ),
                      ],
                    ) : SizedBox(),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        SizedBox(
                          width: 10,
                        ),
                        Text("Reason: ",style: TextStyle(fontFamily: "regular",fontSize: 12),),
                        Expanded(
                          child: TextField(
                            keyboardType: TextInputType.multiline,
                            onChanged: (val){
                              setState(() {
                                requestModel.reason = val;
                              });
                            },
                            minLines: 1,
                            maxLines: null,
                            decoration: InputDecoration(
                              isDense: true,
                            ),
                          )
                        ),
                        SizedBox(
                          width: 30,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                      height: 25,
                      alignment: Alignment.centerLeft,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(color: Colors.black87),
                          bottom: BorderSide(color: Colors.black87)
                        )
                      ),
                      child: Text(" To be filled up by the approving authority",style: TextStyle(fontFamily: "regular",fontStyle: FontStyle.italic,fontSize: 12),)
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      height: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 10,
                          ),
                          Text("Approved by:",style: TextStyle(fontFamily: "regular",fontSize: 13),),
                          SizedBox(
                            width: 30,
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.only(bottom: 3),
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(color: Colors.black87)
                                    )
                                  ),
                                  child: Text("Amador Rojo",textAlign: TextAlign.center,style: TextStyle(fontFamily: "semibold"),),
                                ),
                                SizedBox(
                                  height: 3,
                                ),
                                Text("Head of Office/Authorized Representative",style: TextStyle(fontSize: 11,fontFamily: "regular",fontStyle: FontStyle.italic),)
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 30,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    )
                  ],
                ),
              ),
              // CupertinoCalendar(
              //   mainColor: palettes.blue,
              //   minimumDateTime: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day-1),
              //   maximumDateTime: DateTime(2030, 1, 1),
              //   initialDateTime: DateTime.now(),
              //   currentDateTime: _current,
              //   timeLabel: 'Time',
              //   mode: CupertinoCalendarMode.dateTime,
              //   weekdayDecoration: CalendarWeekdayDecoration(
              //     textStyle: TextStyle(fontWeight: FontWeight.w500)
              //   ),
              //   onDateSelected: (date){
              //     setState(() {
              //       requestModel.date = date.toString();
              //       _current = date;
              //     });
              //   },
              //   onDateTimeChanged: (time){
              //     setState(() {
              //       requestModel.time = time.toString();
              //     });
              //   },
              // ),
              // SizedBox(
              //   height: 20,
              // ),
              // Padding(
              //   padding: EdgeInsets.symmetric(horizontal: 20),
              //   child: Text("Reason",style: TextStyle(fontFamily: "bold",fontSize: 16),),
              // ),
              // SizedBox(
              //   height: 10,
              // ),
              // Container(
              //   margin: EdgeInsets.symmetric(horizontal: 20),
              //   decoration: BoxDecoration(
              //     border: Border.all(color: Colors.grey),
              //     borderRadius: BorderRadius.circular(10)
              //   ),
              //   child: TextField(
              //     controller: _reason,
              //     minLines: 6,
              //     keyboardType: TextInputType.multiline,
              //     maxLines: null,
              //     decoration: InputDecoration(
              //       border: InputBorder.none,
              //       hintText: "Enter request reason...",
              //       hintStyle: TextStyle(fontFamily: "regular"),
              //       contentPadding: EdgeInsets.symmetric(horizontal: 15,vertical: 15)
              //     ),
              //     onChanged: (text){
              //       setState(() {
              //         requestModel.reason = text;
              //       });
              //     },
              //   ),
              // ),
              // SizedBox(
              //   height: 70,
              // ),
              SizedBox(
                height: 50,
              ),
              _buttons.button(text: "Confirm", ontap: (){
                print(requestModel.toMap());
                if(requestModel.date == "" || requestModel.request_type == "" || requestModel.start_time == "" || requestModel.end_time == "" || requestModel.purpose == "" || requestModel.reason == ""){
                  _snackbarMessage.snackbarMessage(context, message: "All fields are required.", is_error: true);
                }else{
                  _screenLoaders.functionLoader(context);
                  requestServices.request().whenComplete((){
                    Navigator.of(context).pop(null);
                    Navigator.of(context).pop(null);
                    _snackbarMessage.snackbarMessage(context, message: "Your request has successfully sent!");
                  });
                }
              }, isValidate: true, radius: 1000),
              SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
