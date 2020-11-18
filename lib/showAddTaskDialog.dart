import 'package:flutter/material.dart';
import 'package:time_counter/helpers/local_data_manager.dart';
import 'package:time_counter/values/todo_localization.dart';
import 'package:uuid/uuid.dart';

import 'models/task_model.dart';

showAddTaskDialog({
  @required BuildContext context,
  @required Function functionRefreshList,
}) {
  TextEditingController nameController = TextEditingController();
  showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(TodoLocalization.add_dialog_new_title),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: TodoLocalization.add_dialog_text_name,
                        labelStyle: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      keyboardType: TextInputType.text,
                    )
                  ],
                ),
              ),
              actions: [
                RaisedButton(
                    child: Text(
                      TodoLocalization.add_dialog_add_button_title,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    color: Colors.purple,
                    onPressed: () {
                      _verifyEnter(
                        context: context,
                        functionRefreshList: functionRefreshList,
                        nameTask: nameController.text,
                      );
                    })
              ],
            );
          },
        );
      });
}

_verifyEnter(
    {@required BuildContext context,
    @required Function functionRefreshList,
    @required String nameTask}) async {
  LocalDataManager ldm = LocalDataManager();
  ldm.addLocalTask(
    new Task(
      id: Uuid().v1(),
      name: nameTask,
      lastTotal: DateTime.now().difference(DateTime.now()),
      lastStart: DateTime.now(),
      active: true,
    ),
  );

  functionRefreshList();
  Navigator.pop(context);
}
