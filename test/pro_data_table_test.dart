import 'package:flutter_test/flutter_test.dart';

import 'package:pro_data_table/pro_data_table.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('pro_data_table', (WidgetTester tester)async{

    await tester.pumpWidget(ProDataTable());

    final singleChildScrollViewFinder  = find.byKey(ValueKey("singlechildkey"));
    expect(singleChildScrollViewFinder, findsOneWidget);

    final datatableFinder  = find.byKey(ValueKey("datatablekey"));
    expect(datatableFinder, findsOneWidget);

    final appbarFinder  = find.byKey(ValueKey("appbarkey"));
    expect(appbarFinder, findsOneWidget);

  });

}
