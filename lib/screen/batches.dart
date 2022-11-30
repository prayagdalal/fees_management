import 'package:flutter/material.dart';

import '../controller/dbHelper.dart';
import '../models/batchModel.dart';
import 'addBatches.dart';

class batches extends StatefulWidget {
  @override
  _batchesState createState() => _batchesState();
}

class _batchesState extends State<batches> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEEEEEE),
      appBar: AppBar(
        title: Text("Batches"),
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[Color(0xFF1E3B70), Color(0xFF29539B)])),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.add_circle_rounded,
              color: Colors.white,
              size: 28,
            ),
            onPressed: () async {
              bool resultRefresh = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => addBatch(new BatchModel())),
              );
              if (resultRefresh == true && resultRefresh != null) {
                setState(() {});
              }
            },
          )
        ],
      ),
      body: FutureBuilder<List<BatchModel>>(
        future: DBProvider.db.getBatches(),
        builder:
            (BuildContext context, AsyncSnapshot<List<BatchModel>> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
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
                      "No Batch Found!",
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      BatchModel item = snapshot.data[index];
                      return Card(
                        margin: EdgeInsets.all(8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(13.0),
                        ),
                        color: Colors.white,
                        elevation: 0,
                        child: InkWell(
                          borderRadius: BorderRadius.all(Radius.circular(13)),
                          onTap: () async {
                            bool resultRefresh = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => addBatch(item)),
                            );
                            if (resultRefresh == true &&
                                resultRefresh != null) {
                              setState(() {});
                            }
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ListTile(
                                title: Text(
                                  item.batchName,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                                subtitle: Text(
                                    "Rs." + item.defaultFeesAmount.toString()),
                                trailing: Wrap(
                                  children: [
                                    IconButton(
                                        onPressed: () {
                                          _displayDialog(item.batchId, context);
                                        },
                                        icon: Icon(
                                          Icons.delete_rounded,
                                          color: Color(0xFF1E3B70),
                                        )),
                                  ],
                                ),
                              ),
                              Divider(
                                indent: 20,
                                endIndent: 20,
                              ),
                              Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        right: 8, bottom: 8),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          item.getStartDate() +
                                              " To " +
                                              item.getEndDate(),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey[800]),
                                        ),
                                        Text(
                                          " | ",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey[800]),
                                        ),
                                        Text(item.days.toString() + " Days",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.grey[800])),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ));
            }
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  _displayDialog(int id, BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              'Are you sure you want to delete this batch?',
              style: TextStyle(fontSize: 17),
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              new FlatButton(
                child: new Text('Delete'),
                onPressed: () {
                  Navigator.of(context).pop();
                  DBProvider.db.deleteBatch(id);
                  setState(() {});
                },
              ),
              new FlatButton(
                child: new Text('Delete (with Student)'),
                onPressed: () {
                  Navigator.of(context).pop();
                  DBProvider.db.deleteRecordByStudentid(id);
                  DBProvider.db.deleteStudentByBatch(id);
                  DBProvider.db.deleteBatch(id);
                  setState(() {});
                },
              )
            ],
          );
        });
  }
}
