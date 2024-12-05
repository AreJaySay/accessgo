import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pass_slip_management/utils/palettes.dart';
import 'package:range_calendar/range_calendar.dart';

class Calendar extends StatefulWidget {
  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  var _events = FirebaseDatabase.instance.ref().child('events');
  Map<DateTime, List<Widget>> events = {};

  List<String> listOfMonthsOfTheYear = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December"
  ];
  List<String> listLabelWeekday = [
    "SUN",
    "MON",
    "TUE",
    "WED",
    "THU",
    "FRI",
    "SAT"
  ];


  Widget generateWidget({required Map details}) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EventView(details: details),
        ),
      ),
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Row(
            children: [
              SizedBox(width: 10),
              details["image"] != "" ?
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(1000),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(details["image"]),
                  )
                ),
              ) :
              CircleAvatar(
                child:  Text(
                  "${details["name"].substring(0, 1)}".toUpperCase(),
                  style: TextStyle(color: Colors.black),
                ),
                backgroundColor: Colors.grey.shade200,
              ),
              SizedBox(width: 15),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(details["name"],style: TextStyle(color: palettes.darkblue, fontFamily: "semibold"),),
                    Text(details["description"],style: TextStyle(color: Colors.grey, fontFamily: "regular"),),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _events.onValue,
        builder: (context, snapshot) {
          List? datas;

          if(snapshot.hasData){
            if(snapshot.data!.snapshot.value != null){
              datas = (snapshot.data!.snapshot.value as Map).values.toList();
              for(int d = 0; d < datas.length; d++){
                events[DateTime.parse(datas[d]["start date"])] = [
                  if(datas.isNotEmpty)...{
                    for(int x = 0; x < datas.where((s) => s["start date"] == datas![d]["start date"]).toList().length; x++)...{
                      generateWidget(details: datas.where((s) => s["start date"] == datas![d]["start date"]).toList()[x]),
                    }
                  }
                ];
              }
            }
          }
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            foregroundColor: palettes.darkblue,
            automaticallyImplyLeading: false,
            centerTitle: true,
            elevation: 1,
            shadowColor: Colors.grey.shade50,
            title: Text("Calendar",style: TextStyle(fontFamily: "bold",fontSize: 17),),
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(vertical: 15),
            child: RangeCalendar(
              onDateSelected: (DateTime date) => null,
              backgroundColorCircleDaySelected: palettes.blue,
              colorIconRangeSelected: palettes.blue,
              colorIconsRangeNotSelected: Colors.grey,
              colorLabelWeekday: Colors.black,
              backgroundColorPointerEvent: palettes.darkblue,
              onTapRange: (CalendarRangeSelected range) => null,
              events: events,
              titleListEvents: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                child: Text("EVENTS",style: TextStyle(fontFamily: "bold"),),
              ),
              listLabelWeekday: listLabelWeekday,
              viewYerOnMonthName: true,
              listOfMonthsOfTheYear: listOfMonthsOfTheYear,
            ),
          ),
        );
      }
    );
  }
}

class EventView extends StatelessWidget {
  const EventView({required this.details});
  final Map details;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text("Event",style: TextStyle(fontFamily: "bold",fontSize: 16),),
        backgroundColor: Colors.white,
        foregroundColor: palettes.darkblue,
        elevation: 1,
        shadowColor: Colors.grey.shade50,
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
        children: [
          Text(details["name"],
            style: TextStyle(
              fontSize: 17,
              fontFamily: "semibold"
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(details["description"],
            style: TextStyle(
                fontFamily: "regular"
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Image(
            fit: BoxFit.fitWidth,
            image: NetworkImage(details["image"]),
          )
        ],
      ),
    );
  }
}
