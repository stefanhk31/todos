// ignore_for_file: prefer_const_constructors

import 'package:in_memory_todos_data_source/in_memory_todos_data_source.dart';
import 'package:test/test.dart';
import 'package:todos_data_source/todos_data_source.dart';

void main() {
  group('InMemoryTodosDataSource', () {
    test('can be instantiated', () {
      expect(InMemoryTodosDataSource(), isNotNull);
    });

    group('CRUD methods', () {
      late InMemoryTodosDataSource inMemoryTodosDataSource;

      setUp(() {
        inMemoryTodosDataSource = InMemoryTodosDataSource();
      });

      test('can create', () async {
        final todo = Todo(title: 'title');
        final result = await inMemoryTodosDataSource.create(todo);
        expect(result.title, equals(todo.title));
      });

      group('read', () {
        setUp(() async {
          await inMemoryTodosDataSource.create(Todo(title: '1'));
          await inMemoryTodosDataSource.create(Todo(title: '2'));
        });
        test('can read all', () async {
          final result = await inMemoryTodosDataSource.readAll();
          expect(result, isA<List<Todo>>());
          expect(result.length, equals(2));
        });

        test('can read', () async {
          final todos = await inMemoryTodosDataSource.readAll();
          final id = todos[0].id;
          final result = await inMemoryTodosDataSource.read(id!);
          expect(result, isNotNull);
          expect(result!.id, equals(id));
        });

        test('returns null if id is not found', () async {
          final result = await inMemoryTodosDataSource.read('not-in-store');
          expect(result, isNull);
        });
      });
      test('can update', () async {
        const newTitle = 'new';
        final todo = await inMemoryTodosDataSource.create(Todo(title: 'title'));
        final result = await inMemoryTodosDataSource.update(
          todo.id!,
          todo.copyWith(title: newTitle),
        );
        expect(result.title, equals(newTitle));
      });
      test('can delete', () async {
        final todo = await inMemoryTodosDataSource.create(Todo(title: 'title'));
        await inMemoryTodosDataSource.delete(todo.id!);
        expect(await inMemoryTodosDataSource.read(todo.id!), isNull);
      });
    });
  });
}
