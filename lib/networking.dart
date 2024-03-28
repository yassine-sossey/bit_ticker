import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkingSolider {
  String url;
  NetworkingSolider(this.url);

  //check if user have access to internet
  Future<bool> hasInternetAccess() async {
    final List<ConnectivityResult> connectivityResult =
        await (Connectivity().checkConnectivity());
    return (connectivityResult.contains(ConnectivityResult.mobile) ||
        connectivityResult.contains(ConnectivityResult.wifi));
  }

  Future<Map> fetchfromwebsite() async {
    // Check if internet access is available
    bool internetOK = await hasInternetAccess();

    if (internetOK) {
      try {
        Uri uri = Uri.parse(url);
        // Fetch data from URL
        http.Response response = await http.get(uri);

        if (response.statusCode == 200) {
          debugPrint('successful fetching');
          String result = response.body;
          Map results = await jsonDecode(result);
          debugPrint('${results['rates'].length}');
          return results;
        } else {
          debugPrint('failed fetching : ${response.statusCode.toString()}');
          return Future.error(
              'Error ${response.statusCode.toString()} failed to reach Data');
        }
      } catch (e) {
        debugPrint('Error: $e');
        return Future.error('Failed to fetch data');
      }
    } else {
      // If no internet
      return Future.error('Please check your internet connection');
    }
  }
}
