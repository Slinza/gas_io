import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:gas_io/design/themes.dart';

const TextStyle subtitleTextStyle = TextStyle(
  color: primaryColor,
  fontSize: 18,
  fontFamily: 'Red Rose',
  fontWeight: FontWeight.w500,
  height: 0.01,
);

BoxDecoration statsContainerDecoration = BoxDecoration(
  color: cardColor,
  borderRadius: BorderRadius.circular(20),
  boxShadow: const [
    BoxShadow(
      color: Colors.grey,
      blurRadius: 4,
      offset: Offset(4, 8), // Shadow position
    ),
  ],
);

TextStyle cardStyle =
    GoogleFonts.abel(textStyle: const TextStyle(fontSize: 18));

TextStyle detailsStyle =
    GoogleFonts.abel(textStyle: const TextStyle(fontSize: 24));

TextStyle detailsStyleBold = GoogleFonts.abel(
    textStyle: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold));

const TextStyle onbordingTitleStyle = TextStyle(
  color: cardColor,
  fontSize: 24,
  fontFamily: 'Red Rose',
  fontWeight: FontWeight.w500,
  height: 0.01,
);
