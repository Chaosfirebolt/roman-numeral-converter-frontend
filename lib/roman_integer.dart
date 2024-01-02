import 'dart:convert';

import 'parser.dart';

class RomanInteger {

  final String _roman;
  final int _arabic;

  RomanInteger(this._roman, this._arabic);

  String get roman => _roman;

  int get arabic => _arabic;

  @override
  String toString() {
    return '$_roman = $_arabic';
  }

  factory RomanInteger.fromJson(String json) {
    var map = jsonDecode(json);
    return RomanInteger(map['r'], map['a']);
  }
}

class Registration {
  
  final String _username;
  final String _password;

  Registration(this._username, this._password);

  factory Registration.fromJson(String json) {
    var map = jsonDecode(json);
    return Registration(map['id'], map['pass']);
  }

  String get password => _password;

  String get username => _username;
}

class RequestResult<T> {

  final bool _success;
  final T? _successResult;
  final String? _errorMessage;

  RequestResult({required bool success, required T? successResult, required String? errorMessage})
      : _errorMessage = errorMessage, _successResult = successResult, _success = success;

  factory RequestResult.fromData({required int response, required Parser<T> parser, required String json}) {
    bool success = response == 200;
    if (success) {
      return RequestResult(success: success, successResult: parser.parse(json), errorMessage: null);
    } else {
      return RequestResult(success: success, successResult: null, errorMessage: jsonDecode(json)['message']);
    }
  }

  String get errorMessage => _errorMessage!;

  T get successResult => _successResult!;

  bool get success => _success;
}
