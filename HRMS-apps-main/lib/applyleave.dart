import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;

class ApplyLeave extends StatefulWidget {
  const ApplyLeave({Key? key}) : super(key: key);

  @override
  State<ApplyLeave> createState() => _ApplyLeaveState();
}

class _ApplyLeaveState extends State<ApplyLeave> {
  TextEditingController dateinput = TextEditingController();
  TextEditingController dateinputto = TextEditingController();
  TextEditingController reason = TextEditingController();
  TextEditingController value = TextEditingController();
  var storage = FlutterSecureStorage();
  List categoryItemlist = [];


  void getRequest() async {
    var session = await storage.read(key: 'cookie');
    var url = Uri.parse("https://hrmsprime.com/my_services_api/partner/get_leave_details");
    var response = await http.get(url,headers: {
      "Cookie": session.toString(),
    });
     if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      setState(() {
        categoryItemlist = jsonData;
      });
      
    }
  }
  
  void initState(){
    super.initState();
    getRequest();
  }
  
  void postdata() async {
    var session = await storage.read(key: 'cookie');
    var jsonMap = {
      "holiday_status_id" : dropdownValue.toString(),
      "name" : reason.text,
      "date_from" :dateinput.text.toString(),
      "date_to" :dateinputto.text.toString()
    };
    var url = Uri.parse(
        "https://hrmsprime.com/my_services_api/partner/apply_leave");

    var response = await http.post(url, body: jsonEncode(jsonMap), headers: {
      "Content-type": "application/json",
      "Cookie": session.toString(),
      'Accept': '*/*'
    });
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Succesfully applied Leave'),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.only(bottom: 100.0),
          duration: const Duration(milliseconds: 2000)));
      // return 1;
    } else if (response.statusCode == 400) {
      var det = jsonDecode(response.body);
      var desc = det['description'];
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(desc),
        behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.only(bottom: 100.0),
          duration: const Duration(milliseconds: 2000)      
      ));
    }
  }

  // @override
  // void initState() {
  //   super.initState();
  //   postdata();
  // }
  
  // @override
  // void initState() {
  //   dateinput.text = "";
  //   dateinputto.text = "";
  //   //set the initial value of text field
  //   super.initState();
  // }

  String dropdownValue = 'Sick Leave';
  final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
    minimumSize: Size(300, 35),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(2)),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleTextStyle: Theme.of(context).appBarTheme.titleTextStyle,
        iconTheme: Theme.of(context).appBarTheme.iconTheme,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        automaticallyImplyLeading: false,
        title: Text(
          'Apply leave',
        ),
        centerTitle: true,
        elevation: 50,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
          ),
        ),
      ),
      body: SingleChildScrollView(
        
        child: 
        
        Column(children: 
        [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Text('Leave type : '),
                
                  DropdownButton(
                    
                    value: dropdownValue,
                    
                    items: categoryItemlist.map((item) {
                      return new DropdownMenuItem(
                        child: new Text(
                          item,   
                          style: TextStyle(
                          fontSize: 20.0,
                          ),
                        ),
                        
                          value: item.toString()      
                       );  
                    }).toList(),  
                     
                      onChanged: (String? newValue) {
                    setState(() {
                      dropdownValue = newValue!;
                    });
                  }, 
                                  ),
                                

                // DropdownButton(
                //   //isExpanded: true, // here need to change
                //   value: dropdownValue,
                //   onChanged: (String? newValue) {
                //     setState(() {
                //       dropdownValue = newValue!;
                //       print(dropdownValue);
                //     });
                //   }, 
                //   items:
                //    <String>[
                //     "Sick Leave",
                //     "Unpaid Leave",
                //     "Compensatory Days",
                //     "Privilege Leave",
                //     "Extra Hours"
                //   ].map<DropdownMenuItem<String>>((String value) {
                //     return DropdownMenuItem<String>(
                //       value: value,
                //       child: Padding(
                //         padding: const EdgeInsets.fromLTRB(0, 0, 30, 0),
                //         child: Text(value),
                        
                //       ),
                //     );
                //   }).toList(),
                // ),
              ],
            ),
            
          ),
          
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: TextField(
              controller: dateinput,
              decoration: InputDecoration(
                  icon: Icon(Icons.calendar_today), 
                  labelText: "From"
                  ),
              readOnly:
                  true,
              onTap: () async {
                setState(() {
                  
                });
                DateTime? pickedDate1 = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(
                        2000), 
                    lastDate: DateTime(2101));
                 
                if (pickedDate1 != null) {
                  
                  String formattedDate1 =
                      DateFormat('yyyy-MM-dd ').format(pickedDate1);
                     
                    
                  setState(() {
                    dateinput.text =
                        formattedDate1; 
                  });
                 
                } else {
                  print("Date is not selected");
                }
              },
            ),
          ),
          Padding(padding: EdgeInsets.all(10)),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: TextField(
              controller: dateinputto,
              decoration: InputDecoration(
                  icon: Icon(Icons.calendar_today),
                  labelText: "To"
                  ),
              readOnly:
                  true, 
              onTap: () async {
                DateTime? pickedDate2 = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(
                        2000), 
                    lastDate: DateTime(2101));
                    

                if (pickedDate2 != null) {
                 
                  String formattedDate2 =
                      DateFormat('yyyy-MM-dd').format(pickedDate2);
                  print(
                      formattedDate2);
                      var date_to = formattedDate2;
                      print(date_to);

                  setState(() {
                    dateinputto.text =
                        formattedDate2;
                  });
                } else {
                  print("Date is not selected");
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: TextField(
              controller: reason,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  
                  // labelText: 'Reason for leave',
                  hintText: 'Reason for leave',
                  isDense: true),
                 

            ),
            
            
          ),
          
          // Padding(
          //   padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
          //   child: Row(
          //     children: [
          //       Expanded(child: SizedBox()),
          //       ElevatedButton(
          //         onPressed: () async {
          //           FilePickerResult? result =
          //               await FilePicker.platform.pickFiles();
          //           if (result == null) {
          //             print("No file selected");
          //           } else {
          //             print(result.files.single.name);
          //           }
          //         },
          //         child: Text("Upload files"),
          //       ),
          //     ],
          //   ),
          // ),
          Padding(padding: EdgeInsets.all(30)),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              onPrimary: Colors.black87,
              minimumSize: Size(300, 60),
              padding: EdgeInsets.all(25),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(2)),
              ),
            ),
            onPressed:() {
                postdata();
                
                  },
                 
            child: Text(
              'Apply Leave',
              style: TextStyle(
                color: Colors.white,
              ),
            
              ),
            ),
           

          
        ]),
      ),
    );
  }
  }
