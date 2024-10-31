import 'package:flutter/material.dart';

import '../config/palette.dart';

Container buildIcon() {
  return Container(
    padding: const EdgeInsets.all(10),
    width: 100,
    height: 100,
    decoration: BoxDecoration(
      color: Palette.primaryColor.withOpacity(0.15),
      shape: BoxShape.circle,
    ),
    child: Container(
      padding: const EdgeInsets.all(10),
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: Palette.primaryColor.withOpacity(0.3),
        shape: BoxShape.circle,
      ),
      child: Container(
        padding: const EdgeInsets.all(10),
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: Palette.primaryColor.withOpacity(0.5),
          shape: BoxShape.circle,
        ),
        child: const Center(
          child: Icon(
            Icons.check,
            // size: 25,
            color: Colors.white,
          ),
        ),
      ),
    ),
  );
}
