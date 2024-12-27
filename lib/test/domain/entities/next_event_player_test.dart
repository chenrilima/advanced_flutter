import 'package:flutter_test/flutter_test.dart';

class NextEventPlayer {
  final String id;
  final String name;
  final bool isConfirmed;

  NextEventPlayer({
    required this.id,
    required this.name,
    required this.isConfirmed,
  });
  String getInitials() {
    final names = name.split(' ');
    final firstChar = names.first[0];
    final lastChar = names.last[0];
    return '$firstChar$lastChar';
  }
}

void main() {
  makeSut(String name) => NextEventPlayer(
        id: '',
        name: name,
        isConfirmed: true,
      );
  test('should return the first letter of the first and last names', () async {
    expect(makeSut('Carlos Henrique').getInitials(), 'CH');
    expect(makeSut('Mayara Gomes da Silva').getInitials(), 'MS');
    expect(makeSut('Julia Gabriella Lima Dias').getInitials(), 'JD');
  });
}
