import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => CalcModel(),
      child: MyApp(),
    )
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Calculator Demo',
      home: Scaffold(body: MyCalc())
    );
  }
}

// keyboard of the calculator
final _keyboardList = ["7","8","9","/","4","5","6","x","1","2","3","-","AC","0","=","+"];

class MyCalc extends StatefulWidget {
  const MyCalc({ Key? key }) : super(key: key);

  @override
  _MyCalcState createState() => _MyCalcState();
}

class _MyCalcState extends State<MyCalc> {

  @override
  Widget build(BuildContext context) {
    final _calculator = Provider.of<CalcModel>(context);

    return Container(
      child: SafeArea(
        child: Column(
          children: <Widget>[
            Container(
              color: Colors.grey.shade200,
              alignment: Alignment.bottomRight,
              padding: const EdgeInsets.only( right: 30.0, bottom: 10),
              height: 200,
              child: Text(
                '${_calculator.value}',
                maxLines: 1,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 50,
                ),
              )
            ),
            Flexible(
              child: GridView.count(
                padding: const EdgeInsets.only(left: 10, right: 10),
                crossAxisCount: 4,
                childAspectRatio: 0.7,
                children: List.generate(_keyboardList.length, (index) {
                  return InkWell(
                    onTap: (){
                      _calculator._onKeyTapped('${_keyboardList[index]}');
                    },
                    child: Container(
                      alignment: Alignment.center,
                      child: Text(
                        '${_keyboardList[index]}',
                        style: TextStyle(
                          fontSize: 25,
                        )
                      )
                    )
                  );
                })
              )
            )
          ]),
      )
    );
  }
}

class CalcModel extends ChangeNotifier {
    String _current = "0";
    String _previous = "";
    String _operation = "";
    bool _isResult = false;
    String get value => _current;

  // Arithmetic
  _onKeyTapped(String text){
    switch (text){
      case "+":
      case "-":
      case "x":
      case "/":
        _isResult = false;
        _operation = text;
        break;
      case "0":
      case "1":
      case "2":
      case "3":
      case "4":
      case "5":
      case "6":
      case "7":
      case "8":
      case "9":
        if (_isResult) {
          _current = text;
          _previous = "";
          _operation = "";
          notifyListeners();
          break;
        }
        if (_operation.isNotEmpty && _previous.isEmpty) {
          _previous = _current;
          _current = "";
        }
        _current += text;
        if (_current.startsWith('0') && _current != '0'){
          _current = _current.substring(1);
        }
        notifyListeners();
        break;
      case "=":
        double val1 = _toDouble(_previous);
        double val2 = _toDouble(_current);
        switch (_operation) {
          case "+":
            _current = "${val1 + val2}";
            break;
          case "-":
            _current = "${val1 - val2}";
            break;
          case "x":
            _current = "${val1 * val2}";
            break;
          case "/":
            _current = "${val1 / val2}";
            break;   
        }
        if (_isInteger(_toDouble(_current))){
          _current = ("${_toDouble(_current).toInt()}");
        }
        _previous = "";
        _isResult = true;
        _operation = "";
        notifyListeners();
        break;
      case "AC":
        _current = "0";
        _previous = "";
        _isResult = false;
        _operation = "";
        notifyListeners();
        break;
    }
  }

  double _toDouble(String val){
    if (val.startsWith('-')) {
      String s = val.substring(1);
      return double.parse(s) * -1;
    } else {
      return double.parse(val);
    }
  }

  bool _isInteger(num val) => (val % 1) == 0;

}