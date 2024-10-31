import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gap/gap.dart';
import 'package:rti_events/widgets/custom_button.dart';

import 'package:vibration/vibration.dart';

import '../../../../config/app_text.dart';
import '../../../../config/functions.dart';
import '../../../../config/palette.dart';
import '../../../models/ticket_model.dart';
import '../../../services/remote/remote_service.dart';
import '../../../widgets/all_sheet_header.dart';
import '../../../widgets/error_sheet_container.dart';
import '../../../widgets/infos_column.dart';
import 'error_sheet.dart';
import 'scan_sheet.dart';

class SearchTicket extends StatefulWidget {
  const SearchTicket({super.key});

  @override
  State<SearchTicket> createState() => _SearchTicketState();
}

class _SearchTicketState extends State<SearchTicket> {
  final TextEditingController _ticketCodeController = TextEditingController();
  // animated rounded btn controller

  @override
  Widget build(BuildContext context) {
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final size = MediaQuery.of(context).size;
    return Container(
      width: double.infinity,
      height: 230,
      margin: EdgeInsets.only(bottom: keyboardHeight),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(5),
          topRight: Radius.circular(5),
        ),
      ),
      child: Column(
        children: [
          const AllSheetHeader(),
          const Gap(10),
          AppText.medium('Trouver un ticket par code'),
          Padding(
            padding: const EdgeInsets.all(13.0),
            child: Column(
              children: [
                InfosColumn(
                  height: 55,
                  opacity: 0.2,
                  label: 'Entrez le code du ticket',
                  widget: Expanded(
                    child: Functions.getTextField(
                      controller: _ticketCodeController,
                      textFieldLabel: 'code',
                    ),
                  ),
                ),
                const Gap(15),
                CustomButton(
                    color: Palette.appRed,
                    width: double.infinity,
                    height: 35,
                    radius: 5,
                    text: 'Trouver le billet',
                    onPress: () async {
                      ////////////implementer la l'enregistrement local  du token
                      if (_ticketCodeController.text.isEmpty) {
                        Functions.showToast(
                          msg: 'Veuillez renseigner le champ !',
                        );
                        return;
                      }

                      EasyLoading.show();

                      int? tickeCode = int.tryParse(_ticketCodeController.text);
                      if (tickeCode != null) {
                        // juste pour le fun
                        // print(id);
                        //_btnController.success();

                        await RemoteService()
                            .getTicket(
                          uniqueCode: tickeCode.toString(),
                        )
                            .then((res) async {
                          if (res.statusCode == 200 || res.statusCode == 201) {
                            TicketModel ticket = ticketModelFromJson(res.body);
                            await AudioPlayer()
                                .play(AssetSource('images/soung.mp3'));
                            EasyLoading.dismiss();
                            Functions.showSimpleBottomSheet(
                              // ignore: use_build_context_synchronously
                              ctxt: context,
                              widget: ScanSheet(ticket: ticket),
                            );
                          } else {
                            //print('-------->');
                            EasyLoading.dismiss();
                            _showError();
                          }
                        });
                      } else {
                        ///////////////////////
                        ///sinon on fait vibrer le device
                        ///et on afficher un message d'erreur
                        ///

                        EasyLoading.dismiss();
                        Vibration.vibrate(duration: 200);
                        Functions.showBottomSheet(
                          ctxt: context,
                          size: size,
                          heightRatio: 3,
                          widget: const ErrorSheetContainer(
                            text: 'Qr code invalide !',
                          ),
                        );
                      }
                      // });
                    })
              ],
            ),
          )
        ],
      ),
    );
  }

  void _showError() => error(context: context);
}
