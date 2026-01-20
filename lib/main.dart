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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("追加しました")),
      );
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
            labelText: "TODO",
            hintText: "やることを入力...",
            border: UnderlineInputBorder(),
          ),
        ),
        const SizedBox(height: 10),
        ElevatedButton(onPressed: addTodo, child: const Text("追加")),
      ]
    );
  }

  Widget buildTodoList() {
    return RefreshIndicator(
      onRefresh: loadTodos,
      child: ListView.builder(
        itemCount: todos.length,
        itemBuilder: (context, index) {
          final todo = todos[index];
          return ListTile(
            title: Text(
              todo.title,
              style: TextStyle(
                decoration: todo.completed
                ? TextDecoration.lineThrough
                : TextDecoration.none,
                color: todo.completed ? Colors.grey : Colors.black,
                fontStyle: todo.completed ? FontStyle.italic : FontStyle.normal,
              )  
            ),
            leading: Checkbox(
              value: todo.completed,
              onChanged: (value) async {
                if (value == null) return;

                await updateCompleted(todo.id, value);
                await loadTodos();
              }
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    showEditDialog(todo);
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () async {
                    await deleteTodo(todo.id);
                    await loadTodos();
                  }
                )
              ]
            )
          );
        }
      )
    );
  }

  Future<void> showEditDialog(Todo todo) async {
    final controller = TextEditingController(text: todo.title);

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("TODOを編集"),
        content: TextField(
          controller: controller,
          autofocus: true,
        ),
        actions: [
          TextButton(
            child: Text("キャンセル"),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: const Text("OK"),
            onPressed: () async {
              final text = controller.text.trim();
              if (text.isEmpty) return;

              await updateTitle(todo.id, text);
              await loadTodos();
              Navigator.pop(context);
            },
          )
        ]
      )
    );
  }

  List<Todo> todos = [];
  bool isLoading = false;

  Future<void> loadTodos() async {
    setState(() {
      isLoading = true;
    });
    // await Future.delayed(const Duration(milliseconds: 1500));
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
            Expanded(
              child: isLoading
              ? const Center(
                child: CircularProgressIndicator()
              )
              : buildTodoList(),
            ),
          ],
        )
      )
      
    );
  }
}
