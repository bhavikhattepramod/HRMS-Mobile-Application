import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:hrms/contacts.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hrms/personal.dart';
import 'package:hrms/work.dart';

class Profile extends StatelessWidget {
  Profile({Key? key}) : super(key: key);
  final storage = FlutterSecureStorage();
  late Uint8List bytes;
  Future<Map<String, dynamic>> fetchAlbum() async {
    var image = await storage.read(key: 'pic');
    bytes = Base64Codec().decode(image!);
    bool trylog = false;
    var session = await storage.read(key: 'cookie');
    print(session);
    final response = await http.get(
        Uri.parse(
            'https://hrmsprime.com/my_services_api/partner/get_employee_details'),
        headers: {"Cookie": session.toString()});
    print(response.body);
    if (response.statusCode == 200) {
      bool flag = false;

      //print(jsonDecode(response.body));
      var jsonvals = jsonDecode(response.body)['employees_list'][0];
      print(jsonvals);
      await storage.write(key: 'employee', value: jsonEncode(jsonvals));
      var det = jsonDecode(response.body)['employees_list'][0];
      //print(await storage.read(key: 'cookie'));
      //print(await storage.read(key: 'employee'));
      // img = writeImageTemp(
      //     jsonDecode(response.body)['employees_list'][0]['employee_photo'],
      //     'eimg');
      return det;
    }

    return Map();
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
          'EMPLOYEE',
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
        child: FutureBuilder<Map>(
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      ClipRRect(
                          borderRadius:
                              BorderRadius.circular(50), //add border radius
                          child: Image.memory(
                            bytes,
                            width: 100,
                            height: 100,
                          )),
                      Text(
                        snapshot.data!['name'],
                        style: TextStyle(
                          fontFamily: 'SourceSansPro',
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                        ),
                      ),
                      Text(
                        snapshot.data!['id'].toString(),
                        style: TextStyle(
                          fontFamily: 'SourceSansPro',
                          fontSize: 20,
                        ),
                      ),
                      // Text(
                      //   snapshot.data!['job_title '],
                      //   style: TextStyle(
                      //     fontFamily: 'SourceSansPro',
                      //     fontSize: 25,
                      //   ),
                      // ),
                      Padding(
                        padding: EdgeInsets.all(5),
                      ),
                      Divider(
                        thickness: 2,
                        indent: 10,
                        endIndent: 10,
                      ),
                      Padding(
                        padding: EdgeInsets.all(5),
                      ),
                      ListTile(
                        leading: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(8)),
                            child: Icon(
                              Icons.face_outlined,
                            )),
                        title: Text('personal'),
                        trailing: Icon(Icons.navigate_next),
                        onTap: (() {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Personal(),
                            ),
                          );
                        }),
                      ),
                      ListTile(
                        leading: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(8)),
                            child: Icon(
                              Icons.work,
                            )),
                        title: Text('Work details'),
                        trailing: Icon(Icons.navigate_next),
                        onTap: (() {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Work(),
                            ),
                          );
                        }),
                      ),
                      ListTile(
                        leading: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(8)),
                            child: Icon(
                              Icons.headphones,
                            )),
                        title: Text('Contact details'),
                        trailing: Icon(Icons.navigate_next),
                        onTap: (() {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Contact(),
                            ),
                          );
                        }),
                      ),
                      Padding(
                        padding: EdgeInsets.all(5),
                      ),
                      Divider(
                        thickness: 2,
                        indent: 10,
                        endIndent: 10,
                      ),
                      Padding(
                        padding: EdgeInsets.all(5),
                      ),
                    ],
                  ),
                ),
              );
            }
            return Center(child: CircularProgressIndicator());
          },
          future: fetchAlbum(),
        ),
      ),
    );
  }
}
