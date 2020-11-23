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
  bool isShowingAdvanced = false;

  if (editingTask == null) {
    editingTask = Task(
      active: true,
      id: Uuid().v1(),
      name: "",
      taskValue: 0,
      lastTotal: DateTime.now().difference(DateTime.now()),
      lastStart: DateTime.now(),
    );
  } else {
    isEditing = true;
  }

  TextEditingController _nameController = TextEditingController();
  TextEditingController _valueController = TextEditingController();

  _nameController.text = editingTask.name;
  _valueController.text = editingTask.taskValue.toString();

  final _formKey = GlobalKey<FormState>();
  showModalBottomSheet(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return Container(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  !isEditing
                      ? TodoLocalization.add_dialog_new_title
                      : TodoLocalization.add_dialog_edit_title,
                  style: TextStyle(
                    color: Colors.purple,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(padding: EdgeInsets.only(bottom: 10)),
                Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            labelText: TodoLocalization.add_dialog_text_name,
                            labelStyle: TextStyle(
                              fontSize: 14,
                            ),
                            prefixIcon: Icon(Icons.chat_outlined),
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
                        ),
                        isShowingAdvanced
                            ? Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(bottom: 7),
                                  ),
                                  TextFormField(
                                    controller: _valueController,
                                    decoration: InputDecoration(
                                      labelText: "Quanto vale a hora?",
                                      labelStyle: TextStyle(fontSize: 14),
                                      prefixText: "R\$",
                                      prefixIcon: Icon(
                                        Icons.attach_money,
                                      ),
                                    ),
                                    keyboardType: TextInputType.number,
                                  )
                                ],
                              )
                            : Container(),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      //crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Switch(
                          value: isShowingAdvanced,
                          activeColor: Colors.purple,
                          activeTrackColor: Colors.purple[50],
                          onChanged: (value) {
                            setState(() {
                              isShowingAdvanced = value;
                            });

                            print(isShowingAdvanced);
                          },
                        ),
                        Text(
                          TodoLocalization.show_advanced_options,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.purple,
                          ),
                        )
                      ],
                    ),
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
                            editingTask.taskValue =
                                double.parse(_valueController.text);

                            _saveTask(
                              context: context,
                              functionRefreshList: functionRefreshList,
                              task: editingTask,
                              isEditing: isEditing,
                            );
                          }
                        })
                  ],
                )
              ],
            ),
          );
        });
      });
}

_saveTask(
    {@required BuildContext context,
    @required Function functionRefreshList,
    @required Task task,
    @required bool isEditing}) async {
  LocalDataManager ldm = LocalDataManager();

  if (!isEditing) {
    task.lastTotal = DateTime.now().difference(DateTime.now());
    task.lastStart = DateTime.now();
    ldm.addLocalTask(task);
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
