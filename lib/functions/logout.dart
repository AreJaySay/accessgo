import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pass_slip_management/credentials/login/login.dart';
import 'package:pass_slip_management/models/auth.dart';
import 'package:pass_slip_management/services/routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Logout{
  final Routes _routes = new Routes();

  void logout(BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext ctx) {
        return StatefulBuilder(
          builder: (context, StateSetter setState){
            return CupertinoAlertDialog(
              title: const Text('Please confirm'),
              content: const Text('Are you sure you want to log out?'),
              actions: [
                CupertinoDialogAction(
                  onPressed: () async{
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    prefs.clear();
                    setState((){
                      authModel.loggedUser = null;
                      authModel.email = "";
                      authModel.pass = "";
                    });
                    _routes.navigator_pushreplacement(context, Login(), transitionType: PageTransitionType.leftToRightWithFade);
                  },
                  child: const Text('Confirm'),
                  isDefaultAction: true,
                  isDestructiveAction: true,
                ),
                // The "No" button
                CupertinoDialogAction(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                  isDefaultAction: false,
                  isDestructiveAction: false,
                )
              ],
            );
          },
        );
      });
  }
}

final Logout logout = new Logout();