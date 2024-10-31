import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gap/gap.dart';
import 'package:get/utils.dart';
import 'package:rti_events/widgets/custom_button.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../../config/app_text.dart';
import '../../../../config/functions.dart';
import '../../../../config/palette.dart';

import '../../../../widgets/all_sheet_header.dart';
import '../../../../widgets/error_sheet_container.dart';
import '../../../../widgets/infos_column.dart';
import '../../../models/inspector_model.dart';
import '../../../models/localization_model.dart';
import '../../../models/ticket_model.dart';
import '../../../services/remote/remote_service.dart';
import '../../../widgets/sucess_icon.dart';
import 'token_checker.dart';

class ScanSheet extends StatefulWidget {
  const ScanSheet({
    super.key,
    required this.ticket,
  });

  final TicketModel ticket;

  @override
  State<ScanSheet> createState() => _ScanSheetState();
}

class _ScanSheetState extends State<ScanSheet> {
  //////////////////////////////////////////:
  ///////////
  //TicketModel? _ticket;
  ///////////////////
  ///
  ///////////////////////////////////////////////
  String? _token;
  ////////////////////::
  ///
  bool isLoading = true;

  Future<void> fetchToken() async {
    // Obtain shared preferences.
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _token = prefs.getString("scantoken");
    /*  _ticket = await Functions.getTicketFromApi(uniqueCode: uniqueCode); */

    //print(_ticket);
  }

  ///
  ////////////////////////////////////////////
  @override
  void initState() {
    fetchToken().whenComplete(() {
      setState(() {
        isLoading = false;
      });
    });

    super.initState();
  }
  ////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return isLoading
        ? Center(
            child: Container(
              height: 100,
              padding: const EdgeInsets.all(18.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator.adaptive(
                    valueColor: AlwaysStoppedAnimation<Color>(Palette.appRed),
                  ),
                  const Gap(5),
                  AppText.small('Chargement...'),
                ],
              ),
            ),
          )
        : getWidget(ticket: widget.ticket, size: size, scantoken: _token);
  }

  ////////////////////////////////////////////////////////
  ///
  ///
  Widget getWidget({
    required TicketModel ticket,
    required Size size,
    required String? scantoken,
  }) {
    if (scantoken == null) {
      // token saver
      return const TokenChecker();
      //return Functions.inactifQrCode(ctxt: context);
      //return Functions.widget404(size: size, ctxt: context);
    }

    // vérifier l'existance de token
    List<InspectorModel> inspectors = ticket.event.inspectors ?? [];
    if (inspectors.isEmpty) {
      // personne n'est autorisé a scanné les tickets de cet évènnement pour le moment!
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
        child: const ErrorSheetContainer(
          text:
              "Personne n'est autorisé à scanner les tickets de cet événement pour le moment !",
        ),
      );
    }
    // vérifier une correspondance de token
    InspectorModel? inspect = inspectors
        .firstWhereOrNull((element) => element.scanToken == scantoken);
    if (inspect == null) {
      // vous n'est pas autorisé a scanné les tickets de cet évènnement
      // Veuillez vérifier votre token ou contacter l'organisateur.
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
        child: const ErrorSheetContainer(
          text:
              "Vous n'êtes pas autorisé à scanner les tickets de cet événement. Veuillez vérifier votre clé de scan ou contacter l'organisateur",
        ),
      );
    }

    // si ticket n'est pas active
    if (!ticket.active) {
      return Functions.inactifQrCode(ctxt: context);
    }

    if (!ticket.firstCheck) {
      return Container(
        width: double.infinity,
        height: 350,
        /* margin: EdgeInsets.only(bottom: keyboardHeight), */
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          ),
        ),
        child: FirstCheck(code: ticket.uniqueCode),
      );
    }

    // sinon si ticket à déjà été scanné
    if (ticket.scanned) {
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
        child: const ErrorSheetContainer(
          text: 'Ce Qr code a déjà été scanné !',
        ),
      );
    } else {
      // vérifier les dates de l'évennement

      /// liste pour stocké toutes les dates de l'évennement
      /// dans ticket.event.localizations
      List<DateTime> dates = [];
      // recuperation des dates
      for (LocalizationModel localization in ticket.event.localizations) {
        dates.add(localization.dateEvent);
      }
      ///// vérifier si l'un des dates dans _dates vaut la date d'aujourd'hui
      ///
      if (!Functions.containsCurrentDate(dates)) {
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
          child: const ErrorSheetContainer(
            icon: FluentIcons.calendar_24_regular,
            text:
                'Ce n\'est pas encore la date de l\'événement\nou la date est déjà passée.',
          ),
        );
      }

      // ou valider le scan

      return firstScan(ticket: ticket, token: inspect.scanToken);
    }
  }

  Widget firstScan({required TicketModel ticket, required String token}) {
    final size = MediaQuery.of(context).size;
    return Container(
      width: double.infinity,
      height: size.height / 1.6,
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
          Stack(
            children: [
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: Functions.borderRadius(),
                  image: const DecorationImage(
                    image: AssetImage('assets/images/ticket2.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  color: Colors.black.withOpacity(0.2),
                ),
              ),
              const AllSheetHeader(),
            ],
          ),
          //////////////////////// qr code infos /////////////////////
          ///////////////////////////////////////////////////////////
          const Gap(5),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  Container(
                    width: 150,
                    height: 145,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 2,
                        color: Palette.primaryColor,
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Container(
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(
                            'assets/images/qr-model.png',
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                    child: Column(
                      children: [
                        InfosColumn(
                          opacity: 0.1,
                          label: 'Pass',
                          widget: AppText.medium(
                            ticket.pass.name,
                            textOverflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(height: 10),
                        InfosColumn(
                          opacity: 0.1,
                          label: 'Event',
                          widget: AppText.medium(
                            ticket.event.name,
                            textOverflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(height: 10),
                        InfosColumn(
                          opacity: 0.1,
                          label: 'Code',
                          widget: AppText.medium(
                            ticket.uniqueCode,
                            textOverflow: TextOverflow.ellipsis,
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            /* child: CustomButton(
              color: Palette.secondaryColor,
              width: double.infinity,
              height: 35,
              radius: 5,
              text: 'Confirmer le scan',
              onPress: () {
                /*  Map<String, dynamic> data = {
                  "is_checked": 1,
                }; */
                EasyLoading.show(status: 'loading...');
                Future.delayed(const Duration(seconds: 5))
                    .then((value) => EasyLoading.dismiss());
              },
            ), */
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              width: double.infinity,
              child: CustomButton(
                color: Palette.appRed,
                width: double.infinity,
                height: 35,
                radius: 5,
                text: 'Confirmer le scan',
                onPress: () {
                  //////////// implementer la validation du scan //////////////////
                  Map<String, dynamic> data = {
                    /* "scanned": 1, */
                    "token": token,
                  };
                  EasyLoading.show();

                  Functions.scanValidation(
                    data: data,
                    uniqueCode: ticket.uniqueCode,
                  ).then((response) {
                    EasyLoading.dismiss();
                    if (response != null) {
                      // _btnController.success();
                      EasyLoading.showToast(
                        'Scan confirmé !',
                        toastPosition: EasyLoadingToastPosition.top,
                      );
                    } else {
                      //_btnController.reset();
                      EasyLoading.showToast(
                        'Try again !',
                        toastPosition: EasyLoadingToastPosition.top,
                      );
                    }
                  });

                  ////////:

                  ////////////////////////////////////////////////////////////////
                },
              ),
            ),
          ),
          ///////////////////////////////////////////////////////////
          ///////////////////////////////////////////////////////////
        ],
      ),
    );
  }
}

class FirstCheck extends StatelessWidget {
  const FirstCheck({
    super.key,
    required this.code,
  });
  final String code;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const AllSheetHeader(),
        Expanded(
          child: Column(
            children: [
              const Gap(10),
              buildIcon(),
              const Gap(10),
              AppText.medium(
                'Ce billet est conforme',
                fontWeight: FontWeight.w500,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: AppText.small(
                  'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor .',
                  textAlign: TextAlign.center,
                  fontWeight: FontWeight.w300,
                ),
              ),
              const Gap(25),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: CustomButton(
                  color: Palette.appRed,
                  width: double.infinity,
                  height: 35,
                  radius: 5,
                  text: 'Valider la vérification',
                  onPress: () async {
                    // EasyLoading.show();

                    Map<String, dynamic> putData = {"first_check": 1};
                    await RemoteService()
                        .putSomethings(data: putData, api: 'tickets/$code');
                    EasyLoading.dismiss();

                    // ignore: use_build_context_synchronously
                    Navigator.of(context).pop();
                  },
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
