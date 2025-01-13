// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:typed_data';

import 'package:advanced_flutter/domain/entities/next_event.dart';
import 'package:advanced_flutter/domain/entities/next_event_player.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';

import 'package:advanced_flutter/test/helpers/fakes.dart';

import '../../../domain/repositories/load_next_event_repo.dart';

enum DomainError { unexpected }

class LoadNextEventHttpRepository implements LoadNextEventRepository {
  final Client httpClient;
  final String url;

  LoadNextEventHttpRepository({
    required this.httpClient,
    required this.url,
  });

  Future<NextEvent> loadNextEvent({required String groupId}) async {
    final uri = Uri.parse(url.replaceFirst(':groupId', groupId));
    final headers = {
      'content-type': 'application/json',
      'accept': 'application/json'
    };
    final response = await httpClient.get(uri, headers: headers);
    if (response.statusCode == 400) {
      throw DomainError.unexpected;
    }
    final event = jsonDecode(response.body);
    return NextEvent(
        groupName: event['groupName'],
        date: DateTime.parse(event['date']),
        players: event['players']
            .map<NextEventPlayer>((player) => NextEventPlayer(
                  id: player['id'],
                  name: player['name'],
                  position: player['position'],
                  photo: player['photo'],
                  isConfirmed: player['isConfirmed'],
                  confirmationDate:
                      DateTime.tryParse(player['confirmationDate'] ?? ''),
                ))
            .toList());
  }
}

class HttpClientSpy implements Client {
  String? method;
  String? url;
  int callsCount = 0;
  Map<String, String>? headers;
  String responseJson = '';
  int statusCode = 200;

  @override
  void close() {}

  @override
  Future<Response> delete(Uri url,
      {Map<String, String>? headers, Object? body, Encoding? encoding}) {
    throw UnimplementedError();
  }

  @override
  Future<Response> get(Uri url, {Map<String, String>? headers}) async {
    method = 'get';
    callsCount++;
    this.url = url.toString();
    this.headers = headers;
    return Response(responseJson, statusCode);
  }

  @override
  Future<Response> head(Uri url, {Map<String, String>? headers}) {
    throw UnimplementedError();
  }

  @override
  Future<Response> patch(Uri url,
      {Map<String, String>? headers, Object? body, Encoding? encoding}) {
    throw UnimplementedError();
  }

  @override
  Future<Response> post(Uri url,
      {Map<String, String>? headers, Object? body, Encoding? encoding}) {
    throw UnimplementedError();
  }

  @override
  Future<Response> put(Uri url,
      {Map<String, String>? headers, Object? body, Encoding? encoding}) {
    throw UnimplementedError();
  }

  @override
  Future<String> read(Uri url, {Map<String, String>? headers}) {
    throw UnimplementedError();
  }

  @override
  Future<Uint8List> readBytes(Uri url, {Map<String, String>? headers}) {
    throw UnimplementedError();
  }

  @override
  Future<StreamedResponse> send(BaseRequest request) {
    throw UnimplementedError();
  }
}

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
    httpClient.statusCode = 400;
    final future = sut.loadNextEvent(groupId: groupId);
    expect(future, throwsA(DomainError.unexpected));
  });
}
