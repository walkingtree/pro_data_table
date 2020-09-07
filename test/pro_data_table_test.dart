import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:pro_data_table/pro_data_table.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('pro_data_table', (WidgetTester tester) async {
    final tblRow = [
      {
        'firstName': "Test",
        'lastName': "B",
        'id': 2001,
        'email': "test@walkingtree.tech"
      },
    ];
    final tblHdr = [
      {
        'name': 'First Name',
        'numeric': false,
        'columnName': 'firstName',
        'filter': false,
        'edit': true
      },

    ];
    await tester.pumpWidget(MaterialApp(
      home: ProDataTable(
        tblRow: tblRow,
        tblHdr: tblHdr,
        title: 'The Data Table Demo',
      ),
    ));

    final singleChildScrollViewFinder = find.byKey(ValueKey("singlechildkey"));
    expect(singleChildScrollViewFinder, findsOneWidget);

    final datatableFinder = find.byKey(ValueKey("datatablekey"));
    expect(datatableFinder, findsOneWidget);

    final appbarFinder = find.byKey(ValueKey("appbarkey"));
    expect(appbarFinder, findsOneWidget);
  });
}
