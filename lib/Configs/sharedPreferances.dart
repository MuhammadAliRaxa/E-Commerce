import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';

class SharedpreferancesHelper {
  static SharedPreferences? _prefs;
  static Future<void> makeInstance()async{
    log("nxbjkasbxjkasbxjkbaskjxbkjasbxkjasbx");
    _prefs=await SharedPreferences.getInstance();
  }
  static Future<bool> isBoardingDone()async{
    return _prefs?.getBool("isBoarding")??false;
  }
  static Future<void> setBoardingtoDone(bool bool)async{
    await _prefs?.setBool("isBoarding", bool);
  }
  static bool isAccountLogin(){
    return _prefs?.getBool("Login")??false;
  }
  static Future<void> setAccountAlreadyLogin(bool bool)async{
    await _prefs?.setBool("Login", bool);
  }
  static Future<void> setAddress(String address)async{
    await _prefs?.setString("Home", address);
  }
  static String? getAddress(){
    return _prefs?.getString("Home");
  } 
}