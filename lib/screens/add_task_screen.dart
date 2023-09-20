import 'package:flutter/material.dart';
import 'package:stock_price_checker_app/models/task.dart';
import 'package:provider/provider.dart';
import 'package:stock_price_checker_app/models/task_data.dart';

class AddTaskScreen extends StatelessWidget {
  static TextEditingController titleController = TextEditingController();
  static TextEditingController bodyController = TextEditingController();
  static TextEditingController body2Controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<TaskData>(context, listen: true).state;
    String? newTaskTitle;
    String? newTaskBody;
    String? newTaskBody2;

    void clearTextField() {
      titleController.clear();
      bodyController.clear();
      body2Controller.clear();
    }

    Widget buildTaskInput() {
      return TextField(
        controller: titleController,
        autofocus: true,
        textAlign: TextAlign.center,
        onChanged: (newText) {
          newTaskTitle = newText;
        },
      );
    }

    Widget buildTaskInput2() {
      return TextField(
        controller: bodyController,
        autofocus: true,
        textAlign: TextAlign.center,
        onChanged: (newText) {
          newTaskBody = newText;
        },
      );
    }

    Widget buildTaskInput3() {
      return TextField(
        controller: body2Controller,
        autofocus: true,
        textAlign: TextAlign.center,
        onChanged: (newText) {
          newTaskBody2 = newText;
        },
      );
    }

    Widget buildOkButton() {
      return TextButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(
              Colors.lightBlueAccent), // Set your desired background color here
        ),
        onPressed: () async {
          if (state == 1 && newTaskTitle != null) {
            Provider.of<TaskData>(context, listen: false).addState();
            Provider.of<TaskData>(context, listen: false)
                .setTitle('Set a lower limit price.');
            Provider.of<TaskData>(context, listen: false).item1 = newTaskTitle!;
            clearTextField();
          } else if (state == 2 && newTaskBody != null) {
            Provider.of<TaskData>(context, listen: false).addState();
            Provider.of<TaskData>(context, listen: false)
                .setTitle('Set a higher limit price.');
            Provider.of<TaskData>(context, listen: false).item2 = newTaskBody!;
            clearTextField();
          } else if (state == 3 && newTaskBody2 != null) {
            Provider.of<TaskData>(context, listen: false).resetState();
            Provider.of<TaskData>(context, listen: false)
                .setTitle('Choose one from them.');
            Provider.of<TaskData>(context, listen: false).item3 = newTaskBody2!;
            clearTextField();

            newTaskTitle = Provider.of<TaskData>(context, listen: false).item1;
            newTaskBody = Provider.of<TaskData>(context, listen: false).item2;
            newTaskBody2 = Provider.of<TaskData>(context, listen: false).item3;
            Provider.of<TaskData>(context, listen: false)
                .addTask(newTaskTitle!, newTaskBody!, newTaskBody2!);

            Provider.of<TaskData>(context, listen: false).saveTasksToStorage();
            Navigator.pop(context);
          } else {
            Provider.of<TaskData>(context, listen: false).state = 1;
            newTaskBody = null;
            newTaskTitle = null;
            newTaskBody2 = null;
          }
        },
        child: Text(
          'OK',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      );
    }

    return Container(
      color: const Color(0xff757575),
      child: Container(
        padding: EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              Provider.of<TaskData>(context, listen: false).displayText,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.lightBlueAccent,
              ),
            ),
            Column(
              children: [
                Visibility(
                  visible: state == 0,
                  child: Column(
                    children: [
                      RadioListTile<int>(
                        title: Text("Crypto"),
                        value: 0,
                        groupValue: null,
                        onChanged: (value) {
                          Provider.of<TaskData>(context, listen: false)
                              .addState();
                          Provider.of<TaskData>(context, listen: false)
                              .setTitle('Enter a crypto symbol.');
                        },
                      ),
                      RadioListTile<int>(
                        title: Text("Stock"),
                        value: 1,
                        groupValue: null,
                        onChanged: (value) {
                          Provider.of<TaskData>(context, listen: false)
                              .addState();
                          Provider.of<TaskData>(context, listen: false)
                              .setTitle('Enter a stock symbol.');
                        },
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible: state == 1,
                  child: Column(
                    children: [
                      buildTaskInput(),
                      buildOkButton()
                      // Add your widgets for state 1 or 2 here
                    ],
                  ),
                ),
                Visibility(
                  visible: state == 2,
                  child: Column(
                    children: [
                      buildTaskInput2(),
                      buildOkButton()
                      // Add your widgets for state 1 or 2 here
                    ],
                  ),
                ),
                Visibility(
                  visible: state == 3,
                  child: Column(
                    children: [
                      buildTaskInput3(),
                      buildOkButton()
                      // Add your widgets for state 1 or 2 here
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
