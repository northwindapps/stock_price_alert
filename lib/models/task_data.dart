import 'package:flutter/foundation.dart';
import 'package:stock_price_checker_app/models/task.dart';
import 'dart:collection';

class TaskData extends ChangeNotifier {
  List<Task> _tasks = [
    Task(name: 'Buy milk'),
    Task(name: 'Buy eggs'),
    Task(name: 'Buy bread'),
  ];

  int state = 0;

  String _displayText = 'Choose one from them.';

  String get displayText => _displayText;

  UnmodifiableListView<Task> get tasks {
    return UnmodifiableListView(_tasks);
  }

  int get taskCount {
    return _tasks.length;
  }

  void setTitle(String newTitle) {
    _displayText = newTitle;
  }

  void addTask(String newTaskTitle) {
    if (newTaskTitle == null) {
      print('String is null');
    } else {
      final task = Task(name: newTaskTitle);
      _tasks.add(task);
    }

    displayText;
    notifyListeners();
  }

  void addState() {
    state += 1;
    notifyListeners();
  }

  void resetState() {
    state = 0;
    notifyListeners();
  }

  void updateTask(Task task) {
    task.toggleDone();
    notifyListeners();
  }

  void deleteTask(Task task) {
    _tasks.remove(task);
    notifyListeners();
  }
}
