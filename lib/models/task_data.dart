import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:stock_price_checker_app/models/task.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:collection';

class TaskData extends ChangeNotifier {
  List<Task> _tasks = [];
  int state = 0;

  // Constructor
  TaskData() {
    _loadTasksFromStorage();
  }

  // Method to load tasks from shared storage
  Future<void> _loadTasksFromStorage() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String>? taskStrings = prefs.getStringList('tasks');

    if (taskStrings != null) {
      List<Map<String, dynamic>> jsonData = taskStrings
          .map((taskString) => json.decode(taskString))
          .cast<Map<String, dynamic>>()
          .toList();
      List names = jsonData.map((item) => item["name"]).toList();
      _tasks.addAll(names.map((nameElement) => Task(name: nameElement)));
      print(names);
      notifyListeners();
    }
  }

  Future<void> saveTasksToStorage() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String> taskStrings = _tasks
        .map((task) => task.toJson())
        .toList()
        .map((json) => jsonEncode(json))
        .toList();
    prefs.setStringList('tasks', taskStrings);
  }

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
