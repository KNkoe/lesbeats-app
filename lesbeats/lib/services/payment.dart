import "package:http/http.dart" as http;
import "package:flutter/material.dart";

class Payment {
  var client = http.Client();
  static const String baseUrl = "";

  Future<dynamic> get(String api) async {
    var url = Uri.parse(baseUrl + api);
    var headers = {"api_key": ""};

    var response = await client.get(url, headers: headers);

    if (response.statusCode == 200) {
      return response.body;
    } else {
      debugPrint("Error");
    }
  }
}
