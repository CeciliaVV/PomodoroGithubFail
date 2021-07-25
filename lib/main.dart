import 'dart:async';
//esto es un comentario fail
import 'package:flutter/material.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
//import 'package:step_progress_indicator/step_progress_indicator.dart';
//import 'package:progress_indicator/progress_indicator.dart';
import 'package:percent_indicator/percent_indicator.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pomodoro',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Timer _timer;

  int minutosPom = 2;
  int segundosPom = 0;
  int minutosDes = 1;
  int segundosDes = 0;
  int min_25 = 120;
  int min_5 = 60;
  int _start = 120;

  int initial_time = 120;

  int paused = 1;
  int reset_5 = 0;
  int reset_25 = 0;
  int reset = 0;

  int valor;
  int temporal;
  int bandera = 0;
  int pomodoros_completos = 0;
  String minutesStr;
  String secondsStr;

  String formato(int seconds) {
    seconds = (seconds % 3600).truncate();
    int minutes = (seconds / 60).truncate();

    minutesStr = (minutes).toString().padLeft(2, '0');
    secondsStr = (seconds % 60).toString().padLeft(2, '0');

    if (seconds < 1 && bandera == 1) {
      pomodoros_completos++;
      return "Pomodoro completed";
    }

    return "$minutesStr:$secondsStr";
  }

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(oneSec, (timer) {
      setState(() {
        if (_start < 1 && bandera == 0) {
          _start = min_5;
          reset_5 = 0;
          initial_time = min_5;
          bandera++;
        } else {
          if (_start < 1 && bandera == 1) {
            paused = 1;
            _start = min_25;
            initial_time = min_25;
            bandera = 0;
          }
          if (paused == 0) {
            _start = _start - 1;
          }
          if (reset_25 == 1) {
            _start = min_25;
            reset_25 = 0;
            initial_time = min_25;
          }
          if (reset_5 == 1) {
            _start = min_5;
            reset_5 = 0;
            initial_time = min_5;
          }
          if (reset == 1) {
            _start = min_25;
            reset = 0;
            initial_time = min_25;
            paused = 0;
          }
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  void initState() {
    startTimer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Container(
              constraints: BoxConstraints.expand(),
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Colors.greenAccent, Colors.teal],
                      begin: FractionalOffset(0.5, 1))),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: 20),
                    Text(
                      "$pomodoros_completos Pomodoros Completos",
                      textAlign: TextAlign.right,
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: "Calibri",
                          fontWeight: FontWeight.w500,
                          fontSize: 30),
                    ),
                    SizedBox(height: 40),
                    /*Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          CircularStepProgressIndicator(
                            child: Text(
                              formatHHMMSS(_start),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: "Russo one",
                                  fontWeight: FontWeight.w500,
                                  fontSize: 50),
                            ),
                            totalSteps: 20,
                            currentStep: 1,
                            stepSize: 20,
                            selectedColor: Colors.red,
                            unselectedColor: Colors.purple[400],
                            padding: 3.1416 / 80,
                            width: 200,
                            height: 200,
                            startingAngle: -3.1416 * 2 / 3,
                            arcSize: 3.1416 * 2 / 3 * 2,
                            gradientColor: LinearGradient(
                              colors: [Colors.red, Colors.purple[400]],
                            ),
                          ),
                        ]),*/
                    /*Text(
                      formatHHMMSS(_start),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: "Russo one",
                          fontWeight: FontWeight.w500,
                          fontSize: 50),
                    ),*/
                    /*new CircularPercentIndicator(
                      radius: 330.0,
                      lineWidth: 20.0,
                      reverse: true,
                      percent: _start / initial_time,
                      center: new Text(
                        formato(_start),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: "Arial",
                            fontWeight: FontWeight.w500,
                            fontSize: 50),
                      ),
                      backgroundColor: Colors.black,
                      progressColor: Colors.greenAccent,
                    ),*/
                    LiquidCustomProgressIndicator(
                      direction: Axis.vertical,
                      shapePath: _buildHeartPath(),
                      center: Text(
                        formato(_start),
                        style: TextStyle(
                          fontSize: 40.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.tealAccent[400],
                        ),
                      ),
                      valueColor: AlwaysStoppedAnimation(Colors.black),
                      value: _start / initial_time,
                      backgroundColor: Colors.white,
                    ),
                    Spacer(),
                    //Expanded(flex: 10, child: center_widget(paused)),
                    Spacer(),
                    SizedBox(height: 5),
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Expanded(
                            flex: 10,
                            child: button("Inicio", reset, 140, 60, 25),
                          ),
                          Expanded(
                            flex: 10,
                            child: button("Pausa", paused, 140, 60, 25),
                          )
                        ]),
                    SizedBox(height: 40),
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            "Tiempo pomodoro: ",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: "Russo one",
                              fontWeight: FontWeight.w400,
                              fontSize: 20,
                            ),
                          ),
                          SizedBox(width: 10),
                          Text(
                            "Tiempo de descanso:",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: "Russo one",
                              fontWeight: FontWeight.w400,
                              fontSize: 20,
                            ),
                          ),
                        ]),
                    SizedBox(height: 15),
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Expanded(
                            flex: 10,
                            child: button("$minutosPom Min $segundosPom Seg",
                                reset_25, 140, 60, 25),
                          ),
                          Expanded(
                            flex: 10,
                            child: button("$minutosDes Min $segundosDes Seg",
                                reset_5, 140, 60, 25),
                          )
                        ]),
                    Spacer(),
                  ],
                ),
              ))),
    );
  }

  Path _buildHeartPath() {
    double x = 1.3;
    return Path()
      ..moveTo(110 * x, 30 * x)
      ..cubicTo(110 * x, 24 * x, 100 * x, 0, 60 * x, 0)
      ..cubicTo(0, 0, 0, 75 * x, 0, 75 * x)
      ..cubicTo(0, 110 * x, 40 * x, 154 * x, 110 * x, 190 * x)
      ..cubicTo(180 * x, 154 * x, 220 * x, 110 * x, 220 * x, 75 * x)
      ..cubicTo(220 * x, 75 * x, 220 * x, 0, 160 * x, 0)
      ..cubicTo(130 * x, 0, 110 * x, 24 * x, 110 * x, 30 * x)
      ..close();
  }

  ingresaMinutos(BuildContext context) {
    paused = 1;
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Tiempo de Pomodoro"),
              content: SizedBox(
                  width: 100.0,
                  height: 60.0,
                  child: Center(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Minutos',
                        labelText: 'Tiempo de Pomodoro',
                        prefixIcon: Icon(Icons.alarm),
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      maxLength: 2,
                      onChanged: (valor) {
                        temporal = int.parse(valor);
                      },
                    ),
                  )),
              actions: [
                TextButton(
                  child: Text("Cancelar"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                TextButton(
                  child: Text("Aceptar"),
                  onPressed: () {
                    setState(() {
                      minutosPom = temporal;
                      _start = minutosPom * 60 + segundosPom;
                      min_25 = minutosPom * 60 + segundosPom;
                      initial_time = _start;
                    });
                    Navigator.pop(context);
                  },
                ),
              ],
            ));
  }

  ingresaSegundos(BuildContext context) {
    paused = 1;
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Tiempo de Pomodoro"),
              content: SizedBox(
                  width: 100.0,
                  height: 60.0,
                  child: Center(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Segundos',
                        labelText: 'Tiempo de Pomodoro',
                        prefixIcon: Icon(Icons.alarm),
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      maxLength: 2,
                      onChanged: (valor) {
                        temporal = int.parse(valor);
                      },
                    ),
                  )),
              actions: [
                TextButton(
                  child: Text("Cancelar"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                TextButton(
                  child: Text("Aceptar"),
                  onPressed: () {
                    setState(() {
                      segundosPom = temporal;
                      _start = minutosPom * 60 + segundosPom;
                      min_25 = minutosPom * 60 + segundosPom;
                      initial_time = _start;
                    });
                    Navigator.pop(context);
                  },
                ),
              ],
            ));
  }

  ingresaMinutosDes(BuildContext context) {
    paused = 1;
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Tiempo de Descanso"),
              content: SizedBox(
                  width: 100.0,
                  height: 60.0,
                  child: Center(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Minutos',
                        labelText: 'Tiempo de Descanso',
                        prefixIcon: Icon(Icons.pan_tool),
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      maxLength: 2,
                      onChanged: (valor) {
                        temporal = int.parse(valor);
                      },
                    ),
                  )),
              actions: [
                TextButton(
                  child: Text("Cancelar"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                TextButton(
                  child: Text("Aceptar"),
                  onPressed: () {
                    setState(() {
                      minutosDes = temporal;
                      _start = minutosDes * 60 + segundosDes;
                      min_5 = minutosDes * 60 + segundosDes;
                      initial_time = _start;
                    });
                    Navigator.pop(context);
                  },
                )
              ],
            ));
  }

  ingresaSegundosDes(BuildContext context) {
    paused = 1;
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Tiempo de Pomodoro"),
              content: SizedBox(
                  width: 100.0,
                  height: 60.0,
                  child: Center(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Segundos',
                        labelText: 'Tiempo de Pomodoro',
                        prefixIcon: Icon(Icons.alarm),
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      maxLength: 2,
                      onChanged: (valor) {
                        temporal = int.parse(valor);
                      },
                    ),
                  )),
              actions: [
                TextButton(
                  child: Text("Cancelar"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                TextButton(
                  child: Text("Aceptar"),
                  onPressed: () {
                    setState(() {
                      segundosDes = temporal;
                      min_5 = segundosDes;
                    });
                    Navigator.pop(context);
                  },
                ),
              ],
            ));
  }

  Widget button(String text, int status, double button_width,
      double button_height, double radius) {
    if (status == 0)
      return unpressed_button(text, button_width, button_height, radius);
    else
      return pressed_button(text, button_width, button_height, radius);
  }

  Widget unpressed_button(
      String text, double button_width, double button_height, double radius) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: button_width,
          height: button_height,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(radius)),
              color: Colors.teal[700],
              boxShadow: [
                BoxShadow(
                  spreadRadius: -2,
                  color: Colors.white,
                  offset: Offset(3, 3),
                  blurRadius: 7,
                )
              ]),
        ),
        Container(
          width: button_width,
          height: button_height,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(radius)),
              color: Colors.teal[700],
              boxShadow: [
                BoxShadow(
                  spreadRadius: -2,
                  color: Colors.white,
                  offset: Offset(3, 3),
                  blurRadius: 7,
                )
              ]),
        ),
        MaterialButton(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          child: Container(
            width: button_width,
            height: button_height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(radius)),
            ),
            child: Container(
                alignment: Alignment.center,
                child: FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Text(
                    text,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: "Russo one",
                      fontWeight: FontWeight.w400,
                      fontSize: 20,
                    ),
                  ),
                )),
          ),
          onPressed: () {
            setState(() {
              if (text == "Pausa") {
                if (paused == 1)
                  paused = 0;
                else
                  paused = 1;
              }
              if (text == "$minutosPom Min $segundosPom Seg") {
                print("hola");
                ingresaMinutos(context);
                ingresaSegundos(context);

                reset_25 = 1;
              } else if (text == "$minutosDes Min $segundosDes Seg") {
                ingresaMinutosDes(context);
                ingresaSegundosDes(context);
                reset_5 = 1;
              }
              if (text == "Inicio") {
                reset = 1;
              }
            });
          },
        )
      ],
    );
  }

  Widget pressed_button(
      String text, double button_width, double button_height, double radius) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: button_width,
          height: button_height,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(radius)),
              color: Colors.teal[700],
              boxShadow: [
                BoxShadow(
                  spreadRadius: -12,
                  color: Colors.white,
                  offset: Offset(2, 2),
                  blurRadius: 7,
                )
              ]),
        ),
        Container(
          width: button_width,
          height: button_height,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(radius)),
              color: Colors.teal[700],
              boxShadow: [
                BoxShadow(
                  spreadRadius: -2,
                  color: Colors.white,
                  offset: Offset(-4, -4),
                  blurRadius: 7,
                )
              ]),
        ),
        MaterialButton(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          child: Container(
            width: button_width,
            height: button_height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(radius)),
            ),
            child: Container(
                alignment: Alignment.center,
                child: FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Text(
                    text,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: "Russo one",
                      fontWeight: FontWeight.w400,
                      fontSize: 20,
                    ),
                  ),
                )),
          ),
          onPressed: () {
            setState(() {
              if (text == "Pausa") {
                if (paused == 1)
                  paused = 0;
                else
                  paused = 1;
              }
            });
          },
        )
      ],
    );
  }
}
