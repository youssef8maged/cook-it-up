import 'dart:convert';
import 'package:cook_it_up/Classes/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Database {
  static const String _key = "db";
  static late SharedPreferences _pref;

  static Future<void> addUser(User user) async{
   _pref = await SharedPreferences.getInstance();
    final List<User> temp = await retrieveUsers();
    for (User element in temp) {
      if (element.email == user.email) {
        temp.remove(element);
        break;
      }
    }
    temp.add(user);
    final List<Map<String, dynamic>> toEncode = [];
    for (User element in temp) {
      toEncode.add(element.toMap());
    }
    await _pref.setString(_key, json.encode(toEncode));
    
  }// add user METHOD

static Future<List<User>> retrieveUsers() async {
    _pref = await SharedPreferences.getInstance();
    final String? encoded = _pref.getString(_key);

    final List<User> temp = [];
    if (encoded != null) {
      final decoded = json.decode(encoded);
      for (var element in decoded) {
        temp.add(User.fromMap(element));
      }
      return temp;
    }else{
      return temp;
    }
  } // retrive users METHOD

}// CLASS