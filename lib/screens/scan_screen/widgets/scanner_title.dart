import 'package:flutter/material.dart';

class ScannerTitle extends StatelessWidget {
  const ScannerTitle({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      child: Container(
        margin: const EdgeInsets.only(top: 100),
        width: double.infinity,
        color: Colors.transparent,
        child: SafeArea(
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: DefaultTextStyle.of(context).style,
              children: [
                const TextSpan(
                  text: 'Placez le  ',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                TextSpan(
                  text: ' Code QR ',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    backgroundColor: Colors.white.withOpacity(0.3),
                  ),
                ),
                const TextSpan(
                  text: ' dans la ',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                TextSpan(
                  text: ' zone de scan ',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    backgroundColor: Colors.white.withOpacity(0.3),
                  ),
                ),
                const TextSpan(
                  text: ' le\nprocessus de scan commencera automatiquement',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
