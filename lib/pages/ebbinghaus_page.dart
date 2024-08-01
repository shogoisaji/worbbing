import 'package:flutter/material.dart';
import 'package:worbbing/presentation/theme/theme.dart';
import 'package:worbbing/presentation/widgets/custom_text.dart';

class EbbinghausPage extends StatelessWidget {
  const EbbinghausPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 50,
            ),
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
                          width: 30,
                          height: 30,
                        ),
                        onTap: () {
                          Navigator.pop(context);
                        }),
                  ),
                ],
              ),
            ),
            Container(
              width: 350,
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(width: 1, color: MyTheme.beige))),
              child: titleText(
                  'The Ebbinghaus forgetting curve', MyTheme.beige, 18),
            ),
            Container(
              padding: const EdgeInsets.only(top: 10, bottom: 20),
              width: 350,
              child: bodyText(
                  'エビングハウスの忘却曲線とは、時間が経過するにつれて情報をどれだけ忘れるかを示す心理学的モデルです。新情報を得た直後は保持率が高いが、数時間以内に急激に忘却が進む。その後、忘却速度は次第に減少します。この曲線は、復習や再学習を行うことで「リセット」され、情報の保持期間が延長します。',
                  MyTheme.beige),
            ),
            Image.asset(
              'assets/images/ebbinghaus.png',
              width: 350,
              // height: 25,
            ),
            const SizedBox(
              height: 30,
            ),
            Container(
              width: 350,
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(width: 1, color: MyTheme.beige))),
              child: titleText('Spaced repetition', MyTheme.beige, 18),
            ),
            Container(
              padding: const EdgeInsets.only(top: 10, bottom: 20),
              width: 350,
              child: bodyText(
                  'スペースドリピテーションは新しい情報を学習した後、短い間隔で最初の復習を行い、その後は徐々に復習の間隔を延ばしていきます。このようにすることで、短期記憶から長期記憶への移行が促され、記憶の持続性が向上します。この手法は「アクティブリコール」を重視し、自分で情報を思い出すプロセスを強化します。',
                  MyTheme.beige),
            ),
            Image.asset(
              'assets/images/spacedRepetition.png',
              width: 350,
              // height: 25,
            ),
            const SizedBox(
              height: 50,
            )
          ],
        ),
      ),
    );
  }
}
