import 'package:cupertino_calendar_picker/cupertino_calendar_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pass_slip_management/functions/loaders.dart';
import 'package:pass_slip_management/models/auth.dart';
import 'package:pass_slip_management/models/request.dart';
import 'package:pass_slip_management/services/apis/request.dart';
import 'package:pass_slip_management/utils/snackbars/snackbar_message.dart';
import '../../utils/palettes.dart';
import '../../widgets/material_button.dart';

class RequestForm extends StatefulWidget {
  @override
  State<RequestForm> createState() => _RequestFormState();
}

class _RequestFormState extends State<RequestForm> {
  final Buttons _buttons = new Buttons();
  final ScreenLoaders _screenLoaders = new ScreenLoaders();
  final TextEditingController _reason = new TextEditingController();
  final SnackbarMessage _snackbarMessage = new SnackbarMessage();
  DateTime _current = DateTime.now();

  @override
  void initState() {
    // TODO: implement initState
    requestModel.date = DateTime.now().toString();
    requestModel.time = DateTime.now().toString();
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
            children: [
              CupertinoCalendar(
                mainColor: palettes.blue,
                minimumDateTime: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day-1),
                maximumDateTime: DateTime(2030, 1, 1),
                initialDateTime: DateTime.now(),
                currentDateTime: _current,
                timeLabel: 'Time',
                mode: CupertinoCalendarMode.dateTime,
                weekdayDecoration: CalendarWeekdayDecoration(
                  textStyle: TextStyle(fontWeight: FontWeight.w500)
                ),
                onDateSelected: (date){
                  setState(() {
                    requestModel.date = date.toString();
                    _current = date;
                  });
                },
                onDateTimeChanged: (time){
                  setState(() {
                    requestModel.time = time.toString();
                  });
                },
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text("Reason",style: TextStyle(fontFamily: "bold",fontSize: 16),),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10)
                ),
                child: TextField(
                  controller: _reason,
                  minLines: 6,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Enter request reason...",
                    hintStyle: TextStyle(fontFamily: "regular"),
                    contentPadding: EdgeInsets.symmetric(horizontal: 15,vertical: 15)
                  ),
                  onChanged: (text){
                    setState(() {
                      requestModel.reason = text;
                    });
                  },
                ),
              ),
              SizedBox(
                height: 70,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: _buttons.button(text: "Confirm", ontap: (){
                  print(requestModel.toMap());
                  if(_reason.text.isEmpty){
                    _snackbarMessage.snackbarMessage(context, message: "Please enter the reason.", is_error: true);
                  }else{
                    _screenLoaders.functionLoader(context);
                    requestServices.request().whenComplete((){
                      Navigator.of(context).pop(null);
                      Navigator.of(context).pop(null);
                      _snackbarMessage.snackbarMessage(context, message: "Your request has successfully sent!");
                    });
                  }
                }, isValidate: true, radius: 1000),
              ),
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
