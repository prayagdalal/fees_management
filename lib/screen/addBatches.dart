import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../controller/dbHelper.dart';
import '../models/batchModel.dart';

class addBatch extends StatefulWidget {
  BatchModel batchObjConstructor;
  addBatch(this.batchObjConstructor);
  @override
  _addBatchState createState() => _addBatchState();
}

class _addBatchState extends State<addBatch> {
  final focus = FocusNode();
  final _formKey = GlobalKey<FormState>();
  final FocusNode _nameFocus = FocusNode();
  final FocusNode _subFocus = FocusNode();
  DateTime selectedDateFrom; // = DateTime.now();
  DateTime selectedDateTo; // = DateTime.now();

  final _batchName = TextEditingController();
  final _defaultFeesController = TextEditingController();
  final dateController = TextEditingController();
  final dateController1 = TextEditingController();
  final daysController = TextEditingController();
  final _subjectController = TextEditingController();
  String _value = 'Monthly';
  String holder = 'Monthly';
  final DateFormat formatter = DateFormat('yyy-MM-dd');

  BatchModel batchObj;

  bool editMode() {
    return (this.widget.batchObjConstructor.batchId != null &&
        this.widget.batchObjConstructor.batchId > 0 &&
        this.widget.batchObjConstructor != null);
  }

  addBatch() {
    batchObj = new BatchModel();
    batchObj.batchName = _batchName.text;
    batchObj.days = int.parse(daysController.text);
    batchObj.startDate =
        selectedDateFrom; //DateTime.parse(dateController.text);
    batchObj.endDate = selectedDateTo; //DateTime.parse(dateController1.text);
    batchObj.subject = _subjectController.text;
    batchObj.type = holder;
    batchObj.defaultFeesAmount = double.parse(_defaultFeesController.text);

    if (editMode()) {
      batchObj.batchId = widget.batchObjConstructor.batchId;

      DBProvider.db.updateBatch(batchObj);
    } else {
      DBProvider.db.addBatch(batchObj);
    }
  }

  @override
  void initState() {
    super.initState();
    selectedDateFrom = widget.batchObjConstructor.startDate;
    selectedDateTo = widget.batchObjConstructor.endDate;
    _defaultFeesController.text =
        widget.batchObjConstructor.defaultFeesAmount.toString() == "null"
            ? ""
            : widget.batchObjConstructor.defaultFeesAmount.toString();
    _batchName.text = widget.batchObjConstructor.batchName;
    dateController.text = widget.batchObjConstructor.startDate == null
        ? ""
        : formatter.format(widget.batchObjConstructor.startDate);
    dateController1.text = widget.batchObjConstructor.endDate == null
        ? ""
        : formatter.format(widget.batchObjConstructor.endDate);
    daysController.text = widget.batchObjConstructor.days.toString() == "null"
        ? "0"
        : widget.batchObjConstructor.days.toString();
    _subjectController.text = widget.batchObjConstructor.subject;
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed
    dateController.dispose();
    dateController1.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFFEEEEEE),
        appBar: AppBar(
          title: editMode() ? Text("Edit Batch") : Text("New Batch"),
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
                      addBatch();
                    });
                    Navigator.of(context).pop(true);

                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(builder: (context) => batches()),
                    // ).then((value) => setState(() {}));
                  } else {
                    print("not valid");
                  }
                },
                icon: Icon(Icons.check_circle_rounded)),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
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
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Batch name:",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                            child: TextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter batch name';
                                }
                                return null;
                              },
                              textInputAction: TextInputAction.done,
                              controller: _batchName,
                              decoration: InputDecoration(
                                hintText: "Enter Batch's Name",
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.green),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 12, 0, 0),
                            child: Text(
                              "Default fees Amount:",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                            child: TextFormField(
                              textInputAction: TextInputAction.done,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter fees';
                                }
                                return null;
                              },
                              controller: _defaultFeesController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                suffixIcon: IconButton(
                                  onPressed: () =>
                                      _defaultFeesController.clear(),
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
                            padding: const EdgeInsets.fromLTRB(0, 12, 0, 0),
                            child: Row(
                              children: [
                                Text(
                                  "Start Date:",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                            child: TextFormField(
                              readOnly: true,
                              controller: dateController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please select start date';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                hintText: 'Pick start your Date',
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.green),
                                ),
                              ),
                              onTap: () async {
                                selectedDateFrom = await showDatePicker(
                                    context: context,
                                    initialDate: (selectedDateFrom != null
                                        ? selectedDateFrom
                                        : DateTime.now()),
                                    firstDate: DateTime(1900),
                                    lastDate: DateTime(2100));
                                if (selectedDateFrom != null)
                                  setState(() {
                                    dateController.text = selectedDateFrom
                                        .toString()
                                        .substring(0, 10);
                                  });
                                if (dateController1.text == "")
                                  setState(() {
                                    daysController.text =
                                        "Please select end date";
                                  });

                                if (dateController1.text != "")
                                  setState(() {
                                    final difference = selectedDateTo
                                        .difference(selectedDateFrom)
                                        .inDays;
                                    daysController.text = difference.toString();
                                  });
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 12, 0, 0),
                            child: Row(
                              children: [
                                Text(
                                  "End Date:",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                            child: TextFormField(
                              readOnly: true,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please select end date';
                                }
                                return null;
                              },
                              controller: dateController1,
                              decoration: InputDecoration(
                                hintText: 'Pick end your Date',
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.green),
                                ),
                              ),
                              onTap: () async {
                                selectedDateTo = await showDatePicker(
                                    context: context,
                                    initialDate: (selectedDateTo != null
                                        ? selectedDateTo
                                        : DateTime.now()),
                                    firstDate: DateTime(1900),
                                    lastDate: DateTime(2100));
                                if (selectedDateTo != null)
                                  setState(() {
                                    dateController1.text = selectedDateTo
                                        .toString()
                                        .substring(0, 10);
                                  });
                                if (dateController.text == "")
                                  setState(() {
                                    daysController.text =
                                        "Please select start date";
                                  });

                                if (dateController.text != "")
                                  setState(() {
                                    final difference = selectedDateTo
                                        .difference(selectedDateFrom)
                                        .inDays;
                                    daysController.text = difference.toString();
                                  });
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 12, 0, 0),
                            child: Row(
                              children: [
                                Text(
                                  "Days:",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
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
                              readOnly: true,
                              controller: daysController,
                              decoration: InputDecoration(
                                hintText: "Total days",
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
                                  "Subject:",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
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
                              // validator: (value) {
                              //   if (value == null || value.isEmpty) {
                              //     return 'Please enter subject';
                              //   }
                              //   return null;
                              // },
                              textInputAction: TextInputAction.done,
                              controller: _subjectController,
                              decoration: InputDecoration(
                                hintText: "Enter Subject's Name",
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.green),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 12, 0, 0),
                            child: Text(
                              "Type:",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                            child: DropdownButtonFormField(
                                value: _value,
                                decoration: InputDecoration(
                                    enabledBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.white))),
                                items: [
                                  DropdownMenuItem<String>(
                                    child: Text("Monthly"),
                                    value: "Monthly",
                                  ),
                                  DropdownMenuItem<String>(
                                    child: Text("Yearly"),
                                    value: "Yearly",
                                  ),
                                  DropdownMenuItem<String>(
                                      child: Text("Quarterly"),
                                      value: "Quarterly"),
                                  DropdownMenuItem<String>(
                                      child: Text("Custom"), value: "Custom")
                                ],
                                onChanged: (value) {
                                  setState(() {
                                    holder = value;
                                  });
                                }),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ));
  }

  _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }
}
