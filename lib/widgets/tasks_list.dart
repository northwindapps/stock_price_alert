import 'package:flutter/material.dart';
import 'package:stock_price_checker_app/widgets/task_tile.dart';
import 'package:provider/provider.dart';
import 'package:stock_price_checker_app/models/task_data.dart';

class TasksList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<TaskData>(
      builder: (context, taskData, child) {
        return ListView.builder(
          itemBuilder: (context, index) {
            final task = taskData.tasks[index];
            return TaskTile(
              taskTitle:
                  task.name, // Non-nullable since task.name can't be null
              isChecked:
                  task.isDone, // Non-nullable since task.isDone can't be null
              checkboxCallback: (bool checkboxState) {
                // Annotated with bool
                taskData.updateTask(task);
              },
              longPressCallback: () {
                // No need to specify a return type here
                taskData.deleteTask(task);
              },
            );
          },
          itemCount: taskData.taskCount,
        );
      },
    );
  }
}
