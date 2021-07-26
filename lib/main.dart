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
  int temporalMin;
  int temporalSeg;
  int bandera = 0;
  String minutesStr;
  String secondsStr;

  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final formKey = new GlobalKey<FormState>();

  String formato(int seconds) {
    seconds = (seconds % 3600).truncate();
    int minutes = (seconds / 60).truncate();

    minutesStr = (minutes).toString().padLeft(2, '0');
    secondsStr = (seconds % 60).toString().padLeft(2, '0');

    if (seconds < 1 && bandera == 1) {
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
      resizeToAvoidBottomInset: false,
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
                      "Pomodoro",
                      textAlign: TextAlign.right,
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: "Calibri",
                          fontWeight: FontWeight.w500,
                          fontSize: 50),
                    ),
                    SizedBox(height: 40),
                    new CircularPercentIndicator(
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
                    ),
                    Spacer(),
                    Spacer(),
                    SizedBox(height: 5),
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Expanded(
                            flex: 10,
                            child: button("Comenzar", reset, 140, 60, 25),
                          ),
                          Expanded(
                            flex: 10,
                            child: button("Pausa", paused, 140, 60, 25),
                          )
                        ]),
                    SizedBox(height: 20),
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
                          SizedBox(width: 30),
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

  ingresaTiempo(BuildContext context) {
    paused = 1;
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Tiempo de Pomodoro"),
              content: SizedBox(
                  width: 100.0,
                  height: 200.0,
                  child: Center(
                      child: Form(
                          key: formKey,
                          child: SingleChildScrollView(
                            child: Column(
                              children: <Widget>[
                                TextFormField(
                                  keyboardType: TextInputType.number,
                                  validator: (valor) {
                                    if (valor.isEmpty)
                                      return 'Debe ingresar datos';
                                    if (int.parse(valor) > 59 ||
                                        int.parse(valor) < 0)
                                      return 'Número no válido';

                                    return null;
                                  },
                                  onSaved: (valor) =>
                                      temporalMin = int.parse(valor),
                                  decoration:
                                      InputDecoration(labelText: 'Minutos'),
                                ),
                                SizedBox(height: 15.0),
                                TextFormField(
                                  keyboardType: TextInputType.number,
                                  validator: (valor) {
                                    if (valor.isEmpty)
                                      return 'Debe ingresar datos';
                                    if (int.parse(valor) > 59 ||
                                        int.parse(valor) < 0)
                                      return 'Número no válido';

                                    return null;
                                  },
                                  onSaved: (valor) =>
                                      temporalSeg = int.parse(valor),
                                  decoration:
                                      InputDecoration(labelText: 'Segundos'),
                                ),
                                SizedBox(height: 50.0),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      TextButton(
                                        child: Text("Cancelar"),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                      ),
                                      SizedBox(width: 20.0),
                                      TextButton(
                                        child: Text("Aceptar"),
                                        onPressed: () {
                                          if (formKey.currentState.validate()) {
                                            formKey.currentState.save();
                                            setState(() {
                                              minutosPom = temporalMin;
                                              segundosPom = temporalSeg;
                                              _start =
                                                  minutosPom * 60 + segundosPom;
                                              min_25 =
                                                  minutosPom * 60 + segundosPom;
                                              initial_time = _start;
                                            });
                                            Navigator.pop(context);
                                          }
                                        },
                                      ),
                                    ])
                              ],
                            ),
                          )))),
            ));
  }

  ingresaTiempoDescanso(BuildContext context) {
    paused = 1;
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Tiempo de Descanso"),
              content: SizedBox(
                  width: 100.0,
                  height: 200.0,
                  child: Center(
                      child: Form(
                          key: formKey,
                          child: SingleChildScrollView(
                            child: Column(
                              children: <Widget>[
                                TextFormField(
                                  keyboardType: TextInputType.number,
                                  validator: (valor) {
                                    if (valor.isEmpty)
                                      return 'Debe ingresar datos';
                                    if (int.parse(valor) > 59 ||
                                        int.parse(valor) < 0)
                                      return 'Número no válido';

                                    return null;
                                  },
                                  onSaved: (valor) =>
                                      temporalMin = int.parse(valor),
                                  decoration:
                                      InputDecoration(labelText: 'Minutos'),
                                ),
                                SizedBox(height: 15.0),
                                TextFormField(
                                  keyboardType: TextInputType.number,
                                  validator: (valor) {
                                    if (valor.isEmpty)
                                      return 'Debe ingresar datos';
                                    if (int.parse(valor) > 59 ||
                                        int.parse(valor) < 0)
                                      return 'Número no válido';

                                    return null;
                                  },
                                  onSaved: (valor) =>
                                      temporalSeg = int.parse(valor),
                                  decoration:
                                      InputDecoration(labelText: 'Segundos'),
                                ),
                                SizedBox(height: 50.0),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      TextButton(
                                        child: Text("Cancelar"),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                      ),
                                      SizedBox(width: 20.0),
                                      TextButton(
                                        child: Text("Aceptar"),
                                        onPressed: () {
                                          if (formKey.currentState.validate()) {
                                            formKey.currentState.save();
                                            setState(() {
                                              minutosDes = temporalMin;
                                              segundosDes = temporalSeg;
                                              min_5 =
                                                  minutosDes * 60 + segundosDes;
                                              _start = min_5;
                                              initial_time = min_5;
                                            });
                                            Navigator.pop(context);
                                          }
                                        },
                                      ),
                                    ])
                              ],
                            ),
                          )))),
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
                ingresaTiempo(context);
                reset_25 = 1;
              } else if (text == "$minutosDes Min $segundosDes Seg") {
                ingresaTiempoDescanso(context);
                reset_5 = 1;
              }
              if (text == "Comenzar") {
                _start = min_25;
                initial_time = min_25;
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
