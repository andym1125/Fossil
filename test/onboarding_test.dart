import 'dart:developer';

import 'package:flutter_test/flutter_test.dart';
import 'package:fossil/fossil.dart';
import 'package:mastodon_api/mastodon_api.dart';
import 'package:mastodon_oauth2/mastodon_oauth2.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:fossil/lib_override/lib_override.dart';
import 'util.dart';
import 'mock/MockMastodonApi.dart';

@GenerateNiceMocks([MockSpec<AccountsV1Service>(), MockSpec<MastodonOAuth2Client>()])
import 'onboarding_test.mocks.dart';


void main() {

  /// fossil.verifyAccount() ///
  test('Fossil.verifyAccount null auth', () async {
    // Create
    var accountsApi = MockAccountsV1Service();
    when(accountsApi.verifyAccountCredentials(bearerToken: null))
    .thenAnswer((realInvocation) => futureMastodonResponse(
      data: dummyAccount(),
      status: HttpStatus.forbidden
    ));

    var mastodon = makeMockMastodonApi(accounts: accountsApi);
    var fossil = Fossil(mastodon);
    var response = await fossil.verifyAccount();
    expect(response, HttpStatus.forbidden);
  });

  test("Fossil verify unauth", () async {

    var accountsApi = MockAccountsV1Service();
    when(accountsApi.verifyAccountCredentials(bearerToken: anyNamed('bearerToken')))
    .thenThrow(Exception("Unauthorized"));

    var mastodon = makeMockMastodonApi(accounts: accountsApi);
    var fossil = Fossil(mastodon);
    fossil.authToken = dummyToken();

    var response = await fossil.verifyAccount();
    expect(response, HttpStatus.unauthorized);

  });

  test('Fossil Verify ok status', () async{
    var accountsApi = MockAccountsV1Service();
    when(accountsApi.verifyAccountCredentials(bearerToken: anyNamed('bearerToken')))
    .thenAnswer((realInvocation) => futureMastodonResponse(
      data: dummyAccount()
    ));

    var mastodon = makeMockMastodonApi(accounts: accountsApi);
    var fossil = Fossil(mastodon);
    fossil.authToken = dummyToken();

    var response = await fossil.verifyAccount();
    expect(response, HttpStatus.ok);
  });

  test('Create an account', () async {
    var accountsApi = MockAccountsV1Service();
    when(accountsApi.createAccount(username: anyNamed("username"), email: anyNamed("email"), password: anyNamed("password"), agreement: anyNamed("agreement"), locale: anyNamed("locale")))
    .thenAnswer((realInvocation) => futureMastodonResponse(data: dummyToken()));

    var mastodon = makeMockMastodonApi(accounts: accountsApi);
    var fossil = Fossil(mastodon);
    fossil.authToken = Token(accessToken: 'sdsds', tokenType: 'dfdf', scopes: List<Scope>.empty(), createdAt: DateTime.now());
  
    expect(await fossil.createAccount("", "", ""), HttpStatus.ok);  
  });

  test('Sign in', () async {
    var oauthMock = MockMastodonOAuth2Client();
    when(oauthMock.executeAuthCodeFlow(scopes: anyNamed("scopes"), forceLogin: anyNamed("forceLogin")))
    .thenAnswer((realInvocation) {
      log("hello");
      return 
    })
  });
}