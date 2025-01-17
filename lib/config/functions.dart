import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

import '../services/remote/remote_service.dart';
import '../widgets/all_sheet_header.dart';
import '../widgets/custom_button.dart';
import 'app_text.dart';
import 'palette.dart';

class Functions {
  static void showSnackBar(
      {required BuildContext ctxt, required String messeage}) {
    ScaffoldMessenger.of(ctxt).showSnackBar(
      SnackBar(
        content: AppText.medium(
          messeage,
          color: Colors.white70,
        ),
        duration: const Duration(seconds: 3),
        elevation: 5,
      ),
    );
  }

  // met a jour un user
  static Future<dynamic> scanValidation({
    required Map<String, dynamic> data,
    required String uniqueCode,
  }) async {
    var response = await RemoteService().putSomethings(
      api: 'tickets/$uniqueCode/scan',
      data: data,
    );
    return response;
  }

  /// bottom sheet preconfiguré
  static Future<void> showBottomSheet({
    required BuildContext ctxt,
    required Widget widget,
    required Size size,
    double heightRatio = 1.3,
    bool isMargin = false,
  }) async {
    return await showModalBottomSheet(
      enableDrag: false,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      useSafeArea: true,
      context: ctxt,
      builder: (context) {
        return Container(
          margin: isMargin
              ? EdgeInsets.only(
                  top: size.height - (size.height / heightRatio),
                )
              : EdgeInsets.zero,
          height: size.height / heightRatio,
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
            ),
          ),
          child: widget,
        );
      },
    );
  }

  static BorderRadius borderRadius() {
    return const BorderRadius.only(
      topLeft: Radius.circular(15),
      topRight: Radius.circular(15),
    );
  }

  /// renvoi un widget avec a l'intérieur un érreur 404
  static Widget widget404({required Size size, required BuildContext ctxt}) {
    return Container(
      /* width: double.infinity, */
      height: 260,
      /* margin: EdgeInsets.only(bottom: keyboardHeight), */
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
      //height: size.height / 1.5,
      width: size.width,
      child: Center(
        child: Column(
          children: [
            const AllSheetHeader(),
            Padding(
              padding: const EdgeInsets.only(top: 20, right: 20, left: 20),
              child: Column(
                children: [
                  Container(
                      width: 135,
                      height: 135,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: SvgPicture.asset('assets/icons/404.svg')),
                  //AppText.medium('Not found !'),
                  AppText.small('Aucune correspondance !'),
                  const SizedBox(
                    height: 20,
                  ),
                  //Expanded(child: Container()),
                  CustomButton(
                    color: Palette.appRed,
                    width: double.infinity,
                    height: 35,
                    radius: 5,
                    text: 'Retour',
                    onPress: () => Navigator.pop(ctxt),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  static Widget inactifQrCode({required BuildContext ctxt}) {
    return Container(
      width: double.infinity,
      height: 230,
      /* margin: EdgeInsets.only(bottom: keyboardHeight), */
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
      child: Column(
        children: [
          const AllSheetHeader(),
          Padding(
            padding: const EdgeInsets.only(top: 20, right: 20, left: 20),
            child: Column(
              children: [
                Container(
                  width: 70,
                  height: 70,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: AssetImage('assets/images/disconnect.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                AppText.medium('Oops !'),
                AppText.small('Ce Qr code est suspendu !'),
                const SizedBox(
                  height: 20,
                ),
                CustomButton(
                  color: Palette.appRed,
                  width: double.infinity,
                  height: 35,
                  radius: 5,
                  text: 'Retour',
                  onPress: () => Navigator.pop(ctxt),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

/*   static Future<TicketModel?> getTicketFromApi(
      {required String uniqueCode}) async {
    return await RemoteService().getTicket(uniqueCode: uniqueCode);
  } */

  // simple bottom sheet
  static Future<void> showSimpleBottomSheet({
    required BuildContext ctxt,
    required Widget widget,
  }) async {
    return await showModalBottomSheet(
      isDismissible: true,
      enableDrag: true,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      useSafeArea: true,
      context: ctxt,
      builder: (context) {
        return widget;
      },
    );
  }

  static TextField getTextField({
    required TextEditingController controller,
    required String textFieldLabel,
    TextInputType keyboardType = TextInputType.name,
    double fontSize = 14,
    FontWeight fontWeight = FontWeight.w600,
    bool obscureText = false,
    void Function(String)? onChanged,
  }) {
    return TextField(
      onChanged: onChanged,
      obscureText: obscureText,
      controller: controller,
      keyboardType: keyboardType,
      style: TextStyle(
        color: Colors.black,
        fontSize: fontSize,
        fontWeight: fontWeight,
      ),
      cursorColor: Colors.black,
      decoration: InputDecoration(
        hintText: textFieldLabel,
        hintStyle: const TextStyle(color: Colors.grey),

        /* label: AppText.medium(
          textFieldLabel,
          color: Colors.grey.withOpacity(0.5),
        ), */
        border: InputBorder.none,
      ),
    );
  }

  static DateTime getToday() {
    // renvoi la date du jour
    return DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );
  }

  static bool containsCurrentDate(List<DateTime> dates) {
    DateTime currentDate = DateTime.now();
    for (DateTime date in dates) {
      if (date.year == currentDate.year &&
          date.month == currentDate.month &&
          date.day == currentDate.day) {
        return true;
      }
    }
    return false;
  }

  static Size contextSize(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return size;
  }

  static followOrganizer() {
    debugPrint('follow organizer');
  }

  static showToast({
    required String msg,
    ToastGravity gravity = ToastGravity.TOP,
  }) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: gravity,
      timeInSecForIosWeb: 1,
      backgroundColor: Palette.primaryColor,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  //

  ///
  static String numberFormat(String input) {
    // Supprimer les espaces et vérifier si l'entrée est un nombre valide
    String cleanedInput = input.replaceAll(' ', '');

    // Supprimer le ".0" à la fin de la chaîne si présent
    if (cleanedInput.endsWith('.0')) {
      cleanedInput = cleanedInput.substring(0, cleanedInput.length - 2);
    }

    // Convertir la chaîne nettoyée en entier
    int? number = int.tryParse(cleanedInput);

    // Si la conversion réussit, formater avec des espaces
    if (number != null) {
      final formattedNumber = NumberFormat('#,###', 'fr_FR').format(number);
      return formattedNumber.replaceAll(',', ' ');
    }

    // Si la conversion échoue, renvoyer la chaîne d'origine
    return input;
  }
}
