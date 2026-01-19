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

Future<void> deleteTodo(int id) async {
  await dio.delete("/todos/$id");
}

Future<void> updateCompleted(int id, bool completed) async {
  await dio.put(
    "/todos/$id",
    data: {
      "completed": completed,
    }
  );
}

Future<void> updateTitle(int id, String title) async {
  await dio.put(
    "/todos/$id",
    data: {
      "title": title,
    }
  );
}