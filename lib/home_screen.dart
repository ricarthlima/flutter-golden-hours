import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:time_counter/helpers/local_data_manager.dart';
import 'package:time_counter/partials/home_list_task_item.dart';
import 'package:time_counter/showAddTaskDialog.dart';
import 'package:time_counter/values/todo_localization.dart';
import 'package:vibration/vibration.dart';

import 'models/task_model.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with AfterLayoutMixin<HomeScreen> {
  List<Task> listTask = List<Task>();

  @override
  void initState() {
    _refresh();

    super.initState();
  }

  @override
  void afterFirstLayout(BuildContext context) {
    _refresh();
  }

  @override
  Widget build(BuildContext context) {
    _refresh();
    return Scaffold(
      appBar: AppBar(
        title: Text(TodoLocalization.appbar_title),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          showAddTaskDialog(
            context: context,
            functionRefreshList: _refresh,
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.today), title: Text("Só hoje")),
          BottomNavigationBarItem(
              icon: Icon(Icons.next_week), title: Text("Essa semana")),
          BottomNavigationBarItem(
              icon: Icon(Icons.timer), title: Text("Todo o tempo"))
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: ListView(
          children: [
            Text(
              TodoLocalization.home_helper_text,
              style: TextStyle(
                fontSize: 14,
                color: Colors.purple,
              ),
              textAlign: TextAlign.center,
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 6, 0, 10),
              child: Divider(
                color: Colors.purple,
              ),
            ),
            for (Task itemTask in this.listTask)
              GestureDetector(
                onTap: () {
                  Vibration.vibrate(duration: 50);
                  _changeActive(itemTask);
                },
                child: HomeListTaskItem(
                  task: itemTask,
                ),
              )
          ],
        ),
      ),
    );
  }

  _refresh() async {
    LocalDataManager ldm = LocalDataManager();
    List<Task> tempListTask = await ldm.getLocalListTask();
    setState(() {
      this.listTask = tempListTask;
    });
  }

  _changeActive(Task task) {
    int index = this.listTask.indexWhere((element) {
      return element.id == task.id;
    });
    if (task.active) {
      task.lastTotal =
          task.lastTotal + DateTime.now().difference(task.lastStart).abs();
      task.active = false;
    } else {
      task.lastStart = DateTime.now();
      task.active = true;
    }

    this.listTask[index] = task;

    LocalDataManager().setLocalListTask(this.listTask);
  }
}
