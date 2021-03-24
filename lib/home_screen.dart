import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:time_counter/helpers/dialogs.dart';
import 'package:time_counter/helpers/local_data_manager.dart';
import 'package:time_counter/pages/signup_page/signup_page.dart';
import 'package:time_counter/partials/drawer.dart';
import 'package:time_counter/partials/home_list_task_item.dart';
import 'package:time_counter/partials/showAddTaskDialog.dart';
import 'package:time_counter/values/todo_localization.dart';
import 'package:vibration/vibration.dart';

import 'models/local_user.dart';
import 'models/task_model.dart';

class HomeScreen extends StatefulWidget {
  final LocalUser localUser;
  HomeScreen({this.localUser});
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with AfterLayoutMixin<HomeScreen> {
  List<Task> listTask = <Task>[];
  LocalUser _localUser = LocalUser();

  String hints =
      "Dicas:\n- Use o botão flutuante para adicionar uma nova tarefa!" +
          "\n- Clique na tarefa para pausar ou retormar a contagem!" +
          "\n- Use o botão editar para alterar as propriedades da tarefa!" +
          "\n- Use o botão lixeira para excluir a tarefa!";

  @override
  void initState() {
    _getLocalUser();
    super.initState();
  }

  @override
  void afterFirstLayout(BuildContext context) {
    _refresh();
    _noUserVerification(context);
  }

  @override
  Widget build(BuildContext context) {
    _refresh();
    return Scaffold(
      appBar: AppBar(
        title: Text(TodoLocalization.appbar_title),
        actions: [
          IconButton(
              icon: Icon(Icons.lightbulb),
              onPressed: () {
                showDefaultDialog(
                    context: context, title: "Dicas!", content: hints);
              })
        ],
      ),
      drawer: getDrawerHome(context, _localUser),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          showAddTaskDialog(
            context: context,
            functionRefreshList: _refresh,
          );
        },
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: this.listTask.isEmpty
            ? Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 32, horizontal: 20),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 24),
                      child: Image.asset(
                        "assets/icon.png",
                        width: 64,
                      ),
                    ),
                    Text(
                      TodoLocalization.home_helper_text,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.purple,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(100, 6, 100, 10),
                      child: Divider(
                        color: Colors.purple,
                      ),
                    ),
                    Text(
                      hints,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    )
                  ],
                ),
              )
            : ReorderableListView(
                onReorder: (int oldIndex, int newIndex) {
                  _reoderList(oldIndex, newIndex);
                },
                padding: EdgeInsets.only(bottom: 64),
                children: [
                  for (int index = 0; index < this.listTask.length; index++)
                    GestureDetector(
                      key: Key('$index'),
                      onTap: () {
                        Vibration.vibrate(duration: 50);
                        _changeActive(this.listTask[index]);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2.5),
                        child: HomeListTaskItem(
                          task: this.listTask[index],
                          deleteTask: _deleteTask,
                          editTask: _editTask,
                          resetTask: _resetTask,
                        ),
                      ),
                    ),
                ],
              ),
      ),
    );
  }

  void _reoderList(int oldIndex, int newIndex) async {
    setState(() {
      if (oldIndex < newIndex) {
        newIndex -= 1;
      }
      final Task task = listTask.removeAt(oldIndex);
      listTask.insert(newIndex, task);
    });
    LocalDataManager().setLocalListTask(this.listTask);
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

  _deleteTask(String idTask) {
    this.listTask.removeWhere((element) {
      return element.id == idTask;
    });
    LocalDataManager().setLocalListTask(this.listTask);
  }

  _editTask(Task task) {
    showAddTaskDialog(
        context: context, functionRefreshList: _refresh, editingTask: task);
  }

  _resetTask(String idTask) {
    this.listTask.firstWhere((element) => element.id == idTask).reset();
    LocalDataManager().setLocalListTask(this.listTask);
    LocalDataManager().printData();
  }

  _noUserVerification(BuildContext context) {
    LocalDataManager().isUserInformationNull().then((value) {
      if (value) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => SignUpPage()));
      }
    });
  }

  _getLocalUser() {
    this._localUser = widget.localUser;
    if (this._localUser == null) {
      this._localUser = LocalUser(avatarId: 0, email: "@@@", name: "Dotcode");
    }

    LocalDataManager().getLocalUser().then((value) {
      setState(() {
        this._localUser = value;
      });
    });
  }
}
