import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pass_slip_management/models/register.dart';
import 'package:pass_slip_management/models/request.dart';
import 'package:pass_slip_management/services/network.dart';

class RequestServices{
  Future request()async{
    try{
      final url = Uri.parse('${networkUtils.networkUtils}/requests.json');
      await http.post(
        url,
        body: json.encode(requestModel.toMap()),
      ).then((data){
        var respo = json.decode(data.body);
        print("REQUEST ${respo}");
      });
    }catch(e){
      print("ERROR REQUEST $e");
    }
  }
}

final RequestServices requestServices = new RequestServices();