import 'dart:convert';

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

class RequestResult {

  final bool _success;
  final RomanInteger? _successResult;
  final String? _errorMessage;

  RequestResult({required bool success, required RomanInteger? successResult, required String? errorMessage})
      : _errorMessage = errorMessage, _successResult = successResult, _success = success;

  factory RequestResult.fromData({required int response, required String json}) {
    bool success = response == 200;
    if (success) {
      return RequestResult(success: success, successResult: RomanInteger.fromJson(json), errorMessage: null);
    } else {
      return RequestResult(success: success, successResult: null, errorMessage: jsonDecode(json)['message']);
    }
  }

  String get errorMessage => _errorMessage!;

  RomanInteger get successResult => _successResult!;

  bool get success => _success;
}
