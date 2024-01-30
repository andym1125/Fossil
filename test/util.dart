import 'dart:async';

import 'package:mastodon_api/mastodon_api.dart';

Future<MastodonResponse<T>> futureMastodonResponse<T>({
  required T data,
  Map<String, String>? headers,
  HttpStatus? status,
  MastodonRequest? mastodonRequest,
  RateLimit? rateLimit
}) =>
  Future.value(
    MastodonResponse<T>(
      data: data,
      headers: headers ?? {},
      status: status ?? HttpStatus.ok,
      request: mastodonRequest ?? MastodonRequest(
        method: HttpMethod.get,
        url: Uri() //TODO: set up default url
      ),
      rateLimit: rateLimit ?? RateLimit(
        limitCount: 5, 
        remainingCount: 5, 
        resetAt: DateTime.now().add(const Duration(minutes: 1))
      )
    )
  );

Account dummyAccount() => Account(
        id: "", 
        username: "", 
        displayName: "", 
        acct: "", 
        note: "", 
        url: "", 
        avatar: "", 
        avatarStatic: "", 
        header: "", 
        headerStatic: "", 
        followersCount: 0, 
        followingCount: 0, 
        statusesCount: 0, 
        emojis: List<Emoji>.empty(), 
        fields: List<Field>.empty(), 
        createdAt: DateTime.now());

Token dummyToken() => Token(
          accessToken: "accessToken", 
          tokenType: "tokenType", 
          scopes: List<Scope>.empty(), 
          createdAt: DateTime.now());
