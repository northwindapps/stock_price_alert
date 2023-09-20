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
            final text =
                task.name + ' ' + task.lowerLimit + ' ' + task.higherLimit;
            return TaskTile(
              taskTitle: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    task.name,
                    style: TextStyle(
                      color: const Color.fromARGB(
                          255, 71, 60, 60), // Change color as needed
                    ),
                  ),
                  Text(
                    task.lowerLimit,
                    style: TextStyle(
                      color: Color.fromARGB(
                          255, 143, 197, 241), // Change color as needed
                    ),
                  ),
                  Text(
                    task.higherLimit,
                    style: TextStyle(
                      color: const Color.fromARGB(
                          255, 255, 138, 130), // Change color as needed
                    ),
                  ),
                ],
              ),

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
