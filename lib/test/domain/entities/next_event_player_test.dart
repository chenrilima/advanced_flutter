import 'package:flutter_test/flutter_test.dart';

class NextEventPlayer {
  final String id;
  final String name;
  final String initials;
  final bool isConfirmed;

  NextEventPlayer._({
    required this.id,
    required this.name,
    required this.initials,
    required this.isConfirmed,
  });

  factory NextEventPlayer({
    required String id,
    required String name,
    required bool isConfirmed,
  }) =>
      NextEventPlayer._(
        id: id,
        name: name,
        isConfirmed: isConfirmed,
        initials: _getInitials(name),
      );

  static String _getInitials(String name) {
    final names = name.toUpperCase().split(' ');
    final firstChar = names.first.split('').firstOrNull ?? '-';
    final lastChar =
        names.last.split('').elementAtOrNull(names.length == 1 ? 1 : 0) ?? '';
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

  test('should return the first letters of the first names', () async {
    expect(initialsOf('Carlos Henrique'), 'CH');
    expect(initialsOf('C'), 'C');
  });

  test('should return "-", when name is empty', () async {
    expect(initialsOf(''), '-');
  });

  test('should convert to uppercase', () async {
    expect(initialsOf('carlos henrique'), 'CH');
    expect(initialsOf('carlos henrique'), 'CH');
    expect(initialsOf('c'), 'C');
  });
}
