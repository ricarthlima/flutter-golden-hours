import 'package:flutter/material.dart';
import 'package:time_counter/helpers/diference_time_helper.dart';
import 'package:time_counter/models/task_model.dart';
import 'package:time_counter/values/todo_localization.dart';
import 'package:toast/toast.dart';

// ignore: must_be_immutable
class HomeListTaskItem extends StatefulWidget {
  final Task task;
  Function deleteTask;
  Function editTask;
  Function resetTask;
  HomeListTaskItem({this.task, this.deleteTask, this.editTask, this.resetTask});

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
        crossAxisAlignment: CrossAxisAlignment.start,
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
                _getCustomTime(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 36,
                ),
              ),
              Row(
                children: [
                  GestureDetector(
                    child: Icon(
                      Icons.refresh_rounded,
                      color: Colors.blue,
                    ),
                    onTap: () {
                      _showResetAlertDialog(context);
                    },
                    onLongPress: () {
                      Toast.show("Zerar o contador", context);
                    },
                  ),
                  Padding(padding: EdgeInsets.only(left: 10)),
                  GestureDetector(
                    child: Icon(
                      Icons.edit,
                      color: Colors.orange,
                    ),
                    onTap: () {
                      widget.editTask(widget.task);
                    },
                    onLongPress: () {
                      Toast.show("Editar a tarefa", context);
                    },
                  ),
                  Padding(padding: EdgeInsets.only(left: 10)),
                  GestureDetector(
                    child: Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                    onLongPress: () {
                      Toast.show("Excluir a tarefa", context);
                    },
                    onTap: () {
                      _showDeletAlertDialog(context);
                    },
                  )
                ],
              )
            ],
          ),
          (widget.task.taskValue != 0)
              ? Text(
                  "R\$ " + _getValue().toStringAsPrecision(2),
                )
              : Container(),
          (widget.task.durationHistory != null &&
                  widget.task.durationHistory.isNotEmpty)
              ? Padding(
                  padding: EdgeInsets.only(top: 5),
                  child: Row(
                    children: [
                      Text(
                        "Total: " +
                            _getCustomTime(
                              addSeconds: widget.task.getTotalHistoric(),
                            ) +
                            " | Média: " +
                            getDifferenceTime(Duration(
                                    seconds: widget.task.getMediumHistoric()))
                                .toString(),
                        style: TextStyle(fontSize: 10, color: Colors.grey),
                      )
                    ],
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  Future _showResetAlertDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Deseja zerar '" + widget.task.name + "'?"),
          content: Text(TodoLocalization.delete_task_warning),
          actions: [
            ElevatedButton(
              child: Text(TodoLocalization.yes),
              onPressed: () {
                widget.resetTask(widget.task.id);
                Navigator.pop(context);
              },
            ),
            ElevatedButton(
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.grey)),
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
  }

  Future _showDeletAlertDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Deseja deletar '" + widget.task.name + "'?"),
          content: Text(TodoLocalization.delete_task_warning),
          actions: [
            ElevatedButton(
              child: Text(TodoLocalization.yes),
              onPressed: () {
                widget.deleteTask(widget.task.id);
                Navigator.pop(context);
              },
            ),
            ElevatedButton(
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.grey)),
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
  }

  String _getCustomTime({int addSeconds}) {
    if (widget.task.active) {
      Duration temp = widget.task.lastTotal +
          widget.task.lastStart.difference(DateTime.now()).abs();
      if (addSeconds != null) {
        temp = temp + Duration(seconds: addSeconds);
      }
      return getDifferenceTime(temp).toString();
    } else {
      if (addSeconds != null) {
        return getDifferenceTime(
                widget.task.lastTotal + Duration(seconds: addSeconds))
            .toString();
      } else {
        return getDifferenceTime(widget.task.lastTotal).toString();
      }
    }
  }

  Duration _getDuration() {
    if (widget.task.active) {
      return widget.task.lastTotal +
          widget.task.lastStart.difference(DateTime.now()).abs();
    } else {
      return widget.task.lastTotal;
    }
  }

  double _getValue() {
    return (widget.task.taskValue / 3600) * _getDuration().inSeconds;
  }
}
