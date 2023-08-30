import 'package:flutter/material.dart';
import 'package:worbbing/presentation/theme/theme.dart';
import 'package:worbbing/presentation/widgets/custom_text.dart';
import 'package:worbbing/presentation/widgets/frequency_dropdown.dart';
import 'package:worbbing/presentation/widgets/words_count_dropdown.dart';

class ConfigPage extends StatefulWidget {
  const ConfigPage({super.key});

  @override
  State<ConfigPage> createState() => _ConfigPageState();
}

class _ConfigPageState extends State<ConfigPage> {
  bool notificationState = false;
  TimeOfDay selectedTime = TimeOfDay.now();
  String selectedFrequency = '1';
  String selectedWordCount = '1';

  void updateFrequency(String newValue) {
    setState(() {
      selectedFrequency = newValue;
    });
  }

  void updateWordCount(String newValue) {
    setState(() {
      selectedWordCount = newValue;
    });
  }

  Widget scheduleTime(int index) {
    int hour = (selectedTime.hour + index * int.parse(selectedFrequency)) > 23
        ? (selectedTime.hour + index * int.parse(selectedFrequency)) - 24
        : (selectedTime.hour + index * int.parse(selectedFrequency));
    String text =
        '${hour.toString().padLeft(2, "0")}:${selectedTime.minute.toString().padLeft(2, "0")}';
    return mediumText(text, hour < 7 ? Colors.grey : Colors.white);
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );

    if (picked != null) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
          const SizedBox(
            height: 50,
          ),
          // title
          SizedBox(
            width: double.infinity,
            height: 80,
            child: Stack(
              children: [
                Align(
                  alignment: const Alignment(-0.89, -0.1),
                  child: InkWell(
                      child: Image.asset(
                        'assets/images/custom_arrow.png',
                        width: 25,
                        height: 25,
                      ),
                      onTap: () {
                        Navigator.pop(context);
                      }),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Image.asset(
                    'assets/images/config.png',
                    width: 200,
                  ),
                ),
              ],
            ),
          ),
          // body
          Container(
            // color: Colors.blue,
            margin: const EdgeInsets.only(top: 30),
            width: 330,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    mediumText('Notification', Colors.white),
                    Switch(
                      activeTrackColor: MyTheme.lemon,
                      inactiveThumbColor: Colors.grey,
                      inactiveTrackColor: Colors.white,
                      value: notificationState,
                      activeColor: MyTheme.grey,
                      onChanged: (bool value) {
                        setState(() {
                          notificationState = value;
                        });
                      },
                    )
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
// frequency
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    mediumText('Notification frequency', Colors.white),
                    Container(
                      width: 70,
                      height: 50,
                      color: Colors.white,
                      child: Stack(
                        children: [
                          Positioned(
                            right: 10,
                            bottom: 3,
                            child: mediumText(
                              'h',
                              Colors.black,
                            ),
                          ),
                          Positioned(
                            top: 5,
                            right: 5,
                            child: FrequencyDropdownWidget(
                              onItemSelected: updateFrequency,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
// notification words count
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    mediumText('Notification Words', Colors.white),
                    Container(
                      width: 70,
                      height: 50,
                      color: Colors.white,
                      child: Stack(
                        children: [
                          Positioned(
                            right: 3,
                            bottom: 3,
                            child: bodyText(
                              'wds',
                              Colors.black,
                            ),
                          ),
                          Positioned(
                            top: 5,
                            right: 15,
                            child: WordsCountDropdownWidget(
                              onItemSelected: updateWordCount,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
// notification time
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    mediumText('Notification Time', Colors.white),
                    GestureDetector(
                      onTap: () => _selectTime(context),
                      child: Container(
                        alignment: Alignment.center,
                        width: 90,
                        height: 50,
                        color: Colors.white,
                        child: titleText(
                            '${selectedTime.hour.toString().padLeft(2, "0")}:${selectedTime.minute.toString().padLeft(2, "0")}',
                            Colors.black,
                            null),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
// notification schedule
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    mediumText('Notification Schedule', Colors.white),
                  ],
                ),
// 24:00 ~ 6:00は除外
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  padding: const EdgeInsets.only(top: 7),
                  color: MyTheme.grey,
                  width: 330,
                  height: 70,
                  // color: Colors.blue,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 24 ~/ int.parse(selectedFrequency),
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(7.0),
                        child: Transform.rotate(
                          angle: 0.9,
                          child: scheduleTime(index),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          )
        ])));
  }
}
