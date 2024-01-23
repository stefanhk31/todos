// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:test/test.dart';
import 'package:todos_data_source/src/models/todo.dart';

void main() {
  group('Todo', () {
    test('supports value equality', () {
      final instanceA = Todo(title: 'title');
      final instanceB = Todo(title: 'title');
      expect(instanceA, equals(instanceB));
    });

    group('copyWith', () {
      late Todo todo;
      setUp(() {
        todo = Todo(title: 'title');
      });
      test('updates id', () {
        const id = '1';
        final result = todo.copyWith(id: id);
        expect(result.id, equals(id));
      });
      test('updates title', () {
        const newTitle = 'new';
        final result = todo.copyWith(title: newTitle);
        expect(result.title, equals(newTitle));
      });
      test('updates description', () {
        const newDesc = 'desc';
        final result = todo.copyWith(description: newDesc);
        expect(result.description, equals(newDesc));
      });
      test('updates isCompleted', () {
        final result = todo.copyWith(isCompleted: true);
        expect(result.isCompleted, isTrue);
      });
    });

    group('json serialization', () {
      late Todo todo;
      setUp(() {
        todo = Todo(title: 'title', id: '123');
      });
      test('can serialize', () {
        final result = todo.toJson();
        expect(result, equals(jsonDecode(_rawJson)));
      });

      test('can de-serialize', () {
        final json = jsonDecode(_rawJson) as Map<String, dynamic>;
        final result = Todo.fromJson(json);
        expect(result, equals(todo));
      });
    });
  });
}

const _rawJson = '''
{
    "id": "123",
    "title": "title",
    "description": "",
    "isCompleted": false
  }
''';
