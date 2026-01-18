import 'package:flutter/material.dart';
import 'models/todo.dart';
import 'api/todo_api.dart';

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
  Future<void> addTodo() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    try {
      await createTodo(text);
      _controller.clear();
      await loadTodos();
    } catch (e) {
      print("create error: $e");
    }
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
          title: Text(todos[index].title),
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

  List<Todo> todos = [];
  bool isLoading = false;

  Future<void> loadTodos() async {
    setState(() {
      isLoading = true;
    });
    try {
      final result = await fetchTodos();
      setState(() {
        todos = result;
      });
    } catch (e) {
      print("API error: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    loadTodos();
  }
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
