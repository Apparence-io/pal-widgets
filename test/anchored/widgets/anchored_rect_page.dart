import 'package:flutter/material.dart';
import 'package:pal_widgets/pal_widgets.dart';

class MyAppWithRectAnchored extends StatelessWidget {
  const MyAppWithRectAnchored({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HelperOrchestrator(
        child: MyHomePage(title: 'Flutter Demo Home Page'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  ButtonStyle get helperOutlineBtnStyle => OutlinedButton.styleFrom(
        primary: Colors.white,
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
        anchorKeyId: 'text1',
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
        negativText: const Text('cancel'),
        positivText: const Text('Ok, understood'),
        positivBtnStyle: helperOutlineBtnStyle,
        negativeBtnStyle: helperOutlineBtnStyle,
        onNegativTap: () => HelperOrchestrator.of(context).hideHelper(),
        onPositivTap: () => HelperOrchestrator.of(context).hideHelper(),
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
                key: HelperOrchestrator.of(context).generateKey('text1'),
                style: const TextStyle(color: Colors.blue, fontSize: 32),
              ),
              Text(
                'test widget helper',
                key: HelperOrchestrator.of(context).generateKey('text2'),
              ),
              const SizedBox(height: 21),
              OutlinedButton(
                onPressed: () {
                  HelperOrchestrator.of(context)
                      .showAnchoredHelper('text1', helper);
                },
                child: const Text('push me 2'),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _incrementCounter,
          tooltip: 'Increment',
          child: const Icon(Icons.add),
        ),
      );
}
