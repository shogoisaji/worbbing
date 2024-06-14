import 'package:flutter/material.dart';
import 'package:worbbing/models/config_model.dart';

class FrequencyDropdownWidget extends StatefulWidget {
  final Function(String) onItemSelected;

  const FrequencyDropdownWidget({super.key, required this.onItemSelected});

  @override
  _FrequencyDropdownWidgetState createState() =>
      _FrequencyDropdownWidgetState();
}

class _FrequencyDropdownWidgetState extends State<FrequencyDropdownWidget> {
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
      // dropdownColor: Colors.blue,
      iconEnabledColor: Colors.transparent,
      value: dropdownValue,
      onChanged: (String? newValue) {
        setState(() {
          dropdownValue = newValue!;
          widget.onItemSelected(newValue);
        });
      },
      items:
          ConfigModel.frequency.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
