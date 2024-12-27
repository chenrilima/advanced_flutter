import 'package:advanced_flutter/domain/entities/next_event_player.dart';

import 'package:flutter_test/flutter_test.dart';

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

  test('should ignore extra whitespaces', () async {
    expect(initialsOf('Carlos Henrique '), 'CH');
    expect(initialsOf(' Carlos Henrique'), 'CH');
    expect(initialsOf('Carlos  Henrique'), 'CH');
    expect(initialsOf(' Carlos  Henrique '), 'CH');
    expect(initialsOf(' Carlos '), 'CA');
    expect(initialsOf('C'), 'C');
    expect(initialsOf(''), '-');
    expect(initialsOf(' '), '-');
  });
}
