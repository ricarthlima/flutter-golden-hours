import 'package:flutter/material.dart';
import 'package:time_counter/helpers/diference_time_helper.dart';
import 'package:time_counter/models/task_model.dart';
import 'package:time_counter/values/todo_localization.dart';

class HomeListTaskItem extends StatefulWidget {
  final Task task;
  Function deleteTask;
  Function editTask;
  HomeListTaskItem({
    this.task,
    this.deleteTask,
    this.editTask,
  });

  @override
  _HomeListTaskItemState createState() => _HomeListTaskItemState();
}

class _HomeListTaskItemState extends State<HomeListTaskItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(7),
      margin: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: widget.task.active ? Colors.purple[50] : Colors.grey[100],
        border: Border.all(
          color: widget.task.active ? Colors.purple : Colors.grey,
          width: 3,
        ),
        borderRadius: BorderRadius.circular(7),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Icon(
              //   Icons.adjust_outlined,
              //   size: 22,
              // ),
              // Padding(
              //   padding: EdgeInsets.only(left: 7),
              // ),
              Text(
                widget.task.name,
                style: TextStyle(
                  fontSize: 16,
                ),
              )
            ],
          ),
          Padding(padding: EdgeInsets.only(top: 5)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _getDuration(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 36,
                ),
              ),
              Row(
                children: [
                  GestureDetector(
                    child: Icon(
                      Icons.edit,
                      color: Colors.orange,
                    ),
                    onTap: () {
                      widget.editTask(widget.task);
                    },
                  ),
                  Padding(padding: EdgeInsets.only(left: 10)),
                  GestureDetector(
                    child: Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text(
                                "Deseja deletar " + widget.task.name + "?"),
                            content: Text(TodoLocalization.delete_task_warning),
                            actions: [
                              RaisedButton(
                                child: Text(TodoLocalization.yes),
                                onPressed: () {
                                  widget.deleteTask(widget.task.id);
                                  Navigator.pop(context);
                                },
                              ),
                              RaisedButton(
                                color: Colors.purple,
                                child: Text(
                                  TodoLocalization.no,
                                  style: TextStyle(color: Colors.white),
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                  )
                ],
              )
            ],
          ),
        ],
      ),
    );
  }

  String _getDuration() {
    if (widget.task.active) {
      Duration temp = widget.task.lastTotal +
          widget.task.lastStart.difference(DateTime.now()).abs();
      return getDifferenceTime(temp).toString();
    } else {
      return getDifferenceTime(widget.task.lastTotal).toString();
    }
  }
}
