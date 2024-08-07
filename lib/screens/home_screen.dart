import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';
import 'add_task_screen.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task Manager'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => AddTaskScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: Provider.of<TaskProvider>(context, listen: false).fetchAndSetTasks(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            return Consumer<TaskProvider>(
              builder: (ctx, taskProvider, child) {
                return taskProvider.tasks.isEmpty
                    ? Center(child: Text('No tasks available.'))
                    : ListView.builder(
                  itemCount: taskProvider.tasks.length,
                  itemBuilder: (ctx, index) {
                    final task = taskProvider.tasks[index];
                    return ListTile(
                      title: Text(task.title),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(task.description),
                          Text('Due Date: ${DateFormat.yMMMd().format(task.dueDate)}'),
                        ],
                      ),
                      trailing: IconButton(
                        icon: Icon(
                          task.isCompleted ? Icons.check_box : Icons.check_box_outline_blank,
                        ),
                        onPressed: () {
                          taskProvider.toggleTaskStatus(index);
                        },
                      ),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (ctx) => AddTaskScreen(task: task),
                          ),
                        );
                      },
                      onLongPress: () {
                        if (task.id != null) {
                          taskProvider.removeTask(task.id!);
                        } else {
                          print('Task ID is null, cannot delete task.');
                        }
                      },
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
