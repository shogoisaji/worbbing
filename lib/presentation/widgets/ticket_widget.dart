import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:worbbing/presentation/theme/theme.dart';

class TicketWidget extends StatelessWidget {
  final int count;
  final double size;
  const TicketWidget({super.key, required this.count, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: size,
        height: size,
        decoration: const BoxDecoration(
          color: Colors.transparent,
        ),
        child: Stack(
          children: [
            Center(
              child: SvgPicture.asset('assets/svg/ticket.svg'),
            ),
            Positioned(
              bottom: 3,
              right: 10,
              child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: MyTheme.grey,
                    border: Border.all(color: Colors.white, width: 1),
                    shape: BoxShape.circle,
                  ),
                  child: Text(count.toString(),
                      style:
                          const TextStyle(color: Colors.white, fontSize: 14))),
            ),
          ],
        ));
  }
}
