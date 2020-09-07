import 'package:flutter/material.dart';
import 'package:data_table_demo/pro_dataTable.dart';
import 'package:data_table_demo/models/employee.dart';

class ContainerScreen extends StatefulWidget {
  @override
  _ContainerScreenState createState() => _ContainerScreenState();
}

class _ContainerScreenState extends State<ContainerScreen> {

  final tblRow = [
    {
      'firstName': "Shubham",
      'lastName': "B",
      'id': 2001,
      'email': "shubham.b@walkingtree.tech"
    },
    {
      'firstName': "HariKrishna",
      'lastName': "S",
      'id': 1002,
      'email': "harikrishna.s@walkingtree.tech"
    },
    {
      'firstName': "Vishnu",
      'lastName': "P",
      'id': 2003,
      'email': "vishnu.p@walkingtree.tech"
    },
    {
      'firstName': "Suman",
      'lastName': "Ravuri",
      'id': 1004,
      'email': "Suman.ravuri@walkingtree.tech"
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
    {
      'name': 'Last Name',
      'numeric': false,
      'columnName': 'lastName',
      'filter': true,
    },
    {
      'name': 'Id',
      'numeric': true,
      'columnName': 'id',
      'filter': false,
    },
    {
      'name': 'Email Id',
      'numeric': false,
      'columnName': 'email',
      'filter': true,
      'edit': true
    },
  ];
  @override
  Widget build(BuildContext context) {
    return ProDataTable(
      tblRow: tblRow,
      tblHdr: tblHdr,
      title: 'The Data Table Demo',
    );
  }
}
