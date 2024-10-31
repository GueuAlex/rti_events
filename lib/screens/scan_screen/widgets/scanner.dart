import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:vibration/vibration.dart';

import '../../../config/functions.dart';
import '../../../models/ticket_model.dart';
import '../../../services/remote/remote_service.dart';
import '../../../widgets/error_sheet_container.dart';
import 'error_sheet.dart';
import 'scan_sheet.dart';

class Scanner extends StatefulWidget {
  const Scanner({
    super.key,
    required this.controller,
  });
  final MobileScannerController controller;

  @override
  State<Scanner> createState() => _ScannerState();
}

class _ScannerState extends State<Scanner> {
  //
  bool isScanCompleted = false;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return MobileScanner(
      controller: widget.controller,
      fit: BoxFit.cover,
      onDetect: (barcodes) async {
        _handleDectect(barcodes, size);
      },
    );
  }

  void _handleDectect(BarcodeCapture barcodes, Size size) async {
    if (!isScanCompleted) {
      ////////://///////////////
      /// on montre le gif de detection

      ////////////////
      /// data =  données que le qrcode continet
      String data = barcodes.barcodes[0].rawValue ?? '';
      //debugPrint(data);

      //////////////
      /// booleen permettant de connaitre l'etat
      /// du process de scanning
      isScanCompleted = true;
      //////////////////////////////
      // on temporise pendant 3 second

      /*  Future.delayed(
                  const Duration(seconds: 3),
                ).whenComplete(() {
                  /////on cache le gif ensuite on enchaine
                  setState(() {
                    showGif = false;
                  }); */
      ///// avec le traitement du qrcode

      //////////////////////////
      /// on attend un int
      /// donc on int.tryParse code pour etre sur de
      /// son type
      int? tickeCode = int.tryParse(data);
      if (tickeCode != null) {
        // juste pour le fun
        // print(id);
        EasyLoading.show();

        await RemoteService()
            .getTicket(
          uniqueCode: tickeCode.toString(),
        )
            .then((res) async {
          if (res.statusCode == 200 || res.statusCode == 201) {
            TicketModel ticket = ticketModelFromJson(res.body);
            await AudioPlayer().play(AssetSource('images/soung.mp3'));
            if (mounted) {
              Functions.showSimpleBottomSheet(
                ctxt: context,
                widget: ScanSheet(ticket: ticket),
              ).whenComplete(() {
                setState(() {
                  isScanCompleted = false;
                });
              });
            }
            EasyLoading.dismiss();
          } else {
            EasyLoading.dismiss();
            if (mounted) {
              error(context: context);
            }
          }
        });
        EasyLoading.dismiss();
      } else {
        ///////////////////////
        ///sinon on fait vibrer le device
        ///et on afficher un message d'erreur
        ///
        Vibration.vibrate(duration: 200);
        Functions.showBottomSheet(
          ctxt: context,
          size: size,
          heightRatio: 3,
          widget: const ErrorSheetContainer(
            text: 'Qr code invalide !',
          ),
        ).whenComplete(() {
          //Future.delayed(const Duration(seconds: 3)).then((_) {
          setState(() {
            isScanCompleted = false;
          });
          // });
        });
      }
      // });
    }
  }
}
