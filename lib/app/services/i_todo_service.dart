import '../models/task.dart';

abstract class IToDoService {
  List<Task> getToDoList();
  void saveToDoList(List<Task> toDoList);
}
