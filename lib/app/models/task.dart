// ignore: constant_identifier_names
enum TaskStatus { Criada, Iniciada, Concluida, Atrasada }

class Task {
  String title;
  String? deadline;
  TaskStatus status;
  bool isCompleted;

  Task({
    required this.title,
    this.deadline,
    this.status = TaskStatus.Criada,
    this.isCompleted = false,
  });

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      title: map['title'],
      deadline: map['deadline'],
      status: TaskStatus.values[map['status'] ?? 0],
      isCompleted: map['isCompleted'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'deadline': deadline,
      'status': status.index,
      'isCompleted': isCompleted,
    };
  }
}
