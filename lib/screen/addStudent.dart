import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspaths;

import '../controller/dbHelper.dart';
import '../models/batchModel.dart';
import '../models/instituteModel.dart';
import '../models/studentHistoryModel.dart';
import '../models/studentModel.dart';

final DateFormat formatter = DateFormat('yyyy-MM-dd');

class addStudent extends StatefulWidget {
  @override
  _addStudentState createState() => _addStudentState();
  StudentModel studentobjConstructor;
  addStudent(this.studentobjConstructor);
}

class _addStudentState extends State<addStudent> {
  File _image;
  List<BatchModel> batchData = [];
  List<InstituteModel> instituteData = [];
  StudentHistoryModel historyObj;

  DateTime selectedDate = DateTime.now();
  var picked;
  final _formKey = GlobalKey<FormState>();
  var image_name;
  var app_path;
  var final_app_path;
  var feesPaid;
  var paidFees;
  bool moreDetailsVisible = false;
  bool buttonVisible = true;

  File imageFile;
  bool isEditMode() {
    return (this.widget.studentobjConstructor != null &&
        this.widget.studentobjConstructor.studentId != null &&
        this.widget.studentobjConstructor.studentId > 0);
  }

  paidFeesSum() async {
    feesPaid =
        await DBProvider.db.getSum(widget.studentobjConstructor.studentId);
    setState(() {
      paidFees = feesPaid[0]['paid'].toString();
    });
    return;
  }

  final _rno = TextEditingController();
  final _sname = TextEditingController();
  final _parentName = TextEditingController();
  final _pmob = TextEditingController();
  final _address = TextEditingController();
  final _fAmount = TextEditingController();
  final dateController = TextEditingController();
  final _remark = TextEditingController();
  final _totalFeesPaid = TextEditingController();
  StudentModel studentObj;

  String _value;
  String holder;
  var batchID;
  var fullPath = "";
  bool _batchloading;
  String appDirectory;

  getApplicationPath() async {
    final appDir = await syspaths.getApplicationSupportDirectory();
    appDirectory = appDir.path;
    setState(() {
      if (widget.studentobjConstructor.studentPhoto != null) {
        fullPath = appDirectory + widget.studentobjConstructor.studentPhoto;
      }
    });
  }

  getImageName() async {
    image_name = "";
    final appDir = await syspaths.getApplicationSupportDirectory();
    String pathDir = appDir.path;
    final fileName = path.basename(imageFile.path);
    // final tmpFile = imageFile.copySync('$pathDir/$fileName');
    setState(() {
      image_name = "/" + fileName;
    });
  }

  addImageInFolder() async {
    final appDir = await syspaths.getApplicationSupportDirectory();
    String pathDir = appDir.path;
    final fileName = path.basename(imageFile.path);
    final tmpFile = imageFile.copySync('$pathDir/$fileName');
  }

  void getRollno() async {
    if (isEditMode()) return;
    int intRollno = await DBProvider.db.getRollno(batchID);
    _rno.text = intRollno.toString();
    setState(() {});
  }

  void initState() {
    getRollno();

    getApplicationPath();

    _rno.text = widget.studentobjConstructor.studentCode.toString() == "null"
        ? ""
        : widget.studentobjConstructor.studentCode.toString();
    _sname.text = widget.studentobjConstructor.studentName;
    _parentName.text = widget.studentobjConstructor.parentName;
    _pmob.text = widget.studentobjConstructor.parentMobile.toString() == "null"
        ? ""
        : widget.studentobjConstructor.parentMobile.toString();
    _address.text = widget.studentobjConstructor.address;

    batchID = widget.studentobjConstructor.batchId;
    _fAmount.text = widget.studentobjConstructor.feesAmount.toString() == "null"
        ? ""
        : widget.studentobjConstructor.feesAmount.toString();
    _totalFeesPaid.text =
        widget.studentobjConstructor.totalFeesPaid.toString() == "null"
            ? "0"
            : widget.studentobjConstructor.totalFeesPaid.toString();
    dateController.text = widget.studentobjConstructor.joinedDate == null
        ? selectedDate.toString().substring(0, 10)
        : formatter.format(widget.studentobjConstructor.joinedDate);
    _remark.text = widget.studentobjConstructor.remark;
    _value = widget.studentobjConstructor.status.toString() == "null"
        ? "Not Paid"
        : widget.studentobjConstructor.status;

    holder = _value;

    if (batchData.isEmpty) {
      batchList();
    }

    super.initState();
  }

  Future<Null> batchList() async {
    await DBProvider.db.getBatches().then((data) {
      batchData = null;
      setState(() {
        batchData = data;
        _batchloading = false;
      });
    });
    return;
  }

  addStudent() {
    studentObj = new StudentModel();
    historyObj = new StudentHistoryModel();

    studentObj.studentPhoto = image_name == null
        ? widget.studentobjConstructor.studentPhoto
        : image_name;
    studentObj.studentCode = _rno.text == null ? null : int.parse(_rno.text);
    studentObj.studentName = _sname.text;
    studentObj.address = _address.text;
    studentObj.parentName = _parentName.text;
    studentObj.parentMobile = _pmob.text.isEmpty ? null : int.parse(_pmob.text);
    studentObj.batchId = batchID;
    studentObj.feesAmount = double.parse(_fAmount.text);
    studentObj.totalFeesPaid = double.parse(_totalFeesPaid.text);
    studentObj.addedDate = DateTime.now();
    studentObj.modifyDate = DateTime.now();
    studentObj.joinedDate = DateTime.parse(dateController.text);
    studentObj.remark = _remark.text;
    studentObj.status = holder;
    studentObj.isDeleted = 0;

    if (isEditMode()) {
      studentObj.studentId = widget.studentobjConstructor.studentId;
      studentObj.addedDate = widget.studentobjConstructor.addedDate;
      DBProvider.db.updateStudent(studentObj);
    } else {
      DBProvider.db
          .addStudent(studentObj)
          .then((value) => DBProvider.db.getLastId())
          .then((value) {
        historyObj.studentId = value[0]["student_id"];
        historyObj.feesAmount =
            _totalFeesPaid.text == "" ? 0 : double.parse(_totalFeesPaid.text);
        historyObj.remark = _remark.text;
        historyObj.addedDate = DateTime.now();
        DBProvider.db.addStudentFees(historyObj);
      });
    }
  }

  Future getImage() async {
    // ignore: deprecated_member_use
    imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);

    if (imageFile != null) {
      setState(() {
        getImageName();

        _image = imageFile;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFFEEEEEE),
        appBar: AppBar(
          title: isEditMode() ? Text("Edit Student") : Text("New Student"),
          flexibleSpace: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: <Color>[Color(0xFF1E3B70), Color(0xFF29539B)])),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    setState(() {
                      if (image_name != null) {
                        addImageInFolder();
                      }
                      addStudent();
                    });
                    if (isEditMode()) {
                      Navigator.of(context).pop(true);
                    } else {
                      // ADD Student
                      Navigator.of(context).pop(true);
                    }
                  } else {
                    print("not valid");
                  }
                },
                icon: Icon(Icons.check_circle_rounded)),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8),
          child: Card(
            color: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(13.0),
            ),
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          getImage();
                        },
                        child: Stack(children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            //crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Card(
                                color: Colors.white,
                                elevation: 3,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(4),
                                  child: CircleAvatar(
                                    radius: 60,
                                    backgroundColor: Colors.white,
                                    child: ClipOval(
                                      child: new SizedBox(
                                          width: 170.0,
                                          height: 170.0,
                                          child: (_image == null &&
                                                  widget.studentobjConstructor
                                                          .studentPhoto ==
                                                      null)
                                              ? Icon(
                                                  Icons
                                                      .add_photo_alternate_rounded,
                                                  size: 35,
                                                )
                                              : (_image != null)
                                                  ? Image.file(
                                                      _image,
                                                      fit: BoxFit.fill,
                                                    )
                                                  : (widget.studentobjConstructor
                                                              .studentPhoto !=
                                                          null)
                                                      ? Image.file(
                                                          File(fullPath),
                                                          fit: BoxFit.fill,
                                                        )
                                                      : null),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ]),
                      ),
                      Divider(),
                      Text(
                        "Roll no:",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 17),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                        child: TextFormField(
                          controller: _rno,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter roll no';
                            }
                            return null;
                          },
                          textInputAction: TextInputAction.done,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: "Enter Rollno",
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.green),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 12, 0, 0),
                        child: Text(
                          "Student name:",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 17),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                        child: TextFormField(
                          controller: _sname,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter student name';
                            }
                            return null;
                          },
                          textInputAction: TextInputAction.done,
                          decoration: InputDecoration(
                            hintText: "Enter Student's Name",
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.green),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 12, 0, 0),
                        child: Row(
                          children: [
                            Text(
                              "Select Batch:",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 17),
                            ),
                            Text(
                              " (Optional)",
                              style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            )
                          ],
                        ),
                      ),
                      DropdownButtonHideUnderline(
                        child: new DropdownButton(
                          hint: Text("  Select Batch"),
                          value: batchID,
                          items: batchData.map((item) {
                            return new DropdownMenuItem(
                              value: item.batchId,
                              child: new Text("  " + item.batchName),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              batchID = value;
                              getRollno();

                              for (var i = 0; i < batchData.length; i++) {
                                if (batchData[i].batchId == value) {
                                  _fAmount.text =
                                      batchData[i].defaultFeesAmount.toString();
                                }
                              }
                              batchID = value;
                            });
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 12, 0, 0),
                        child: Text(
                          "Fees Amount:",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 17),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                        child: TextFormField(
                          controller: _fAmount,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter fees amount';
                            }
                            if (double.parse(_fAmount.text) <
                                double.parse(_totalFeesPaid.text)) {
                              return 'Total Fees >= Paid Fees';
                            }

                            return null;
                          },
                          textInputAction: TextInputAction.done,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: "Enter Amount",
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.green),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 12, 0, 0),
                        child: Text(
                          "Total Fees Paid:",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 17),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                        child: TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter fees amount';
                            }
                            if (_fAmount.text.isNotEmpty) {
                              if (double.parse(_totalFeesPaid.text) >
                                  double.parse(_fAmount.text))
                                return 'Paid Fees <= Total Fees';
                            }
                            return null;
                          },
                          controller: _totalFeesPaid,
                          readOnly: isEditMode(),
                          textInputAction: TextInputAction.done,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            suffixIcon: Visibility(
                              visible: !isEditMode(),
                              child: IconButton(
                                onPressed: () => _totalFeesPaid.clear(),
                                icon: Icon(
                                  Icons.clear,
                                  color: Colors.grey,
                                  size: 16,
                                ),
                              ),
                            ),
                            hintText: "Enter paid Amount",
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.green),
                            ),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: buttonVisible == true ? true : false,
                        child: Center(
                          child: OutlinedButton(
                            onPressed: () {
                              setState(() {
                                moreDetailsVisible = true;
                                buttonVisible = false;
                              });
                            },
                            child: Text('Add more details'),
                          ),
                        ),
                      ),
                      moreFields()
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }

  Widget moreFields() {
    return Visibility(
      visible: moreDetailsVisible == true ? true : false,
      child: Wrap(children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 12, 0, 0),
          child: Row(
            children: [
              Text(
                "Parent name:",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
              ),
              Text(
                " (Optional)",
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 12,
                  color: Colors.grey,
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
          child: TextFormField(
            controller: _parentName,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
              hintText: "Enter Parent's Name",
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.green),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 12, 0, 0),
          child: Row(
            children: [
              Text(
                "Parent Mobile No:",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
              ),
              Text(
                " (Optional)",
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 12,
                  color: Colors.grey,
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
          child: TextFormField(
            controller: _pmob,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
              hintText: "Enter Parent's Mobile No",
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.green),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 12, 0, 0),
          child: Row(
            children: [
              Text(
                "Address:",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
              ),
              Text(
                " (Optional)",
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 12,
                  color: Colors.grey,
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
          child: TextFormField(
            controller: _address,
            // validator: (value) {
            //   if (value == null || value.isEmpty) {
            //     return 'Please enter address';
            //   }
            //   return null;
            // },
            maxLines: 2,
            textInputAction: TextInputAction.done,
            keyboardType: TextInputType.multiline,
            decoration: InputDecoration(
              hintText: "Enter Address",
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.green),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 12, 0, 0),
          child: Text(
            "Joined Date:",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
          child: TextFormField(
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please pick joined date';
              }
              return null;
            },
            readOnly: true,
            controller: dateController,
            decoration: InputDecoration(
              hintText: 'Pick Joined Date',
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.green),
              ),
            ),
            onTap: () async {
              picked = await showDatePicker(
                  context: context,
                  initialDate: selectedDate,
                  firstDate: DateTime(1900),
                  lastDate: DateTime(2100));
              if (picked != null && picked != selectedDate)
                setState(() {
                  selectedDate = picked;
                  dateController.text =
                      selectedDate.toString().substring(0, 10);
                });
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 12, 0, 0),
          child: Row(
            children: [
              Text(
                "Remark:",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
              ),
              Text(
                " (Optional)",
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 12,
                  color: Colors.grey,
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
          child: TextFormField(
            controller: _remark,
            maxLines: 2,
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
      ]),
    );
  }

  _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }
}
