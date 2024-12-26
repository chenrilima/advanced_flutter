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
    return '${names[0][0]}${names[1][0]}';
  }
}

void main() {
  test('should return the first letter of the first and last names', () async {
    final player = NextEventPlayer(
      id: '',
      name: 'Carlos Henrique',
      isConfirmed: true,
    );
    expect(player.getInitials(), 'CH');

    final player2 = NextEventPlayer(
      id: '',
      name: 'Mayara Silva',
      isConfirmed: true,
    );
    expect(player2.getInitials(), 'MS');
  });
}
