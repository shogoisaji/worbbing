import 'package:flutter/material.dart';
import 'package:worbbing/presentation/widgets/registration_text_field.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(children: [
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
                  alignment: const Alignment(-0.89, 0),
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
                  alignment: const Alignment(0.15, 0),
                  child: Image.asset(
                    'assets/images/registration.png',
                    width: 250,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Container(
            alignment: Alignment.centerRight,
            child: Icon(Icons.flag, size: 36, color: Colors.white),
          ),
          registrationTextField(),
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: InkWell(
              onTap: () {
                //
              },
              child: Image.asset(
                'assets/images/deepL.png',
                width: 50,
              ),
            ),
          ),
          registrationTextField(),
          const SizedBox(
            height: 50,
          ),
          registrationMemoTextField(),
        ]),
      ),
    );
  }
}
