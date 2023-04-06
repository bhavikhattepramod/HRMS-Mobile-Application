import 'dart:convert';
import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Work extends StatelessWidget {
  Work({Key? key}) : super(key: key);
  int i = 0;
  final storage = FlutterSecureStorage();
  List<String> head = <String>[
    "job_title ",
    "department_name",
    "manager_name",
    "work_location",
    "joining_date",
    "identification_num",
    "salary_info"
  ];
  List<String> detail = <String>[];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleTextStyle: Theme.of(context).appBarTheme.titleTextStyle,
        iconTheme: Theme.of(context).appBarTheme.iconTheme,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        automaticallyImplyLeading: false,
        title: Text(
          'Work details',
        ),
        centerTitle: true,
        elevation: 2,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
          ),
        ),
      ),
      body: FutureBuilder(
        future: storage.read(key: 'employee'),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Map det = jsonDecode(snapshot.data.toString());
            head.forEach((key) {
              detail.add(det[key].toString());
            });
            return ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: head.length,
              itemBuilder: (BuildContext context, int index) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${head[index]}:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(detail[index]),
                    Divider(
                      endIndent: 10,
                      indent: 10,
                      thickness: 2,
                    )
                  ],
                );
              },
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

