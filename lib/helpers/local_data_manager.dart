import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:time_counter/models/task_model.dart';
import 'package:time_counter/values/preferences_keys.dart';

class LocalDataManager {
  addLocalTask(Task task) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<Task> list = await getLocalListTask();
    list.add(task);
    prefs.setString(PreferencesKeys.listTasks, json.encode(list));
  }

  Future<List<Task>> getLocalListTask() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var result = prefs.getString(PreferencesKeys.listTasks);
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
    prefs.setString(PreferencesKeys.listTasks, json.encode(listTask));
  }

  printData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var result = prefs.getString(PreferencesKeys.listTasks);
    print(result);
  }
}
