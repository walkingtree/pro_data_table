import 'package:flutter/material.dart';

class DataTableThemeData {
   DataTableThemeData({
    this.decoration,
      this.dataRowColor,
      this.headingRowColor,
     this.dataTextStyle,
     this.headingTextStyle,
     this.sortIconColor,
     this.sortIconPadding,
     this.dividerThickness,
     this.dataRowHeight,
     this.headingRowHeight,
     this.horizontalMargin,
     this.columnSpacing,
  });

   Decoration decoration; // This is new functionality, as currently you need to use a parent [Ink] widget to set the border or background color of DataTable.
   MaterialStateProperty<Color> dataRowColor;
   MaterialStateProperty<Color> headingRowColor;
   MaterialStateProperty<TextStyle> dataTextStyle;
   MaterialStateProperty<TextStyle> headingTextStyle;
   Color sortIconColor;
   EdgeInsetsGeometry sortIconPadding;
  double dividerThickness;
  double dataRowHeight;
  double headingRowHeight;
  double horizontalMargin;
  double columnSpacing;
  }
