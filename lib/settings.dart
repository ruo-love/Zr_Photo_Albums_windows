import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_pc/config/app_color.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:test_pc/config/state.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  Color pickerColor = Colors.white;
  // ValueChanged<Color> callback
  void changeColor(Color color) {
    print(color.value);
    setState(() => pickerColor = color);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      color: Colors.white,
      child: Container(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: BlockPicker(
              availableColors: [
                Colors.red,
                Colors.pink,
                Colors.purple,
                Colors.deepPurple,
                Colors.indigo,
                Colors.blue,
                Colors.lightBlue,
                Colors.cyan,
                Colors.teal,
                Colors.green,
                Colors.lightGreen,
                Colors.lime,
                Colors.yellow,
                Colors.amber,
                Colors.orange,
                Colors.deepOrange,
                Colors.brown,
                Colors.grey,
                Colors.blueGrey,
                Colors.black,
              ],
              pickerColor: pickerColor,
              onColorChanged: (color) {
                changeColor(color);
                Provider.of<ThemeChangeNotifier>(context, listen: false)
                    .changeColor(color.value);
              },
              useInShowDialog: false,
              layoutBuilder: (context, colors, child) => Row(
                    children: [for (Color color in colors) child(color)],
                  ),
              itemBuilder: (color, isCurrentColor, changeColor) {
                return InkWell(
                  onTap: () {
                    changeColor();
                  },
                  child: Container(
                    width: 24,
                    height: 24,
                    margin: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.grey)),
                    child: pickerColor == color
                        ? Icon(
                            Icons.check,
                            size: 16,
                            color: Colors.black,
                          )
                        : Container(),
                  ),
                );
              }),
        ),
      ),
    );
  }
}
