import 'dart:convert';

import '../core/singletons/shared_prefs.dart';
import '../models/task.dart';
import 'i_todo_service.dart';

class ToDoService implements IToDoService {
  @override
  List<Task> getToDoList() {
    List<String> toDoListString =
        SharedPrefs.instance.getStringList('toDoList') ?? [];

    List<Task> toDoList = toDoListString
        .map(
          (task) => Task.fromMap(json.decode(task)),
        )
        .toList();

    return toDoList;
  }

  @override
  void saveToDoList(List<Task> toDoList) {
    List<String> toDoListString = toDoList
        .map(
          (task) => jsonEncode(task.toMap()),
        )
        .toList();

    SharedPrefs.instance.setStringList('toDoList', toDoListString);
  }
}
