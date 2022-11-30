import 'package:flutter/material.dart';

import '../controller/dbHelper.dart';
import '../models/instituteModel.dart';

class instituteSetting extends StatefulWidget {
  @override
  InstituteModel instituteObject;

  instituteSetting(InstituteModel instituteObject) {
    this.instituteObject = instituteObject;
  }
  _instituteSettingState createState() => _instituteSettingState();
}

class _instituteSettingState extends State<instituteSetting> {
  InstituteModel instituteObj;
  final _formKey = GlobalKey<FormState>();

  var focus = FocusNode();
  final FocusNode _nameFocus = FocusNode();
  final FocusNode _subFocus = FocusNode();
  var _instituteName = TextEditingController();
  var _address = TextEditingController();
  var _email = TextEditingController();
  var _website = TextEditingController();
  var _mob = TextEditingController();
  var _des = TextEditingController();

  var instituteCount;
  @override
  Future<Null> CountInstitute() async {
    instituteCount = await DBProvider.db
        .getCountInstitute(widget.instituteObject.instituteId);

    return;
  }

  void initState() {
    super.initState();
    CountInstitute();
    _instituteName.text = widget.instituteObject.instituteName;
    _address.text = widget.instituteObject.address;
    _email.text = widget.instituteObject.emailId;
    _website.text = widget.instituteObject.websiteUrl;
    _mob.text = widget.instituteObject.contactNo.toString() == "null"
        ? ""
        : widget.instituteObject.contactNo.toString();
    _des.text = widget.instituteObject.instituteDescription;
  }

  @override
  void dispose() {
    super.dispose();
  }

  Edit() {
    instituteObj = new InstituteModel();
    instituteObj.instituteName = _instituteName.text;
    instituteObj.address = _address.text;
    instituteObj.emailId = _email.text;
    instituteObj.websiteUrl = _website.text;
    instituteObj.contactNo = int.parse(_mob.text);
    instituteObj.instituteDescription = _des.text;
    instituteObj.modifyDate = DateTime.now();
    instituteObj.addedDate = DateTime.now();

    if (instituteCount[0]['totalInstitute'] == 1) {
      instituteObj.instituteId = widget.instituteObject.instituteId;
      instituteObj.addedDate = widget.instituteObject.addedDate;
      DBProvider.db.updateInstitute(instituteObj);
    }
    if (instituteCount[0]['totalInstitute'] <= 0) {
      DBProvider.db.addInstitute(instituteObj);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFFEEEEEE),
        appBar: AppBar(
          title: Text("Institute Setting"),
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
                      Edit();
                    });
                    Navigator.pop(context);
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
                              "Institute name:",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                              child: TextFormField(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter institute name';
                                  }
                                  return null;
                                },
                                controller: _instituteName,
                                textInputAction: TextInputAction.done,
                                focusNode: _nameFocus,
                                onFieldSubmitted: (_) => _nameFocus.unfocus(),
                                decoration: InputDecoration(
                                  hintText: "Enter Institute's Name",
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
                                //     return 'Please enter address';
                                //   }
                                //   return null;
                                // },
                                maxLines: 5,
                                controller: _address,
                                textInputAction: TextInputAction.done,
                                keyboardType: TextInputType.multiline,
                                onFieldSubmitted: (_) => _nameFocus.unfocus(),
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
                              child: Row(
                                children: [
                                  Text(
                                    "Institute Email:",
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
                                //     return 'Please enter email';
                                //   }
                                //   return null;
                                // },
                                controller: _email,
                                textInputAction: TextInputAction.done,
                                onFieldSubmitted: (_) => _nameFocus.unfocus(),
                                decoration: InputDecoration(
                                  hintText: "Enter Institute's Email",
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
                                    "Institute Website:",
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
                                //     return 'Please enter website';
                                //   }
                                //   return null;
                                // },
                                controller: _website,
                                textInputAction: TextInputAction.done,
                                onFieldSubmitted: (_) => _nameFocus.unfocus(),
                                decoration: InputDecoration(
                                  hintText: "Enter Institute's Website URL",
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.green),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 12, 0, 0),
                              child: Text(
                                "Institute Contact No:",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                              child: TextFormField(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter contact';
                                  }
                                  return null;
                                },
                                keyboardType: TextInputType.number,
                                controller: _mob,
                                textInputAction: TextInputAction.done,
                                onFieldSubmitted: (_) => _nameFocus.unfocus(),
                                decoration: InputDecoration(
                                  hintText: "Enter Institute's Contact No",
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
                                    "description:",
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
                                //     return 'Please enter description';
                                //   }
                                //   return null;
                                // },
                                maxLines: 5,
                                controller: _des,
                                textInputAction: TextInputAction.done,
                                keyboardType: TextInputType.multiline,
                                onFieldSubmitted: (_) => _nameFocus.unfocus(),
                                decoration: InputDecoration(
                                  hintText: "Enter description",
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
                  ),
                ),
              )),
        ));
  }

  _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }
}
