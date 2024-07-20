import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:worbbing/presentation/theme/theme.dart';

class TicketWidget extends StatefulWidget {
  final int count;
  final double size;
  final bool isEnableUseAnimation;
  const TicketWidget(
      {super.key,
      required this.count,
      required this.size,
      this.isEnableUseAnimation = false});

  @override
  State<TicketWidget> createState() => _TicketWidgetState();
}

class _TicketWidgetState extends State<TicketWidget> {
  bool _isUseTicket = false;

  @override
  void didUpdateWidget(covariant TicketWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!widget.isEnableUseAnimation) return;
    if (widget.count != oldWidget.count) {
      if (widget.count < oldWidget.count) {
        setState(() {
          _isUseTicket = true;
        });
        Future.delayed(const Duration(milliseconds: 1000), () {
          setState(() {
            _isUseTicket = false;
          });
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: widget.size,
        height: widget.size,
        decoration: const BoxDecoration(
          color: Colors.transparent,
        ),
        child: _isUseTicket
            ? Lottie.asset('assets/lottie/use_ticket.json', repeat: false)
            : Stack(
                children: [
                  Center(
                    child: widget.count == 0
                        ? SvgPicture.asset('assets/svg/e_ticket.svg')
                        : SvgPicture.asset('assets/svg/ticket.svg'),
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
                        child: Text(widget.count.toString(),
                            style: const TextStyle(
                                color: Colors.white, fontSize: 14))),
                  ),
                ],
              ));
  }
}
