import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart' as syspaths;
import '../controller/dbHelper.dart';
import '../models/studentHistoryModel.dart';
import '../models/studentModel.dart';
import 'addStudent.dart';

class studentOperations extends StatefulWidget {
  @override
  _studentOperationsState createState() => _studentOperationsState();

  StudentModel studentItem;
  studentOperations(this.studentItem);

  refresData(StudentModel item) {
    this.studentItem = item;
  }
}

class _studentOperationsState extends State<studentOperations> {
  final DateFormat formatter = DateFormat('dd, MMM yyy');
  final _totalFeesPaid = TextEditingController();
  final _remark = TextEditingController();
  var paidFees;
  final _formKey = GlobalKey<FormState>();
  var image_name;
  var app_path;
  var final_app_path;
  File imageFile;
  var fullPath;
  var feesPaid;
  bool _paidFeesLoader = true;

  String appDirectory;
  getApplicationPath() async {
    final appDir = await syspaths.getApplicationSupportDirectory();
    appDirectory = appDir.path;
    setState(() {
      if (widget.studentItem.studentPhoto != null) {
        fullPath = appDirectory + widget.studentItem.studentPhoto;
      }
    });
  }

  Future<bool> _onWillPop() async {
    Navigator.of(context).pop(true);
  }

  paidFeesSum() async {
    feesPaid = await DBProvider.db.getSum(widget.studentItem.studentId);
    _paidFeesLoader = false;
    setState(() {
      paidFees = feesPaid[0]['paid'].toString();
    });
    return;
  }

  _displayDialog(int id, BuildContext context) async {
    final result = await showDialog<bool>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Are you sure you want to delete this Student?',
                  style: TextStyle(fontSize: 17),
                ),
                Divider(),
                Text(
                  'Note: Fees History will be removed!!',
                  style: TextStyle(color: Colors.red, fontSize: 12),
                )
              ],
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
              new FlatButton(
                child: new Text('Ok'),
                onPressed: () async {
                  await DBProvider.db.deleteStudentHistory(id);
                  await DBProvider.db.deleteStudent(id);
                  Navigator.of(context).pop(true);
                  Navigator.of(context).pop(true);
                  // setState(() {
                  //   Navigator.push(
                  //     context,
                  //     MaterialPageRoute(builder: (context) => navbar()),
                  //   ).then((value) => setState(() {}));
                  // });
                },
              )
            ],
          );
        });
    if (result) {
      setState(() {});
    }
  }

  deleteFees(StudentHistoryModel item) async {
    var studentdata = widget.studentItem;
    setState(() {
      DBProvider.db.deleteRecord(item.historyId);
    });
    await paidFeesSum();

    StudentModel studentObj = new StudentModel();
    studentObj.studentId = studentdata.studentId;
    studentObj.studentName = studentdata.studentName;
    studentObj.studentCode = studentdata.studentCode;
    studentObj.addedDate = studentdata.addedDate;
    studentObj.joinedDate = studentdata.joinedDate;
    studentObj.modifyDate = DateTime.now();
    studentObj.status = studentdata.status;
    studentObj.feesAmount = studentdata.feesAmount;
    studentObj.isDeleted = 0;
    studentObj.address = studentdata.address;
    studentObj.remark = studentdata.remark;
    studentObj.studentPhoto = studentdata.studentPhoto;
    studentObj.parentMobile = studentdata.parentMobile;
    studentObj.batchId = studentdata.batchId;
    studentObj.totalFeesPaid = paidFees == "null" ? 0 : double.parse(paidFees);

    setState(() {
      DBProvider.db.updateStudent(studentObj);
    });
  }

  editFees(StudentHistoryModel item) async {
    StudentHistoryModel historyObj = new StudentHistoryModel();
    var studentdata = widget.studentItem;
    historyObj.studentId = item.studentId;
    historyObj.feesAmount = double.parse(_totalFeesPaid.text);
    historyObj.remark = _remark.text;
    historyObj.addedDate = item.addedDate;
    historyObj.historyId = item.historyId;

    setState(() {
      DBProvider.db.updateStudentHistorytable(historyObj);
    });
    await paidFeesSum();
    StudentModel studentObj = new StudentModel();
    studentObj.studentId = studentdata.studentId;
    studentObj.studentName = studentdata.studentName;
    studentObj.studentCode = studentdata.studentCode;
    studentObj.addedDate = studentdata.addedDate;
    studentObj.joinedDate = studentdata.joinedDate;
    studentObj.modifyDate = DateTime.now();
    studentObj.status = studentdata.status;
    studentObj.feesAmount = studentdata.feesAmount;
    studentObj.isDeleted = 0;
    studentObj.address = studentdata.address;
    studentObj.remark = studentdata.remark;
    studentObj.studentPhoto = studentdata.studentPhoto;
    studentObj.parentMobile = studentdata.parentMobile;
    studentObj.batchId = studentdata.batchId;
    studentObj.totalFeesPaid = double.parse(paidFees);

    setState(() {
      DBProvider.db.updateStudent(studentObj);
    });
  }

  payFees(StudentModel item) async {
    StudentHistoryModel historyObj = new StudentHistoryModel();
    historyObj.studentId = item.studentId;
    historyObj.feesAmount = double.parse(_totalFeesPaid.text);
    historyObj.remark = _remark.text;
    historyObj.addedDate = DateTime.now();
    setState(() {
      DBProvider.db.addStudentFees(historyObj);
    });
    await paidFeesSum();
    StudentModel studentObj = new StudentModel();
    studentObj.studentId = item.studentId;
    studentObj.studentName = item.studentName;
    studentObj.studentCode = item.studentCode;
    studentObj.addedDate = item.addedDate;
    studentObj.joinedDate = item.joinedDate;
    studentObj.modifyDate = DateTime.now();
    studentObj.status = item.status;
    studentObj.feesAmount = item.feesAmount;
    studentObj.isDeleted = 0;
    studentObj.address = item.address;
    studentObj.remark = item.remark;
    studentObj.studentPhoto = item.studentPhoto;
    studentObj.parentMobile = item.parentMobile;
    studentObj.batchId = item.batchId;
    studentObj.totalFeesPaid = double.parse(paidFees);

    setState(() {
      DBProvider.db.updateStudent(studentObj);
    });
  }

  _displayDialogForFees(StudentModel item, BuildContext context) async {
    var tmpFess = paidFees;
    _totalFeesPaid.text = "";
    _remark.text = "";
    final result = await showDialog<bool>(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              title: Text(
                'Pay Fees of ' + item.studentName,
                style: TextStyle(fontWeight: FontWeight.w900),
              ),
              actions: <Widget>[
                new FlatButton(
                  child: new Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                new FlatButton(
                  child: new Text('Pay Fees'),
                  onPressed: () {
                    setState(() {
                      if (_formKey.currentState.validate()) {
                        payFees(item);
                        Navigator.pop(context, true);
                      }
                    });
                  },
                ),
              ],
              content: Form(
                key: _formKey,
                child: Container(
                  height: 200,
                  width: 150,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          Column(
                            children: [
                              Text("Paid Fees:",
                                  style: TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16)),
                              paidFees == "null"
                                  ? Text("₹ 0.0",
                                      style: TextStyle(
                                          color: Colors.green,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16))
                                  : Text("₹ " + tmpFess.toString(),
                                      style: TextStyle(
                                          color: Colors.green,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16))
                            ],
                          ),
                          Spacer(),
                          Column(
                            children: [
                              Text("Total Fees:",
                                  style: TextStyle(
                                      color: Colors.orange,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16)),
                              Text("₹ " + item.feesAmount.toString(),
                                  style: TextStyle(
                                      color: Colors.orange,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16))
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Divider(),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                        child: TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter fees amount';
                            }
                            if (tmpFess > item.feesAmount) {
                              return 'Paid Fees <= Total Fees';
                            }
                            return null;
                          },
                          textInputAction: TextInputAction.done,
                          keyboardType: TextInputType.number,
                          controller: _totalFeesPaid,
                          decoration: InputDecoration(
                            hintText: "Enter Amount",
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.green),
                            ),
                          ),
                          onChanged: (amount) {
                            setState(() {
                              tmpFess = item.totalFeesPaid +
                                  double.parse(_totalFeesPaid.text);
                            });
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                        child: TextFormField(
                          controller: _remark,
                          textInputAction: TextInputAction.done,
                          keyboardType: TextInputType.multiline,
                          // onFieldSubmitted: (_) => _nameFocus.unfocus(),
                          decoration: InputDecoration(
                            hintText: "Enter Remark",
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.green),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          });
        });
    if (result == true && result != null) {
      setState(() {
        paidFeesSum();
      });
    }
  }

  _displayDialogEditHistory(
      StudentHistoryModel item, BuildContext context) async {
    // var tmpFess = item.totalFeesPaid;
    _totalFeesPaid.text = item.feesAmount.toString();
    _remark.text = item.remark;
    final result = await showDialog<bool>(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Edit fees history',
                    style: TextStyle(fontWeight: FontWeight.w900),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    formatter.format(item.addedDate),
                    style:
                        TextStyle(fontWeight: FontWeight.normal, fontSize: 14),
                  ),
                ],
              ),
              actions: <Widget>[
                new FlatButton(
                  child: new Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                ),
                new FlatButton(
                  child: new Text('Delete'),
                  onPressed: () {
                    setState(() {
                      deleteFees(item);
                      Navigator.of(context).pop(true);
                    });
                  },
                ),
                new FlatButton(
                  child: new Text('Update'),
                  onPressed: () {
                    setState(() {
                      if (_formKey.currentState.validate()) {
                        editFees(item);
                        Navigator.of(context).pop(true);
                      }
                    });
                  },
                ),
              ],
              content: Form(
                key: _formKey,
                child: Container(
                  height: 140,
                  width: 150,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Divider(),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                        child: TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter fees amount';
                            }
                            if (double.parse(_totalFeesPaid.text) >
                                widget.studentItem.feesAmount) {
                              return 'Paid Fees <= Total Fees';
                            }
                            return null;
                          },
                          textInputAction: TextInputAction.done,
                          keyboardType: TextInputType.number,
                          controller: _totalFeesPaid,
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                              onPressed: () => _totalFeesPaid.clear(),
                              icon: Icon(
                                Icons.clear,
                                color: Colors.grey,
                                size: 16,
                              ),
                            ),
                            hintText: "Enter Amount",
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.green),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                        child: TextFormField(
                          controller: _remark,
                          textInputAction: TextInputAction.done,
                          keyboardType: TextInputType.multiline,
                          decoration: InputDecoration(
                            hintText: "Enter Remark",
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.green),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          });
        });
    if (result == true && result != null) {
      setState(() {
        paidFeesSum();
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    getApplicationPath();
    paidFeesSum();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    StudentModel item = widget.studentItem;
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Color(0xFFEEEEEE),
        appBar: AppBar(
          title: Text(item.studentName + "'s Profile"),
          flexibleSpace: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: <Color>[Color(0xFF1E3B70), Color(0xFF29539B)])),
          ),
        ),
        body: _paidFeesLoader
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(13.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                                child: CircleAvatar(
                                  radius: 20,
                                  backgroundColor: Colors.grey[200],
                                  child: ClipOval(
                                    child: new SizedBox(
                                      width: 100.0,
                                      height: 100.0,
                                      child: (item.studentPhoto != null)
                                          ? Image.file(
                                              File(fullPath),
                                              fit: BoxFit.fill,
                                            )
                                          : Image.asset(
                                              "assets/student1.png",
                                              fit: BoxFit.fill,
                                            ),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.studentName,
                                      style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.call_rounded,
                                          size: 18,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              4, 0, 0, 0),
                                          child: item.parentMobile == null
                                              ? Text(
                                                  "-",
                                                  style: TextStyle(
                                                      color: Colors.grey[700]),
                                                )
                                              : Text(
                                                  item.parentMobile.toString(),
                                                  style: TextStyle(
                                                      color: Colors.grey[700]),
                                                ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              Spacer(),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 8, 8, 0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      "Total: " + item.feesAmount.toString(),
                                      style: TextStyle(
                                          color: Colors.blue[800],
                                          fontWeight: FontWeight.w600),
                                    ),
                                    SizedBox(
                                      height: 6,
                                    ),
                                    paidFees == "null"
                                        ? Text(
                                            "Paid: 0.0",
                                            style: TextStyle(
                                                color: Colors.green[800],
                                                fontWeight: FontWeight.w600),
                                          )
                                        : Text(
                                            "Paid: " + paidFees,
                                            style: TextStyle(
                                                color: Colors.green[800],
                                                fontWeight: FontWeight.w600),
                                          ),
                                    SizedBox(
                                      height: 6,
                                    ),
                                    paidFees == "null"
                                        ? Text(
                                            "Due: " +
                                                (item.feesAmount).toString(),
                                            style: TextStyle(
                                                color: Colors.red[800],
                                                fontWeight: FontWeight.w600),
                                          )
                                        : Text(
                                            "Due: " +
                                                (item.feesAmount -
                                                        double.parse(paidFees))
                                                    .toString(),
                                            style: TextStyle(
                                                color: Colors.red[800],
                                                fontWeight: FontWeight.w600),
                                          ),
                                  ],
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(color: Colors.grey[300], height: 1),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                child: Text(
                                  "Added on " +
                                      formatter.format(item.addedDate),
                                  style: TextStyle(color: Colors.grey[700]),
                                ),
                              ),
                              Spacer(),
                              IconButton(
                                  onPressed: () async {
                                    bool resultRefresh = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              addStudent(item)),
                                    );
                                    if (resultRefresh == true &&
                                        resultRefresh != null) {
                                      widget.refresData(await DBProvider.db
                                          .getStudentDetail(item.studentId));
                                      getApplicationPath();
                                      setState(() {});
                                    }
                                  },
                                  icon: Icon(
                                    Icons.edit_rounded,
                                    color: Color(0xFF1E3B70),
                                  )),
                              IconButton(
                                  onPressed: () {
                                    _displayDialog(item.studentId, context);
                                  },
                                  icon: Icon(
                                    Icons.delete_rounded,
                                    color: Color(0xFF1E3B70),
                                  )),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                        padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(13.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(8, 0, 0, 0),
                                  child: Row(
                                    children: [
                                      Text(
                                        "Fees History",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                            color: Color(0xFF1E3B70)),
                                      ),
                                      Spacer(),
                                      IconButton(
                                          onPressed: () {
                                            _totalFeesPaid.text = "";
                                            _remark.text = "";
                                            _displayDialogForFees(
                                                item, context);
                                          },
                                          icon: Icon(
                                            Icons.add_circle_rounded,
                                            color: Color(0xFF1E3B70),
                                            size: 30,
                                          ))
                                    ],
                                  ),
                                ),
                                Container(color: Colors.grey[300], height: 1),
                                SizedBox(
                                  height: 10,
                                ),
                                Expanded(
                                  child:
                                      FutureBuilder<List<StudentHistoryModel>>(
                                    future: DBProvider.db
                                        .getHistory(item.studentId),
                                    builder: (BuildContext context,
                                        AsyncSnapshot<List<StudentHistoryModel>>
                                            snapshot) {
                                      if (snapshot.hasData) {
                                        return ListView.builder(
                                          shrinkWrap: true,
                                          scrollDirection: Axis.vertical,
                                          itemCount: snapshot.data.length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            StudentHistoryModel item =
                                                snapshot.data[index];
                                            return Visibility(
                                              visible: item.feesAmount == 0.0 ||
                                                      item.feesAmount == 0
                                                  ? false
                                                  : true,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Card(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  elevation: 0.3,
                                                  child: InkWell(
                                                      onTap: () {
                                                        _displayDialogEditHistory(
                                                            item, context);
                                                      },
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Table(
                                                          children: [
                                                            TableRow(children: [
                                                              Column(children: [
                                                                Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .centerLeft,
                                                                  child: Text(
                                                                    formatter
                                                                        .format(
                                                                            item.addedDate),
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            14,
                                                                        fontWeight:
                                                                            FontWeight.w500),
                                                                  ),
                                                                )
                                                              ]),
                                                              Column(children: [
                                                                Align(
                                                                    alignment:
                                                                        Alignment
                                                                            .center,
                                                                    child: item
                                                                            .remark
                                                                            .isEmpty
                                                                        ? Text(
                                                                            "----",
                                                                            style: TextStyle(
                                                                                fontSize:
                                                                                    14,
                                                                                fontWeight: FontWeight
                                                                                    .w500))
                                                                        : Text(
                                                                            item
                                                                                .remark,
                                                                            style:
                                                                                TextStyle(fontSize: 14, fontWeight: FontWeight.w500)))
                                                              ]),
                                                              Column(children: [
                                                                Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .centerRight,
                                                                  child: Text(
                                                                      "Rs." +
                                                                          item.feesAmount
                                                                              .toString(),
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              14,
                                                                          fontWeight:
                                                                              FontWeight.w500)),
                                                                )
                                                              ]),
                                                            ]),
                                                          ],
                                                        ),
                                                      )),
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      } else {
                                        return Center(
                                            child: CircularProgressIndicator());
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )),
                  ),
                ],
              ),
      ),
    );
  }

  Widget handleBack() {
    return new WillPopScope(
      onWillPop: _onWillPop,
      child: new Scaffold(
        appBar: new AppBar(
          title: new Text("Home Page"),
        ),
        body: new Center(
          child: new Text("Home Page"),
        ),
      ),
    );
  }
}
