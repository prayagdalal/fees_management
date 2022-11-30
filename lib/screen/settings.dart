import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

import '../controller/dbHelper.dart';
import '../models/instituteModel.dart';
import 'instituteSetting.dart';
import 'package:flutter/material.dart';

class settings extends StatefulWidget {
  @override
  _settingsState createState() => _settingsState();
}

class _settingsState extends State<settings> {
  var res;

  InstituteModel instituteObj;

  void initState() {
    instituteObj = new InstituteModel();

    super.initState();

    DBProvider.db.initDatabase();
    instituteDetails();
  }

  Future<Null> instituteDetails() async {
    res = await DBProvider.db.getInstitute();

    if (res.length <= 0) {
      instituteObj = new InstituteModel();
    }
    if (res.length == 1) {
      instituteObj = res[0];
    }
    return;
  }

  Future<bool> _onWillPop() async {
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEEEEEE),
      appBar: AppBar(
          title: Text("Settings"),
          flexibleSpace: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: <Color>[Color(0xFF1E3B70), Color(0xFF29539B)])),
          )),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(13.0),
                ),
                color: Colors.white,
                elevation: 0,
                child: ListTile(
                  title: Text(
                    "Institute setting",
                    style: TextStyle(
                        color: Colors.grey[800],
                        fontSize: 18,
                        fontWeight: FontWeight.w500),
                  ),
                  leading: Icon(Icons.school_rounded, color: Color(0xFF1E3B70)),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => instituteSetting(instituteObj)),
                    );
                  },
                ),
              ),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(13.0),
                ),
                color: Colors.white,
                elevation: 0,
                child: ListTile(
                  title: Text(
                    "Backup",
                    style: TextStyle(
                        color: Colors.grey[800],
                        fontSize: 18,
                        fontWeight: FontWeight.w500),
                  ),
                  leading: Icon(Icons.backup_rounded, color: Color(0xFF1E3B70)),
                  onTap: () {
                    showBackup();
                  },
                ),
              ),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(13.0),
                ),
                color: Colors.white,
                elevation: 0,
                child: ListTile(
                  title: Text(
                    "About us",
                    style: TextStyle(
                        color: Colors.grey[800],
                        fontSize: 18,
                        fontWeight: FontWeight.w500),
                  ),
                  leading:
                      Icon(Icons.description_rounded, color: Color(0xFF1E3B70)),
                  onTap: () {
                    showAboutus();
                  },
                ),
              ),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(13.0),
                ),
                color: Colors.white,
                elevation: 0,
                child: ListTile(
                  title: Text(
                    "Rate us",
                    style: TextStyle(
                        color: Colors.grey[800],
                        fontSize: 18,
                        fontWeight: FontWeight.w500),
                  ),
                  leading: Icon(Icons.star_rounded, color: Color(0xFF1E3B70)),
                  onTap: () {},
                ),
              ),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(13.0),
                ),
                color: Colors.white,
                elevation: 0,
                child: ListTile(
                  title: Text(
                    "Contact us",
                    style: TextStyle(
                        color: Colors.grey[800],
                        fontSize: 18,
                        fontWeight: FontWeight.w500),
                  ),
                  leading: Icon(Icons.contact_support_rounded,
                      color: Color(0xFF1E3B70)),
                  onTap: () {
                    showContactUs();
                  },
                ),
              ),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(13.0),
                ),
                color: Colors.white,
                elevation: 0,
                child: ListTile(
                  title: Text(
                    "Share this app",
                    style: TextStyle(
                        color: Colors.grey[800],
                        fontSize: 18,
                        fontWeight: FontWeight.w500),
                  ),
                  leading: Icon(Icons.share_rounded, color: Color(0xFF1E3B70)),
                  onTap: () async {
                    await Share.share(
                        'https://play.google.com/store/apps/details?id=gnhub.feesmanagement');
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget BackupDialog() {
    return Container(
        height: 70.0, // Change as per your requirement
        width: 240.0,
        margin: EdgeInsets.only(left: 0.0, right: 0.0),
// Change as per your requirement
        child: Stack(children: [
          Positioned(
            right: 0.0,
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Align(
                alignment: Alignment.topRight,
                child: CircleAvatar(
                  radius: 12,
                  backgroundColor: Color(0xFF1E3B70),
                  child: Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 30,
              ),
              Text("This Functionality Is In Development",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.grey[850])),
            ],
          ),
        ]));
  }

  showBackup() async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: BackupDialog(),
          );
        });
  }

  Widget contactDialog() {
    return Container(
        height: 240, // Change as per your requirement
        width: 240.0,
        margin: EdgeInsets.only(left: 0.0, right: 0.0),
// Change as per your requirement
        child: Stack(children: [
          Positioned(
            right: 0.0,
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Align(
                alignment: Alignment.topRight,
                child: CircleAvatar(
                  radius: 12,
                  backgroundColor: Color(0xFF1E3B70),
                  child: Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 30,
              ),
              Text("Fees management",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                      color: Colors.grey[850])),
              Divider(),
              Text("We are thanking you for using this app.",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                      color: Colors.grey[700])),
              SizedBox(height: 8),
              Row(
                children: [
                  Text("Write us on ",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                          color: Colors.grey[700])),
                  InkWell(
                    onTap: () {
                      launch("mailto:info@gnhub.com");
                    },
                    child: Text("info@gnhub.com",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                            color: Colors.blue)),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Text("Generation Next",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                      color: Colors.grey[700])),
              SizedBox(height: 8),
              InkWell(
                onTap: () {
                  launch("http://www.gnhub.com/");
                },
                child: Text("http://www.gnhub.com/",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                        color: Colors.blue)),
              ),
              SizedBox(height: 8),
              InkWell(
                onTap: () {
                  launch("tel://0261 2665403");
                },
                child: Text("0261 2665403",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                        decoration: TextDecoration.underline,
                        color: Colors.blue)),
              ),
            ],
          ),
        ]));
  }

  showContactUs() async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: contactDialog(),
          );
        });
  }

  Widget aboutUsDialog() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      // height: 300.0, // Change as per your requirement
      // width: 240.0,
      margin: EdgeInsets.only(left: 0.0, right: 0.0),
// Change as per your requirement
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('''Fees management provides following features:
- Manage batches
- Manage students
- Filter students batch wise
- Showing total, received, due 
  fees amount
- Add, Edit, Delete Student's Fees
  history 
- Students fees history
- Institute setting
- Backup
- Simple design and navigation''',
                textAlign: TextAlign.left,
                maxLines: 50,
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 17,
                    color: Colors.grey[700])),
          ],
        ),
      ),
    );
  }

  showAboutus() async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('About App'),
            content: aboutUsDialog(),
            actions: [
              MaterialButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Close'),
              )
            ],
          );
        });
  }
}
