/*

TO DO PAGE: responsible for providing cubit to the view (UI)

- use BlocProvider

*/

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/domain/repository/todo_repo.dart';
import 'package:todo_app/presentation/todo_cubit.dart';
import 'package:todo_app/presentation/todo_view.dart';

class TodoPage extends StatelessWidget {
  final TodoRepo todoRepo;
  final VoidCallback onToggleTheme;
  final ThemeMode themeMode;

  const TodoPage({
    super.key,
    required this.todoRepo,
    required this.onToggleTheme,
    required this.themeMode,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TodoCubit(todoRepo),
      child: TodoView(onToggleTheme: onToggleTheme, themeMode: themeMode),
    );
  }
}
