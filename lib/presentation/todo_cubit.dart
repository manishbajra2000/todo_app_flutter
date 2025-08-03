/*

TO DO CUBIT - simple state management 

Each cubit is a list of todos.

*/

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/domain/models/todo.dart';
import 'package:todo_app/domain/repository/todo_repo.dart';

class TodoCubit extends Cubit<List<Todo>> {
  // reference to repo
  final TodoRepo todoRepo;

  // Constructor initializes the cubit with an empty list
  TodoCubit(this.todoRepo) : super([]) {
    loadTodos();
  }

  // L O A D
  Future<void> loadTodos() async {
    // fetch list of todos from repo
    final todoList = await todoRepo.getTodos();

    // emit the fetch list as the new state
    emit(todoList);
  }

  Future<void> loadTodobyID(int id) async {
    final todo = await todoRepo.getTodoById(id);
    if (todo != null) {
      emit([todo]);
    } else {
      emit([]);
    }
  }

  // A D D
  Future<void> addTodo(
    String text, {
    TodoPriority priority = TodoPriority.medium,
    DateTime? dueDate,
  }) async {
    // create a new todo with unique id
    final newTodo = Todo(
      id: DateTime.now().millisecondsSinceEpoch,
      text: text,
      priority: priority,
      dueDate: dueDate,
    );

    // save the new todo to repo
    await todoRepo.addTodo(newTodo);

    // re-load
    loadTodos();
  }

  // D E L E T E
  Future<void> deleteTodo(Todo todo) async {
    // delete the provided todo from the repo
    await todoRepo.deleteTodo(todo);

    // re-load
    loadTodos();
  }

  // T O G G L E
  Future<void> toggleCompletion(Todo todo) async {
    // toggle the provided completion status of provided todo
    final updatedTodo = todo.toggleCompletion();

    // update the todo in repo with new completion status
    await todoRepo.updateTodo(updatedTodo);

    // re-load
    loadTodos();
  }

  Future<void> editTodo(
    int id,
    String newText, {
    TodoPriority? priority,
    DateTime? dueDate,
  }) async {
    // get the existing todo from repository
    final existingTodo = await todoRepo.getTodoById(id);
    if (existingTodo == null) return;

    // create updated todo
    final updatedTodo = existingTodo.copyWith(
      text: newText,
      priority: priority,
      dueDate: dueDate,
    );

    // update in repository
    await todoRepo.updateTodo(updatedTodo);

    // re-load
    loadTodos();
  }
}
