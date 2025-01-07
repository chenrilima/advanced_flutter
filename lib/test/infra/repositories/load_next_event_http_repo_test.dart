// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';

import 'package:advanced_flutter/test/helpers/fakes.dart';

class LoadNextEventHttpRepository {
  final Client httpClient;
  final String url;

  LoadNextEventHttpRepository({
    required this.httpClient,
    required this.url,
  });

  Future<void> loadNextEvent({required String groupId}) async {
    final uri = Uri.parse(url.replaceFirst(':groupId', groupId));
    await httpClient.get(uri);
  }
}

class HttpClientSpy implements Client {
  String? method;
  String? url;
  int callsCount = 0;

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
    return Response('', 200);
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
    // o setUp roda sempre antes do que os testes que vem a abaixo:
    groupId = anyString();
    url = 'https://domain.com/api/groups/:groupId/next_event';
    httpClient = HttpClientSpy();
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
}
