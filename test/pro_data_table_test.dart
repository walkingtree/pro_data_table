import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pro_data_table/pro_data_table.dart';


void main() {
  testWidgets('datatable test', (WidgetTester tester)async{

    await tester.pumpWidget(ProDataTable(   tblRow : [
    {
    'firstName': "Shubham",
    'lastName': "B",
    'id': 2001,
    'email': "shubham.b@walkingtree.tech"
    }],tblHdr: [
      {
      'name': 'First Name',
      'numeric': false,
      'columnName': 'firstName',
      'filter': false,
      'edit': true
      },]));

    final singleChildScrollViewFinder  = find.byKey(ValueKey("abc"));
    expect(singleChildScrollViewFinder, findsOneWidget);

    final containerFinder  = find.byKey(ValueKey("abcd"));
    expect(containerFinder, findsOneWidget);

    final listViewFinder  = find.byKey(ValueKey("abcde"));
    expect(listViewFinder, findsOneWidget);


  });

}

