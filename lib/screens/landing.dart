import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:pass_slip_management/screens/calendar/calendar.dart';
import 'package:pass_slip_management/screens/home/home.dart';
import 'package:pass_slip_management/screens/profile/profile.dart';
import 'package:pass_slip_management/services/routes.dart';
import 'package:pass_slip_management/utils/palettes.dart';

class Landing extends StatefulWidget {
  @override
  State<Landing> createState() => _LandingState();
}

class _LandingState extends State<Landing> {
  final Routes _routes = new Routes();
  int _selectedIndex = 2;
  List<Widget> _pages = [Calendar(),Profile(),Home()];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: _pages[_selectedIndex],
        floatingActionButton: FloatingActionButton(
          backgroundColor: palettes.darkblue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(1000)
          ),
          child: Icon(Icons.qr_code_2,size: 30,color: Colors.white,),
          onPressed: (){
            setState(() {
              _selectedIndex = 2;
            });
          },
          //params
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: AnimatedBottomNavigationBar(
          icons: [
            Icons.calendar_month,
            Icons.account_circle_outlined
          ],
          iconSize: 27,
          activeColor: palettes.darkblue,
          inactiveColor: Colors.grey.shade700,
          activeIndex: _selectedIndex,
          gapLocation: GapLocation.center,
          backgroundColor: Colors.white,
          notchSmoothness: NotchSmoothness.smoothEdge,
          onTap: (index) => setState(() => _selectedIndex = index),
          //other params
        ),
      )
    );
  }
}
