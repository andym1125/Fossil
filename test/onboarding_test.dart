import 'package:flutter_test/flutter_test.dart';
import 'package:fossil/fossil.dart';
import 'package:mastodon_api/mastodon_api.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:fossil/lib_override/lib_override.dart';

import 'mock/MockMastodonApi.dart';

@GenerateNiceMocks([MockSpec<AccountsV1Service>()])
import 'onboarding_test.mocks.dart';


void main() {

  /// fossil.verifyAccount() ///
  test('Fossil.verifyAccount null auth', () async {
    // Create
    var accountsApi = MockAccountsV1Service();
    when(accountsApi.verifyAccountCredentials(bearerToken: null))
    .thenAnswer((realInvocation) => Future.value(
      MastodonResponse<Account>(
        data: Account(id: "", username: "", displayName: "", acct: "", note: "", url: "", avatar: "", avatarStatic: "", header: "", headerStatic: "", followersCount: 0, followingCount: 0, statusesCount: 0, emojis: List<Emoji>.empty(), fields: List<Field>.empty(), createdAt: DateTime.now()), 
        headers: {}, //TODO bearer token
        status: HttpStatus.forbidden,
        request: MastodonRequest(
          method: HttpMethod.get,
          url: Uri() //TODO fill out
        ),
        rateLimit: RateLimit(
          limitCount: 5, 
          remainingCount: 5, 
          resetAt: DateTime.now())
        ),
    ));
    var mastodon = MockMastodonApi(
      instance: "mastodon.fossil.com", 
      bearerToken: '', 
      timeout: Duration.zero, 
      accounts: accountsApi);
    var fossil = Fossil(mastodon);

    //Run
    var response = await fossil.verifyAccount();

    //Verify
    expect(response, HttpStatus.forbidden);
  });

  test("Fossil verify unauth", () async {

    var accountsApi = MockAccountsV1Service();
    when(accountsApi.verifyAccountCredentials(bearerToken: anyNamed('bearerToken')))
    .thenThrow(Exception("Unauthorized"));

    var mastodon = MockMastodonApi(
      instance: "mastadon.fossil.com", 
      bearerToken: 'GE9gBS0F6x6c1V2MMMC2hGh7ntdsms97FirCK4TQy78', 
      timeout: Duration.zero,
      accounts: accountsApi);
    var fossil = Fossil(mastodon);
    fossil.authToken = Token(accessToken: 'sdsds', tokenType: 'dfdf', scopes: List<Scope>.empty(), createdAt: DateTime.now());

    var response = await fossil.verifyAccount();

    expect(response, HttpStatus.unauthorized);

  });

  test('Fossil Verify ok status', () async{
    var accountsApi = MockAccountsV1Service();
    when(accountsApi.verifyAccountCredentials(bearerToken: anyNamed('bearerToken')))
    .thenAnswer((realInvocation) => Future.value(
      MastodonResponse<Account>(
        data: Account(id: "", username: "", displayName: "", acct: "", note: "", url: "", avatar: "", avatarStatic: "", header: "", headerStatic: "", followersCount: 0, followingCount: 0, statusesCount: 0, emojis: List<Emoji>.empty(), fields: List<Field>.empty(), createdAt: DateTime.now()), 
        headers: {}, //TODO bearer token
        status: HttpStatus.ok,
        request: MastodonRequest(
          method: HttpMethod.get,
          url: Uri() //TODO fill out
        ),
        rateLimit: RateLimit(
          limitCount: 5, 
          remainingCount: 5, 
          resetAt: DateTime.now())
        ),
    ));

    var mastodon = MockMastodonApi(
      instance: "mastadon.fossil.com", 
      bearerToken: 'GE9gBS0F6x6c1V2MMMC2hGh7ntdsms97FirCK4TQy78', 
      timeout: Duration.zero,
      accounts: accountsApi);
    var fossil = Fossil(mastodon);
    fossil.authToken = Token(accessToken: 'sdsds', tokenType: 'dfdf', scopes: List<Scope>.empty(), createdAt: DateTime.now());
  });

  test('Create an account', () async {

    var accountsApi = MockAccountsV1Service();
    when(accountsApi.createAccount(username: "", email: "", password: "", agreement: true, locale: const MyLocale(lang: Language.english, country: Country.unitedStates)))
    .thenAnswer((realInvocation) => Future.value(
      MastodonResponse<Token>(
        data: Token(
          accessToken: "accessToken", 
          tokenType: "tokenType", 
          scopes: List<Scope>.empty(), 
          createdAt: DateTime.now()), 
        headers: <String, String>{}, 
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

  test('Accessing environment variable secrets', () {
  });

}