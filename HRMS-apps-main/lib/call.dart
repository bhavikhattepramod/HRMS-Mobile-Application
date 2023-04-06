// import 'package:flutter/material.dart';
// import 'package:flutter/src/foundation/key.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:outline_search_bar/outline_search_bar.dart';

// class Call extends StatefulWidget {
//   const Call({Key? key}) : super(key: key);

//   @override
//   State<Call> createState() => _CallState();
// }

// class _CallState extends State<Call> {
//   TextEditingController textController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         titleTextStyle: Theme.of(context).appBarTheme.titleTextStyle,
//         iconTheme: Theme.of(context).appBarTheme.iconTheme,
//         backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
//         automaticallyImplyLeading: false,
//         title: Text(
//           'CALL',
//         ),
//         centerTitle: true,
//         elevation: 2,
//         leading: IconButton(
//           onPressed: () {
//             Navigator.pop(context);
//           },
//           icon: Icon(
//             Icons.arrow_back,
//           ),
//         ),
//       ),
//       body: SafeArea(
//           child: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(15.0),
//             child: OutlineSearchBar(),
//           ),
//           Padding(padding: EdgeInsets.all(20)),
//           Padding(
//             padding: const EdgeInsets.all(12.0),
//             child: Container(
//               decoration: BoxDecoration(color: Color.fromARGB(255, 230, 225, 225)),
//               child: Row(
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
//                     child: Image.asset('assets/pic.png',
//                         width: 60, height: 50, fit: BoxFit.fill),
//                   ),
//                   Expanded(
//                     child: Column(
//                       children: [Text("Person1"), Text("ID : 1")],
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.all(15.0),
//                     child: IconButton(
//                       icon: Icon(Icons.call),
//                       color: Colors.black,
//                       onPressed : ()=>{}
//                     ),
//                   ),  
//                 ],
//               ),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(12.0),
//             child: Container(
//               decoration: BoxDecoration(color: Color.fromARGB(255, 230, 225, 225)),
//               child: Row(
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
//                     child: Image.asset('assets/pic.png',
//                         width: 60, height: 50, fit: BoxFit.fill),
//                   ),
//                   Expanded(
//                     child: Column(
//                       children: [Text("Person2"), Text("ID : 2")],
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.all(15.0),
//                     child: IconButton(
//                       icon: Icon(Icons.call),
//                       color: Colors.black,
//                       onPressed : ()=>{}
//                     ),
//                   ),  
//                 ],
//               ),
//             ),
//           ),
//         ],
//       )),
//     );
//   }
// }





import 'dart:convert';
import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Call extends StatelessWidget {
  // Contact({Key? key}) : super(key: key);
  int i = 0;
  final storage = FlutterSecureStorage();
  List<String> head = <String>[
    "work_mobile",
    // "work_email",
    "work_phone",
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
          'CALL',
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

