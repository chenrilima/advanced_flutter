import 'package:advanced_flutter/domain/entities/domain_error.dart';
import 'package:advanced_flutter/infra/repositories/load_next_event_http_repo.dart';
import 'package:advanced_flutter/test/infra/api/clients/http_client_spy.dart';

import 'package:flutter_test/flutter_test.dart';

import 'package:advanced_flutter/test/helpers/fakes.dart';

void main() {
  late String groupId;
  late String url;
  late HttpClientSpy httpClient;
  late LoadNextEventHttpRepository sut;

  setUpAll(() {
    // setUpAll roda uma vez só, antes de todos os testes
    url = 'https://domain.com/api/groups/:groupId/next_event';
  });

  setUp(() {
    // o setUp roda sempre antes do que os testes que vem abaixo:
    groupId = anyString();
    httpClient = HttpClientSpy();
    httpClient.responseJson = '''
    {
    "groupName": "any name",
    "date": "2024-08-30T10:30",
    "players": [{
       "id": "id 1",
       "name": "name 1",
       "isConfirmed": true
    }, {
       "id": "id 2",
       "name": "name 2",
       "position": "position 2",
        "photo": "photo 2",
       "isConfirmed": false,
       "confirmationDate": "2024-08-29T11:00"
    }]
    }
    ''';
    sut = LoadNextEventHttpRepository(httpClient: httpClient, url: url);
  });
  test('Should request with correct method', () async {
    await sut.loadNextEvent(groupId: groupId);
    expect(httpClient.method, 'get');
    expect(httpClient.callsCount, 1);
  });

  test('Should request with correct URL', () async {
    await sut.loadNextEvent(groupId: groupId);
    expect(httpClient.url, 'https://domain.com/api/groups/$groupId/next_event');
  });

  test('Should request with correct headers', () async {
    await sut.loadNextEvent(groupId: groupId);
    expect(httpClient.headers?['content-type'], 'application/json');
    expect(httpClient.headers?['accept'], 'application/json');
  });

  test('Should request NextEvent on 200', () async {
    final event = await sut.loadNextEvent(groupId: groupId);
    expect(event.groupName, 'any name');
    expect(event.date, DateTime(2024, 8, 30, 10, 30));
    expect(event.players[0].id, 'id 1');
    expect(event.players[0].name, 'name 1');
    expect(event.players[0].isConfirmed, true);

    expect(event.players[1].id, 'id 2');
    expect(event.players[1].position, 'position 2');
    expect(event.players[1].photo, 'photo 2');
    expect(event.players[1].name, 'name 2');
    expect(event.players[1].confirmationDate, DateTime(2024, 8, 29, 11, 0));
    expect(event.players[1].isConfirmed, false);
  });

  test('Should throw UnexpectedError on 400', () async {
    httpClient.simulateBadRequestError();
    final future = sut.loadNextEvent(groupId: groupId);
    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw SessionExpiredError on 401', () async {
    httpClient.simulateUnauthorizedError();
    final future = sut.loadNextEvent(groupId: groupId);
    expect(future, throwsA(DomainError.sessionExpired));
  });

  test('Should throw UnexpectedError on 403', () async {
    httpClient.simulateForbiddenError();
    final future = sut.loadNextEvent(groupId: groupId);
    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw UnexpectedError on 404', () async {
    httpClient.simulateNotFoundError();
    final future = sut.loadNextEvent(groupId: groupId);
    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw UnexpectedError on 500', () async {
    httpClient.simulateServerError();
    final future = sut.loadNextEvent(groupId: groupId);
    expect(future, throwsA(DomainError.unexpected));
  });
}
