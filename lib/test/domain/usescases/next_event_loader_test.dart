import 'dart:math';

import 'package:advanced_flutter/domain/entities/next_event.dart';
import 'package:advanced_flutter/domain/entities/next_event_player.dart';
import 'package:advanced_flutter/domain/repositories/load_next_event_repo.dart';
import 'package:advanced_flutter/domain/usecases/next_event_loader.dart';
import 'package:flutter_test/flutter_test.dart';

class LoadNextEventSpyRepository implements LoadNextEventRepository {
  String? groupId;
  var callsCount = 0;
  NextEvent? output;
  Error? error;

  @override
  Future<NextEvent> loadNextEvent({required String groupId}) async {
    this.groupId = groupId;
    callsCount++;
    if (error != null) throw error!;
    return output!;
  }
}

void main() {
  late String groupId;
  late LoadNextEventSpyRepository repo;
  late NextEventLoader sut;

  setUp(() {
    // arrange
    groupId = Random().nextInt(50000).toString();
    repo = LoadNextEventSpyRepository();
    repo.output =
        NextEvent(groupName: 'any group name', date: DateTime.now(), players: [
      NextEventPlayer(
        id: 'any id 1',
        name: 'any name 1',
        isConfirmed: true,
        confirmationDate: DateTime.now(),
      ),
      NextEventPlayer(
        id: 'any id 2',
        name: 'any name 2',
        isConfirmed: false,
        confirmationDate: DateTime.now(),
      ),
    ]);
    sut = NextEventLoader(repo: repo);
  });

  test('should load event data from a repository', () async {
    await sut(groupId: groupId); // act
    expect(repo.groupId, groupId); // assert
    expect(repo.callsCount, 1);
  });

  test('should return event data on sucess', () async {
    final event = await sut(groupId: groupId);
    expect(event.groupName, repo.output?.groupName);
    expect(event.date, repo.output?.date);
    expect(event.players.length, 2);
    expect(event.players[0].id, repo.output?.players[0].id);
    expect(event.players[0].name, repo.output?.players[0].name);
    expect(event.players[0].isConfirmed, repo.output?.players[0].isConfirmed);
    expect(event.players[0].initials, isNotEmpty);
    expect(event.players[1].id, repo.output?.players[1].id);
    expect(event.players[1].name, repo.output?.players[1].name);
    expect(event.players[1].isConfirmed, repo.output?.players[1].isConfirmed);
    expect(event.players[1].initials, isNotEmpty);
  });
  test('should return event data on sucess', () async {
    final error = Error();
    repo.error = error;
    final future = sut(groupId: groupId);
    expect(future, throwsA(error));
  });
}
