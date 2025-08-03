/*

ISAR TO DO MODEL 

Converts todo model into isar todo model so that we can store in our isar db.

*/

import 'package:isar/isar.dart';
import 'package:todo_app/domain/models/todo.dart';

// to generate isar todo object, run: dart run build_runner build
part 'isar_todo.g.dart';

@collection
class TodoIsar {
  Id id = Isar.autoIncrement;
  late String text;
  late bool isCompleted;
  int priority = 1; // Default to medium
  DateTime? dueDate;

  // convert isar object -> pure todo object to use in our app
  Todo toDomain() {
    TodoPriority safePriority;
    if (priority >= 0 && priority < TodoPriority.values.length) {
      safePriority = TodoPriority.values[priority];
    } else {
      safePriority = TodoPriority.medium;
    }
    return Todo(
      id: id,
      text: text,
      isCompleted: isCompleted,
      priority: safePriority,
      dueDate: dueDate,
    );
  }

  // convert pure todo object -> isar object to store in isar db
  static TodoIsar fromDomain(Todo todo) {
    return TodoIsar()
      ..id = todo.id
      ..text = todo.text
      ..isCompleted = todo.isCompleted
      ..priority = todo.priority.index
      ..dueDate = todo.dueDate;
  }
}
