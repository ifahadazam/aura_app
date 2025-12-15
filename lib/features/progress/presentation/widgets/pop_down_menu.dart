import 'package:flutter/material.dart';

class SimpleDropDownMenu extends StatefulWidget {
  const SimpleDropDownMenu({super.key});

  @override
  State<SimpleDropDownMenu> createState() => _SimpleDropDownMenuState();
}

class _SimpleDropDownMenuState extends State<SimpleDropDownMenu> {
  String selected = "Option 1";

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        value: selected,
        borderRadius: BorderRadius.circular(14),
        items: [
          DropdownMenuItem(value: "Option 1", child: Text("Option 1")),
          DropdownMenuItem(value: "Option 2", child: Text("Option 2")),
          DropdownMenuItem(value: "Option 3", child: Text("Option 3")),
        ],
        onChanged: (value) {
          setState(() => selected = value!);
        },
      ),
    );
  }
}
