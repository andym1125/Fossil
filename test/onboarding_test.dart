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
    when(accountsApi.createAccount(username: "", email: "", password: "", agreement: true, locale: const Locale(lang: Language.americanEnglish, country: Country.unitedStates))).thenAnswer((realInvocation) => Future.value(
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

  test('Accessing environment variable secrets', () {
  });

}