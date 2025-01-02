class NextEventPlayer {
  final String id;
  final String name;
  final String initials;
  final bool isConfirmed;
  final DateTime date;

  NextEventPlayer._(
      {required this.id,
      required this.name,
      required this.initials,
      required this.isConfirmed,
      required this.date});

  factory NextEventPlayer({
    required String id,
    required String name,
    required bool isConfirmed,
    required DateTime confirmationDate,
  }) =>
      NextEventPlayer._(
        id: id,
        name: name,
        isConfirmed: isConfirmed,
        initials: _getInitials(name),
        date: DateTime.now(),
      );

  static String _getInitials(String name) {
    final names = name.toUpperCase().trim().split(' ');
    final firstChar = names.first.split('').firstOrNull ?? '-';
    final lastChar =
        names.last.split('').elementAtOrNull(names.length == 1 ? 1 : 0) ?? '';
    return '$firstChar$lastChar';
  }
}
