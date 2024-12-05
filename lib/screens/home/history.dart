import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pass_slip_management/models/auth.dart';

import '../../utils/palettes.dart';

class RequestHistory extends StatefulWidget {
  @override
  State<RequestHistory> createState() => _RequestHistoryState();
}

class _RequestHistoryState extends State<RequestHistory> with TickerProviderStateMixin {
  var _requests = FirebaseDatabase.instance.ref().child('requests');
  TabController? _tabController;
  int _selectedTab = 0;
  List _requestdatas = [];

  @override
  void initState() {
    // TODO: implement initState
    _tabController = TabController(vsync: this, length: 4);
    super.initState();
  }


  @override
  void dispose() {
    _tabController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _requests.onValue,
        builder: (context, snapshot) {
          List? pending;
          List? accepted;
          List? declined;
          List? expired;

          if(snapshot.hasData){
            if(snapshot.data!.snapshot.value != null){
              if(_selectedTab == 0){
                pending = (snapshot.data!.snapshot.value as Map).values.toList().where((s)=>s["status"] == "Pending" && s["email"] == authModel.loggedUser!["email"]).toList();
                _requestdatas = pending;
              }else if(_selectedTab == 1){
                accepted = (snapshot.data!.snapshot.value as Map).values.toList().where((s)=>s["status"] == "Accepted" && s["email"] == authModel.loggedUser!["email"]).toList();
                _requestdatas = accepted;
              }else if(_selectedTab == 2){
                declined = (snapshot.data!.snapshot.value as Map).values.toList().where((s)=>s["status"] == "Declined" && s["email"] == authModel.loggedUser!["email"]).toList();
                _requestdatas = declined;
              }else{
                expired = (snapshot.data!.snapshot.value as Map).values.toList().where((s)=>s["status"] == "Expired" && s["email"] == authModel.loggedUser!["email"]).toList();
                _requestdatas = expired;
              }
            }
          }
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            foregroundColor: palettes.darkblue,
            centerTitle: true,
            elevation: 1,
            shadowColor: Colors.grey.shade50,
            title: Text("Request history",style: TextStyle(fontFamily: "bold",fontSize: 17),),
            bottom: TabBar(
              padding: EdgeInsets.symmetric(horizontal: 20),
              labelPadding: EdgeInsets.symmetric(vertical: 10),
              controller: _tabController,
              indicatorColor: palettes.darkblue,
              indicatorWeight: 4,
              indicatorSize: TabBarIndicatorSize.tab,
              dividerColor: Colors.transparent,
              labelColor: palettes.darkblue,
              labelStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              unselectedLabelColor: Colors.grey,
              tabs: const [
                Text("Pending"),
                Text("Accepted"),
                Text("Declined"),
                Text("Expired"),
              ],
              onTap: (index){
                setState(() {
                  _selectedTab = index;
                });
              },
              isScrollable: false,
            ),
          ),
          body: !snapshot.hasData ?
          Center(
            child: CircularProgressIndicator(color: palettes.darkblue,),
          ) :
          _requestdatas!.isEmpty?
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image(
                  width: 150,
                  image: AssetImage("assets/icons/no_result_found.png"),
                ),
                Text("NO REQUEST FOUND.",style: TextStyle(fontFamily: "regular",color: Colors.grey),)
              ],
            ),
          ) :
          ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            itemBuilder: (context, index){
              return Card(
                color: Colors.white,
                child: ListTile(
                  leading: Container(
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(1000),
                        color: palettes.darkblue.withOpacity(0.1)
                    ),
                    child: Icon(Icons.qr_code, color: _selectedTab == 0 ? Colors.deepOrangeAccent : _selectedTab == 1 ? palettes.darkblue : _selectedTab == 2 ? Colors.redAccent : Colors.grey,),
                  ),
                  title: Row(
                    children: [
                      Text(DateFormat("dd MMM, yyyy").format(DateTime.parse(_requestdatas[index]["date"])),style: TextStyle(color: Colors.black),),
                      Text(" • ${DateFormat("h:mm a").format(DateTime.parse(_requestdatas[index]["time"]))}",style: TextStyle(color: Colors.grey.shade700),)
                    ],
                  ),
                  subtitle: Text(_requestdatas[index]["reason"]),
                ),
              );
            },
            itemCount: _requestdatas.length,
          ),
        );
      }
    );
  }
}
