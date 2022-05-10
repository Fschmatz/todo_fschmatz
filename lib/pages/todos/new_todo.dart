import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:todo_fschmatz/widgets/dialog_alert_error.dart';
import '../../classes/todo.dart';
import '../../db/todos/todo_controller.dart';

class NewTodo extends StatefulWidget {
  @override
  _NewTodoState createState() => _NewTodoState();

  const NewTodo({Key? key}) : super(key: key);
}

class _NewTodoState extends State<NewTodo> {

  TextEditingController customControllerName = TextEditingController();

  Future<void> _save() async {
    saveTodo(Todo(null, customControllerName.text));
  }

  String checkForErrors() {
    String errors = "";
    if (customControllerName.text.isEmpty) {
      errors += "Name is empty\n";
    }
    return errors;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            tooltip: 'Save',
            icon: const Icon(
              Icons.save_outlined,
            ),
            onPressed: () async {
              String errors = checkForErrors();
              if (errors.isEmpty) {
                _save();
                Navigator.of(context).pop();
              } else {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return dialogAlertErrors(errors, context);
                  },
                );
              }
            },
          )
        ],
        title: const Text('New Todo'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text("Name",
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.secondary)),
          ),
          ListTile(
            title: TextField(
              autofocus: true,
              minLines: 1,
              maxLength: 30,
              maxLengthEnforcement: MaxLengthEnforcement.enforced,
              controller: customControllerName,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                border: InputBorder.none,
                counterText: "",
                helperText: "* Required",
                prefixIcon: Icon(
                  Icons.notes_outlined,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
