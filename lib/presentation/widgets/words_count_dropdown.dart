import 'package:flutter/material.dart';
import 'package:worbbing/models/config_model.dart';

class WordsCountDropdownWidget extends StatefulWidget {
  final Function(String) onItemSelected;

  const WordsCountDropdownWidget({required this.onItemSelected});

  @override
  _WordsCountDropdownWidgetState createState() =>
      _WordsCountDropdownWidgetState();
}

class _WordsCountDropdownWidgetState extends State<WordsCountDropdownWidget> {
  String dropdownValue = '1';

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      alignment: Alignment.center,
      underline: Container(
        height: 2,
        color: Colors.transparent,
      ),
      style: const TextStyle(color: Colors.black, fontSize: 32),
      iconEnabledColor: Colors.transparent,
      value: dropdownValue,
      onChanged: (String? newValue) {
        setState(() {
          dropdownValue = newValue!;
          widget.onItemSelected(newValue);
        });
      },
      items:
          ConfigModel.wordCount.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
