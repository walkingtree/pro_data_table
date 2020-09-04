// library pro_dataTable;

import 'dart:collection';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

class ProDataTable extends StatefulWidget {
  ///A key for the Widget
  final Key key;
  //The Table Row data
  List<dynamic> tblRow;
  //The Table Header column data
  List<dynamic> tblHdr;
  //The Table Title
  String title;
//The default sorted column index
  int selectedSort;
//Default ascending sort true/false
  bool sort;
  ProDataTable({
    this.key,
    @required this.tblRow,
    @required this.tblHdr,
    @required this.title,
    this.selectedSort = 0,
    this.sort = true,
  });

  @override
  _ProDataTableState createState() => _ProDataTableState();
}

class _ProDataTableState extends State<ProDataTable> {
  List _distinctIds;
  List<String> _selectedValues = <String>[];
  List<dynamic> _filterCols = [];
  List<dynamic> _selectedData = [];
  List<dynamic> _rowDatas = [];

  String selectedName;
  final nameController = TextEditingController();
  final editNameController = TextEditingController();
  final lastNameController = TextEditingController();
  bool _sort;
  int _selectedSort;
  // bool flag = true;

  String dropdownValue;

  List _rowData;

  void initState() {
    super.initState();
    _rowDatas = widget.tblRow;
    _rowData = _rowDatas;
    _sort = widget.sort;
    _selectedSort = widget.selectedSort;
    getFilteredCols();
    onSortColumn(_selectedSort, _sort);
    // selectedData = [];
  }

  List<dynamic> getFilteredCols() {
    _filterCols = widget.tblHdr.where((i) => i['filter'] == true).toList();
    print('_filterCols');
    print(_filterCols);
    // return _filterCols;
  }

  void launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title), actions: [
        IconButton(
          icon: Icon(Icons.delete),
          onPressed: () {
            setState(
              () {
                _selectedData.forEach(
                  (element) {
                    _rowData.remove(element);
                  },
                );
                _selectedValues.clear();
              },
            );
          },
        ),
        IconButton(
          icon: Icon(Icons.share),
          onPressed: () {
            getCsv(widget.tblHdr, _rowData);
          },
        ),
        IconButton(
          icon: Icon(Icons.save),
          onPressed: () {
print("***Updated data will send in a callback function***");
          },
        ),
      ]),
      body: Column(
        children: <Widget>[
          Expanded(
            child: tableBody(
              context,
            ),
          ),
        ],
      ),
    );
  }

  List<dynamic> getDistinct(columnName) {
    _distinctIds =
        LinkedHashSet<String>.from(_rowData.map((e) => e[columnName])).toList();
    return _distinctIds;
  }

  SingleChildScrollView tableBody(BuildContext ctx) {
    _rowDatas = _selectedValues.length > 0
        ? searchSelected(
            _selectedValues,
          )
        : _rowData;

    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          dataRowHeight: 50,
          dividerThickness: 0,
          sortAscending: _sort,
          sortColumnIndex: _selectedSort,
          showCheckboxColumn: true,
          columns: widget.tblHdr
              .map((element) => DataColumn(
                    label: Container(
                      width: MediaQuery.of(context).size.width*0.3,
                      height: MediaQuery.of(context).size.height*0.1,
                      //  color: Colors.green,
                      child: Row(
                        children: [
                          Text(element['name']),
                          element['filter'] == true
                              ? PopupMenuButton(
                                  itemBuilder: (_) =>
                                      getDistinct(element['columnName'])
                                          .map((option) {
                                        return PopupMenuItem<String>(
                                            child: Row(
                                              children: [
                                                Icon(
                                                  _selectedValues
                                                          .contains(option)
                                                      ? Icons
                                                          .radio_button_checked
                                                      : Icons
                                                          .radio_button_unchecked,
                                                  color: _selectedValues
                                                          .contains(option)
                                                      ? Colors.green
                                                      : Colors.grey,
                                                  size: 15,
                                                ),
                                                SizedBox(width: 10),
                                                Text(option)
                                              ],
                                            ),
                                            value: option);
                                      }).toList(),
                                  onSelected: (option) {
                                    setState(() {
                                      if (_selectedValues.contains(option))
                                        _selectedValues.remove(option);
                                      else
                                        _selectedValues.add(option);
                                    });
                                    print(_selectedValues);
                                  })
                              : SizedBox()
                        ],
                      ),
                    ),
                    onSort: (columnIndex, ascending) {
                      setState(() {
                        _sort = !_sort;
                        _selectedSort = columnIndex;
                      });
                      onSortColumn(columnIndex, ascending);
                    },
                  ))
              .toList(),
          rows: _rowDatas
              .map(
                (_row) => DataRow.byIndex(
                  index: _rowDatas.indexOf(_row),
                  // key: ValueKey(user.rollNo),
                  selected: _selectedData.contains(_row),
                  color: (_rowDatas.indexOf(_row) % 2) == 0
                      ? MaterialStateProperty.all<Color>(
                          Colors.green.withOpacity(0.08))
                      : MaterialStateProperty.all<Color>(Colors.white),
                  onSelectChanged: (b) {
                    print("Onselect");
                    onSelectedRow(b, _row);
                  },
                  cells: widget.tblHdr
                      .map(
                        (element) => (element['edit'] == true)
                            ? DataCell(
                                getCell(
                                  _row[element['columnName']],
                                  element['columnName'],
                                  _rowDatas.indexOf(_row),
                                ),
                                onTap: () {
                                  setState(() {
                                    selectedName = _row[element['columnName']];
                                  });
                                  print(
                                      'Toggle ${_row[element['columnName']]}');
                                },
                              )
                            : DataCell(
                                getTextCell(
                                  //'lastName',
                                  _row[element['columnName']].toString(),
                                ),
                              ),
                      )
                      .toList(),
                  // [DataCell(
                  //   // Text(_row.firstName),
                  //   getCell(_row['firstName'], _rowDatas.indexOf(_row)),
                  //   onTap: () {
                  //     setState(() {
                  //       selectedName = _row['firstName'];
                  //     });
                  //     print('Toggle ${_row['firstName']}');
                  //   },
                  // ),
                  // DataCell(
                  //   Text(_row['lastName']),
                  // ),
                  // DataCell(
                  //   Text('${_row['id']}'),
                  // ),
                  // DataCell(
                  //   Text(_row['email']),
                  // ),]
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  onSortColumn(int columnIndex, bool ascending) {
    print('on sort column');
    print(widget.tblHdr[columnIndex]);
    String columnName = widget.tblHdr[columnIndex]['columnName'];
    bool numeric = widget.tblHdr[columnIndex]['numeric'];
    // final sort_rowData = _rowData as Map<String, dynamic>;

    print(columnName);
    print(columnIndex);
    if (numeric != true) {
      print(columnName);
      if (ascending) {
        _rowDatas.sort((a, b) => a[columnName].compareTo(b[columnName]));
      } else {
        _rowDatas.sort((a, b) => b[columnName].compareTo(a[columnName]));
      }
    } else {
      if (ascending) {
        Comparator<dynamic> idComparator =
            (a, b) => a[columnName].compareTo(b[columnName]);
        _rowDatas.sort(idComparator);
      } else {
        Comparator<dynamic> idComparator =
            (a, b) => b[columnName].compareTo(a[columnName]);
        _rowDatas.sort(idComparator);
      }
    }
  }

  onSelectedRow(bool selected, dynamic data) async {
    setState(() {
      if (selected) {
        _selectedData.add(data);
      } else {
        _selectedData.remove(data);
      }
    });
    print(_selectedData);
  }

  updateName(index, colName) {
    print('In');
    print(editNameController.text);
    if (editNameController.text != '') {
      setState(() {
        _rowDatas[index][colName] = editNameController.text;
        selectedName = '';
      });
    }

    editNameController.text = '';
  }

  Widget getTextCell(String _rowName) {
    return Text(_rowName);
  }

  Widget getCell(String _rowName, String colName, int index) {
    return (_rowName != selectedName)
        ? Text(_rowName)
        : Container(
            width: 100,
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.grey, width: 0.2)),
                    ),
                    controller: editNameController,
                    onSaved: (newValue) => editNameController.text = newValue,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    updateName(index, colName);
                  },
                  padding: new EdgeInsets.all(2.0),
                  iconSize: 20,
                  icon: Icon(Icons.save, color: Colors.black),
                ),
              ],
            ),
          );
  }

  searchSelected(List<String> selectedValues) {
    List<dynamic> newDataList = [];

    _rowData.forEach(
      (x) => {
        _filterCols.forEach(
          (element) {
            if (selectedValues.contains(x[element['columnName']])) {
              if (!newDataList.contains(x)) {
                newDataList.add(x);
              }
            }
          },
        )
      },
    );
    return newDataList;
  }

  getCsv(associateList, tblRow) async {
    //create an element rows of type list of list. All the above data set are stored in associate list
//Let associate be a model class with attributes name,gender and age and associateList be a list of associate model class.

    List<List<dynamic>> rows = List<List<dynamic>>();

    for (int i = 0; i < tblRow.length; i++) {
//row refer to each column of a row in csv file and rows refer to each row in a file
      List<dynamic> row = List();
      for (int j = 0; j < associateList.length; j++) {
        row.add(tblRow[i][associateList[j]['columnName']]);
      }
      // row.add(tblRow[i]['firstName']);
      // row.add(tblRow[i]['lastName']);
      // row.add(tblRow[i]['id']);
      // row.add(tblRow[i]['email']);
      print(row.toString());
      rows.add(row);
    }

    List<dynamic> row = List();
    for (int i = 0; i < associateList.length; i++) {
      row.add(associateList[i]['name']);
    }
    print(rows.toString());
    rows.insert(0, row);
    print(rows.toString());
    await Permission.storage.request();

    bool checkPermission = await Permission.storage.isGranted;

    if (checkPermission) {
//store file in documents folder

      String dir = (await getExternalStorageDirectory()).absolute.path + "/doc";
      var file = "$dir";
      print(file);
      var myFile = File(file + ".csv");

// convert rows to String and write as csv file

      String csv = const ListToCsvConverter().convert(rows);
      await myFile.writeAsString(csv);
      launchURL(file + ".csv");
    }
  }
}
