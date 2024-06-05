import 'package:flutter/material.dart';
import 'package:pal_widgets/pal_widgets.dart';

class MyAppAnchoredNoBtn extends StatelessWidget {
  const MyAppAnchoredNoBtn({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HelperOrchestrator(
        child: MyHomePage2(title: 'Flutter Demo Home Page'),
      ),
    );
  }
}

class MyHomePage2 extends StatefulWidget {
  const MyHomePage2({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage2> createState() => _MyHomePage2State();
}

class _MyHomePage2State extends State<MyHomePage2> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  ButtonStyle get helperOutlineBtnStyle => OutlinedButton.styleFrom(
        padding: const EdgeInsets.all(12),
        textStyle: const TextStyle(
          color: Colors.white,
          fontSize: 18,
        ),
        side: const BorderSide(
          width: 1.0,
          style: BorderStyle.solid,
          color: Colors.white,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      );

  AnchoredHelper get helper => AnchoredHelper(
        title: const Text(
          'Title lorem pitume',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 32,
          ),
        ),
        description: const Text(
          'Lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 21,
          ),
        ),
        bgColor: Colors.blue,
        onTapAnchor: () => HelperOrchestrator.of(context).hideHelper(),
        rightBtnStyle: helperOutlineBtnStyle,
        leftBtnStyle: helperOutlineBtnStyle,
        widgetFactory: AnchoredRectHoleHelper.anchorFactory,
      );

  @override
  Widget build(BuildContext context) {
    return content;
  }

  Widget get content => Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'You have pushed the button this many times:',
              ),
              Text(
                '$_counter',
                style: const TextStyle(color: Colors.blue, fontSize: 32),
              ),
              const Text('test widget helper'),
              const SizedBox(height: 21),
              OutlinedButton(
                onPressed: () {
                  HelperOrchestrator.of(context) //
                      .showAnchoredHelper('text1', helper);
                },
                child: const Text('push me 2'),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          key: HelperOrchestrator.of(context).generateKey('text1'),
          onPressed: _incrementCounter,
          tooltip: 'Increment',
          child: const Icon(Icons.add),
        ),
      );
}
