import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:crypto/crypto.dart';

class PaymentAPI {
  final String _baseUrl = 'http://34.224.64.89:85/chaperone-apihub/';
  final String _apiKey;
  final String _clientSecret;

  PaymentAPI(this._apiKey, this._clientSecret);

  // Make an authorized request to the payment endpoint
  Future<http.Response> makePayment(
      String extTransactionId,
      String clientCode,
      String msisdn,
      String otp,
      double amount,
      String checksum,
      String currency,
      String otpMedium,
      String subsStartDate,
      int subsCount,
      int subsFrequency,
      String subsPeriod,
      bool processNow,
      String redirectUrl,
      String email,
      bool cardPayment) async {
    try {
      // Prepare the request body
      var body = jsonEncode({
        "transactionRequest": {
          "extTransactionId": extTransactionId,
          "clientCode": clientCode,
          "msisdn": msisdn,
          "otp": otp,
          "amount": amount.toString(),
          "checksum": checksum,
          "currency": currency,
          "otpMedium": otpMedium,
          "subscriptions": {
            "subs_StartDate": subsStartDate,
            "subsCount": subsCount,
            "subs_Frequency": subsFrequency,
            "subs_Period": subsPeriod,
            "process_Now": processNow
          },
          "redirectUrl": redirectUrl
        }
      });

      // Prepare the headers
      var headers = {
        'Authorization': 'Bearer $_apiKey',
        'Content-Type': 'application/json'
      };
      // Add the query parameters to the URL
      var url =
          '$_baseUrl/api/CPayPayments/payment?email=$email&cardPayment=$cardPayment';
      // Make the POST request
      final response =
          await http.post(Uri.parse(url), headers: headers, body: body);

      // If the request was successful, return the response
      if (response.statusCode == 200) {
        return response;
      } else {
        // If the request was not successful, throw an error
        throw Exception('Failed to make payment: ${response.body}');
      }
    } catch (e) {
      // If there was an error, rethrow it
      rethrow;
    }
  }

  // Make an authorized request to the confirm endpoint
  Future<http.Response> confirmPayment(String extTransactionId) async {
    try {
      // Prepare the headers
      var headers = {
        'Authorization': 'Bearer $_apiKey',
      };

      // Make the POST request
      final response = await http.post(
          Uri.parse('$_baseUrl/api/CPayPayments/confirm'),
          headers: headers,
          body: jsonEncode({"extTransactionId": extTransactionId}));

      // If the request was successful, return the response
      if (response.statusCode == 200) {
        return response;
      } else {
        // If the request was not successful, throw an error
        throw Exception('Failed to confirm payment: ${response.body}');
      }
    } catch (e) {
      // If there was an error, rethrow it
      rethrow;
    }
  }

  // Function to generate a checksum from the response
  Future<String> generateChecksum(String extTransactionId, String clientCode,
      double amount, String msisdn) async {
    // Create the request body
    var requestBody = {
      "extTransactionId": extTransactionId,
      "clientCode": clientCode,
      "amount": amount,
      "msisdn": msisdn,
    };

    // Convert the request body to a JSON string
    var jsonBody = json.encode(requestBody);

    // Send the request
    var response = await http.post(
        Uri.parse("$_baseUrl/api/cpaypayments/getchecksum"),
        body: jsonBody);

    return response.body;
  }

  String generateChecksumInitiation(String extTransactionalId,
      String clientCode, String amount, String msisdn) {
    var key = utf8.encode(_clientSecret);
    var bytes = utf8.encode(extTransactionalId + clientCode + amount + msisdn);

    var hmacSha256 = Hmac(sha256, key); // HMAC-SHA256
    var digest = hmacSha256.convert(bytes);

    return digest.toString();
  }

  String generateChecksumConfirmation(String extTransactionalId,
      String clientCode, String amount, String msisdn, otp) {
    var key = utf8.encode(_clientSecret);
    var bytes =
        utf8.encode(extTransactionalId + clientCode + amount + msisdn + otp);

    var hmacSha256 = Hmac(sha256, key); // HMAC-SHA256
    var digest = hmacSha256.convert(bytes);

    return digest.toString();
  }
}
