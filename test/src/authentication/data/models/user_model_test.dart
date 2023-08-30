import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:tdd_bloc_tutorial/core/utils/typedef.dart';
import 'package:tdd_bloc_tutorial/src/authentication/data/models/user_model.dart';
import 'package:tdd_bloc_tutorial/src/authentication/domain/entities/user.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  const tModel = UserModel.empty();

  test('should be a subclass of [User] entity', () {
    // arrange
    // Act

    // Assert
    expect(tModel, isA<User>());
  });

  final tJson = fixture('user.json');
  final tMap = jsonDecode(tJson) as DataMap;

  group('fromMap', () {
    test('Should return a [UserModel] with the right data', () {
      // Arrange

      // Act
      final result = UserModel.fromMap(tMap);
      // Assert
      expect(result, equals(tModel));
    });
  });

  group('fromJson', () {
    test('Should return a [UserModel] with the right data', () {
      final result = UserModel.fromJson(tJson);

      expect(result, equals(tModel));
    });
  });

  group('toMap', () {
    test('Should return [Map] with the right data', () {
      final result = tModel.toMap();

      expect(result, equals(tMap));
    });
  });

  group('toJson', () {
    test('Should return a [Json] with the right data', () {
      final result = tModel.toJson();

      final tJson = jsonEncode({
        "id": "1",
        "createdAt": "_empty.createdAt",
        "name": "_empty.name",
        "avatar": "_empty.avatar"
      });

      expect(result, tJson);
    });
  });

  group('copyWith', () {
    test('Should return [UserModel] with different data', () {
      // Act
      final result = tModel.copyWith(name: 'Paul');
      // Assert
      expect(result.name, equals('Paul'));
    });
  });
}
