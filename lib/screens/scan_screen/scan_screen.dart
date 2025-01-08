import 'dart:io';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:rti_events/config/app_text.dart';
import 'package:rti_events/widgets/all_sheet_header.dart';
import 'package:rti_events/widgets/custom_button.dart';

import '../../config/functions.dart';
import '../../config/overlay.dart';
import '../../config/palette.dart';
import '../../providers/keyboardvisibility.provider.dart';
import '../scan_history/scan_history.dart';
import 'widgets/scanner.dart';
import 'widgets/scanner_title.dart';
import 'widgets/search_ticket.dart';
import 'widgets/token_checker.dart';

class ScannerScreen extends ConsumerStatefulWidget {
  static const routeName = '/';
  const ScannerScreen({super.key});

  @override
  ScannerScreenState createState() => ScannerScreenState();
}

class ScannerScreenState extends ConsumerState<ScannerScreen> {
  /// bools

  bool isFlashOn = false;
  bool isFontCamera = false;

  //controllers
  MobileScannerController mobileScannerController = MobileScannerController();

  //init audio player
  AudioCache player = AudioCache();

  @override
  Widget build(BuildContext context) {
    //final size = MediaQuery.of(context).size;
    //print(size.width);
    bool isKeyboardVisible = ref.watch(keyboardVisibilityProvider);
    return Scaffold(
      body: Stack(
        children: [
          Scanner(
            controller: mobileScannerController,
          ),
          Visibility(
            visible: !isKeyboardVisible,
            child: QRScannerOverlay(
              overlayColour: Colors.black.withOpacity(0.45),
            ),
          ),
          /////////////// top widgets menu//s///////////
          Positioned(
            child: Container(
              width: double.infinity,
              color: Colors.transparent,
              child: SafeArea(
                child: AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  centerTitle: true,
                  title: AppText.medium(
                    'Scanner',
                    color: Palette.whiteColor,
                  ),
                ),
              ),
            ),
          ),
          const ScannerTitle(),

          ////////// bottom widgets //////////////////////:
          Positioned(
            bottom: 35,
            right: 15,
            child: Container(
              // margin: EdgeInsets.only(top: size.height / 1.2),
              //width: double.infinity,
              color: Colors.transparent,
              child: SafeArea(
                child: Column(
                  //mainAxisAlignment: MainAxisAlignment.center,
                  //crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.2),
                      ),
                      child: InkWell(
                        onTap: () {
                          mobileScannerController.toggleTorch();
                          setState(() {
                            isFlashOn = !isFlashOn;
                          });
                        },
                        child: Icon(
                          color: Colors.white,
                          !isFlashOn
                              ? FluentIcons.flash_off_24_regular
                              : FluentIcons.flash_24_filled,
                        ),
                      ),
                    ),
                    const Gap(10),
                    Container(
                      padding: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.2),
                      ),
                      child: InkWell(
                        onTap: () async {
                          ref.read(keyboardVisibilityProvider.notifier).state =
                              true;
                          await Functions.showSimpleBottomSheet(
                            ctxt: context,
                            widget: const TokenChecker(),
                          );
                          ref.read(keyboardVisibilityProvider.notifier).state =
                              false;
                        },
                        child: const Icon(
                          color: Colors.white,
                          FluentIcons.key_24_regular,
                        ),
                      ),
                    ),
                    const Gap(10),
                    Container(
                      padding: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.2),
                      ),
                      child: InkWell(
                        onTap: () async {
                          // Show keyboard visibility as true before displaying the action sheet
                          ref.read(keyboardVisibilityProvider.notifier).state =
                              true;

                          // Display the modal action sheet and wait for a selection
                          if (Platform.isIOS) {
                            await _iosActions();
                          } else {
                            await Functions.showSimpleBottomSheet(
                              ctxt: context,
                              widget: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 15,
                                ),
                                width: double.infinity,
                                height: 140,
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
                                    Expanded(
                                      child: Column(
                                        children: [
                                          AppText.medium('Historique de scan'),
                                          const Gap(3),
                                          AppText.normal(
                                              'Afficher l\'historique de scan de ce jour'),
                                          const Gap(15),
                                          CustomButton(
                                            color: Palette.appRed,
                                            width: double.infinity,
                                            height: 35,
                                            radius: 5,
                                            text: 'Afficher',
                                            onPress: () => _gotoScanHistory(),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }

                          // Reset keyboard visibility to false
                          ref.read(keyboardVisibilityProvider.notifier).state =
                              false;
                        },
                        child: const Icon(
                          color: Colors.white,
                          FluentIcons.history_24_regular,
                        ),
                      ),
                    ),
                    const Gap(10),
                    Container(
                      padding: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.2),
                      ),
                      child: InkWell(
                        onTap: () async {
                          ref.read(keyboardVisibilityProvider.notifier).state =
                              true;
                          await Functions.showSimpleBottomSheet(
                            ctxt: context,
                            widget: const SearchTicket(),
                          );
                          ref.read(keyboardVisibilityProvider.notifier).state =
                              false;
                        },
                        child: const Icon(
                          color: Colors.white,
                          FluentIcons.search_24_regular,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  void _gotoScanHistory() {
    Navigator.pushNamed(context, ScanHistory.routeName);
  }

  Future<void> _iosActions() async {
    final selectedAction = await showModalActionSheet<String>(
      context: context,
      title: 'Historique de scan',
      message: 'Afficher l\'historique de scan de ce jour',
      actions: [
        const SheetAction(
          label: 'Afficher',
          key: 'option1', // You can identify actions by these keys
        ),
      ],
      cancelLabel: 'Annuler',
    );

    // Handle the selected action
    if (selectedAction == 'option1') {
      //
      _gotoScanHistory();
    } else if (selectedAction == 'option2') {
      // Perform action for Option 2
    }
  }
}
