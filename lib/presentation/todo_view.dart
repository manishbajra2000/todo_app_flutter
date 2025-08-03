/*

TO DO VIEW: responsible for UI

- use BlocBuilder

*/

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/domain/models/todo.dart';
import 'package:todo_app/presentation/todo_cubit.dart';

class TodoView extends StatelessWidget {
  const TodoView({super.key});

  // show dialog box for user to type
  void _showAddTodoBox(BuildContext context) {
    final todoCubit = context.read<TodoCubit>();
    final textController = TextEditingController();
    ValueNotifier<bool> isTextNotEmpty = ValueNotifier(false);
    TodoPriority selectedPriority = TodoPriority.medium;
    DateTime? selectedDueDate;

    textController.addListener(() {
      isTextNotEmpty.value = textController.text.trim().isNotEmpty;
    });

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: const [
              Icon(Icons.add_task, color: Colors.deepPurple),
              SizedBox(width: 8),
              Text(
                'Add Todo',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: textController,
                  autofocus: true,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Enter todo',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    filled: true,
                    fillColor: Colors.grey[50],
                    prefixIcon: const Icon(
                      Icons.edit_note_rounded,
                      color: Colors.deepPurple,
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.purple[50],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.flag,
                        size: 20,
                        color: Colors.deepPurple,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: DropdownButton<TodoPriority>(
                          value: selectedPriority,
                          isExpanded: true,
                          underline: const SizedBox(),
                          onChanged: (value) =>
                              setState(() => selectedPriority = value!),
                          items: TodoPriority.values
                              .map(
                                (p) => DropdownMenuItem(
                                  value: p,
                                  child: Text(
                                    p.name[0].toUpperCase() +
                                        p.name.substring(1),
                                    style: TextStyle(
                                      color: p == TodoPriority.high
                                          ? Colors.red
                                          : p == TodoPriority.medium
                                          ? Colors.orange
                                          : Colors.green,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.purple[50],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.calendar_today,
                        size: 20,
                        color: Colors.deepPurple,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          selectedDueDate == null
                              ? 'No due date'
                              : 'Due: '
                                    '${selectedDueDate!.toLocal().year}-${selectedDueDate!.toLocal().month.toString().padLeft(2, '0')}-${selectedDueDate!.toLocal().day.toString().padLeft(2, '0')}',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: selectedDueDate ?? DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          );
                          if (picked != null)
                            setState(() => selectedDueDate = picked);
                        },
                        child: Container(
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Colors.deepPurple, // match text color
                                width: 2,
                              ),
                            ),
                          ),
                          child: const Text(
                            'Pick Date',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.deepPurple,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ValueListenableBuilder<bool>(
              valueListenable: isTextNotEmpty,
              builder: (context, enabled, _) => ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: enabled
                    ? () {
                        todoCubit.addTodo(
                          textController.text.trim(),
                          priority: selectedPriority,
                          dueDate: selectedDueDate,
                        );
                        Navigator.of(context).pop();
                      }
                    : null,
                child: const Text('Add', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // show dialog box for editing a todo
  void _showEditTodoBox(BuildContext context, Todo todo) {
    final todoCubit = context.read<TodoCubit>();
    final textController = TextEditingController(text: todo.text);
    TodoPriority selectedPriority = todo.priority;
    DateTime? selectedDueDate = todo.dueDate;
    ValueNotifier<bool> isTextNotEmpty = ValueNotifier(
      textController.text.trim().isNotEmpty,
    );

    textController.addListener(() {
      isTextNotEmpty.value = textController.text.trim().isNotEmpty;
    });

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: const [
              Icon(Icons.edit, color: Colors.deepPurple),
              SizedBox(width: 8),
              Text('Edit Todo', style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: textController,
                  autofocus: true,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Edit todo',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    filled: true,
                    fillColor: Colors.grey[50],
                    prefixIcon: const Icon(
                      Icons.edit_note_rounded,
                      color: Colors.deepPurple,
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.purple[50],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.flag,
                        size: 20,
                        color: Colors.deepPurple,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: DropdownButton<TodoPriority>(
                          value: selectedPriority,
                          isExpanded: true,
                          underline: const SizedBox(),
                          onChanged: (value) =>
                              setState(() => selectedPriority = value!),
                          items: TodoPriority.values
                              .map(
                                (p) => DropdownMenuItem(
                                  value: p,
                                  child: Text(
                                    p.name[0].toUpperCase() +
                                        p.name.substring(1),
                                    style: TextStyle(
                                      color: p == TodoPriority.high
                                          ? Colors.red
                                          : p == TodoPriority.medium
                                          ? Colors.orange
                                          : Colors.green,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.purple[50],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.calendar_today,
                        size: 20,
                        color: Colors.deepPurple,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          selectedDueDate == null
                              ? 'No due date'
                              : 'Due: '
                                    '${selectedDueDate!.toLocal().year}-${selectedDueDate!.toLocal().month.toString().padLeft(2, '0')}-${selectedDueDate!.toLocal().day.toString().padLeft(2, '0')}',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: selectedDueDate ?? DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          );
                          if (picked != null)
                            setState(() => selectedDueDate = picked);
                        },
                        child: Container(
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Colors.deepPurple, // match text color
                                width: 2,
                              ),
                            ),
                          ),
                          child: const Text(
                            'Pick Date',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.deepPurple,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ValueListenableBuilder<bool>(
              valueListenable: isTextNotEmpty,
              builder: (context, enabled, _) => ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: enabled
                    ? () {
                        todoCubit.editTodo(
                          todo.id,
                          textController.text.trim(),
                          priority: selectedPriority,
                          dueDate: selectedDueDate,
                        );
                        Navigator.of(context).pop();
                      }
                    : null,
                child: const Text(
                  'Save',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // BUILD UI
  @override
  Widget build(BuildContext context) {
    final todoCubit = context.read<TodoCubit>();
    // Sorting/filtering state
    return _TodoViewWithSorting(
      todoCubit: todoCubit,
      showAddTodoBox: _showAddTodoBox,
      showEditTodoBox: _showEditTodoBox,
    );
  }
}

// Helper widget for sorting/filtering and displaying todos
class _TodoViewWithSorting extends StatefulWidget {
  final TodoCubit todoCubit;
  final void Function(BuildContext) showAddTodoBox;
  final void Function(BuildContext, Todo) showEditTodoBox;
  const _TodoViewWithSorting({
    required this.todoCubit,
    required this.showAddTodoBox,
    required this.showEditTodoBox,
  });
  @override
  State<_TodoViewWithSorting> createState() => _TodoViewWithSortingState();
}

class _TodoViewWithSortingState extends State<_TodoViewWithSorting> {
  String filter = 'All';
  String sortBy = 'Due Date';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => widget.showAddTodoBox(context),
      ),
      appBar: AppBar(
        title: const Text('Todos'),
        actions: [
          DropdownButton<String>(
            value: filter,
            onChanged: (v) => setState(() => filter = v!),
            items: [
              'All',
              'Active',
              'Completed',
            ].map((f) => DropdownMenuItem(value: f, child: Text(f))).toList(),
          ),
          DropdownButton<String>(
            value: sortBy,
            onChanged: (v) => setState(() => sortBy = v!),
            items: ['Due Date', 'Priority']
                .map((s) => DropdownMenuItem(value: s, child: Text('Sort: $s')))
                .toList(),
          ),
        ],
      ),
      body: BlocBuilder<TodoCubit, List<Todo>>(
        builder: (context, todos) {
          // Filter
          List<Todo> filtered = filter == 'All'
              ? todos
              : filter == 'Active'
              ? todos.where((t) => !t.isCompleted).toList()
              : todos.where((t) => t.isCompleted).toList();
          // Sort
          if (sortBy == 'Due Date') {
            filtered.sort((a, b) {
              if (a.dueDate == null && b.dueDate == null) return 0;
              if (a.dueDate == null) return 1;
              if (b.dueDate == null) return -1;
              return a.dueDate!.compareTo(b.dueDate!);
            });
          } else if (sortBy == 'Priority') {
            filtered.sort(
              (a, b) => a.priority.index.compareTo(b.priority.index),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: filtered.length,
            itemBuilder: (context, index) {
              final todo = filtered[index];
              Color priorityColor;
              switch (todo.priority) {
                case TodoPriority.high:
                  priorityColor = Colors.redAccent;
                  break;
                case TodoPriority.medium:
                  priorityColor = Colors.orangeAccent;
                  break;
                case TodoPriority.low:
                  priorityColor = Colors.green;
                  break;
              }
              return Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  title: Text(
                    todo.text,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      decoration: todo.isCompleted
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  ),
                  subtitle: Row(
                    children: [
                      Icon(Icons.flag, color: priorityColor, size: 18),
                      const SizedBox(width: 4),
                      Text(
                        todo.priority.name[0].toUpperCase() +
                            todo.priority.name.substring(1),
                        style: TextStyle(
                          color: priorityColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (todo.dueDate != null) ...[
                        const SizedBox(width: 16),
                        Icon(
                          Icons.calendar_today,
                          size: 16,
                          color: Colors.blueGrey,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${todo.dueDate!.toLocal().toString().split(' ')[0]}',
                          style: const TextStyle(color: Colors.blueGrey),
                        ),
                      ],
                    ],
                  ),
                  onTap: () => widget.showEditTodoBox(context, todo),
                  leading: Checkbox(
                    value: todo.isCompleted,
                    onChanged: (value) =>
                        widget.todoCubit.toggleCompletion(todo),
                    activeColor: priorityColor,
                  ),
                  trailing: IconButton(
                    icon: const Icon(
                      Icons.delete_outline,
                      color: Colors.redAccent,
                    ),
                    onPressed: () => widget.todoCubit.deleteTodo(todo),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
