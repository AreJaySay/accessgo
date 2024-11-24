import 'dart:io';
import '../models/auth.dart';

class HttpRequests {
  /// initializing constructor
  HttpRequests._privateConstructor();

  /// creating private instance of class.
  static final HttpRequests _instance = HttpRequests._privateConstructor();

  /// get instance
  static HttpRequests get instance => _instance;

  final Map<String, String>? defaultHeader = {"Accept": "application/json"};
  // final Map<String, String>? headerWithToken = {
  //   HttpHeaders.authorizationHeader: "Bearer ${authModel.accessToken}",
  //   "Accept": "application/json"
  // };
}