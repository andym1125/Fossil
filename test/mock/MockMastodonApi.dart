import 'package:mastodon_api/mastodon_api.dart';
import 'package:mockito/mockito.dart';
import 'dart:io';


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

class MockAccountsV1ServiceWithInvalidInputStub extends Mock implements AccountsV1Service {

  @override
  Future<MastodonResponse<Token>> createAccount({
    required String username, 
    required String email, 
    required String password, 
    bool agreement = true, 
    Locale locale = const Locale(lang: Language.americanEnglish, country: Country.unitedStates), 
    String? reason
    }) async {
    throw Exception("Invalid input");
  }
}

class MockAccountsV1ServiceWithInvalidEmailStub extends Mock implements AccountsV1Service {
  @override
  Future<MastodonResponse<Token>> createAccount({
    required String username,
    required String email,
    required String password,
    required bool agreement,
    required Locale locale,
    String? reason,
  }) async {
    if (!email.contains("@")) {
      throw Exception("Invalid email address");
    }

    return Future.value(MastodonResponse<Token>(
      data: Token(
          accessToken: "accessToken", 
          tokenType: "tokenType", 
          scopes: List<Scope>.empty(), 
          createdAt: DateTime.now()), 
        headers: Map(), 
        status: HttpStatus.ok, 
        request: MastodonRequest(
          method: HttpMethod.get,
          url: Uri()
        ), 
        rateLimit: RateLimit(
          limitCount: 5, 
          remainingCount: 5, 
          resetAt: DateTime.now()))
          );
  }
}

class MockAccountsV1ServiceWithInvalidPasswordStub extends Mock implements AccountsV1Service {

  @override
  Future<MastodonResponse<Token>> createAccount({
    required String username,
    required String email,
    required String password,
    bool agreement = true,
    required Locale locale,
    String? reason,
  }) async {
    if (password.length < 8) {
      throw Exception("Password must be at least 8 characters long");
    }

    return Future.value(MastodonResponse<Token>(
      data: Token(
          accessToken: "accessToken", 
          tokenType: "tokenType", 
          scopes: List<Scope>.empty(), 
          createdAt: DateTime.now()), 
        headers: Map(), 
        status: HttpStatus.ok, 
        request: MastodonRequest(
          method: HttpMethod.get,
          url: Uri()
        ), 
        rateLimit: RateLimit(
          limitCount: 5, 
          remainingCount: 5, 
          resetAt: DateTime.now()))
          );
  }
}

class MockAccountsV1ServiceWithExistingEmailStub extends Mock implements AccountsV1Service {

  @override
  Future<MastodonResponse<Token>> createAccount({
    required String username,
    required String email,
    required String password,
    bool agreement = true,
    required Locale locale,
    String? reason,
  }) async {
    if (email == "existing_email@example.com") {
      throw Exception("Email address already in use");
    }

    return Future.value(MastodonResponse<Token>(
      headers: {},
      status: HttpStatus.ok,
      request: MastodonRequest(
        method: HttpMethod.post,
        url: Uri.parse("https://example.com/api/v1/accounts"),
      ),
      rateLimit: RateLimit(
        limitCount: 100,
        remainingCount: 100,
        resetAt: DateTime.now(),
      ),
      data: Token(
        accessToken: "",
        tokenType: "",
        scopes: List<Scope>.empty(),
        createdAt: DateTime.now(),
      ),
    ));
  }
}

// bool isEmailVerified(String email) {
//   // Open the CSV file for reading.
//   final file = File('verificationEmail.csv');
  
//   try {
//     final lines = file.readAsLinesSync();
    
//     // Iterate over the lines and check if the email address is in the file.
//     for (final line in lines) {
//       if (line == email) {
//         return true;
//       }
//     }
//   } catch (e) {
//     print('Error reading the file: $e');
//   }

//   return false;
// }
// class MockAccountsV1ServiceWithVerifiedEmailStub extends Mock implements AccountsV1Service {

//   @override
//   Future<MastodonResponse<Token>> createAccount({
//     required String username, 
//     required String email, 
//     required String password, 
//     bool agreement = true, 
//     Locale locale = const Locale(lang: Language.americanEnglish, country: Country.unitedStates), 
//     String? reason
//     }) async {
//     if (!isEmailVerified(email)) {
//       throw Exception("Email address is not verified");
//     }

//     return Future.value(MastodonResponse<Token>(
//       headers: {},
//       status: HttpStatus.ok,
//       request: MastodonRequest(
//         method: HttpMethod.post,
//         url: Uri.parse("https://example.com/api/v1/accounts"),
//       ),
//       rateLimit: RateLimit(
//         limitCount: 100,
//         remainingCount: 100,
//         resetAt: DateTime.now(),
//       ),
//       data: Token(
//         accessToken: "",
//         tokenType: "",
//         scopes: List<Scope>.empty(),
//         createdAt: DateTime.now(),
//       ),
//     ));
//   }
// }

//class MockAccountsV1Service extends Mock implements AccountsV1Service {}