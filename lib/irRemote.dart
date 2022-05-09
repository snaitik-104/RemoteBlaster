// ignore_for_file: unused_local_variable

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:rxdart/rxdart.dart';
import 'package:ir_sensor_plugin/ir_sensor_plugin.dart';

class Remote extends StatefulWidget {
  @override
  State<Remote> createState() => _RemoteState();
}

final bool hasIrEmitter = IrSensorPlugin.hasIrEmitter as bool;
final String result = IrSensorPlugin.getCarrierFrequencies as String;

class _RemoteState extends State<Remote> {
  final TextEditingController titleController = new TextEditingController();
  final GlobalKey<FormState> _keyDialogForm = new GlobalKey<FormState>();

String hex0 = "",hex1="",hex2="",hex3="",hex4="",hex5="",hex6="",hex7="",hex8="",hex9="",hex10="",hex11="",hex12="",hex13="",hex14="";
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 4,
      width: MediaQuery.of(context).size.width / 4,

      // color: Colors.grey,
      margin: EdgeInsets.all(50),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40),
        color: Color.fromARGB(255, 131, 131, 131),
      ),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Column(
          //   mainAxisAlignment: MainAxisAlignment.start,
          //   children: [
          //     Expanded(
          //       child: InkWell(
          //         onTap: () {
          //           IrSensorPlugin.transmit(pattern: hex0);
          //         },
          //         child: Container(
          //           height: 70,
          //           width: 70,
          //           decoration: BoxDecoration(
          //               color: Colors.yellow,
          //               shape: BoxShape.circle,
          //               boxShadow: [
          //                 BoxShadow(
          //                   color: Color.fromARGB(255, 45, 43, 43)
          //                       .withOpacity(0.6),
          //                   spreadRadius: 1,
          //                   blurRadius: 6,
          //                   offset: Offset(0, 4),
          //                 )
          //               ]),
          //           child: Center(
          //             child: Text(
          //               'PO',
          //               style: TextStyle(
          //                 fontWeight: FontWeight.w600,
          //                 fontSize: 28,
          //               ),
          //             ),
          //           ),
          //         ),
          //       ),
          //     ),
          //     Expanded(
          //       child: InkWell(
          //         onTap: () {
          //           IrSensorPlugin.transmit(pattern: hex1);
          //         },
          //         child: Container(
          //           height: 70,
          //           width: 70,
          //           decoration: BoxDecoration(
          //               color: Colors.yellow,
          //               shape: BoxShape.circle,
          //               boxShadow: [
          //                 BoxShadow(
          //                   color: Color.fromARGB(255, 45, 43, 43)
          //                       .withOpacity(0.6),
          //                   spreadRadius: 1,
          //                   blurRadius: 6,
          //                   offset: Offset(0, 4),
          //                 )
          //               ]),
          //           child: Center(
          //             child: Text(
          //               '1',
          //               style: TextStyle(
          //                 fontWeight: FontWeight.w600,
          //                 fontSize: 28,
          //               ),
          //             ),
          //           ),
          //         ),
          //       ),
          //     ),
          //     Expanded(
          //       child: InkWell(
          //         onTap: () {
          //           IrSensorPlugin.transmit(pattern: hex2);
          //         },
          //         child: Container(
          //           height: 70,
          //           width: 70,
          //           decoration: BoxDecoration(
          //               color: Colors.yellow,
          //               shape: BoxShape.circle,
          //               boxShadow: [
          //                 BoxShadow(
          //                   color: Color.fromARGB(255, 45, 43, 43)
          //                       .withOpacity(0.6),
          //                   spreadRadius: 1,
          //                   blurRadius: 6,
          //                   offset: Offset(0, 4),
          //                 )
          //               ]),
          //           child: Center(
          //             child: Text(
          //               '4',
          //               style: TextStyle(
          //                 fontWeight: FontWeight.w600,
          //                 fontSize: 28,
          //               ),
          //             ),
          //           ),
          //         ),
          //       ),
          //     ),
          //     Expanded(
          //       child: InkWell(
          //         onTap: () {
          //           IrSensorPlugin.transmit(pattern: hex3);
          //         },
          //         child: Container(
          //           height: 70,
          //           width: 70,
          //           decoration: BoxDecoration(
          //               color: Colors.yellow,
          //               shape: BoxShape.circle,
          //               boxShadow: [
          //                 BoxShadow(
          //                   color: Color.fromARGB(255, 45, 43, 43)
          //                       .withOpacity(0.6),
          //                   spreadRadius: 1,
          //                   blurRadius: 6,
          //                   offset: Offset(0, 4),
          //                 )
          //               ]),
          //           child: Center(
          //             child: Text(
          //               '7',
          //               style: TextStyle(
          //                 fontWeight: FontWeight.w600,
          //                 fontSize: 28,
          //               ),
          //             ),
          //           ),
          //         ),
          //       ),
          //     ),
          //     Expanded(
          //       child: InkWell(
          //         onTap: () {
          //           IrSensorPlugin.transmit(pattern: hex4);
          //         },
          //         child: Container(
          //           height: 70,
          //           width: 70,
          //           decoration: BoxDecoration(
          //               color: Colors.yellow,
          //               shape: BoxShape.circle,
          //               boxShadow: [
          //                 BoxShadow(
          //                   color: Color.fromARGB(255, 45, 43, 43)
          //                       .withOpacity(0.6),
          //                   spreadRadius: 1,
          //                   blurRadius: 6,
          //                   offset: Offset(0, 4),
          //                 )
          //               ]),
          //           child: Center(
          //             child: Text(
          //               '10',
          //               style: TextStyle(
          //                 fontWeight: FontWeight.w600,
          //                 fontSize: 28,
          //               ),
          //             ),
          //           ),
          //         ),
          //       ),
          //     ),
          //   ],
          // ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {
                    IrSensorPlugin.transmit(pattern: "0xF708FB04");
                  },
                  child: Container(
                    height: 70,
                    width: 70,
                    decoration: BoxDecoration(
                        color: Colors.yellow,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromARGB(255, 45, 43, 43)
                                .withOpacity(0.6),
                            spreadRadius: 1,
                            blurRadius: 6,
                            offset: Offset(0, 4),
                          )
                        ]),
                    child: Center(
                      child: Text(
                        '1',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 28,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: () {
                    IrSensorPlugin.transmit(pattern: "0xEE11FB04");
                  },
                  child: Container(
                    height: 70,
                    width: 70,
                    decoration: BoxDecoration(
                        color: Colors.yellow,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromARGB(255, 45, 43, 43)
                                .withOpacity(0.6),
                            spreadRadius: 1,
                            blurRadius: 6,
                            offset: Offset(0, 4),
                          )
                        ]),
                    child: Center(
                      child: Text(
                        '2',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 28,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: () {
                    IrSensorPlugin.transmit(pattern: "0xED12FB04");
                  },
                  child: Container(
                    height: 70,
                    width: 70,
                    decoration: BoxDecoration(
                        color: Colors.yellow,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromARGB(255, 45, 43, 43)
                                .withOpacity(0.6),
                            spreadRadius: 1,
                            blurRadius: 6,
                            offset: Offset(0, 4),
                          )
                        ]),
                    child: Center(
                      child: Text(
                        '3',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 28,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: () {
                    IrSensorPlugin.transmit(pattern: "0xEC13FB04");
                  },
                  child: Container(
                    height: 70,
                    width: 70,
                    decoration: BoxDecoration(
                        color: Colors.yellow,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromARGB(255, 45, 43, 43)
                                .withOpacity(0.6),
                            spreadRadius: 1,
                            blurRadius: 6,
                            offset: Offset(0, 4),
                          )
                        ]),
                    child: Center(
                      child: Text(
                        '4',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 28,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: () {
                    IrSensorPlugin.transmit(pattern: "0xEB14FB04");
                  },
                  child: Container(
                    height: 70,
                    width: 70,
                    decoration: BoxDecoration(
                        color: Colors.yellow,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromARGB(255, 45, 43, 43)
                                .withOpacity(0.6),
                            spreadRadius: 1,
                            blurRadius: 6,
                            offset: Offset(0, 4),
                          )
                        ]),
                    child: Center(
                      child: Text(
                        '5',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 28,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          // Column(
          //   mainAxisAlignment: MainAxisAlignment.start,
          //   children: [
          //     Expanded(
          //       child: InkWell(
          //         onTap: () {
          //           IrSensorPlugin.transmit(pattern: hex10);
          //         },
          //         child: Container(
          //           height: 70,
          //           width: 70,
          //           decoration: BoxDecoration(
          //               color: Colors.yellow,
          //               shape: BoxShape.circle,
          //               boxShadow: [
          //                 BoxShadow(
          //                   color: Color.fromARGB(255, 45, 43, 43)
          //                       .withOpacity(0.6),
          //                   spreadRadius: 1,
          //                   blurRadius: 6,
          //                   offset: Offset(0, 4),
          //                 )
          //               ]),
          //           child: Center(
          //             child: Text(
          //               'MU',
          //               style: TextStyle(
          //                 fontWeight: FontWeight.w600,
          //                 fontSize: 28,
          //               ),
          //             ),
          //           ),
          //         ),
          //       ),
          //     ),
          //     Expanded(
          //       child: InkWell(
          //         onTap: () {
          //           IrSensorPlugin.transmit(pattern: hex11);
          //         },
          //         child: Container(
          //           height: 70,
          //           width: 70,
          //           decoration: BoxDecoration(
          //               color: Colors.yellow,
          //               shape: BoxShape.circle,
          //               boxShadow: [
          //                 BoxShadow(
          //                   color: Color.fromARGB(255, 45, 43, 43)
          //                       .withOpacity(0.6),
          //                   spreadRadius: 1,
          //                   blurRadius: 6,
          //                   offset: Offset(0, 4),
          //                 )
          //               ]),
          //           child: Center(
          //             child: Text(
          //               '3',
          //               style: TextStyle(
          //                 fontWeight: FontWeight.w600,
          //                 fontSize: 28,
          //               ),
          //             ),
          //           ),
          //         ),
          //       ),
          //     ),
          //     Expanded(
          //       child: InkWell(
          //         onTap: () {
          //           IrSensorPlugin.transmit(pattern: hex12);
          //         },
          //         child: Container(
          //           height: 70,
          //           width: 70,
          //           decoration: BoxDecoration(
          //               color: Colors.yellow,
          //               shape: BoxShape.circle,
          //               boxShadow: [
          //                 BoxShadow(
          //                   color: Color.fromARGB(255, 45, 43, 43)
          //                       .withOpacity(0.6),
          //                   spreadRadius: 1,
          //                   blurRadius: 6,
          //                   offset: Offset(0, 4),
          //                 )
          //               ]),
          //           child: Center(
          //             child: Text(
          //               '6',
          //               style: TextStyle(
          //                 fontWeight: FontWeight.w600,
          //                 fontSize: 28,
          //               ),
          //             ),
          //           ),
          //         ),
          //       ),
          //     ),
          //     Expanded(
          //       child: InkWell(
          //         onTap: () {
          //           IrSensorPlugin.transmit(pattern: hex13);
          //         },
          //         child: Container(
          //           height: 70,
          //           width: 70,
          //           decoration: BoxDecoration(
          //               color: Colors.yellow,
          //               shape: BoxShape.circle,
          //               boxShadow: [
          //                 BoxShadow(
          //                   color: Color.fromARGB(255, 45, 43, 43)
          //                       .withOpacity(0.6),
          //                   spreadRadius: 1,
          //                   blurRadius: 6,
          //                   offset: Offset(0, 4),
          //                 )
          //               ]),
          //           child: Center(
          //             child: Text(
          //               '9',
          //               style: TextStyle(
          //                 fontWeight: FontWeight.w600,
          //                 fontSize: 28,
          //               ),
          //             ),
          //           ),
          //         ),
          //       ),
          //     ),
          //     Expanded(
          //       child: InkWell(
          //         onTap: (){
          //           IrSensorPlugin.transmit(pattern: hex14);
          //         },
          //         child: Container(
          //           height: 70,
          //           width: 70,
          //           decoration: BoxDecoration(
          //               color: Colors.yellow,
          //               shape: BoxShape.circle,
          //               boxShadow: [
          //                 BoxShadow(
          //                   color: Color.fromARGB(255, 45, 43, 43)
          //                       .withOpacity(0.6),
          //                   spreadRadius: 1,
          //                   blurRadius: 6,
          //                   offset: Offset(0, 4),
          //                 )
          //               ]),
          //           child: Center(
          //             child: Text(
          //               '12',
          //               style: TextStyle(
          //                 fontWeight: FontWeight.w600,
          //                 fontSize: 28,
          //               ),
          //             ),
          //           ),
          //         ),
          //       ),
          //     ),
          //   ],
          // )
        ],
      ),
    );
  }
}

// String hexCode = "";
// TextEditingController ageController = new TextEditingController();
// Future<void> _displayTextInputDialog(BuildContext context) async {
//   return showDialog(
//       context: context,
//       builder: (context) {
//         ageController.text = "";
//         return AlertDialog(
//           title: Text('Enter HEX code'),
//           content: TextField(
//             onChanged: (value) {
//               hexCode = value;
//             },
//             controller: ageController,
//             decoration: InputDecoration(hintText: "xxxxxxxxx"),
//           ),
//           actions: <Widget>[
//             // ignore: deprecated_member_use
//             FlatButton(
//               //color: Colors.red,
//               //textColor: Colors.white,
//               child: Text('CANCEL'),
//               onPressed: () {
//                Navigator.pop(context);
//               },
//             ),
//             // ignore: deprecated_member_use
//             FlatButton(
//               //color: Colors.green,
//               //textColor: Colors.white,
//               child: Text('OK'),
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//             ),
//           ],
//         );
//       });
// }


