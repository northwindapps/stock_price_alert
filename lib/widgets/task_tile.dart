import 'package:flutter/material.dart';

class TaskTile extends StatelessWidget {
  final bool isChecked;
  final Row taskTitle;
  final Function checkboxCallback;
  final Function longPressCallback;

  TaskTile({
    required this.isChecked,
    required this.taskTitle,
    required this.checkboxCallback,
    required this.longPressCallback,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onLongPress: () => longPressCallback(),
      title: taskTitle,
      trailing: Checkbox(
        activeColor: Colors.lightBlueAccent,
        value: isChecked,
        onChanged: (newValue) {
          checkboxCallback(
              newValue); // Pass the newValue which is of type bool?
        },
      ),
    );
  }
}
