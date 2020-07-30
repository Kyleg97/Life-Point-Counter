import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent, // transparent status bar
  ));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.orange,
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
  //bool add = false; // true == addition, false == subtraction
  int operation = 0; // 0 == no operation, 1 == addition, 2 == subtraction
  bool willEnd = false; // will this attack finish the duel?
  Color currentColor = Colors.orange;
  TextEditingController controller = new TextEditingController();
  String numberToChange = "";

  /*void _calculate() {
    if (controller.text.length != 0) {
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
  }*/

  void _calculate() {
    if (controller.text.length != 0) {
      int number = int.parse(controller.text);
      setState(() {
        if (selected) {
          if (operation == 1) {
            player1 += number;
          } else {
            player1 -= number;
          }
        } else {
          if (operation == 1) {
            player2 += number;
          } else {
            player2 -= number;
          }
        }
      });
      controller.text = "";
      operation = 0;
    }
  }

  /*void _backspace() {
    setState(() {
      if (controller.text.length != 0) {
        controller.text =
            controller.text.substring(0, controller.text.length - 1);
        if (!add) {
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
        }
      }
    });
  }*/
  void _backspace() {
    setState(() {
      if (controller.text.length != 0) {
        controller.text =
            controller.text.substring(0, controller.text.length - 1);
        if (operation == 2) {
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
        }
      }
    });
  }

  Widget _numberButton(int number) {
    return InkResponse(
      onTap: () {
        if (operation != 0) {
          setState(() {
            controller.text += number.toString();
            if (operation == 2) {
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
            }
          });
        }
      },
      child: Container(
        margin: EdgeInsets.all(15),
        decoration: BoxDecoration(shape: BoxShape.circle),
        child: Center(
          child: Text(number.toString(),
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
        ),
      ),
    );
  }

  Widget _operationButton(Widget operation, Function fun) {
    return InkResponse(
      onTap: () {
        setState(() {
          fun();
        });
      },
      child: Container(
        margin: EdgeInsets.all(15),
        decoration: BoxDecoration(shape: BoxShape.circle),
        child: Center(child: operation),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Dueling Retards",
          style: TextStyle(color: Colors.white),
        ),
        // actions: <Widget>[Icon(Icons.menu)],
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: height / 50),
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
                                color: selected ? Colors.white : Colors.black,
                              )),
                          Text("Player 1",
                              style: TextStyle(
                                  fontSize: 18,
                                  color:
                                      selected ? Colors.white : Colors.black)),
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
                                  color:
                                      selected ? Colors.black : Colors.white)),
                          Text("Player 2",
                              style: TextStyle(
                                  fontSize: 18,
                                  color:
                                      selected ? Colors.black : Colors.white)),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              flex: 3,
              child: Align(
                alignment: Alignment.bottomRight,
                child: TextFormField(
                  style: TextStyle(fontSize: 22, color: Colors.black),
                  textAlign: TextAlign.end,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        borderSide: BorderSide(color: Colors.blue)),
                    hintText: selected ? "Player 1" : "Player 2",
                  ),
                  enabled: false,
                  controller: controller,
                ),
              ),
            ),
            Expanded(
              flex: 5,
              child: GridView.count(
                crossAxisSpacing: 20,
                crossAxisCount: 4,
                children: <Widget>[
                  _operationButton(
                      Text('AC',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                              color: currentColor)), () {
                    setState(() {
                      willEnd = false;
                      controller.text = "";
                      operation = 0;
                    });
                  }),
                  /*_operationButton(
                      Text('+',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                              color: Colors.black)), () {
                    if (operation == 1) {
                      operation = 0;
                    } else {
                      operation = 1;
                      willEnd = false;
                    }
                  }),*/
                  InkResponse(
                    onTap: () {
                      setState(() {
                        if (operation == 1) {
                          operation = 0;
                        } else {
                          operation = 1;
                          willEnd = false;
                        }
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: operation == 1 ? Colors.blue : Colors.white),
                      child: Center(
                        child: Text('+',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                                color: Colors.black)),
                      ),
                    ),
                  ),
                  InkResponse(
                    onTap: () {
                      setState(() {
                        if (operation == 2) {
                          operation = 0;
                        } else {
                          operation = 2;
                          if (controller.text.length != 0) {
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
                          }
                        }
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: operation == 2 ? Colors.red : Colors.white),
                      child: Center(
                        child: Text('-',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                                color: Colors.black)),
                      ),
                    ),
                  ),
                  /*_operationButton(
                      Text('-',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                              color: Colors.black)), () {
                    if (operation == 2) {
                      operation = 0;
                    } else {
                      operation = 2;
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
                    }
                  }),*/
                  _operationButton(
                      Icon(Icons.backspace, color: currentColor), _backspace),
                  _numberButton(7),
                  _numberButton(8),
                  _numberButton(9),
                  _numberButton(000),
                  _numberButton(4),
                  _numberButton(5),
                  _numberButton(6),
                  _numberButton(00),
                  _numberButton(1),
                  _numberButton(2),
                  _numberButton(3),
                  _numberButton(0),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: MaterialButton(
                minWidth: width / 1.2,
                child: Text(willEnd ? "SEND TO THE SHADOW REALM" : "=",
                    style: TextStyle(
                        fontWeight:
                            willEnd ? FontWeight.normal : FontWeight.bold,
                        fontSize: willEnd ? 17 : 24,
                        color: willEnd ? Colors.black : Colors.orange)),
                textColor: Colors.black,
                color: willEnd ? Colors.purple[500] : Colors.white,
                onPressed: _calculate,
              ),
            ),
            SizedBox(
              height: height / 50,
            ),
          ],
        ),
      ),
    );
  }
}
