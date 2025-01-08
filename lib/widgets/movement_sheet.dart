import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gap/gap.dart';
import 'package:rti_events/services/remote/remote_service.dart';

import '../../../config/app_text.dart';
import '../../../config/palette.dart';
import '../../../widgets/all_sheet_header.dart';
import '../../../widgets/custom_button.dart';

class MovementSheet extends StatelessWidget {
  final int ticketId;
  final int inspectorId;
  const MovementSheet(
      {super.key, required this.ticketId, required this.inspectorId});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const AllSheetHeader(),
        Container(
          margin: const EdgeInsets.only(bottom: 5),
          width: double.infinity,
          height: 100,
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.01),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.elliptical(200, 10),
              bottomRight: Radius.elliptical(200, 10),
            ),
          ),
          child: Center(
            child: Container(
              // padding: const EdgeInsets.all(20),
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.05),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Image.asset('assets/images/person-walk.webp'),
              ),
            ),
          ),
        ),
        Gap(10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: AppText.medium(
            'Veuillez indiquer le mouvement de\nce participant',
            textAlign: TextAlign.center,
            fontWeight: FontWeight.w500,
          ),
        ),
        //AppText.small('Veu')
        const Gap(8),
        Padding(
          padding: const EdgeInsets.only(
            top: 10,
            right: 15,
            left: 15,
          ),
          child: Row(
            children: [
              Expanded(
                child: CustomButton(
                  color: const Color.fromARGB(255, 36, 88, 48),
                  width: double.infinity,
                  height: 35,
                  radius: 5,
                  text: 'Entrée',
                  onPress: () => handleEntry(ctxt: context),
                ),
              ),
              Gap(5),
              Expanded(
                child: CustomButton(
                  color: Palette.appRed,
                  width: double.infinity,
                  height: 35,
                  radius: 5,
                  text: 'Sortie',
                  onPress: () => handleOut(ctxt: context),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  handleEntry({required BuildContext ctxt}) async {
    EasyLoading.show();
    final Map<String, dynamic> data = {
      "ticket_id": ticketId,
      "inspector_id": inspectorId,
      "movement": "entree",
    };
    await RemoteService().postSomethings(api: 'tickets/scan', data: data);
    EasyLoading.showToast('Mouvement enregistré !',
        toastPosition: EasyLoadingToastPosition.top);
    EasyLoading.dismiss();
    Navigator.pop(ctxt);
  }

  handleOut({required BuildContext ctxt}) async {
    final Map<String, dynamic> data = {
      "ticket_id": ticketId,
      "inspector_id": inspectorId,
      "movement": "sortie",
    };
    EasyLoading.show();
    await RemoteService().postSomethings(api: 'tickets/scan', data: data);
    EasyLoading.showToast('Mouvement enregistré !',
        toastPosition: EasyLoadingToastPosition.top);
    EasyLoading.dismiss();
    Navigator.pop(ctxt);
  }
}
