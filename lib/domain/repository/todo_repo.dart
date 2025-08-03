/* 

TO DO REPOSITORY

Here you can define what the app can do.

*/

import 'package:todo_app/domain/models/todo.dart';

abstract class TodoRepo {
  // get a list of todos
  Future<List<Todo>> getTodos();

  // add a new todo
  Future<void> addTodo(Todo newTodo);

  // update existing todo
  Future<void> updateTodo(Todo todo);

  // delete a todo
  Future<void> deleteTodo(Todo todo);
}


/*

Notes:

- the repo in the domain layer outlines what operations the app can do, but 
it doesn't worry about specific implementation details. That's for the data 
layer.

- Technology Agnostic: independent of any technology or framework.

*/