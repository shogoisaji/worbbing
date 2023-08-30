import 'package:flutter/material.dart';
import 'package:worbbing/presentation/theme/theme.dart';
import 'package:worbbing/presentation/widgets/custom_text.dart';
import 'package:worbbing/presentation/widgets/notice_block.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({super.key});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
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
                      'assets/images/detail.png',
                      width: 200,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Column(
                  children: [
                    bodyText('NoticeDuration', MyTheme.grey),
                    const SizedBox(
                      height: 8,
                    ),
                    noticeBlock(72, 5, MyTheme.lemon),
                  ],
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                  child: Row(
                    children: [
                      bodyText('Forgetting\n  Duration', MyTheme.grey),
                      SizedBox(
                        width: 10,
                      ),
                      // change forgetting duration
                      titleText('14', MyTheme.orange, null),
                    ],
                  ),
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.grey)),
                ),
                Column(
                  children: [
                    // flag bool choice
                    Icon(Icons.flag, color: Colors.white, size: 56),
                    SizedBox(
                      height: 7,
                    ),
                  ],
                ),
              ],
            ),
            // original word
            Container(
              margin: EdgeInsets.only(top: 50),
              alignment: Alignment.topLeft,
              width: 300,
              child: bodyText('English', MyTheme.grey),
            ),
            Container(
              alignment: Alignment.center,
              width: 300,
              height: 50,
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment(1, 0),
                    child: IconButton(
                        onPressed: () {
                          // Edit
                        },
                        icon: Icon(
                          Icons.create,
                          color: Colors.white,
                          size: 26,
                        )),
                  ),
                  Align(
                      alignment: Alignment(0, 0),
                      child: titleText('addmission', Colors.white, null)),
                ],
              ),
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(color: Colors.white, width: 1.0))),
            ),
            // translated word
            Container(
              margin: EdgeInsets.only(top: 40),
              alignment: Alignment.topLeft,
              width: 300,
              child: bodyText('日本語', MyTheme.grey),
            ),
            Container(
              alignment: Alignment.center,
              width: 300,
              height: 50,
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment(1, 0),
                    child: IconButton(
                        onPressed: () {
                          // Edit
                        },
                        icon: Icon(
                          Icons.create,
                          color: Colors.white,
                          size: 26,
                        )),
                  ),
                  Align(
                      alignment: Alignment(0, 0),
                      child: titleText('入場', Colors.white, null)),
                ],
              ),
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(color: Colors.white, width: 1.0))),
            ),
            const SizedBox(
              height: 40,
            ),
            Container(
              width: 300,
              alignment: Alignment.topLeft,
              child: subText('Memo', Colors.white),
            ),
            Stack(
              children: [
                Transform.translate(
                  offset: const Offset(6, 5),
                  child: Transform.rotate(
                      angle: 0.02,
                      child: Container(
                          width: 300, height: 150, color: MyTheme.orange)),
                ),
                Container(width: 300, height: 150, color: Colors.white),
                Positioned(
                  right: 0,
                  child: IconButton(
                      onPressed: () {
                        // Edit
                      },
                      icon: Icon(
                        Icons.create,
                        color: Colors.black,
                        size: 26,
                      )),
                ),
              ],
            ),

            Container(
                margin: EdgeInsets.only(top: 40),
                alignment: Alignment.center,
                width: 230,
                height: 30,
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(color: Colors.white, width: 1.0))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // change registration data
                    bodyText('Registration Date', Colors.white),
                    bodyText('2023.8.23', Colors.white),
                  ],
                )),
            Container(
                margin: EdgeInsets.only(top: 20),
                alignment: Alignment.center,
                width: 230,
                height: 30,
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(color: Colors.white, width: 1.0))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // change update count
                    bodyText('Update Count', Colors.white),
                    Container(
                        alignment: Alignment.center,
                        width: 50,
                        child: bodyText('3', Colors.white)),
                  ],
                )),
            const SizedBox(
              height: 70,
            ),
          ],
        ),
      ),
    );
  }
}
