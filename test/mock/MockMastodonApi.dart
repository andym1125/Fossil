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
  }) : v1 = MockMastodonV1Service(accountsp: accounts);

  /// Returns the v1 service.
  @override
  final MastodonV1Service v1;
}

class MockMastodonV1Service extends Fake implements MastodonV1Service {
  MockMastodonV1Service({
    AccountsV1Service? accountsp
  }) {
    if(accountsp != null) {
      accounts = accountsp;
    }
  }

  

  // @override
  // final InstanceV1Service instance;

  // @override
  // final AppsV1Service apps;

  @override
  late AccountsV1Service accounts;

  // @override
  // final StatusesV1Service statuses;

  // @override
  // final TimelinesV1Service timelines;

  // @override
  // final NotificationsV1Service notifications;

  // @override
  // final MediaV1Service media;
}

//class MockAccountsV1Service extends Mock implements AccountsV1Service {}