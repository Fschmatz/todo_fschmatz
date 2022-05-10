import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:todo_fschmatz/classes/tag.dart';
import 'package:todo_fschmatz/widgets/dialog_alert_error.dart';
import '../../db/tags/tag_controller.dart';
import '../../util/block_picker_alt.dart';
import '../../util/utils_functions.dart';

class EditTag extends StatefulWidget {
  @override
  _EditTagState createState() => _EditTagState();

  Tag tag;

  EditTag({Key? key, required this.tag}) : super(key: key);
}

class _EditTagState extends State<EditTag> {

  TextEditingController customControllerName = TextEditingController();
  Color pickerColor = const Color(0xFFe35b5b);
  Color currentColor = const Color(0xFFe35b5b);

  @override
  void initState() {
    super.initState();
    customControllerName.text = widget.tag.name;
    currentColor = parseColorFromDb(widget.tag.color);
    pickerColor = parseColorFromDb(widget.tag.color);
  }

  Future<void> _updateTag() async {
    updateTag(Tag(
      widget.tag.id,
      customControllerName.text,
      currentColor.toString(),
    ));
  }

  String checkForErrors() {
    String errors = "";
    if (customControllerName.text.isEmpty) {
      errors += "Name is empty\n";
    }
    return errors;
  }

  //COLORS
  void changeColor(Color color) {
    setState(() => pickerColor = color);
  }

  createAlertSelectColor(BuildContext context) {
    Widget okButton = TextButton(
      child: const Text(
        "Ok",
      ),
      onPressed: () {
        setState(() => {currentColor = pickerColor});
        Navigator.of(context).pop();
      },
    );

    AlertDialog alert = AlertDialog(
      title: const Text(
        "Select Color:",
      ),
      content: SingleChildScrollView(
          child: BlockPicker(
        pickerColor: currentColor,
        onColorChanged: changeColor,
      )),
      actions: [
        okButton,
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
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
                _updateTag();
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
        title: const Text('New Tag'),
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
          ),
          ListTile(
            title: Text("Color",
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.secondary)),
          ),
          ListTile(
            //leading: const Icon(Icons.colorize_outlined),
            title: OutlinedButton(
                onPressed: () {
                  createAlertSelectColor(context);
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(100, 50),
                  elevation: 0,
                  primary: currentColor,
                  onPrimary: currentColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                child: const SizedBox.shrink()),
          ),
        ],
      ),
    );
  }
}
