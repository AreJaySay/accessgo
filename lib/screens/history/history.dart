import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pass_slip_management/utils/palettes.dart';
import 'package:table_calendar/table_calendar.dart';

class History extends StatefulWidget {
  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  TabController? _tabController;
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: DefaultTabController(
        length: 2,
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              pinned: true,
              floating: true,
              snap: true,
              backgroundColor: Colors.white,
              foregroundColor: palettes.darkblue,
              automaticallyImplyLeading: false,
              centerTitle: true,
              expandedHeight: 470.0,
              elevation: 1,
              shadowColor: Colors.grey.shade50,
              surfaceTintColor: Colors.white,
              title: Text("Request History",style: TextStyle(fontFamily: "bold",fontSize: 17),),
              flexibleSpace: FlexibleSpaceBar(
                background: Center(
                  child: Container(
                    width: double.infinity,
                    height: 350,
                    child: TableCalendar(
                      firstDay: DateTime.utc(2024, 1, 16),
                      lastDay: DateTime.now(),
                      focusedDay: DateTime.now(),
                      calendarStyle: CalendarStyle(
                        weekendTextStyle: TextStyle(color: Colors.red,fontFamily: "regular"),
                        todayDecoration: BoxDecoration(
                          color: Colors.transparent
                        ),
                        todayTextStyle: TextStyle(color: Colors.black,fontFamily: "regular"),
                        defaultDecoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(1000),
                            color: palettes.blue
                        ),
                        defaultTextStyle: TextStyle(color: Colors.white,fontFamily: "regular"),
                      ),
                    )
                  ),
                ),
              ),
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
                  Text("Accepted"),
                  Text("Declined"),
                ],
                onTap: (index){
                  setState(() {
                    _selectedTab = index;
                  });
                },
                isScrollable: false,
              ),
            ),
            SliverFillRemaining(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index){
                  return Card(
                    color: Colors.white,
                    child: ListTile(
                      leading: Container(
                        width: 45,
                        height: 45,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(1000),
                          color: _selectedTab == 1 ? Colors.red.withOpacity(0.1) : palettes.darkblue.withOpacity(0.1)
                        ),
                        child: Icon(Icons.qr_code),
                      ),
                      title: Text(DateFormat("dd MMM, yyyy").format(DateTime.now()),style: TextStyle(color: _selectedTab == 1 ? Colors.redAccent : Colors.black),),
                      subtitle: Text(DateFormat("h:mm a").format(DateTime.now())),
                    ),
                  );
                },
                itemCount: 10,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class RequestData {
  RequestData(this.type, this.year, this.sales);
  final String year, type;
  final double sales;
}