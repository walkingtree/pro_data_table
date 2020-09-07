library pro_data_table;


// library pro_dataTable;

import 'dart:collection';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class ProDataTable extends StatefulWidget {
  //A key for the Widget
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


  String dropdownValue;

  List _rowData;

  void initState() {
    super.initState();
    _rowDatas = widget.tblRow;      //assigning the row data passed to local list
    _rowData = _rowDatas;
    _sort = widget.sort;             // assingning the sort true/false to local variable
    _selectedSort = widget.selectedSort;      // assigning the initial sort column index
    getFilteredCols();                 // Call the `getFilteredCols` callback function
    onSortColumn(_selectedSort, _sort);   // Call the `onSortColumn` callback function

  }


// adding the filterable columns to a list
  List<dynamic> getFilteredCols() {
    _filterCols = widget.tblHdr.where((i) => i['filter'] == true).toList();

  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      key: ValueKey('appbarkey'),
          title: Text(widget.title), actions: [
        IconButton(
          icon: Icon(Icons.delete),
          onPressed: () {
            //delete operation on row data with the selected items
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
            getCsv(widget.tblHdr, _rowData); // Call the `onSortColumn` callback function
          },
        ),
      ]),
      body: Column(
        children: <Widget>[
          Expanded(
            child: tableBody(
              context,
            ),                              // Call the `tableBody` callback function
          ),
        ],
      ),
    );
  }

  //This will get the all distinct records  for filter dropdown
  List<dynamic> getDistinct(columnName) {
    _distinctIds =
        LinkedHashSet<String>.from(_rowData.map((e) => e[columnName])).toList();
    return _distinctIds;
  }

  SingleChildScrollView tableBody(BuildContext ctx) {

    //Filtering data based on the  selected values from dropdown
    // if selected values are empty show all the data else filtered data
    _rowDatas = _selectedValues.length > 0
        ? searchSelected(
      _selectedValues,
    )
        : _rowData;

    //Returns the datatable widget
    return SingleChildScrollView(
      key: ValueKey('singlechildkey'),
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          key: ValueKey('datatablekey'),
          dataRowHeight: 50,
          dividerThickness: 5,
          sortAscending: _sort,
          sortColumnIndex: _selectedSort,
          showCheckboxColumn: true,
          columns: widget.tblHdr                          // Mapping the header list which passed as a param
              .map((element) => DataColumn(
            label: Container(
              width: 150,
              height: 60,
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
                                    Icon(                    //if  the the selected values contain  the iteration,will show green radio button.
                                      _selectedValues
                                          .contains(option)
                                          ? Icons
                                          .radio_button_checked
                                          : Icons
                                          .radio_button_unchecked,
                                      color: _selectedValues
                                          .contains(option)
                                          ? Colors.blue
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
                          if (_selectedValues.contains(option)) //check and uncheck the radio button on selected
                            _selectedValues.remove(option);
                          else
                            _selectedValues.add(option);
                        });

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
                  Colors.blueAccent.withOpacity(0.08))
                  : MaterialStateProperty.all<Color>(Colors.white),
              onSelectChanged: (b) {

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
            ),
          )
              .toList(),
        ),
      ),
    );
  }


//passing the initial sort index and sortable true/false
  //sort operation on columns for ascending and descending

  onSortColumn(int columnIndex, bool ascending) {

    String columnName = widget.tblHdr[columnIndex]['columnName'];
    bool numeric = widget.tblHdr[columnIndex]['numeric'];

    if (numeric != true) {

      if (ascending) {
        _rowDatas.sort((a, b) => a[columnName].compareTo(b[columnName]));
      } else {
        _rowDatas.sort((a, b) => b[columnName].compareTo(a[columnName]));
      }
    } else {
      if (ascending) {
        Comparator<dynamic> idComparator =
            (a, b) => a[columnName].compareTo(b[columnName]); //comparing two columns
        _rowDatas.sort(idComparator);
      } else {
        Comparator<dynamic> idComparator =
            (a, b) => b[columnName].compareTo(a[columnName]);
        _rowDatas.sort(idComparator);
      }
    }
  }

  //All Selected rows will be added to the  '_selectedData' list.
  onSelectedRow(bool selected, dynamic data) async {
    setState(() {
      if (selected) {
        _selectedData.add(data);
      } else {
        _selectedData.remove(data);
      }
    });

  }

//Updates the edited cell with latest value
  updateName(index, colName) {

    if (editNameController.text != '') {
      setState(() {
        _rowDatas[index][colName] = editNameController.text;
        selectedName = '';
      });
    }

    editNameController.text = '';
  }
// Returns Text data cell
  Widget getTextCell(String _rowName) {
    return Text(_rowName);
  }
// Returns Text data or if edit is true returns a textformfield

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

  //Returns the filtered data
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


  //Exporting the List data as csv file
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

      rows.add(row);
    }

    List<dynamic> row = List();
    for (int i = 0; i < associateList.length; i++) {
      row.add(associateList[i]['name']);
    }

    rows.insert(0, row);

    await Permission.storage.request(); //asking for storage permission 

    bool checkPermission = await Permission.storage.isGranted;

    if (checkPermission) {
//store file in documents folder

      String dir = (await getExternalStorageDirectory()).absolute.path + "/doc";
      var file = "$dir";

      var myFile = File(file + ".csv");

// convert rows to String and write as csv file

      String csv = const ListToCsvConverter().convert(rows);

      await myFile.writeAsString(csv);

    }
  }
}
