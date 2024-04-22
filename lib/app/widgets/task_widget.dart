import 'package:flutter/material.dart';

import '../controllers/todo_controller.dart';
import '../core/singletons/app_colors.dart';
import '../models/task.dart';
import '../services/todo_service.dart';

class TaskWidget extends StatefulWidget {
  const TaskWidget({
    super.key,
    required this.index,
    required this.task,
  });

  final int index;
  final Task task;

  @override
  State<TaskWidget> createState() => _TaskWidgetState();
}

class _TaskWidgetState extends State<TaskWidget> {
  final ToDoController _toDoController =
      ToDoController.getInstance(ToDoService());

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColor.shade.withOpacity(0.5),
            spreadRadius: -3,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
        color: AppColor.light,
      ),
      child: ListTile(
        leading: Checkbox(
            value: widget.task.isCompleted,
            shape: const CircleBorder(),
            onChanged: (bool? value) {
              setState(() {
                if (value!) {
                  widget.task.isCompleted = true;
                  widget.task.status = TaskStatus.Concluida;
                  _toDoController.finishTask(widget.index);
                } else {
                  widget.task.isCompleted = false;
                  widget.task.status = TaskStatus.Criada;
                  _toDoController.restoreTask(widget.index);
                }
              });
            }),
        title: Row(
          children: [
            Expanded(
              child: Text(
                widget.task.title,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: TextStyle(
                  decoration: widget.task.isCompleted
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                ),
              ),
            ),
            const SizedBox(width: 14),
            GestureDetector(
              onTap: () {
                _updateStatus();
                _toDoController.updateTask(
                  widget.task.deadline,
                  index: widget.index,
                  title: widget.task.title,
                  status: widget.task.status,
                  isCompleted: widget.task.isCompleted,
                );
              },
              child: Container(
                color: AppColor.light,
                height: 24,
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: _getStatusColor(),
                      radius: 4,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      widget.task.status.toString().split('.').last,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.task.deadline != null)
              Text(
                (_formatDate(widget.task.deadline.toString())),
                style: TextStyle(
                  decoration: widget.task.isCompleted
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _updateStatus() {
    setState(() {
      switch (widget.task.status) {
        case TaskStatus.Criada:
          widget.task.status = TaskStatus.Iniciada;
          widget.task.isCompleted = false;
          break;
        case TaskStatus.Iniciada:
          widget.task.isCompleted = true;
          widget.task.status = TaskStatus.Concluida;
          break;
        case TaskStatus.Concluida:
          widget.task.isCompleted = false;
          widget.task.status = TaskStatus.Criada;
          break;
        case TaskStatus.Atrasada:
          widget.task.isCompleted = false;
          widget.task.status = TaskStatus.Iniciada;
          break;
      }
    });
  }

  Color _getStatusColor() {
    switch (widget.task.status) {
      case TaskStatus.Criada:
        return AppColor.shade;
      case TaskStatus.Iniciada:
        return AppColor.success;
      case TaskStatus.Concluida:
        return AppColor.primary;
      case TaskStatus.Atrasada:
        return AppColor.error;
    }
  }

  String _formatDate(String date) {
    return "${date.substring(8, 10)}/${date.substring(5, 7)}/${date.substring(0, 4)}";
  }
}
