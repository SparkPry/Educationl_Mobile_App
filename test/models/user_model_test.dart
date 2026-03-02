import 'package:education_app/models/user_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('UserModel Tests', () {
    test('UserModel should be created with correct properties', () {
      // Arrange
      const name = 'John Doe';
      const email = 'john@example.com';
      const avatar = 'https://example.com/avatar.jpg';

      // Act
      final user = UserModel(
        name: name,
        email: email,
        avatar: avatar,
      );

      // Assert
      expect(user.name, equals(name));
      expect(user.email, equals(email));
      expect(user.avatar, equals(avatar));
    });

    test('UserModel should handle empty strings', () {
      // Arrange
      const name = '';
      const email = '';
      const avatar = '';

      // Act
      final user = UserModel(
        name: name,
        email: email,
        avatar: avatar,
      );

      // Assert
      expect(user.name, isEmpty);
      expect(user.email, isEmpty);
      expect(user.avatar, isEmpty);
    });

    test('UserModel with valid email format', () {
      // Arrange
      const validEmail = 'user@domain.com';

      // Act & Assert
      final user = UserModel(
        name: 'Test User',
        email: validEmail,
        avatar: 'avatar.jpg',
      );
      expect(user.email, contains('@'));
    });

    test('Multiple UserModel instances should be independent', () {
      // Arrange
      final user1 = UserModel(
        name: 'User One',
        email: 'user1@example.com',
        avatar: 'avatar1.jpg',
      );
      final user2 = UserModel(
        name: 'User Two',
        email: 'user2@example.com',
        avatar: 'avatar2.jpg',
      );

      // Act & Assert
      expect(user1.name, isNot(equals(user2.name)));
      expect(user1.email, isNot(equals(user2.email)));
      expect(user1.avatar, isNot(equals(user2.avatar)));
    });
  });
}
