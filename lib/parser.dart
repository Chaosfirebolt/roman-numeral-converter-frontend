import 'package:roman_numeral_converter_frontend/roman_integer.dart';

abstract class Parser<T> {

  T parse(String json);
}

class RomanIntegerParser extends Parser<RomanInteger> {
  @override
  RomanInteger parse(String json) {
    return RomanInteger.fromJson(json);
  }
}

class RegistrationParser extends Parser<Registration> {
  @override
  Registration parse(String json) {
    return Registration.fromJson(json);
  }
}
