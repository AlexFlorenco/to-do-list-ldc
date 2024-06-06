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
  final _searchTaskEditingController = TextEditingController();
  String? _deadlineTaskValue;
  final FocusNode _searchFocusNode = FocusNode();
  final FocusNode _taskFocusNode = FocusNode();

  bool _isAddButton = true;
  bool _isSearching = false;
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
        backgroundColor:
            MediaQuery.platformBrightnessOf(context) == Brightness.light
                ? AppColor.primary
                : AppColor.primaryDark,
        title: const Text('Lista de Tarefas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              _isSearching = !_isSearching;
              _searchFocusNode.requestFocus();
              _clearInputs();
              setState(() {});
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              _isSearching
                  ? Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          Expanded(
                            child: CustomTextFormField(
                              controller: _searchTaskEditingController,
                              label: 'Buscar tarefa',
                              onPressed: _clearInputs,
                              focusNode: _searchFocusNode,
                              onSubmit: () {
                                // _isSearching = false;
                                // setState(() {});
                              },
                              onChanged: (value) {
                                _toDoController.searchTask(value.trim());
                              },
                            ),
                          ),
                        ],
                      ),
                    )
                  : Container(),
              Expanded(
                child: _toDoController.toDoList.isEmpty
                    ? const EmptyWidget()
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(10, 20, 10, 150),
                        separatorBuilder: (_, __) => const SizedBox(height: 6),
                        itemCount: _toDoController.toDoList.length,
                        itemBuilder: (_, index) {
                          var task = _toDoController.toDoList[index];
                          return GestureDetector(
                            onTap: () {
                              _taskFocusNode.requestFocus();
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
                                      _toDoController.deleteTask(
                                          index: index,
                                          title: task.title,
                                          deadline: task.deadline);
                                      _clearInputs();
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackbarWidget(
                                          message:
                                              "Tarefa removida com sucesso!",
                                          context: context,
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
              ),
            ],
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                  color: MediaQuery.platformBrightnessOf(context) ==
                          Brightness.light
                      ? AppColor.light
                      : AppColor.lightDark),
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
                                      _titleTaskEditingController.text.trim(),
                                      _deadlineTaskValue,
                                    )
                                  : _toDoController.updateTask(
                                      _deadlineTaskValue,
                                      index: _selectedTaskIndex!,
                                      title: _titleTaskEditingController.text
                                          .trim(),
                                      status: _selectedTask!.status,
                                      isCompleted: _selectedTask!.isCompleted,
                                      isSearching: _isSearching,
                                    );
                              _isAddButton
                                  ? ScaffoldMessenger.of(context).showSnackBar(
                                      SnackbarWidget(
                                        message: "Tarefa criada com sucesso!",
                                        context: context,
                                      ),
                                    )
                                  : ScaffoldMessenger.of(context).showSnackBar(
                                      SnackbarWidget(
                                        message:
                                            "Tarefa atualizada com sucesso!",
                                        context: context,
                                      ),
                                    );
                            }
                            _isSearching = false;
                            _clearInputs();
                          },
                          controller: _titleTaskEditingController,
                          onPressed: _clearInputs,
                          label: _isAddButton ? 'Nova tarefa' : 'Editar tarefa',
                          focusNode: _taskFocusNode,
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
                                  _titleTaskEditingController.text.trim(),
                                  _deadlineTaskValue,
                                );
                                _isSearching = false;
                                _clearInputs();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackbarWidget(
                                    message: "Tarefa criada com sucesso!",
                                    context: context,
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
                                  title:
                                      _titleTaskEditingController.text.trim(),
                                  status: _selectedTask!.status,
                                  isCompleted: _selectedTask!.isCompleted,
                                  isSearching: _isSearching,
                                );
                                _isSearching = false;
                                _clearInputs();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackbarWidget(
                                    message: "Tarefa atualizada com sucesso!",
                                    context: context,
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
    _searchTaskEditingController.clear();
    _deadlineTaskValue = null;
    _isAddButton = true;
    _toDoController.getToDoList();
  }
}
