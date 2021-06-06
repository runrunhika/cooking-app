
class CurrentInfo {
  static final _instance = CurrentInfo._internal();

  List<Map<String, dynamic>> foods = [];
  List<String> foodimages = [];

  factory CurrentInfo() { return _instance; }
  CurrentInfo._internal();
}