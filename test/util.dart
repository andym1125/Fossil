import 'dart:async';

import 'package:mastodon_api/mastodon_api.dart';
import 'package:mastodon_oauth2/mastodon_oauth2.dart' as oauth;

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

Future<oauth.OAuthResponse> futureOauthResponse() =>
  Future.value(
    oauth.OAuthResponse(
      accessToken: "accessToken",
      tokenType: "tokenType",
      scopes: List<oauth.Scope>.empty(),
      createdAt: DateTime.now()
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




 Status dummyStatus = Status(
  id: '123',
  url: 'some_url',
  uri: 'some_uri',
  content: 'some_content',
  spoilerText: 'some_spoiler_text',
  visibility: Visibility.private,
  favouritesCount: 0,
  repliesCount: 0,
  reblogsCount: 0,
  language: null,
  inReplyToId: 'some_in_reply_to_id',
  inReplyToAccountId: 'some_in_reply_to_account_id',
  isFavourited: false,
  isReblogged: false,
  isMuted: false,
  isBookmarked: false,
  isSensitive: false,
  isPinned: false,
  lastStatusAt: DateTime.now(),
  account: dummyAccount(),
  application: null,
  poll: null,
  reblog: null,
  mediaAttachments: [],
  emojis: [],
  tags: [],
  createdAt: DateTime.now(),
);
