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
    final names = name.toUpperCase().trim().split(' ');
    final firstChar = names.first.split('').firstOrNull ?? '-';
    final lastChar =
        names.last.split('').elementAtOrNull(names.length == 1 ? 1 : 0) ?? '';
    return '$firstChar$lastChar';
  }
}
