import '../models/task.dart';

abstract class IToDoController {
  void getToDoList();
  void createTask(String title, String? deadline);
  void updateTask(String? deadline,
      {required int index,
      required String title,
      required TaskStatus status,
      required bool isCompleted,
      required bool isSearching});
  void deleteTask(
      {required int index, required String title, String? deadline});
  void finishTask(int index, String title, String? deadline);
  void restoreTask(int index, String title, String? deadline);
  void searchTask(String title);
}
