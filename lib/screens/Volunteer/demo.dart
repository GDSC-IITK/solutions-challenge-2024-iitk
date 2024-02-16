import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  int _newIndex = 0;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(
      length: 3,
      vsync: this,
    );
  }

  _back() {
    if (_tabController!.index > 0) {
      _newIndex = _tabController!.index - 1;

      setState(() {});

      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        _tabController!.animateTo(_newIndex);
      });
    }
  }

  _next() {
    if (_tabController!.index < _tabController!.length - 1) {
      _newIndex = _tabController!.index + 1;

      setState(() {});

      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        _tabController!.animateTo(_newIndex);
      });
    }
  }

  Widget _tab(int index) {
    var value = "Page $index:   ${_newIndex + 1} / ${_tabController!.length}";
    print(value);

    return Row(
      children: [
        TextButton(
          onPressed: _back,
          child: const Text("Back"),
        ),
        Text(
          value,
          style: const TextStyle(),
        ),
        TextButton(
          onPressed: _next,
          child: const Text("Next"),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            _tab(1),
            _tab(2),
            _tab(3),
          ],
        ));
  }
}
