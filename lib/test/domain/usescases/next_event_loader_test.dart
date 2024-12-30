import 'dart:math';

import 'package:flutter_test/flutter_test.dart';

class NextEventLoader {
  final LoadNextEventRepository repo;

  NextEventLoader({required this.repo});

  Future<void> call({required String groupId}) async {
    await repo.loadNextEvent(groupId: groupId);
  }
}

abstract class LoadNextEventRepository {
  Future<void> loadNextEvent({required String groupId});
}

class LoadNextEvenMockRepository implements LoadNextEventRepository {
  String? groupId;
  var callsCount = 0;

  @override
  Future<void> loadNextEvent({required String groupId}) async {
    this.groupId = groupId;
    callsCount++;
  }
}

void main() {
  test('should load event data from a repository', () async {
    final groupId = Random().nextInt(50000).toString();
    final repo = LoadNextEvenMockRepository();
    final sut = NextEventLoader(repo: repo);
    await sut(groupId: groupId);
    expect(repo.groupId, groupId);
    expect(repo.callsCount, 1);
  });
}
