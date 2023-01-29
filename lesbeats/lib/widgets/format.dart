import 'package:encrypt/encrypt.dart';
import 'dart:math';

String numberFormat(dynamic n) {
  String num = n.toString();
  int len = num.length;

  if (n >= 1000 && n < 1000000) {
    return '${num.substring(0, len - 3)}.${num.substring(len - 3, 1 + (len - 3))}k';
  } else if (n >= 1000000 && n < 1000000000) {
    return '${num.substring(0, len - 6)}.${num.substring(len - 6, 1 + (len - 6))}m';
  } else if (n > 1000000000) {
    return '${num.substring(0, len - 9)}.${num.substring(len - 9, 1 + (len - 9))}b';
  } else {
    return num.toString();
  }
}

bool isNumeric(String s) {
  return double.tryParse(s) != null;
}

// Encrypts the message using the given key
String encrypt(String key, String message) {
  final keyBytes = Key.fromUtf8(key.substring(0, 32));
  final iv = IV.fromLength(16);

  final encrypter = Encrypter(AES(keyBytes));

  final encrypted = encrypter.encrypt(message, iv: iv);

  return encrypted.base64;
}

// Decrypts the message using the given key
String decrypt(String key, String cypher) {
  final keyBytes = Key.fromUtf8(key.substring(0, 32));
  final iv = IV.fromLength(16);
  final encrypter = Encrypter(AES(keyBytes));
  final decrypted = encrypter.decrypt(Encrypted.fromBase64(cypher), iv: iv);

  return decrypted;
}

String generateRandomString(int len) {
  var r = Random();
  return String.fromCharCodes(
      List.generate(len, (index) => r.nextInt(33) + 89));
}
