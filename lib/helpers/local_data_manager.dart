import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:time_counter/models/task_model.dart';
import 'package:time_counter/models/local_user.dart';
import 'package:time_counter/values/preferences_keys.dart';

class LocalDataManager {
  addLocalTask(Task task) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<Task> list = await getLocalListTask();
    list.add(task);
    prefs.setString(PreferencesKeys().getListTaks(), json.encode(list));
  }

  Future<List<Task>> getLocalListTask() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var result = prefs.getString(PreferencesKeys().getListTaks());
    List<Task> list = <Task>[];
    if (result != null) {
      List<dynamic> listDy = json.decode(result);
      for (dynamic d in listDy) {
        list.add(Task.fromJson(d));
      }
    }
    return list;
  }

  setLocalListTask(List<Task> listTask) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(PreferencesKeys().getListTaks(), json.encode(listTask));
  }

  printData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var result = prefs.getString(PreferencesKeys().getListTaks());
    print(result);
  }

  Future<bool> isUserInformationNull() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var result = prefs.getString(PreferencesKeys.localUserData);
    if (result == null) {
      return true;
    }
    return false;
  }

  saveLocalUser(LocalUser user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(PreferencesKeys.localUserData, json.encode(user.toJson()));
  }

  Future<LocalUser> getLocalUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final posUser = prefs.getString(PreferencesKeys.localUserData);

    if (posUser != null) {
      return LocalUser.fromJson(json.decode(posUser));
    }
    return null;
  }
}
