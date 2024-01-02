import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import 'parser.dart';
import 'roman_integer.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class HttpUtil {
  static const store = FlutterSecureStorage();

  static Future<RequestResult<RomanInteger>> getResult(String input) async {
    var authority = const String.fromEnvironment('authority');
    Uri uri = Uri.https(
      authority,
      '/convert',
      {
        'val': input,
      },
    );

    String authKey = 'auth';
    String? maybeAuth = await store.read(key: authKey).then((value) => value);
    String auth = maybeAuth ?? await _doRegister(authKey);

    final response = await http.get(
      uri,
      headers: {
        HttpHeaders.authorizationHeader: 'Basic $auth',
      },
    );
    return RequestResult.fromData(
      response: response.statusCode,
      parser: RomanIntegerParser(),
      json: response.body,
    );
  }

  static Future<String> _doRegister(String authKey) async {
    RequestResult actualResult = await register().then((value) => value);
    if (!actualResult.success) {
      throw Exception(actualResult.errorMessage);
    }
    String auth = '${actualResult.successResult.username}:${actualResult.successResult.password}';
    String encoded = base64Encode(utf8.encode(auth));
    store.write(key: authKey, value: encoded);
    return encoded;
  }

  static Future<RequestResult<Registration>> register() async {
    var authority = const String.fromEnvironment('authority');
    Uri uri = Uri.https(authority, '/app/register');
    final response =
        await http.post(uri, encoding: Encoding.getByName('utf-8'));
    return RequestResult.fromData(
      response: response.statusCode,
      parser: RegistrationParser(),
      json: response.body,
    );
  }
}
