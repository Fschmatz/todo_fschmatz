/// Block Color Picker

library block_colorpicker;

import 'package:flutter/material.dart';

import 'package:flutter_colorpicker/src/utils.dart';

const List<Color> _defaultColors = [
  Color(0xfffc5252),
  Color(0xfff85585),
  Color(0xffd660f1),
  Color(0xFF9B70FC),
  Color(0xFF5A73FD),
  Color(0xff4594ec),
  Color(0xff46c2e3),
  Color(0xff45d9ae),
  Color(0xff3dd57c),
  Color(0xFF4CCC46),
  Color(0xff82da3f),
  Color(0xffecce39),
  Color(0xfffc8a28),
  Color(0xffff7340),
  Color(0xff719cb0),
  Color(0xFFB28181),
];

typedef PickerLayoutBuilder = Widget Function(
    BuildContext context, List<Color> colors, PickerItem child);
typedef PickerItem = Widget Function(Color color);
typedef PickerItemBuilder = Widget Function(
    Color color, bool isCurrentColor, void Function() changeColor);

class BlockPicker extends StatefulWidget {
  const BlockPicker({
    required this.pickerColor,
    required this.onColorChanged,
    this.availableColors = _defaultColors,
    this.layoutBuilder = defaultLayoutBuilder,
    this.itemBuilder = defaultItemBuilder,
  });

  final Color pickerColor;
  final ValueChanged<Color> onColorChanged;
  final List<Color> availableColors;
  final PickerLayoutBuilder layoutBuilder;
  final PickerItemBuilder itemBuilder;

  static Widget defaultLayoutBuilder(
      BuildContext context, List<Color> colors, PickerItem child) {
    Orientation orientation = MediaQuery.of(context).orientation;

    return SizedBox(
      width: orientation == Orientation.portrait ? 300.0 : 300.0,
      height: orientation == Orientation.portrait ? 300.0 : 280.0,
      child: GridView.count(
        crossAxisCount: orientation == Orientation.portrait ? 4 : 6,
        crossAxisSpacing: 5.0,
        mainAxisSpacing: 5.0,
        children: colors.map((Color color) => child(color)).toList(),
      ),
    );
  }

  static Widget defaultItemBuilder(
      Color color, bool isCurrentColor, void Function() changeColor) {
    return Container(
      margin: const EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50.0),
        color: color,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: changeColor,
          borderRadius: BorderRadius.circular(50.0),
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 210),
            opacity: isCurrentColor ? 1.0 : 0.0,
            child: Icon(
              Icons.done,
              color: useWhiteForeground(color) ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  @override
  State<StatefulWidget> createState() => _BlockPickerState();
}

class _BlockPickerState extends State<BlockPicker> {
  late Color _currentColor;

  @override
  void initState() {
    _currentColor = widget.pickerColor;
    super.initState();
  }

  void changeColor(Color color) {
    setState(() => _currentColor = color);
    widget.onColorChanged(color);
  }

  @override
  Widget build(BuildContext context) {
    return widget.layoutBuilder(
      context,
      widget.availableColors,
          (Color color, [bool? _, Function? __]) => widget.itemBuilder(
          color, _currentColor.value == color.value, () => changeColor(color)),
    );
  }
}

class MultipleChoiceBlockPicker extends StatefulWidget {
  const MultipleChoiceBlockPicker({
    required this.pickerColors,
    required this.onColorsChanged,
    this.availableColors = _defaultColors,
    this.layoutBuilder = BlockPicker.defaultLayoutBuilder,
    this.itemBuilder = BlockPicker.defaultItemBuilder,
  });

  final List<Color> pickerColors;
  final ValueChanged<List<Color>> onColorsChanged;
  final List<Color> availableColors;
  final PickerLayoutBuilder layoutBuilder;
  final PickerItemBuilder itemBuilder;

  @override
  State<StatefulWidget> createState() => _MultipleChoiceBlockPickerState();
}

class _MultipleChoiceBlockPickerState extends State<MultipleChoiceBlockPicker> {
  late List<Color> _currentColors;

  @override
  void initState() {
    _currentColors = widget.pickerColors;
    super.initState();
  }

  void toggleColor(Color color) {
    setState(() {
      _currentColors.contains(color)
          ? _currentColors.remove(color)
          : _currentColors.add(color);
    });
    widget.onColorsChanged(_currentColors);
  }

  @override
  Widget build(BuildContext context) {
    return widget.layoutBuilder(
      context,
      widget.availableColors,
          (Color color, [bool? _, Function? __]) => widget.itemBuilder(
        color,
        _currentColors.contains(color),
            () => toggleColor(color),
      ),
    );
  }
}