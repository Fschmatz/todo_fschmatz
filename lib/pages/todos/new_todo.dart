import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../classes/todo.dart';
import '../../db/todos/todo_controller.dart';

class NewTodo extends StatefulWidget {
  @override
  _NewTodoState createState() => _NewTodoState();

  const NewTodo({Key? key}) : super(key: key);
}

class _NewTodoState extends State<NewTodo> {
  TextEditingController customControllerName = TextEditingController();
  bool _validName = true;

  Future<void> _save() async {
    saveTodo(Todo(null, customControllerName.text));
  }

  bool validateTextFields() {
    String errors = "";
    if (customControllerName.text.isEmpty) {
      errors += "Name";
      _validName = false;
    }
    return errors.isEmpty ? true : false;
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
              if (validateTextFields()) {
                _save();
                Navigator.of(context).pop();
              } else {
                setState(() {
                  _validName;
                });
              }
            },
          )
        ],
        title: const Text('New Todo'),
      ),
      body: ListView(
        children: [

          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              autofocus: true,
              minLines: 1,
              maxLength: 30,
              maxLengthEnforcement: MaxLengthEnforcement.enforced,
              controller: customControllerName,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                labelText: "Name",
                counterText: "",
                helperText: "* Required",
                errorText: _validName ?  null : "Name is empty",
              ),
            ),
          )
        ],
      ),
    );
  }
}
