import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:todo_fschmatz/classes/todo.dart';
import '../../db/todos/todo_controller.dart';

class EditTodo extends StatefulWidget {
  Todo todo;

  @override
  _EditTodoState createState() => _EditTodoState();

  EditTodo({Key? key, required this.todo}) : super(key: key);
}

class _EditTodoState extends State<EditTodo> {
  TextEditingController customControllerName = TextEditingController();
  bool _validName = true;

  @override
  void initState() {
    super.initState();
    customControllerName.text = widget.todo.name;
  }

  Future<void> _updateTodo() async {
    updateTodo(Todo(widget.todo.id, customControllerName.text));
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
                _updateTodo();
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
              autofocus: false,
              minLines: 1,
              maxLength: 30,
              maxLengthEnforcement: MaxLengthEnforcement.enforced,
              controller: customControllerName,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                  labelText: "Name",
                  counterText: "",
                  helperText: "* Required",
                  errorText: _validName ? null : "Name is empty"),
            ),
          ),
        ],
      ),
    );
  }
}
