import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int player1 = 8000, player2 = 8000;
  bool selected = true; // true == player1, false == player2
  bool add = false; // true == addition, false == subtraction
  bool willEnd = false; // will this attack finish the duel?
  bool dialVisible = true; // speed dial
  Color currentColor = Colors.red;
  TextEditingController controller = new TextEditingController();
  String numberToChange = "";

  void setDialVisible(bool value) {
    setState(() {
      dialVisible = value;
    });
  }

  void _calculate() {
    int number = int.parse(controller.text);
    setState(() {
      if (selected) {
        if (add) {
          player1 += number;
        } else {
          player1 -= number;
        }
      } else {
        if (add) {
          player2 += number;
        } else {
          player2 -= number;
        }
      }
    });
    controller.text = "";
  }

  Widget _numberButton(int number) {
    return MaterialButton(
        height: 100,
        child: Text(number.toString(),
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
        textColor: Colors.black,
        color: Colors.grey[100],
        onPressed: () {
          setState(() {
            controller.text += number.toString();
            if (selected) {
              if ((player1 - int.parse(controller.text)) <= 0) {
                willEnd = true;
              } else {
                willEnd = false;
              }
            } else {
              if ((player2 - int.parse(controller.text)) <= 0) {
                willEnd = true;
              } else {
                willEnd = false;
              }
            }
          });
        });
  }

  Widget _operationButton(String operation) {
    return MaterialButton(
        height: 100,
        child: Text(operation,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
        textColor: Colors.black,
        color: operation == "+" ? Colors.blue : Colors.red,
        //onPressed: () => operation == "+" ? add = true : add = false,
        onPressed: () {
          setState(() {
            if (operation == "+") {
              add = true;
              currentColor = Colors.blue;
            } else {
              add = false;
              currentColor = Colors.red;
            }
          });
        });
  }

  SpeedDial buildSpeedDial() {
    return SpeedDial(
      animatedIcon: AnimatedIcons.menu_close,
      animatedIconTheme: IconThemeData(size: 22.0, color: Colors.black),
      backgroundColor: Colors.white,
      // child: Icon(Icons.add),
      onOpen: () => print('OPENING DIAL'),
      onClose: () => print('DIAL CLOSED'),
      visible: dialVisible,
      curve: Curves.decelerate,
      // overlayOpacity: 0.5,
      children: [
        SpeedDialChild(
          child: Icon(Icons.rotate_left, color: Colors.white),
          backgroundColor: Colors.deepOrange,
          onTap: () => print('FIRST CHILD'),
          label: 'Coin Toss',
          labelStyle:
              TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
          labelBackgroundColor: Colors.deepOrangeAccent,
        ),
        SpeedDialChild(
          child: Icon(Icons.offline_pin, color: Colors.white),
          backgroundColor: Colors.green,
          onTap: () => print('SECOND CHILD'),
          label: 'Dice Roll',
          labelStyle:
              TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
          labelBackgroundColor: Colors.green,
        ),
        SpeedDialChild(
          child: Icon(Icons.restore, color: Colors.white),
          backgroundColor: Colors.blue,
          onTap: () => print('THIRD CHILD'),
          label: 'Reset Game',
          labelStyle:
              TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
          labelBackgroundColor: Colors.blue,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      floatingActionButton: buildSpeedDial(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                InkWell(
                  onTap: () {
                    if (!selected) {
                      setState(() {
                        selected = !selected;
                      });
                    }
                  },
                  child: Card(
                    color: selected ? currentColor : Colors.white,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                      child: Column(
                        children: <Widget>[
                          Text(player1.toString(),
                              style: TextStyle(
                                fontSize: 42,
                              )),
                          Text("Player 1", style: TextStyle(fontSize: 18)),
                        ],
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    if (selected) {
                      setState(() {
                        selected = !selected;
                      });
                    }
                  },
                  child: Card(
                    color: !selected ? currentColor : Colors.white,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                      child: Column(
                        children: <Widget>[
                          Text(player2.toString(),
                              style: TextStyle(
                                fontSize: 42,
                              )),
                          Text("Player 2", style: TextStyle(fontSize: 18)),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 5),
            Container(
              width: 300,
              height: 50,
              child: TextFormField(
                style: TextStyle(fontSize: 22, color: Colors.white),
                textAlign: TextAlign.end,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      borderSide: BorderSide(color: Colors.blue)),
                  hintText: '',
                ),
                enabled: false,
                controller: controller,
              ),
            ),
            Container(
              width: width,
              height: height / 2.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      _numberButton(7),
                      _numberButton(8),
                      _numberButton(9),
                      MaterialButton(
                          height: 100,
                          child: Icon(Icons.backspace),
                          textColor: Colors.black,
                          color: Colors.grey[100],
                          onPressed: () {
                            setState(() {
                              if (controller.text.length != 0) {
                                controller.text = controller.text
                                    .substring(0, controller.text.length - 1);
                              }
                            });
                          }),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      _numberButton(4),
                      _numberButton(5),
                      _numberButton(6),
                      MaterialButton(
                          height: 100,
                          textColor: Colors.black,
                          color: Colors.grey[100],
                          onPressed: () {}),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      _numberButton(1),
                      _numberButton(2),
                      _numberButton(3),
                      MaterialButton(
                          height: 100,
                          textColor: Colors.black,
                          color: Colors.grey[100],
                          onPressed: () {}),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      _operationButton("+"),
                      _numberButton(0),
                      _operationButton("-"),
                      MaterialButton(
                          height: 100,
                          textColor: Colors.black,
                          color: Colors.grey[100],
                          onPressed: () {}),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 25),
            MaterialButton(
              height: height / 12,
              minWidth: width / 1.2,
              child: Text(willEnd ? "SEND TO THE SHADOW REALM" : "=",
                  style: TextStyle(
                      fontWeight: willEnd ? FontWeight.normal : FontWeight.bold,
                      fontSize: willEnd ? 17 : 24)),
              textColor: Colors.black,
              color: willEnd ? Colors.purple[500] : Colors.grey[100],
              onPressed: _calculate,
            ),
          ],
        ),
      ),
    );
  }
}
