import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool darkMode = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: darkMode ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        brightness: Brightness.light,
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
      ),
      home: CalculatorPage(
        darkMode: darkMode,
        toggleTheme: () {
          setState(() {
            darkMode = !darkMode;
          });
        },
      ),
    );
  }
}

class CalculatorPage extends StatefulWidget {
  final bool darkMode;
  final VoidCallback toggleTheme;

  const CalculatorPage({
    super.key,
    required this.darkMode,
    required this.toggleTheme,
  });

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  String display = '0';
  String history = '';

  double firstNum = 0;
  String op = '';
  bool newNumber = false;

  void pressNumber(String value) {
    setState(() {
      if (newNumber) {
        display = value == '.' ? '0.' : value;
        newNumber = false;
      } else if (value == '.') {
        if (!display.contains('.')) {
          display += '.';
        }
      } else if (display == '0') {
        display = value;
      } else {
        display += value;
      }
    });
  }

  void pressOperator(String value) {
    setState(() {
      firstNum = double.parse(display);
      op = value;
      history = '$display $op';
      newNumber = true;
    });
  }

  void pressEquals() {
    if (op == '') return;

    double secondNum = double.parse(display);
    double answer = 0;

    if (op == '+') {
      answer = firstNum + secondNum;
    } else if (op == '-') {
      answer = firstNum - secondNum;
    } else if (op == '×') {
      answer = firstNum * secondNum;
    } else if (op == '÷') {
      if (secondNum == 0) {
        setState(() {
          history = '$firstNum $op $secondNum =';
          display = 'Error';
          op = '';
          newNumber = true;
        });
        return;
      }
      answer = firstNum / secondNum;
    }

    setState(() {
      history = '${formatNum(firstNum)} $op ${formatNum(secondNum)} =';
      display = formatNum(answer);
      op = '';
      newNumber = true;
    });
  }

  void pressClear() {
    setState(() {
      display = '0';
      history = '';
      firstNum = 0;
      op = '';
      newNumber = false;
    });
  }

  void pressDelete() {
    setState(() {
      if (newNumber || display == 'Error') {
        display = '0';
        newNumber = false;
      } else if (display.length > 1) {
        display = display.substring(0, display.length - 1);
      } else {
        display = '0';
      }
    });
  }

  String formatNum(double num) {
    if (num == num.toInt()) {
      return num.toInt().toString();
    }
    return num.toString();
  }

  Widget calcButton(
    String text, {
    required VoidCallback onPressed,
    Color? color,
    Color? textColor,
  }) {
    return SizedBox(
      width: 75,
      height: 75,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: textColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: const TextStyle(fontSize: 28),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Color operatorColor = Colors.blue;
    Color specialColor = Colors.red;
    Color numberColor = Theme.of(context).colorScheme.surfaceContainerHighest;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gradient Calculator'),
        actions: [
          IconButton(
            onPressed: widget.toggleTheme,
            icon: Icon(
              widget.darkMode ? Icons.light_mode : Icons.dark_mode,
            ),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: widget.darkMode
            ? const LinearGradient(
              colors: [
                Color.fromARGB(255, 39, 7, 90),
                Color.fromARGB(255, 42, 83, 153),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              )
            : const LinearGradient(
            colors: [
              Color.fromARGB(255, 247, 190, 242),
              Color.fromARGB(255, 170, 203, 255),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
  ),
  child: Padding(
    padding: const EdgeInsets.all(16),
    child: Column(
      children: [
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                alignment: Alignment.bottomRight,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      history,
                      style: const TextStyle(fontSize: 24),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      display,
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                calcButton(
                  'C',
                  onPressed: pressClear,
                  color: specialColor,
                  textColor: Colors.white,
                ),
                const SizedBox(width: 10),
                calcButton(
                  '<',
                  onPressed: pressDelete,
                  color: const Color.fromARGB(255, 216, 127, 43),
                  textColor: Colors.white,
                ),
                const SizedBox(width: 10),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                calcButton('7', onPressed: () => pressNumber('7'), color: numberColor),
                const SizedBox(width: 10),

                calcButton('8', onPressed: () => pressNumber('8'), color: numberColor),
                const SizedBox(width: 10),

                calcButton('9', onPressed: () => pressNumber('9'), color: numberColor),
                const SizedBox(width: 10),

                calcButton(
                  '-',
                  onPressed: () => pressOperator('-'),
                  color: operatorColor,
                  textColor: Colors.white,
                ),
                 const SizedBox(width: 10),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                calcButton('4', onPressed: () => pressNumber('4'), color: numberColor),
                const SizedBox(width: 10),
                calcButton('5', onPressed: () => pressNumber('5'), color: numberColor),
                const SizedBox(width: 10),
                calcButton('6', onPressed: () => pressNumber('6'), color: numberColor),
                const SizedBox(width: 10),
                calcButton(
                  '+',
                  onPressed: () => pressOperator('+'),
                  color: operatorColor,
                  textColor: Colors.white,
                ),
                const SizedBox(width: 10),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                calcButton('1', onPressed: () => pressNumber('1'), color: numberColor),
                const SizedBox(width: 10),
                calcButton('2', onPressed: () => pressNumber('2'), color: numberColor),
                const SizedBox(width: 10),
                calcButton('3', onPressed: () => pressNumber('3'), color: numberColor),
                const SizedBox(width: 10),
                calcButton(
                  '÷',
                  onPressed: () => pressOperator('÷'),
                  color: operatorColor,
                  textColor: Colors.white,
                ),
                const SizedBox(width: 10),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                calcButton('0', onPressed: () => pressNumber('0'), color: numberColor),
                const SizedBox(width: 10),
                calcButton('.', onPressed: () => pressNumber('.'), color: numberColor),
                const SizedBox(width: 10),
                calcButton(
                  '=',
                  onPressed: pressEquals,
                  color: Colors.green,
                  textColor: Colors.white,
                ),
                const SizedBox(width: 10),
                calcButton(
                  '×',
                  onPressed: () => pressOperator('×'),
                  color: operatorColor,
                  textColor: Colors.white,
                ),
                const SizedBox(width: 10),
              ],
            ),
          ],
        ),
      ),
      ),
    );
  }
}