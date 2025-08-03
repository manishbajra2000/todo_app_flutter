/*

TO DO MODEL 

This is what a to do object is.

--------------------------------------------------------------------------------

It has these properties:

- id
- text 
- isCompleted

--------------------------------------------------------------------------------


Methods:

- toggle completion on and off

*/

enum TodoPriority { high, medium, low }

class Todo {
  final int id;
  final String text;
  final bool isCompleted;
  final TodoPriority priority;
  final DateTime? dueDate;

  Todo({
    required this.id,
    required this.text,
    this.isCompleted = false, // initially, todo is incomplete
    this.priority = TodoPriority.medium,
    this.dueDate,
  });

  Todo toggleCompletion() {
    return copyWith(isCompleted: !isCompleted);
  }

  Todo copyWith({
    int? id,
    String? text,
    bool? isCompleted,
    TodoPriority? priority,
    DateTime? dueDate,
  }) {
    return Todo(
      id: id ?? this.id,
      text: text ?? this.text,
      isCompleted: isCompleted ?? this.isCompleted,
      priority: priority ?? this.priority,
      dueDate: dueDate ?? this.dueDate,
    );
  }
}
