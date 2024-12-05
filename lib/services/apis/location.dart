import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pass_slip_management/models/location.dart';
import 'package:pass_slip_management/models/register.dart';
import 'package:pass_slip_management/models/request.dart';
import 'package:pass_slip_management/services/network.dart';

class LocationServices{
  Future addLocation()async{
    try{
      final url = Uri.parse('${networkUtils.networkUtils}/locations.json');
      await http.post(
        url,
        body: json.encode(locationModel.toMap()),
      ).then((data){
        var respo = json.decode(data.body);
        print("LOCATION ${respo}");
      });
    }catch(e){
      print("ERROR LOCATION $e");
    }
  }
}

final LocationServices locationServices = new LocationServices();