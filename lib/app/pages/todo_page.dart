import 'package:flutter/material.dart';
import '../controllers/todo_controller.dart';
import '../core/singletons/app_colors.dart';
import '../models/task.dart';
import '../services/todo_service.dart';
import '../widgets/custom_icon_button_widget.dart';
import '../widgets/custom_text_form_field_widget.dart';
import '../widgets/empty_widget.dart';
import '../widgets/snackbar_widget.dart';
import '../widgets/task_widget.dart';

class ToDoPage extends StatefulWidget {
  const ToDoPage({super.key});

  @override
  State<ToDoPage> createState() => _ToDoPageState();
}

class _ToDoPageState extends State<ToDoPage> {
  final ToDoController _toDoController =
      ToDoController.getInstance(ToDoService());
  final _formKey = GlobalKey<FormState>();
  final _titleTaskEditingController = TextEditingController();
  String? _deadlineTaskValue;

  bool _isAddButton = true;
  int? _selectedTaskIndex;
  Task? _selectedTask;

  @override
  void initState() {
    super.initState();
    _toDoController.getToDoList();
    _toDoController.addListener(() {
      setState(() {});
    });
    _titleTaskEditingController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.primary,
        title: const Text('To Do List'),
      ),
      body: Stack(
        children: [
          _toDoController.toDoList.isEmpty
              ? const EmptyWidget()
              : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(10, 20, 10, 150),
                  separatorBuilder: (_, __) => const SizedBox(height: 6),
                  itemCount: _toDoController.toDoList.length,
                  itemBuilder: (_, index) {
                    var task = _toDoController.toDoList[index];
                    return GestureDetector(
                      onTap: () {
                        _selectedTaskIndex = index;
                        _selectedTask = task;
                        setState(() {
                          _isAddButton = false;
                        });
                        _titleTaskEditingController.text = task.title;
                        _deadlineTaskValue = task.deadline;
                      },
                      onLongPressStart: (touch) {
                        showMenu(
                          context: context,
                          position: RelativeRect.fromLTRB(
                            touch.globalPosition.dx,
                            touch.globalPosition.dy,
                            touch.globalPosition.dx,
                            touch.globalPosition.dy,
                          ),
                          items: [
                            PopupMenuItem(
                              child: const Text('Deletar'),
                              onTap: () {
                                _toDoController.deleteTask(index: index);
                                _clearInputs();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackbarWidget(
                                    message: "Tarefa removida com sucesso!",
                                  ),
                                );
                              },
                            ),
                          ],
                        );
                      },
                      child: TaskWidget(index: index, task: task),
                    );
                  },
                ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(color: AppColor.light),
              child: SafeArea(
                child: Row(
                  children: [
                    Expanded(
                      child: Form(
                        key: _formKey,
                        child: CustomTextFormField(
                          onSubmit: () {
                            if (_formKey.currentState!.validate()) {
                              _isAddButton
                                  ? _toDoController.createTask(
                                      _titleTaskEditingController.text,
                                      _deadlineTaskValue,
                                    )
                                  : _toDoController.updateTask(
                                      _deadlineTaskValue,
                                      index: _selectedTaskIndex!,
                                      title: _titleTaskEditingController.text,
                                      status: _selectedTask!.status,
                                      isCompleted: _selectedTask!.isCompleted,
                                    );
                              _isAddButton
                                  ? ScaffoldMessenger.of(context).showSnackBar(
                                      SnackbarWidget(
                                          message:
                                              "Tarefa criada com sucesso!"),
                                    )
                                  : ScaffoldMessenger.of(context).showSnackBar(
                                      SnackbarWidget(
                                        message:
                                            "Tarefa atualizada com sucesso!",
                                      ),
                                    );
                            }
                            _clearInputs();
                          },
                          controller: _titleTaskEditingController,
                          onPressed: _clearInputs,
                          label: _isAddButton ? 'Nova tarefa' : 'Editar tarefa',
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    GestureDetector(
                      child: const Icon(Icons.calendar_month, size: 30),
                      onTap: () => _showDatePicker(),
                    ),
                    const SizedBox(width: 16),
                    _isAddButton
                        ? CustomIconButton(
                            icon: Icons.add,
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                _toDoController.createTask(
                                  _titleTaskEditingController.text,
                                  _deadlineTaskValue,
                                );
                                _clearInputs();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackbarWidget(
                                    message: "Tarefa criada com sucesso!",
                                  ),
                                );
                              }
                            },
                          )
                        : CustomIconButton(
                            icon: Icons.update,
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                _toDoController.updateTask(
                                  _deadlineTaskValue,
                                  index: _selectedTaskIndex!,
                                  title: _titleTaskEditingController.text,
                                  status: _selectedTask!.status,
                                  isCompleted: _selectedTask!.isCompleted,
                                );
                                _clearInputs();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackbarWidget(
                                    message: "Tarefa atualizada com sucesso!",
                                  ),
                                );
                              }
                            },
                          ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _showDatePicker() async {
    DateTime? datePicked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2030),
      locale: const Locale('pt', 'BR'),
    );

    if (datePicked != null) {
      _deadlineTaskValue = datePicked.toString().split(" ")[0];
    }
  }

  _clearInputs() {
    _titleTaskEditingController.clear();
    _deadlineTaskValue = null;
    _isAddButton = true;
  }
}
