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
  void updateTask(String? deadline,
      {required int index,
      required String title,
      required TaskStatus status,
      required bool isCompleted}) {
    _toDoList[index].title = title;
    _toDoList[index].status = status;
    _toDoList[index].isCompleted = isCompleted;
    if (deadline != null) _toDoList[index].deadline = deadline;

    _updateAllLateTasks();
    _saveToDoList();
  }

  @override
  void deleteTask({required int index}) {
    _toDoList.removeAt(index);
    _saveToDoList();
  }

  @override
  void finishTask(int index) {
    _toDoList[index].isCompleted = true;
    Task task = _toDoList.removeAt(index);
    _toDoList.add(task);

    _saveToDoList();
  }

  @override
  void restoreTask(int index) {
    _toDoList[index].isCompleted = false;
    Task task = _toDoList.removeAt(index);
    _toDoList.insert(0, task);
    _updateAllLateTasks();
    _saveToDoList();
  }

  void _addTaskToList(Task task) {
    _toDoList.add(task);
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
