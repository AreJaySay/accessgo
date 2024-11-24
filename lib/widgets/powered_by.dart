import 'package:flutter/material.dart';

class PoweredBy extends StatefulWidget {
  @override
  State<PoweredBy> createState() => _PoweredByState();
}

class _PoweredByState extends State<PoweredBy> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("Powered by:",style: TextStyle(fontFamily: "semibold"),),
        SizedBox(
          height: 5,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              width: 65,
              image: AssetImage("assets/logos/pgis.png"),
            ),
            SizedBox(
              width: 5,
            ),
            Image(
              width: 75,
              image: AssetImage("assets/logos/iscc.png"),
            ),
            SizedBox(
              width: 5,
            ),
            Image(
              width: 75,
              image: AssetImage("assets/logos/one_ilocos_sur.png"),
            )
          ],
        )
      ],
    );
  }
}
