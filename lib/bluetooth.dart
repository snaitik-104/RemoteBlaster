// ignore_for_file: prefer_adjacent_string_concatenation

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

// For using PlatformException
import 'package:flutter/services.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class BluetoothApp extends StatefulWidget {
  @override
  _BluetoothAppState createState() => _BluetoothAppState();
}

String d1="",d2="",d3="",d4="",d5="";
class _BluetoothAppState extends State<BluetoothApp> {
  // Initializing the Bluetooth connection state to be unknown
  BluetoothState _bluetoothState = BluetoothState.UNKNOWN;
  // Initializing a global key, as it would help us in showing a SnackBar later
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  // Get the instance of the Bluetooth
  FlutterBluetoothSerial _bluetooth = FlutterBluetoothSerial.instance;
  // Track the Bluetooth connection with the remote device

  BluetoothConnection? connection;

  int _deviceState = 0;

  bool isDisconnecting = false;

  Map<String, Color> colors = {
    'onBorderColor': Colors.green,
    'offBorderColor': Colors.red,
    'neutralBorderColor': Colors.transparent,
    'onTextColor': Color.fromARGB(255, 56, 142, 60),
    'offTextColor': Color.fromARGB(255, 208, 48, 48),
    'neutralTextColor': Colors.blue,
  };

  // To track whether the device is still connected to Bluetooth
  bool get isConnected => connection != null && connection!.isConnected;

  // Define some variables, which will be required later
  List<BluetoothDevice> _devicesList = [];
  BluetoothDevice? _device;
  bool _connected = false;
  bool _isButtonUnavailable = false;

  @override
  void initState() {
    super.initState();

    // Get current state
    FlutterBluetoothSerial.instance.state.then((state) {
      setState(() {
        _bluetoothState = state;
      });
    });

    _deviceState = 0; // neutral

    // If the bluetooth of the device is not enabled,
    // then request permission to turn on bluetooth
    // as the app starts up
    enableBluetooth();

    // Listen for further state changes
    FlutterBluetoothSerial.instance
        .onStateChanged()
        .listen((BluetoothState state) {
      setState(() {
        _bluetoothState = state;
        if (_bluetoothState == BluetoothState.STATE_OFF) {
          _isButtonUnavailable = true;
        }
        getPairedDevices();
      });
    });
  }

  @override
  void dispose() {
    // Avoid memory leak and disconnect
    if (isConnected) {
      isDisconnecting = true;
      connection!.dispose();
      connection != null;
    }

    super.dispose();
  }

  // Request Bluetooth permission from the user
  Future<bool> enableBluetooth() async {
    // Retrieving the current Bluetooth state
    _bluetoothState = await FlutterBluetoothSerial.instance.state;

    // If the bluetooth is off, then turn it on first
    // and then retrieve the devices that are paired.
    if (_bluetoothState == BluetoothState.STATE_OFF) {
      await FlutterBluetoothSerial.instance.requestEnable();
      await getPairedDevices();
      return true;
    } else {
      await getPairedDevices();
    }
    return false;
  }

  // For retrieving and storing the paired devices
  // in a list.
  Future<void> getPairedDevices() async {
    List<BluetoothDevice> devices = [];

    // To get the list of paired devices
    try {
      devices = await _bluetooth.getBondedDevices();
    } on PlatformException {
      print("Error");
    }

    // It is an error to call [setState] unless [mounted] is true.
    if (!mounted) {
      return;
    }

    // Store the [devices] list in the [_devicesList] for accessing
    // the list outside this class
    setState(() {
      _devicesList = devices;
    });
  }

  // Now, its time to build the UI
  @override
  Widget build(BuildContext context) {
    var d;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Visibility(
                visible: _isButtonUnavailable &&
                    _bluetoothState == BluetoothState.STATE_ON,
                child: LinearProgressIndicator(
                  backgroundColor: Colors.yellow,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        'Enable Bluetooth',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Switch(
                      value: _bluetoothState.isEnabled,
                      onChanged: (bool value) {
                        future() async {
                          if (value) {
                            await FlutterBluetoothSerial.instance
                                .requestEnable();
                          } else {
                            await FlutterBluetoothSerial.instance
                                .requestDisable();
                          }

                          await getPairedDevices();
                          _isButtonUnavailable = false;

                          if (_connected) {
                            _disconnect();
                          }
                        }

                        future().then((_) {
                          setState(() {});
                        });
                      },
                    )
                  ],
                ),
              ),
              Stack(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Text(
                          "PAIRED DEVICES",
                          style: TextStyle(fontSize: 24, color: Colors.blue),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              'Device:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            DropdownButton(
                              items: _getDeviceItems(),
                              onChanged: (value) => setState(
                                  () => _device = value as BluetoothDevice),
                              value: _devicesList.isNotEmpty ? _device : null,
                            ),
                            RaisedButton(
                              onPressed: _isButtonUnavailable
                                  ? null
                                  : _connected
                                      ? _disconnect
                                      : _connect,
                              child:
                                  Text(_connected ? 'Disconnect' : 'Connect'),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            // ignore: unnecessary_new

                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          elevation: _deviceState == 0 ? 4 : 0,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: InkWell(
                                    child: Text(
                                      "Device 1",
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: _deviceState == 0
                                            ? colors['neutralTextColor']
                                            : _deviceState == 1
                                                ? colors['onTextColor']
                                                : colors['offTextColor'],
                                      ),
                                    ),
                                  ),
                                ),
                                FlatButton(
                                  onPressed: () => _connected
                                      ? _sendOnMessageToBluetooth("1")
                                      : null,
                                  child: Text("ON"),
                                ),
                                FlatButton(
                                  onPressed: () => _connected
                                      ? _sendOffMessageToBluetooth("1")
                                      : null,
                                  child: Text("OFF"),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          elevation: _deviceState == 0 ? 4 : 0,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Text(
                                      "Device 2",
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: _deviceState == 0
                                            ? colors['neutralTextColor']
                                            : _deviceState == 1
                                                ? colors['onTextColor']
                                                : colors['offTextColor'],
                                      ),
                                    ),
                                  ),
                                  FlatButton(
                                    onPressed: () => _connected
                                        ? _sendOnMessageToBluetooth("2")
                                        : null,
                                    child: Text("ON"),
                                  ),
                                  FlatButton(
                                    onPressed: () => _connected
                                        ? _sendOffMessageToBluetooth("2")
                                        : null,
                                    child: Text("OFF"),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          elevation: _deviceState == 0 ? 4 : 0,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Text(
                                      "Device 3",
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: _deviceState == 0
                                            ? colors['neutralTextColor']
                                            : _deviceState == 1
                                                ? colors['onTextColor']
                                                : colors['offTextColor'],
                                      ),
                                    ),
                                  ),
                                  FlatButton(
                                    onPressed: () => _connected
                                        ? _sendOnMessageToBluetooth("3")
                                        : null,
                                    child: Text("ON"),
                                  ),
                                  FlatButton(
                                    onPressed: () => _connected
                                        ? _sendOffMessageToBluetooth("3")
                                        : null,
                                    child: Text("OFF"),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          elevation: _deviceState == 0 ? 4 : 0,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Text(
                                      "Device 4",
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: _deviceState == 0
                                            ? colors['neutralTextColor']
                                            : _deviceState == 1
                                                ? colors['onTextColor']
                                                : colors['offTextColor'],
                                      ),
                                    ),
                                  ),
                                  FlatButton(
                                    onPressed: () => _connected
                                        ? _sendOnMessageToBluetooth("4")
                                        : null,
                                    child: Text("ON"),
                                  ),
                                  FlatButton(
                                    onPressed: () => _connected
                                        ? _sendOffMessageToBluetooth("4")
                                        : null,
                                    child: Text("OFF"),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            // ignore: unnecessary_new

                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          elevation: _deviceState == 0 ? 4 : 0,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Text(
                                      "Device 5",
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: _deviceState == 0
                                            ? colors['neutralTextColor']
                                            : _deviceState == 1
                                                ? colors['onTextColor']
                                                : colors['offTextColor'],
                                      ),
                                    ),
                                  ),
                                  FlatButton(
                                    onPressed: () => _connected
                                        ? _sendOnMessageToBluetooth("5")
                                        : null,
                                    child: Text("ON"),
                                  ),
                                  FlatButton(
                                    onPressed: () => _connected
                                        ? _sendOffMessageToBluetooth("5")
                                        : null,
                                    child: Text("OFF"),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    color: Colors.blue,
                  ),
                ],
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "NOTE: If you cannot find the device in the list, please pair the device by going to the bluetooth settings",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                        SizedBox(height: 15),
                        RaisedButton(
                          elevation: 2,
                          child: Text("Bluetooth Settings"),
                          onPressed: () {
                            FlutterBluetoothSerial.instance.openSettings();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  // Create the List of devices to be shown in Dropdown Menu
  List<DropdownMenuItem<BluetoothDevice>> _getDeviceItems() {
    List<DropdownMenuItem<BluetoothDevice>> items = [];
    if (_devicesList.isEmpty) {
      items.add(DropdownMenuItem(
        child: Text('NONE'),
      ));
    } else {
      _devicesList.forEach((device) {
        items.add(DropdownMenuItem(
          child: Text(device.name as String),
          value: device,
        ));
      });
    }
    return items;
  }

  // Method to connect to bluetooth
  void _connect() async {
    setState(() {
      _isButtonUnavailable = true;
    });
    if (_device == null) {
      show('No device selected');
    } else {
      if (!isConnected) {
        await BluetoothConnection.toAddress(_device!.address)
            .then((_connection) {
          print('Connected to the device');
          connection = _connection;
          setState(() {
            _connected = true;
          });

          connection!.input!.listen(null).onDone(() {
            if (isDisconnecting) {
              print('Disconnecting locally!');
            } else {
              print('Disconnected remotely!');
            }
            if (this.mounted) {
              setState(() {});
            }
          });
        }).catchError((error) {
          print('Cannot connect, exception occurred');
          print(error);
        });
        show('Device connected');

        setState(() => _isButtonUnavailable = false);
      }
    }
  }

  // void _onDataReceived(Uint8List data) {
  //   // Allocate buffer for parsed data
  //   int backspacesCounter = 0;
  //   data.forEach((byte) {
  //     if (byte == 8 || byte == 127) {
  //       backspacesCounter++;
  //     }
  //   });
  //   Uint8List buffer = Uint8List(data.length - backspacesCounter);
  //   int bufferIndex = buffer.length;

  //   // Apply backspace control character
  //   backspacesCounter = 0;
  //   for (int i = data.length - 1; i >= 0; i--) {
  //     if (data[i] == 8 || data[i] == 127) {
  //       backspacesCounter++;
  //     } else {
  //       if (backspacesCounter > 0) {
  //         backspacesCounter--;
  //       } else {
  //         buffer[--bufferIndex] = data[i];
  //       }
  //     }
  //   }
  // }

  // Method to disconnect bluetooth
  void _disconnect() async {
    setState(() {
      _isButtonUnavailable = true;
      _deviceState = 0;
    });

    await connection!.close();
    show('Device disconnected');
    if (!connection!.isConnected) {
      setState(() {
        _connected = false;
        _isButtonUnavailable = false;
      });
    }
  }

  // Method to send message,
  // for turning the Bluetooth device on
  _sendOnMessageToBluetooth(String n) async {
    connection!.output.add(Uint8List.fromList(utf8.encode(n + "\r\n")));
    await connection!.output.allSent;
    show('Device Turned On');
    setState(() {
      _deviceState = 1; // device on
    });
  }

  // Method to send message,
  // for turning the Bluetooth device off
  _sendOffMessageToBluetooth(String m) async {
    connection!.output.add(Uint8List.fromList(utf8.encode(m + "\r\n")));
    await connection!.output.allSent;
    show('Device Turned Off');
    setState(() {
      _deviceState = -1; // device off
    });
  }

  // Method to show a Snackbar,
  // taking message as the text
  Future show(
    String message, {
    Duration duration: const Duration(seconds: 3),
  }) async {
    await new Future.delayed(new Duration(milliseconds: 100));
    _scaffoldKey.currentState?.showSnackBar(
      new SnackBar(
        content: new Text(
          message,
        ),
        duration: duration,
      ),
    );
  }
}

// String hexCode = "";
// TextEditingController ageController = new TextEditingController();
// Future<void> _displayTextInputDialog(BuildContext context, int n) async {
//   return showDialog(
//       context: context,
//       builder: (context) {
//         ageController.text = "";
//         return AlertDialog(
//           title: Text('Enter Device code'),
//           content: TextField(
//             onChanged: (value) {
//               hexCode = value;
//               print(hexCode);
//               switch (n) {
//                 case 1: d1=hexCode;
                  
//                   break;
//                 case 2: d2=hexCode;
//                   break;
//                 case 3: d3=hexCode;
//                   break;
//                 case 4: d4=hexCode;
//                   break;
//                 case 5: d5=hexCode;
//                   break;
//                 default:
//               }
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
//                 Navigator.pop(context);
//               },
//             ),
//             // ignore: deprecated_member_use
//             FlatButton(
//               //color: Colors.green,
//               //textColor: Colors.white,
//               child: Text('OK'),
//               onPressed: () {
//                 print(hexCode);
//                 Navigator.pop(context);
                
//               },
//             ),
//           ],
//         );
//       });
// }
