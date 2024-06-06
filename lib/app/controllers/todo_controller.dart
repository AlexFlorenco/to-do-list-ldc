import 'dart:developer';

import 'package:flutter/material.dart';
import '../models/task.dart';
import '../services/i_todo_service.dart';
import 'i_todo_controller.dart';

class ToDoController extends ChangeNotifier implements IToDoController {
  static ToDoController? _instance;
  final IToDoService toDoService;

  // Construtor privado para impedir instanciação direta
  ToDoController._(this.toDoService) {
    _toDoList = [];
  }

  // Instância única do controller
  static ToDoController getInstance(IToDoService toDoService) {
    _instance ??= ToDoController._(toDoService);
    return _instance!;
  }

  late List<Task> _toDoList;
  List<Task> get toDoList => _toDoList;

  @override
  void getToDoList() {
    _toDoList = toDoService.getToDoList();
    _updateAllLateTasks();
    notifyListeners();
  }

  @override
  void createTask(String title, String? deadline) {
    Task newTask = Task(
      title: title,
      deadline: deadline,
    );
    _addTaskToList(newTask);
    _updateAllLateTasks();
  }

  @override
  void updateTask(
    String? deadline, {
    required int index,
    required String title,
    required TaskStatus status,
    required bool isCompleted,
    required bool isSearching,
  }) {
    if (isSearching) {
      var list = toDoService.getToDoList();
      list.firstWhere((element) => element.title == _toDoList[index].title)
        ..title = title
        ..status = status
        ..isCompleted = isCompleted
        ..deadline = deadline;
      _toDoList = list;
    } else {
      _toDoList[index]
        ..title = title
        ..status = status
        ..isCompleted = isCompleted
        ..deadline = deadline;
    }

    _updateAllLateTasks();
    _saveToDoList();
  }

  @override
  void deleteTask({
    required int index,
    required String title,
    String? deadline,
  }) {
    var list = toDoService.getToDoList();
    bool removed = false;
    list.removeWhere(
      (element) {
        if (!removed &&
            element.title == title &&
            element.deadline == deadline) {
          removed = true;
          return true;
        }
        return false;
      },
    );
    _toDoList = list;
    _saveToDoList();
  }

  @override
  void finishTask(int index, String title, String? deadline) {
    var list = toDoService.getToDoList();
    list.firstWhere(
        (element) => element.title == title && element.deadline == deadline)
      ..isCompleted = true
      ..status = TaskStatus.Concluida;
    _toDoList = list;
    _saveToDoList();
  }

  @override
  void restoreTask(int index, String title, String? deadline) {
    var list = toDoService.getToDoList();
    list.firstWhere(
        (element) => element.title == title && element.deadline == deadline)
      ..isCompleted = false
      ..status = TaskStatus.Criada;
    _toDoList = list;
    _updateAllLateTasks();
    _saveToDoList();

    // _toDoList[index].isCompleted = false;
    // Task task = _toDoList.removeAt(index);
    // _toDoList.insert(0, task);
    // _updateAllLateTasks();
    // _saveToDoList();
  }

  @override
  void searchTask(String title) {
    log("searchTask: $title");
    if (title == "") {
      return getToDoList();
    }
    _toDoList = toDoService.getToDoList();
    List<Task> searchList = _toDoList
        .where((task) => task.title.toLowerCase().contains(title.toLowerCase()))
        .toList();
    searchList.isNotEmpty ? _toDoList = searchList : _toDoList = [];
    notifyListeners();
  }

  void _addTaskToList(Task task) {
    var list = toDoService.getToDoList();
    list.add(task);
    _toDoList = list;
    _saveToDoList();
  }

  void _saveToDoList() {
    _sortListByDate();
    _sortListByStatusCompleted();

    toDoService.saveToDoList(_toDoList);
    notifyListeners();
  }

  // Converte uma data no formato de string 'yyyy-MM-dd' para DateTime
  DateTime _parseDate(String date) {
    var parts = date.split('-');
    return DateTime(
      int.parse(parts[0]),
      int.parse(parts[1]),
      int.parse(parts[2]),
    );
  }

  // Ordena a lista por prazo
  void _sortListByDate() {
    _toDoList.sort((a, b) {
      DateTime dateA = DateTime(3000);
      DateTime dateB = DateTime(3000);

      if (a.deadline != null && !a.isCompleted) {
        dateA = _parseDate(a.deadline!);
      }
      if (b.deadline != null && !b.isCompleted) {
        dateB = _parseDate(b.deadline!);
      }
      return dateA.compareTo(dateB);
    });
  }

  // Ordena a lista por status de conclusão
  void _sortListByStatusCompleted() {
    _toDoList.sort((a, b) =>
        (a.isCompleted == b.isCompleted) ? 0 : (a.isCompleted ? 1 : -1));
  }

  // Atualiza o status das tarefas atrasadas na lista
  void _updateAllLateTasks() {
    _toDoList.asMap().forEach((index, task) {
      if (task.deadline != null && !task.isCompleted) {
        if (_parseDate(task.deadline!).compareTo(DateTime(DateTime.now().year,
                DateTime.now().month, DateTime.now().day)) ==
            -1) {
          _toDoList[index].status = TaskStatus.Atrasada;
        }
      }
    });
  }
}
