import 'dart:convert';
import 'package:hrms/dashboard.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:hrms/employeeLogin.dart';
import 'package:hrms/pallete.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(Home());
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final storage = FlutterSecureStorage();
  Widget next = login();
  @override
  void initState() {
    super.initState();
    initialization();
  }

  void initialization() async {
    await Future.delayed(const Duration(seconds: 2));
    FlutterNativeSplash.remove();
  }

  Future<int> fetchAlbum() async {
    var session = await storage.read(key: 'cookie');

    final response = await http.get(
        Uri.parse(
            'https://hrmsprime.com/my_services_api/partner/get_dashboard_details'),
        headers: {"Cookie": session.toString()});

    if (response.statusCode == 200) {
      //print(jsonDecode(response.body));
      if (jsonDecode(response.body)['code'] == '401') {
        return 0;
      } else {
        //print(await storage.read(key: 'cookie'));
        //print(await storage.read(key: 'employee'));
        return 1;
      }
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      
      home: FutureBuilder<int>(
        future: fetchAlbum(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data == 1) {
              return dashboard();
            } else {
              return login();
            }
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      theme: ThemeData(
          iconTheme: IconThemeData(color: Color.fromARGB(255, 255, 255, 255)),
          backgroundColor: Color.fromARGB(255, 236, 236, 236),
          primarySwatch: Palette.kToDark,
          brightness: Brightness.light,
          textTheme: TextTheme(
            bodyText2: TextStyle(
              color: Color.fromARGB(255, 0, 0, 0),
              fontSize: 22,
            ),
            bodyText1: TextStyle(color: Colors.black),
            subtitle1: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            subtitle2: TextStyle(
              //fontFamily: 'Lexend Deca',
              color: Color(0xFF95A1AC),
              fontSize: 20,
              fontWeight: FontWeight.normal,
            ),
          ),
          appBarTheme: AppBarTheme(
              backgroundColor: Color.fromARGB(255, 26, 67, 106),
              iconTheme: IconThemeData(color: Colors.white),
              titleTextStyle: TextStyle(
                color: Colors.white,
                fontFamily: 'Roboto Condensed',
                fontSize: 25,
                fontWeight: FontWeight.w800,
              )),
          buttonTheme: ButtonThemeData(
            buttonColor: Color.fromARGB(255, 26, 67, 106),
            padding: EdgeInsets.all(25),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(2)),
            ),
          )),
      debugShowCheckedModeBanner: false,
    );
  }
}
