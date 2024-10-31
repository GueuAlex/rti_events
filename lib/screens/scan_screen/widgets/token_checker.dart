import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gap/gap.dart';
import 'package:rti_events/widgets/custom_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../config/app_text.dart';
import '../../../../config/functions.dart';
import '../../../../config/palette.dart';
import '../../../../widgets/all_sheet_header.dart';
import '../../../../widgets/infos_column.dart';

class TokenChecker extends StatefulWidget {
  const TokenChecker({super.key});

  @override
  State<TokenChecker> createState() => _TokenCheckerState();
}

class _TokenCheckerState extends State<TokenChecker> {
  final TextEditingController _tokenController = TextEditingController();
  void _getBack() {
    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
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
          AppText.medium('Clé d\'autorisation'),
          Padding(
            padding: const EdgeInsets.all(13.0),
            child: Column(
              children: [
                InfosColumn(
                  height: 55,
                  opacity: 0.2,
                  label: 'Entrez la clé de scan',
                  widget: Expanded(
                    child: Functions.getTextField(
                        controller: _tokenController, textFieldLabel: 'clé'),
                  ),
                ),
                const Gap(15),
                CustomButton(
                  color: Palette.appRed,
                  width: double.infinity,
                  height: 35,
                  radius: 5,
                  text: 'Enregistrer la clé',
                  onPress: () async {
                    ////////////implementer la l'enregistrement local  du token
                    if (_tokenController.text.isEmpty) {
                      EasyLoading.showToast(
                        'Veuillez renseigner le champ !',
                        toastPosition: EasyLoadingToastPosition.bottom,
                      );
                      return;
                    }

                    String token = _tokenController.text;
                    //print(_token);

                    // Obtain shared preferences.
                    final SharedPreferences prefs =
                        await SharedPreferences.getInstance();

                    // Save an String value to 'action' key.
                    bool tokenIsSet = await prefs.setString('scantoken', token);

                    if (tokenIsSet) {
                      EasyLoading.showToast(
                        'Token enregistré avec succès.',
                        toastPosition: EasyLoadingToastPosition.top,
                      );
                      _getBack();
                    } else {
                      EasyLoading.showToast(
                        'Something went wrong try again !',
                        toastPosition: EasyLoadingToastPosition.top,
                      );
                    }
                    ////////:

                    ////////////////////////////////////////////////////////////////
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
