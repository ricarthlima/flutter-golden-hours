import 'package:flutter/material.dart';
import 'package:time_counter/helpers/local_data_manager.dart';
import 'package:time_counter/values/todo_localization.dart';
import 'package:uuid/uuid.dart';

import '../models/task_model.dart';

showAddTaskDialog({
  @required BuildContext context,
  @required Function functionRefreshList,
  Task editingTask,
}) {
  bool isEditing = false;

  if (editingTask == null) {
    editingTask = Task(
      active: true,
      id: Uuid().v1(),
      name: "",
    );
  } else {
    isEditing = true;
  }

  TextEditingController _nameController = TextEditingController();

  _nameController.text = editingTask.name;

  final _formKey = GlobalKey<FormState>();
  showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: !isEditing
                  ? Text(TodoLocalization.add_dialog_new_title)
                  : Text(TodoLocalization.add_dialog_edit_title),
              content: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: TodoLocalization.add_dialog_text_name,
                          labelStyle: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        keyboardType: TextInputType.name,
                        validator: (value) {
                          if (value.isEmpty) {
                            return "O título não pode ser vazio.";
                          }
                          if (value.length < 4) {
                            return "Use um título mais descritivo.";
                          }
                          return null;
                        },
                      )
                    ],
                  ),
                ),
              ),
              actions: [
                RaisedButton(
                    child: !isEditing
                        ? Text(
                            TodoLocalization.add_dialog_add_button_title,
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            TodoLocalization.add_dialog_edit_button_title,
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                    color: Colors.purple,
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        // Atribuir no Model
                        editingTask.name = _nameController.text;

                        _saveTask(
                          context: context,
                          functionRefreshList: functionRefreshList,
                          task: editingTask,
                          isEditing: isEditing,
                        );
                      }
                    })
              ],
            );
          },
        );
      });
}

_saveTask(
    {@required BuildContext context,
    @required Function functionRefreshList,
    @required Task task,
    @required bool isEditing}) async {
  LocalDataManager ldm = LocalDataManager();

  if (!isEditing) {
    ldm.addLocalTask(
      new Task(
        id: Uuid().v1(),
        name: task.name,
        lastTotal: DateTime.now().difference(DateTime.now()),
        lastStart: DateTime.now(),
        active: true,
      ),
    );
  } else {
    List<Task> listTask = await ldm.getLocalListTask();
    int index = listTask.indexWhere((element) {
      return element.id == task.id;
    });
    listTask[index] = task;
    ldm.setLocalListTask(listTask);
  }

  functionRefreshList();
  Navigator.pop(context);
}
