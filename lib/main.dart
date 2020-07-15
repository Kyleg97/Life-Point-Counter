import 'dart:collection';

import 'package:flutter/material.dart';

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
  String numberToChange = "00000";

  void _calculate() {
    int number = 0;
    for (int i = 0; i < numberToChange.length; i++) {
      number += int.parse(numberToChange[i]);
    }
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
    numberToChange = "";
  }

  Widget _numberButton(int number) {
    return MaterialButton(
      height: 100,
      child: Text(number.toString(),
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
      textColor: Colors.black,
      color: Colors.grey[100],
      onPressed: () => numberToChange += number.toString(),
    );
  }

  Widget _operationButton(String operation) {
    return MaterialButton(
        height: 100,
        child: Text(operation,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
        textColor: Colors.black,
        color: operation == "+" ? Colors.blue[100] : Colors.red[100],
        //onPressed: () => operation == "+" ? add = true : add = false,
        onPressed: () {
          setState(() {
            if (operation == "+") {
              add = true;
            } else {
              add = false;
            }
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Text("Player 1"),
                    Text(player1.toString()),
                  ],
                ),
                Column(
                  children: <Widget>[
                    Text("Player 2"),
                    Text(player2.toString()),
                  ],
                ),
              ],
            ),
            SizedBox(height: 10),
            Container(
              width: 260,
              height: 50,
              decoration: BoxDecoration(
                  border: Border.all(
                      color: add == true ? Colors.blue : Colors.red, width: 1)),
              child: Center(
                child: Text(numberToChange),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    _numberButton(7),
                    _numberButton(8),
                    _numberButton(9),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    _numberButton(4),
                    _numberButton(5),
                    _numberButton(6),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    _numberButton(1),
                    _numberButton(2),
                    _numberButton(3),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    _operationButton("+"),
                    _operationButton("-"),
                    _numberButton(0),
                  ],
                ),
              ],
            ),
            SizedBox(height: 25),
            MaterialButton(
              height: 100,
              child: Text("=",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
              textColor: Colors.black,
              color: Colors.grey[100],
              onPressed: _calculate,
            ),
          ],
        ),
      ),
    );
  }
}
