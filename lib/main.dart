import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KenCode Flutter Practice',
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'KenCode Flutter Practice'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _controller = TextEditingController();
  List<String> todos = [];
  void addTodo() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      todos.add(text);
      _controller.clear();
    });
  }

  Widget buildInputArea() {
    return Column(
      children: [
        TextField(
          controller: _controller,
          decoration: const InputDecoration(
            labelText: "TODOを入力",
            border: UnderlineInputBorder(),
          ),
        ),
        const SizedBox(height: 10),
        ElevatedButton(onPressed: addTodo, child: const Text("追加")),
      ]
    );
  }

  Widget buildTodoList() {
    return ListView.builder(
      itemCount: todos.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(todos[index]),
          trailing: IconButton(icon: const Icon(Icons.delete),
            onPressed: () {
              setState(() {
                todos.removeAt(index);
              });
            },
          ),
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Padding(padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            buildInputArea(),
            const SizedBox(height: 20),
            Expanded(child: buildTodoList()),
          ],
        )
      )
      
    );
  }
}
