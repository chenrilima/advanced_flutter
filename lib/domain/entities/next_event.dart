import 'package:advanced_flutter/domain/entities/next_event_player.dart';

class NextEvent {
  // usecase
  final String groupName;
  late final DateTime date;
  final List<NextEventPlayer> players;

  NextEvent(
      {required this.groupName, required this.date, required this.players});
}
