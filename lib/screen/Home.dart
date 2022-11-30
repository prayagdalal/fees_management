import 'dart:io';

import 'package:fees_management/models/batchModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart' as syspaths;

import '../controller/dbHelper.dart';
import '../models/studentHistoryModel.dart';
import '../models/studentModel.dart';
import 'addStudent.dart';
import 'studentOperations.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _totalFeesPaid = TextEditingController();
  final _remark = TextEditingController();
  final DateFormat formatter = DateFormat('dd, MMM yyy');
  String appDir = '';
  String defaultPhoto = 'assets/student1.png';

  StudentHistoryModel historyObj;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    //DBProvider.db.deleteTbl();
    dashBoardData();
    loadStudent();
  }

  var total;
  var received;
  bool dashboardLoader = true;
  File imageFile;
  String filterBy = "All";
  String appDirectory;
  List<StudentModel> studentList = new List();

  Future<Null> dashBoardData() async {
    total = await DBProvider.db.getSumByBatch();
    received = await DBProvider.db.getRecivedFees();
    setState(() {
      dashboardLoader = false;
    });
    return;
  }

  getApplicationPath(String studentPath) async {
    final appDir = await syspaths.getApplicationSupportDirectory();
    appDirectory = appDir.path;
    // setState(() {
    //   if (studentPath != null) {
    //     // fullPath = appDirectory + studentPath;
    //     // avtarLoader = false;
    //   }
    // });
  }

  loadStudent({batchId = 0}) async {
    appDir = (await syspaths.getApplicationSupportDirectory()).path;
    studentList.clear();
    studentList.addAll(await DBProvider.db.getStudent(batchId: batchId));

    setState(() {
      dashBoardData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFFEEEEEE),
        appBar: AppBar(
            leading: Image.asset("assets/appBar.png"),
            title: Align(
                alignment: Alignment(-1.3, 0),
                child: new Text(
                  "Fees Management",
                  style: TextStyle(fontWeight: FontWeight.bold),
                )),
            flexibleSpace: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: <Color>[Color(0xFF1E3B70), Color(0xFF29539B)])),
            )),
        body: dashboardLoader == true
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                children: [
                  Padding(
                      padding: EdgeInsets.fromLTRB(10, 15, 0, 15),
                      child: IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            getDashboardBlock(
                                'Total',
                                total[0]['total'] == null
                                    ? 0.0
                                    : total[0]['total'],
                                Colors.blueAccent[700]),
                            getDashboardBlock(
                                'Received',
                                received[0]['received'] == null
                                    ? 0.0
                                    : received[0]['received'],
                                Colors.green[900]),
                            getDashboardBlock(
                                'Due',
                                total[0]['total'] == null ||
                                        received[0]['received'] == null
                                    ? total[0]['total'] == null
                                        ? 0.0
                                        : total[0]['total']
                                    : total[0]['total'] -
                                        received[0]['received'],
                                Colors.redAccent[700]),
                          ],
                        ),
                      )),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                      child: Card(
                        color: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(13.0),
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                              child: Row(
                                children: [
                                  Text(
                                    "Students",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        color: Color(0xFF1E3B70)),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Card(
                                    elevation: 0,
                                    color: Color(0xFF1E3B70),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(13.0),
                                    ),
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 8,
                                              right: 8,
                                              top: 4,
                                              bottom: 4),
                                          child: Text(
                                            filterBy,
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                color: Colors.white,
                                                fontSize: 11),
                                          ),
                                        ),
                                        Visibility(
                                          visible:
                                              filterBy != 'All' ? true : false,
                                          child: GestureDetector(
                                            onTap: () {
                                              filterBy = 'All';
                                              loadStudent();
                                              setState(() {});
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      0, 2, 4, 2),
                                              child: Icon(
                                                Icons.cancel,
                                                size: 14,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Spacer(),
                                  IconButton(
                                      onPressed: () {
                                        showBatchFilter();
                                      },
                                      icon: Icon(
                                        Icons.filter_list_rounded,
                                        color: Color(0xFF1E3B70),
                                        size: 30,
                                      )),
                                  IconButton(
                                      onPressed: () async {
                                        bool resultRefresh =
                                            await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => addStudent(
                                                  new StudentModel())),
                                        );
                                        if (resultRefresh == true &&
                                            resultRefresh != null) {
                                          setState(() {
                                            loadStudent();
                                          });
                                        }
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
                            Expanded(
                              child: studentList.length <= 0
                                  ? Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.sentiment_neutral_outlined,
                                            color: Colors.grey,
                                            size: 60,
                                          ),
                                          SizedBox(
                                            height: 3,
                                          ),
                                          Text(
                                            "No Student Found!",
                                            style: TextStyle(
                                              color: Colors.grey,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : ListView.builder(
                                      itemCount: studentList.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        StudentModel item = studentList[index];
                                        //getApplicationPath(item.studentPhoto);

                                        FlutterMoneyFormatter remainFees =
                                            FlutterMoneyFormatter(
                                                amount: item.feesAmount -
                                                    item.totalFeesPaid,
                                                settings:
                                                    MoneyFormatterSettings(
                                                  fractionDigits: 0,
                                                ));
                                        MoneyFormatterOutput remainFees1 =
                                            remainFees.output;

                                        return ListTile(
                                          onTap: () async {
                                            bool resultRefresh =
                                                await Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      studentOperations(item)),
                                            );
                                            if (resultRefresh == true &&
                                                resultRefresh != null) {
                                              setState(() {
                                                loadStudent();
                                              });
                                            }
                                          },
                                          leading: CircleAvatar(
                                            radius: 20,
                                            backgroundColor: Colors.grey[200],
                                            child: ClipOval(
                                              child: new SizedBox(
                                                width: 100.0,
                                                height: 100.0,
                                                child: (item.getHasImage())
                                                    ? Image.file(
                                                        File(item.getPhotoPath(
                                                            appDir)),
                                                        fit: BoxFit.fill,
                                                      )
                                                    : Image.asset(
                                                        this.defaultPhoto,
                                                        fit: BoxFit.fill,
                                                      ),
                                              ),
                                            ),
                                          ),
                                          title: Text(
                                            item.studentName,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          subtitle: Text("Roll No: " +
                                              item.studentCode.toString()),
                                          trailing: Wrap(children: [
                                            (item.feesAmount -
                                                        item.totalFeesPaid) <=
                                                    0
                                                ? Text(
                                                    "Paid",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16,
                                                        color: Colors.green),
                                                  )
                                                : Text(
                                                    "Rs " +
                                                        remainFees1.nonSymbol +
                                                        " Due",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16,
                                                        color:
                                                            Colors.redAccent),
                                                  ),
                                          ]),
                                        );
                                      },
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ));
  }

  Widget getDashboardBlock(String label, double amount, Color textColor) {
    return Expanded(
        child: Container(
            margin: const EdgeInsets.only(right: 10),
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey[300],
                    blurRadius: 0,
                  ),
                ]),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                  child: Text(
                    label,
                    style: TextStyle(
                        fontSize: 18,
                        color: textColor,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Divider(),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                  child: Text(
                    'Rs.' + amount.toString(),
                    style: TextStyle(fontSize: 18, color: Colors.grey[850]),
                  ),
                )
              ],
            )));
  }

  Widget setupAlertDialoadContainer(List<BatchModel> batchList) {
    return Container(
      height: 300.0, // Change as per your requirement
      width: 300.0, // Change as per your requirement
      child: batchList.length <= 0
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.hourglass_empty_rounded,
                    color: Colors.grey,
                    size: 30,
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  Text(
                    "No Batch Found!",
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.w800,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              shrinkWrap: true,
              itemCount: batchList.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  color: Color(0x111E3B70),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(13.0),
                  ),
                  elevation: 0,
                  child: ListTile(
                    dense: true,
                    onTap: () {
                      Navigator.of(context).pop();
                      filterBy = batchList[index].batchName;
                      loadStudent(batchId: batchList[index].batchId);
                      setState(() {});
                    },
                    trailing: Visibility(
                        visible: batchList[index].batchName == filterBy
                            ? true
                            : false,
                        child: Icon(
                          Icons.check_circle,
                          size: 20,
                          color: Color(0xFF1E3B70),
                        )),
                    title: Text(
                      batchList[index].batchName,
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
                    ),
                  ),
                );
              },
            ),
    );
  }

  showBatchFilter() async {
    List<BatchModel> batchList = await DBProvider.db.getBatches();

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Filter Batch',
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
            content: setupAlertDialoadContainer(batchList),
          );
        });
  }
}
