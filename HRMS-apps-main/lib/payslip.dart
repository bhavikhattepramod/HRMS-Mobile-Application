import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:downloads_path_provider_28/downloads_path_provider_28.dart';
import 'package:file_utils/file_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hrms/download.dart';
import 'package:http/http.dart' as http;
import 'package:intl/date_time_patterns.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'apiCall.dart';
import 'package:image/image.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pdf;

class payslip extends StatefulWidget {
  const payslip({Key? key}) : super(key: key);

  @override
  State<payslip> createState() => _payslipState();
}

class _payslipState extends State<payslip> {
  var fileName = '/pspdfkit-flutter-quickstart-guide.pdf';
  var year;
  var month;
  var storage = FlutterSecureStorage();
  bool trydown = false;
  var reason = '';
  
  Future fetchAlbum(BuildContext context) async {
    bool trylog = false;
    var session = await storage.read(key: 'cookie');
    Map<String, dynamic> jsonMap = {
      "month": month,
      "year": year,
    };
    final uri1 = Uri.parse(
        'https://hrmsprime.com/my_services_api/partner/get_payslip_id');

    final response =
        await http.get(uri1.replace(queryParameters: jsonMap),
        headers: {"Cookie": session.toString()});
    if (response.statusCode == 200) {
      var det = jsonDecode(response.body);
      var fileurl = det['url'];
      var pdf = det['pdf'];
      final encodedStr = pdf.toString();
      String dir = (await getApplicationDocumentsDirectory()).path;
      File file = File("$dir/" + DateTime.now().toString() + ".pdf");
    var bytes = base64Decode(pdf.toString().replaceAll('\n', ''));
    final output = await getTemporaryDirectory();
    final file1 = File("${output.path}/example.pdf");
    await file1.writeAsBytes(bytes.buffer.asUint8List());
    await OpenFile.open("${output.path}/example.pdf");
    setState(() {});
   }
   else{
     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('PLEASE CONTACT HR TO GENERATE PAYSLIP FOR THIS MONTH'),
      ));
   }
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleTextStyle: Theme.of(context).appBarTheme.titleTextStyle,
        iconTheme: Theme.of(context).appBarTheme.iconTheme,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        automaticallyImplyLeading: false,
        title: Text(
          'PAYSLIP',
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
      
      body: SafeArea(
          child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DropdownButton(
                  hint: Text("Select Year"),
                  value: year,
                  onChanged: (newValue) {
                    setState(() {
                      year = newValue!;
                    });
                  },
                  items: <String>[
                    '2023',
                    '2022',
                    '2021',
                    '2020',
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 50, 0),
                        child: Text(value),
                      ),
                    );
                  }).toList(),
                ),
                DropdownButton(
                  hint: Text("Select Month"),
                  value: month,
                  onChanged: (newValue) {
                    setState(() {
                      month = newValue!;
                    });
                  },
                  items: <String>[
                    '1',
                    '2',
                    '3',
                    '4',
                    '5',
                    '6',
                    '7',
                    '8',
                    '9',
                    '10',
                    '11',
                    '12',
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 50, 0),
                        child: Text(value),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              onPrimary: Colors.black87,
              minimumSize: Size(300, 60),
              padding: EdgeInsets.all(25),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(2)),
              ),
            ),
            onPressed: 
            year == null || month == null
                ? null
                : () {
                    fetchAlbum(context);
                  
                  },    
            child: Text(
              'View Payslip',
              style: TextStyle(
              color: Colors.white,
              ),
              ),
            ),
          if (trydown) Text(reason),
        ],
      )),
    );
  }
  }


