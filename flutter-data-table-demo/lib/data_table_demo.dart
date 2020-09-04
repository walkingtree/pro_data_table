import 'dart:collection';
import 'dart:io';
import 'dart:async';
import 'dart:convert';
//import 'dart:html';
import 'dart:async';
import 'dart:io';
import 'package:android_intent/android_intent.dart';
import 'package:csv/csv.dart';
import 'package:data_table_demo/datatheme.dart';
import 'package:flutter/cupertino.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';


import './models/employee.dart';
import 'package:flutter/material.dart';



class DataTableDemo extends StatefulWidget {
  @override
  _DataTableDemoState createState() => _DataTableDemoState();
}

class _DataTableDemoState extends State<DataTableDemo>  {

  List<Employee> emps;
  List distinctIds;
  List<String> selectedValues = <String>[];
  List<Employee> selectedEmps = [] ;
  int selectedSort = 2;
  String selectedName;
  final nameController = TextEditingController();
  final editNameController = TextEditingController();
  final lastNameController = TextEditingController();
  bool sort = true;
  bool flag = true;
  List<dynamic> labels = [
    {'name': 'First Name', 'num': true, 'col': 'firstName', "flag" : false,},
    {'name': 'Last Name', 'num': true, 'col': 'lastName',"flag" : true , },
    {'name': 'Id', 'num': true, 'col': 'id',"flag" : false, },
    {'name': 'Email Id', 'num': true, 'col': 'email',"flag" : false,},
  ];



  String dropdownValue;

  List empss;

  String file;

void initState(){
 emps = Employee.getList();
  selectedEmps = [] ;
}


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Data Table Demo'),
        actions:[


          IconButton(
            icon: Icon(Icons.delete),
            onPressed: (){
              setState(() {
                selectedEmps.forEach((element) {
                  empss.remove(element);
                });
                selectedValues.clear();
              });
            },
          ),

          IconButton(
            icon: Icon(Icons.share),
            onPressed: (){
              getCsv(emps);

            },
          ),

        ]
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: tableBody(
              context,
            ),
          ),
          // Padding(
          //   padding: EdgeInsets.all(10.0),
          //   child: TextFormField(
          //       controller: nameController,
          //       decoration: InputDecoration(
          //         border: OutlineInputBorder(
          //             borderSide: BorderSide(color: Colors.grey, width: 0.2)),
          //         hintText: "Edit here",
          //         hintStyle: TextStyle(color: Colors.grey),
          //       )),
          // ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   mainAxisSize: MainAxisSize.min,
          //   children: <Widget>[
          //     Padding(
          //       padding: EdgeInsets.all(10.0),
          //       child: OutlineButton(
          //         child: Text('SELECTED ${selectedUsers.length}'),
          //         onPressed: () {},
          //       ),
          //     ),
          //     Padding(
          //       padding: EdgeInsets.all(10.0),
          //       child: OutlineButton(
          //         child: Text('DELETE SELECTED'),
          //         onPressed: selectedUsers.isEmpty
          //             ? null
          //             : () {
          //                 deleteSelected();
          //               },
          //       ),
          //     ),
          //   ],
          // ),
        ],
      ),
      floatingActionButton: new FloatingActionButton(
        child: Icon(Icons.add),
onPressed: (){
  setState(() {
//    Employee.getList().add(
//        Employee.getList()[ Employee.getList().length-1] =  new Employee(
//          firstName: "Hyderabad",
//          lastName: "C",
//          id: 20023,
//          email: "Hyd@walkingtree.tech"),
//    );
    emps.add(
        new Employee(
          firstName: "Hyderabad",
          lastName: "C",
          id: 20023,
          email: "Hyd@walkingtree.tech"),
    );
  });
  return Employee.getList();
}
      ),
    );
  }

  SingleChildScrollView tableBody(BuildContext ctx) {


    distinctIds = LinkedHashSet<String>.from(emps.map((e) => e.lastName)).toList();

    empss = selectedValues.length > 0
        ? searchSelected(selectedValues)
        : emps;

    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,

              child: DataTable(

                dataRowHeight: 50,
                dividerThickness: 5,
                sortAscending: sort,
                sortColumnIndex: selectedSort,
                showCheckboxColumn: true,
                columns: labels
                    .map(
                      (label) => DataColumn(
                        label:Container(
                          width: 150,
                          height: 60,
                        //  color: Colors.green,
                          child: Row(

                            children: [
                             Text(label['name']),
                          label['flag'] == true ?

                          PopupMenuButton(
                              itemBuilder: (_) =>
                                  distinctIds.map((option) {
                                    return new PopupMenuItem<String>(
                                        child: Row(
                                          children: [
                                            Icon(
                                              selectedValues.contains(option)
                                                  ? Icons.radio_button_checked
                                                  : Icons.radio_button_unchecked,
                                              color: selectedValues
                                                  .contains(option)
                                                  ? Colors.blue
                                                  : Colors.grey,
                                              size: 15,
                                            ),
                                            SizedBox(width: 10),
                                            Text(option)
                                          ],
                                        ), value: option );
                                  }).toList(),
                              onSelected: (option) {
                                setState(() {
                                  if (selectedValues.contains(option))
                                    selectedValues.remove(option);
                                  else
                                    selectedValues.add(option);
                                });
print(selectedValues);
                              })


                              :SizedBox()

                            ],
                          ),
                        ),
//                        label: Text(
//                          name['name'],
//                          style: TextStyle(
//                            fontStyle: FontStyle.italic,
//                            color: Colors.deepOrange,
//                          ),
//                        ),
                       // numeric: name['num'],
                        onSort: (columnIndex, ascending) {
                          print('In sort');
                          print(columnIndex);
                          print(ascending);
                          setState(() {
                            sort = !sort;
                            selectedSort = columnIndex;
                          });
                          onSortColumn(columnIndex, ascending);
                        },
                      )
                    )
                    .toList(),
                // columns: [
                //   DataColumn(
                //     label: Text(
                //       "First Name",
                //       style: TextStyle(
                //         fontStyle: FontStyle.italic,
                //         color: Colors.deepOrange,
                //       ),
                //     ),
                //     numeric: false,
                //     tooltip: "This is First Name",
                //     onSort: (columnIndex, ascending) {
                //       setState(() {
                //         sort = !sort;
                //       });
                //       onSortColumn(columnIndex, ascending);
                //     },
                //   ),
                //   DataColumn(
                //     label: Text(
                //       "Last Name",
                //       style: TextStyle(
                //         fontStyle: FontStyle.italic,
                //         color: Colors.deepOrange,
                //       ),
                //     ),
                //     numeric: false,
                //     tooltip: "This is Last Name",
                //   ),
                //   DataColumn(
                //     label: Text(
                //       "Id",
                //       style: TextStyle(
                //         fontStyle: FontStyle.italic,
                //         color: Colors.deepOrange,
                //       ),
                //     ),
                //     numeric: true,
                //     // onSort: (c, i) {
                //     //   setState(() {
                //     //     onSortRoll(users);
                //     //   });
                //     // },
                //   ),
                //   DataColumn(
                //     label: Text(
                //       "Email Id",
                //       style: TextStyle(
                //         fontStyle: FontStyle.italic,
                //         color: Colors.deepOrange,
                //       ),
                //     ),
                //     numeric: false,
                //     // onSort: (c, i) {
                //     //   setState(() {
                //     //     onSortRoll(users);
                //     //   });
                //     // },
                //   ),
                // ],
                rows: empss
                    .map(
                      (emp) => DataRow.byIndex(
                        index: empss.indexOf(emp),
                          // key: ValueKey(user.rollNo),
                          selected: selectedEmps.contains(emp),
                          color: ( empss.indexOf(emp) % 2) == 0 ? MaterialStateProperty.all<Color>(Colors.blueAccent.withOpacity(0.08)) : MaterialStateProperty.all<Color>(Colors.white),
                          onSelectChanged: (b) {
                            print("Onselect");
                            onSelectedRow(b, emp);
                          },
                          cells: [
                            DataCell(

                              // Text(emp.firstName),
                              getCell(emp.firstName, empss.indexOf(emp)),
                              onTap: () {
                                // print(LocalKey;
                                // dtable.setSelectedName(user.firstName);
                                setState(() {
                                  selectedName = emp.firstName;
                                });
                                print('Toggle ${emp.firstName}');
                              },
                            ),
                            DataCell(
                              Text(emp.lastName),
                              // getCell(user.firstName, users.indexOf(user)),
                              // onTap: () {
                              //   // print(LocalKey;
                              //   // dtable.setSelectedName(user.firstName);
                              //   setState(() {
                              //     selectedName = user.firstName;
                              //   });
                              //   print('Toggle ${user.firstName}');
                              // },
                            ),
                            DataCell(
                              Text('${emp.id}'),
                              // TextFormField(
                              //     controller: lastNameController,
                              //     decoration: InputDecoration(
                              //       border: OutlineInputBorder(
                              //           borderSide:
                              //               BorderSide(color: Colors.grey, width: 0.2)),
                              //       hintText: '',
                              //       hintStyle: TextStyle(color: Colors.grey),
                              //     )),
                              // placeholder: true,
                              // showEditIcon: true,
                              // onTap: () {
                              //   onTapCell(user);
                              // },
                            ),
                            DataCell(
                              Text(emp.email),
                            ),
                          ]),
                    )
                    .toList(),
              ),



      ),
    );
  }

  onSortColumn(int columnIndex, bool ascending) {
    print('on sort column');
    print(labels[columnIndex]);
    String columnName = labels[columnIndex]['col'];
    bool numeric = labels[columnIndex]['num'];
    // final sortEmps = emps as Map<String, dynamic>;

    print(columnName);
    print(columnIndex);
    if (numeric != true) {
      print(columnName);
      if (ascending) {
        empss.sort((a, b) => a.firstName.compareTo(b.firstName));
      } else {
        empss.sort((a, b) => b.firstName.compareTo(a.firstName));
      }
    }
    else{
      if (ascending) {
        Comparator<Employee> idComparator = (a, b) => a.id.compareTo(b.id);
        empss.sort(idComparator);
      } else {
        Comparator<Employee> idComparator = (a, b) => b.id.compareTo(a.id);
        empss.sort(idComparator);
      }
    }
  }

  onSelectedRow(bool selected, Employee emp) async {
    setState(() {
      if (selected) {
        selectedEmps.add(emp);
      } else {
        selectedEmps.remove(emp);
      }
    });
    print(selectedEmps);
  }

  updateName(index) {
    print('In');
    print(editNameController.text);
    if (editNameController.text != '') {
      setState(() {
        empss[index].firstName = editNameController.text;
        selectedName = '';
      });
    }

    editNameController.text = '';
  }

  Widget getCell(empName, index) {
    return (empName != selectedName)
        ? Text(empName)
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
                    updateName(index);
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
    List<Employee> newDataList = [];

    emps.forEach((x) => {
      if ( selectedValues.contains(x.lastName))
        {
          newDataList.add(x),
        }
    });
    return newDataList;
  }


  getCsv(associateList) async {

    //create an element rows of type list of list. All the above data set are stored in associate list
//Let associate be a model class with attributes name,gender and age and associateList be a list of associate model class.


    List<List<dynamic>> rows = List<List<dynamic>>();

    for (int i = 0; i <associateList.length;i++) {

//row refer to each column of a row in csv file and rows refer to each row in a file
      List<dynamic> row = List();
      row.add(associateList[i].firstName);
      row.add(associateList[i].lastName);
      row.add(associateList[i].id);
      row.add(associateList[i].email);
      print(row.toString());
      rows.add(row);
    }
    List Label = ['FirstName','LastName','Id','EmailId'];
    rows.insert(0,Label);



    await Permission.storage.request();

    bool checkPermission=await  Permission.storage.isGranted;
    if(checkPermission) {

//store file in documents folder

      String dir = (await getExternalStorageDirectory()).absolute.path+"/doc";
      file = "$dir";
      print(file);
      var myFile =  File(file+".csv");

// convert rows to String and write as csv file

      String csv = const ListToCsvConverter().convert(rows);
      await myFile.writeAsString(csv);



      String path = myFile.path;

      final AndroidIntent intent = AndroidIntent(
          action: 'action_view',
          data: Uri.encodeFull(path),
          type: "csv/*");
      intent.launch();
    }


  }
}
