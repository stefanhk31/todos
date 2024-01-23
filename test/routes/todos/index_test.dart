import 'dart:convert';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:in_memory_todos_data_source/in_memory_todos_data_source.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:todos_data_source/todos_data_source.dart';

import '../../../routes/todos/index.dart' as route;

class _MockRequestContext extends Mock implements RequestContext {}

class _MockTodoDataSource extends Mock implements InMemoryTodosDataSource {}

void main() {
  late InMemoryTodosDataSource inMemoryTodosDataSource;

  setUp(() {
    inMemoryTodosDataSource = _MockTodoDataSource();
  });

  group('GET /', () {
    test('responds with a 200', () async {
      final context = _MockRequestContext();
      final request = Request('GET', Uri.parse('http://127.0.0.1/'));
      when(() => context.request).thenReturn(request);
      when(() => context.read<TodosDataSource>())
          .thenReturn(inMemoryTodosDataSource);
      when(
        () => inMemoryTodosDataSource.readAll(),
      ).thenAnswer((_) => Future.value([Todo(title: 'title')]));
      final response = await route.onRequest(context);
      expect(response.statusCode, equals(HttpStatus.ok));
    });
  });

  group('POST /', () {
    test('responds with a 200 and a created todo', () async {
      final context = _MockRequestContext();
      final todo = Todo(title: 'title', id: '123');
      final body = jsonEncode(todo.toJson());
      final request = Request(
        'POST',
        Uri.parse('http://127.0.0.1/'),
        body: body,
      );
      when(() => context.request).thenReturn(request);
      when(() => context.read<TodosDataSource>())
          .thenReturn(inMemoryTodosDataSource);
      when(() => inMemoryTodosDataSource.create(todo))
          .thenAnswer((_) => Future.value(todo));
      final response = await route.onRequest(context);
      expect(response.statusCode, equals(HttpStatus.created));
      expect(response.body(), completion(equals(body)));
    });
  });
}
