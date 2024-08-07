import 'package:flutter/material.dart';
import '../models/task.dart';
import '../helpers/db_helper.dart';

class TaskProvider with ChangeNotifier {
  List<Task> _tasks = [];

  List<Task> get tasks {
    return [..._tasks];
  }

  Future<void> fetchAndSetTasks() async {
    final dataList = await DBHelper().fetchTasks();
    _tasks = dataList;
    notifyListeners();
  }

  Future<void> addTask(Task task) async {
    final id = await DBHelper().insertTask(task);
    task = Task(
      id: id,
      title: task.title,
      description: task.description,
      dueDate: task.dueDate,
      isCompleted: task.isCompleted,
    );
    _tasks.add(task);
    notifyListeners();
  }

  Future<void> updateTask(Task task) async {
    await DBHelper().updateTask(task);
    final taskIndex = _tasks.indexWhere((t) => t.id == task.id);
    if (taskIndex >= 0) {
      _tasks[taskIndex] = task;
      notifyListeners();
    }
  }

  Future<void> removeTask(int id) async {
    await DBHelper().deleteTask(id);
    _tasks.removeWhere((task) => task.id == id);
    notifyListeners();
  }

  void toggleTaskStatus(int index) {
    _tasks[index].isCompleted = !_tasks[index].isCompleted;
    updateTask(_tasks[index]);
    notifyListeners();
  }
}
