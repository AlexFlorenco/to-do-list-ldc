import '../models/task.dart';

abstract class IToDoController {
  void getToDoList();
  void createTask(String title, String? deadline);
  void updateTask(String? deadline,
      {required int index,
      required String title,
      required TaskStatus status,
      required bool isCompleted});
  void deleteTask({required int index});
  void finishTask(int index);
  void restoreTask(int index);
}
