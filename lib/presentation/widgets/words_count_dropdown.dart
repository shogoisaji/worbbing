import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:worbbing/models/config_model.dart';

class WordsCountDropdownWidget extends StatefulWidget {
  final int selectedWordsCount;
  final Function(int) onItemSelected;

  const WordsCountDropdownWidget(
      {super.key,
      required this.onItemSelected,
      required this.selectedWordsCount});

  @override
  _WordsCountDropdownWidgetState createState() =>
      _WordsCountDropdownWidgetState();
}

class _WordsCountDropdownWidgetState extends State<WordsCountDropdownWidget> {
  int dropdownValue = 1;

  @override
  Widget build(BuildContext context) {
    dropdownValue = widget.selectedWordsCount;
    return DropdownButton<int>(
      onTap: () {
        HapticFeedback.lightImpact();
      },
      dropdownColor: Colors.white,
      alignment: Alignment.center,
      underline: Container(
        height: 2,
        color: Colors.transparent,
      ),
      style: const TextStyle(color: Colors.black, fontSize: 32),
      iconEnabledColor: Colors.transparent,
      value: dropdownValue,
      onChanged: (int? newValue) {
        HapticFeedback.lightImpact();
        setState(() {
          dropdownValue = newValue!;
          widget.onItemSelected(newValue);
        });
      },
      items: ConfigModel.wordCount.map<DropdownMenuItem<int>>((int value) {
        return DropdownMenuItem<int>(
          value: value,
          child: Text(value.toString()),
        );
      }).toList(),
    );
  }
}
