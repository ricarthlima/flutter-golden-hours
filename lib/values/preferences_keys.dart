import 'package:time_counter/helpers/is_debug.dart';

class PreferencesKeys {
  String getListTaks() {
    if (isInDebugMode()) {
      return "debug_list_tasks";
    } else {
      return "list_tasks";
    }
  }
}
