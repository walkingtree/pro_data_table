# pro_data_table

A flutter plugin for a custom datatable.

## Features:
* Delete the data rows
* Theming the grid
* Export the data in csv file
* Save Changes

### Getting Started


<img src="https://github.com/abhilashahyd/pro_dataTable/blob/master/assets/images/2020-08-21%20(1).jpg" width="200">
<img src="https://github.com/abhilashahyd/pro_dataTable/blob/master/assets/images/2020-08-21.jpg" width="200">
<img src="https://github.com/abhilashahyd/pro_dataTable/blob/master/assets/images/2020-08-23%20(1).jpg" width="200">
<img src="https://github.com/abhilashahyd/pro_dataTable/blob/master/assets/images/2020-08-23.jpg" width="200">

#### Properties

```final Key key;   //A key for the widget``` 


```List<dynamic> tblRow;   //The Table Row data```

> **Example:**  final tblRow = [   <br />
>             {                      <br />
>               'firstName': "HariKrishna",  <br />
>              'lastName': "S",          <br />
>               'id': 2001,            <br />
>               'email': "harikrishna.s@walkingtree.com"   <br />
>             },                       <br />
>             ];                       <br />



``` List<dynamic> tblHdr;   //The Table Header column data,The object must contain below params. ``` <br />
 ``` name ```<br />
``` num  ```<br />
``` col ```<br />
``` flag ```<br />
``` edit ```<br />

>**Example:** List<dynamic> tblHdr = [ <br />
>             {                        <br />
>             'name': 'First Name',  &nbsp; // column name   <br />
>              'num': true,        &nbsp; // If the column is number column true else false  <br />
>               'col': 'firstName',  &nbsp; // column id                                <br />
>                "flag" : false,    &nbsp;// if the column has filter then true else false    <br />
>                "edit" : true,    &nbsp;// if the column is editable  then true else false    <br />
>                },                <br />                   
>          ];                                        
          
          
          
```String title;     //The Table Title```



```int selectedSort;   //Pass the default sorted column index```



```bool sort;         //Default ascending sort true/false```


##### Usage:

>ProDataTable(<br />
>     tblRow: tblRow, <br />
>      tblHdr: tblHdr, <br />
>      title: 'The Data Table Demo', <br />
>    ); <br />