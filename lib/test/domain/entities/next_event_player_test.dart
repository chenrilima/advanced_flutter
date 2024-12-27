import 'package:flutter_test/flutter_test.dart';

class NextEventPlayer {
  final String id;
  final String name;
  late final String initials;
  final bool isConfirmed;

  NextEventPlayer({
    required this.id,
    required this.name,
    required this.isConfirmed,
  }) {
    initials = _getInitials();
  }
  String _getInitials() {
    final names = name.split(' ');
    final firstChar = names.first[0];
    final lastChar = names.last[0];
    return '$firstChar$lastChar';
  }
}

void main() {
  String initialsOf(String name) => NextEventPlayer(
        id: '',
        name: name,
        isConfirmed: true,
      ).initials;
  test('should return the first letter of the first and last names', () async {
    expect(initialsOf('Carlos Henrique'), 'CH');
    expect(initialsOf('Mayara Gomes da Silva'), 'MS');
    expect(initialsOf('Julia Gabriella Lima Dias'), 'JD');
  });
}
