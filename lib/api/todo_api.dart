import '../models/todo.dart';
import 'api_client.dart';

Future<List<Todo>> fetchTodos() async {
  final response = await dio.get("/todos");

  final List list = response.data;
  return list.map((e) => Todo.fromJson(e)).toList();
}

Future<void> createTodo(String title) async {
  await dio.post(
    "/todos",
    data: {
      "title": title,
    },
  );
}