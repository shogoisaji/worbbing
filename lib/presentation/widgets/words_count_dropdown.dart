import 'package:flutter/material.dart';
import 'package:worbbing/models/config_model.dart';

class WordsCountDropdownWidget extends StatefulWidget {
  final String setelcedWordsCount;
  final Function(String) onItemSelected;

  const WordsCountDropdownWidget(
      {super.key,
      required this.onItemSelected,
      required this.setelcedWordsCount});

  @override
  _WordsCountDropdownWidgetState createState() =>
      _WordsCountDropdownWidgetState();
}

class _WordsCountDropdownWidgetState extends State<WordsCountDropdownWidget> {
  String dropdownValue = '1';

  @override
  Widget build(BuildContext context) {
    dropdownValue = widget.setelcedWordsCount;
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
