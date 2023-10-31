import 'package:flutter_test/flutter_test.dart';
import 'package:fossil/fossil.dart';
import 'package:mastodon_api/mastodon_api.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'mock/MockMastodonApi.dart';

@GenerateNiceMocks([MockSpec<AccountsV1Service>()])
import 'onboarding_test.mocks.dart';


void main() {
  test('Create an account', () async {

    var accountsApi = MockAccountsV1Service();
    when(accountsApi.createAccount(username: "", email: "", password: "", agreement: true, locale: const Locale(lang: Language.americanEnglish, country: Country.unitedStates)))
    .thenAnswer((realInvocation) => Future.value(
      MastodonResponse<Token>(
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
          resetAt: DateTime.now()))));

    var mastodon = MockMastodonApi(instance: "sdfsdf", bearerToken: "bearerToken", timeout: Duration.zero, accounts: accountsApi);
    var fossil = Fossil(mastodon);
    expect(await fossil.createAccount("", "", ""), HttpStatus.ok);
  });

  test('Creating an account when the Mastodon API is unavailable', () async {

    var accountsApi = MockAccountsV1Service();
    when(accountsApi.createAccount(username: "", email: "", password: "", agreement: true, locale: const Locale(lang: Language.americanEnglish, country: Country.unitedStates)))
    .thenThrow(Exception());

    var mastodon = MockMastodonApi(instance: "sdfsdf", bearerToken: "bearerToken", timeout: Duration.zero, accounts: accountsApi);
    var fossil = Fossil(mastodon);

    // Expect the createAccount() method to throw an exception when the Mastodon API is unavailable.
    expect(() async => await fossil.createAccount("", "", ""), throwsException);
  });
  
  test('Creating an account with invalid input throws an exception', () async {

    var accountsApi = MockAccountsV1ServiceWithInvalidInputStub();
    var mastodon = MockMastodonApi(instance: "sdfsdf", bearerToken: "bearerToken", timeout: Duration.zero, accounts: accountsApi);
    var fossil = Fossil(mastodon);

    // Expect the createAccount() method to throw an exception when invalid input is provided.
    expect(() async => await fossil.createAccount("", "", ""), throwsException);
  });

  test('Creating an account with invalid email throws an exception', () async {

    var accountsApi = MockAccountsV1ServiceWithInvalidEmailStub();
    
    var mastodon = MockMastodonApi(instance: "sdfsdf", bearerToken: "bearerToken", timeout: Duration.zero, accounts: accountsApi);
    var fossil = Fossil(mastodon);

    // Expect the createAccount() method to throw an exception when an invalid email address is provided.
    expect(() async => await fossil.createAccount("username", "invalid_email", "password"), throwsException);
  });

  test('Creating an account with an invalid password throws an exception', () async {
  var accountsApi = MockAccountsV1ServiceWithInvalidPasswordStub();
  var mastodon = MockMastodonApi(instance: "sdfsdf", bearerToken: "bearerToken", timeout: Duration.zero, accounts: accountsApi);
  var fossil = Fossil(mastodon);

  // Expect the createAccount() method to throw an exception when an invalid password is provided.
  expect(() async => await fossil.createAccount("username", "email@example.com", "short"), throwsException);
});

test('Creating an account with an existing email address throws an exception', () async {
  var accountsApi = MockAccountsV1ServiceWithExistingEmailStub();
  var mastodon = MockMastodonApi(instance: "sdfsdf", bearerToken: "bearerToken", timeout: Duration.zero, accounts: accountsApi);
  var fossil = Fossil(mastodon);

  // Expect the createAccount() method to throw an exception when an existing email address is provided.
  expect(() async => await fossil.createAccount("username", "existing_email@example.com", "password"), throwsException);
});
  test('Accessing environment variable secrets', () {
  });

}