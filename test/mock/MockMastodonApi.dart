// ignore_for_file: file_names

import 'package:mastodon_api/mastodon_api.dart';
import 'package:mockito/mockito.dart';

class MockMastodonApi extends Fake implements MastodonApi {
  /// Returns the new instance of [_MastodonApi].
  MockMastodonApi({
    required String instance,
    required String bearerToken,
    required Duration timeout,
    RetryConfig? retryConfig,
    AccountsV1Service? accounts,
    TimelinesV1Service? timelines,
    StatusesV1Service? statuses,
  }) : v1 = MockMastodonV1Service(accountsp: accounts, timelinesService: timelines, statusesService: statuses);

  /// Returns the v1 service.
  @override
  final MastodonV1Service v1;
}

MockMastodonApi makeMockMastodonApi({
  String? instance,
  String? bearerToken,
  Duration? timeout,
  RetryConfig? retryConfig,
  AccountsV1Service? accounts,
  TimelinesV1Service? timelines,
  StatusesV1Service? statuses,
}) => MockMastodonApi(
  instance: "mock.fossil.com",
  bearerToken: bearerToken ?? "dsgsdfsdf",
  timeout: const Duration(seconds: 10),
  retryConfig: retryConfig,
  accounts: accounts,
  timelines: timelines,
);

class MockMastodonV1Service extends Fake implements MastodonV1Service {
  MockMastodonV1Service({
    AccountsV1Service? accountsp,
    TimelinesV1Service? timelinesService,
    StatusesV1Service? statusesService,
  }) {
    if(accountsp != null) {
      accounts = accountsp;
    }
    if(timelinesService != null) {
      timelines = timelinesService;
    }
    if(statusesService != null) {
      statuses = statusesService;
    }
  }

  

  // @override
  // final InstanceV1Service instance;

  // @override
  // final AppsV1Service apps;

  @override
  late AccountsV1Service accounts;

  @override
  late StatusesV1Service statuses;

  @override
  late TimelinesV1Service timelines;

  // @override
  // final NotificationsV1Service notifications;

  // @override
  // final MediaV1Service media;
}

//class MockAccountsV1Service extends Mock implements AccountsV1Service {}