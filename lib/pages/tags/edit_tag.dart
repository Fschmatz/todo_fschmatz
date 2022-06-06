import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:todo_fschmatz/classes/tag.dart';
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
  bool _validName = true;

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

  bool validateTextFields() {
    if (customControllerName.text.isEmpty) {
      _validName = false;
      return false;
    }
    return true;
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
              if (validateTextFields()) {
                _updateTag();
                Navigator.of(context).pop();
              } else {
                setState(() {
                  _validName;
                });
              }
            },
          )
        ],
        title: const Text('Edit Tag'),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
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
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 16, 5),
            child: Text('Color',
              style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).textTheme.headline1!.color
              ),
            ),
          ),
          ListTile(
            title: OutlinedButton(
                onPressed: () {
                  createAlertSelectColor(context);
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(100, 60),
                  elevation: 0,
                  primary: currentColor,
                  onPrimary: currentColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: const SizedBox.shrink()),
          ),
        ],
      ),
    );
  }
}
