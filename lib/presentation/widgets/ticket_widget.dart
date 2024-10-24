import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

enum TicketState { normal, use, earn }

class TicketWidget extends StatefulWidget {
  final int count;
  final double size;
  final bool isEnabledUseAnimation;
  final Color bgColor;
  const TicketWidget(
      {super.key,
      required this.count,
      required this.size,
      this.isEnabledUseAnimation = false,
      required this.bgColor});

  @override
  State<TicketWidget> createState() => _TicketWidgetState();
}

class _TicketWidgetState extends State<TicketWidget> {
  TicketState _ticketState = TicketState.normal;

  @override
  void didUpdateWidget(covariant TicketWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!widget.isEnabledUseAnimation) return;
    if (widget.count != oldWidget.count) {
      if (widget.count < oldWidget.count) {
        setState(() {
          _ticketState = TicketState.use;
        });
        Future.delayed(const Duration(milliseconds: 1000), () {
          setState(() {
            _ticketState = TicketState.normal;
          });
        });
      } else if (widget.count > oldWidget.count) {
        setState(() {
          _ticketState = TicketState.earn;
        });
        Future.delayed(const Duration(milliseconds: 3000), () {
          setState(() {
            _ticketState = TicketState.normal;
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
        child: switch (_ticketState) {
          TicketState.normal => Stack(
              children: [
                Center(
                  child: widget.count == 0
                      ? SvgPicture.asset('assets/svg/e_ticket.svg')
                      : SvgPicture.asset('assets/svg/ticket.svg'),
                ),
                Align(
                  alignment: const Alignment(0.4, 0.6),
                  child: Container(
                      width: widget.size / 2,
                      height: widget.size / 2,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: widget.bgColor,
                        border: Border.all(color: Colors.white, width: 1),
                        shape: BoxShape.circle,
                      ),
                      child: AutoSizeText(widget.count.toString(),
                          style: GoogleFonts.inter(
                              color: Colors.white, fontSize: widget.size))),
                ),
              ],
            ),
          TicketState.use =>
            Lottie.asset('assets/lottie/use_ticket.json', repeat: false),
          TicketState.earn =>
            Lottie.asset('assets/lottie/earn_ticket.json', repeat: false)
        });

    // child: _isUseTicket
    //     ? Lottie.asset('assets/lottie/use_ticket.json', repeat: false)
    //     : Stack(
    //         children: [
    //           Center(
    //             child: widget.count == 0
    //                 ? SvgPicture.asset('assets/svg/e_ticket.svg')
    //                 : SvgPicture.asset('assets/svg/ticket.svg'),
    //           ),
    //           Align(
    //             alignment: const Alignment(0.4, 0.6),
    //             child: Container(
    //                 width: widget.size / 2,
    //                 height: widget.size / 2,
    //                 alignment: Alignment.center,
    //                 decoration: BoxDecoration(
    //                   color: widget.bgColor,
    //                   border: Border.all(color: Colors.white, width: 1),
    //                   shape: BoxShape.circle,
    //                 ),
    //                 child: AutoSizeText(widget.count.toString(),
    //                     style: GoogleFonts.inter(
    //                         color: Colors.white, fontSize: widget.size))),
    //           ),
    //         ],
    //       ));
  }
}
