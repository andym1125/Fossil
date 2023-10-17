import 'package:mastodon_api/mastodon_api.dart';

class Fossil
{
  late MastodonApi mastodon;
  Token? authToken;

  bool authenticated = false;

  // Constructs a new Fossil backend instance based on environmental configuration
  Fossil()
  {
    mastodon = MastodonApi(
      instance: const String.fromEnvironment('MASTODON_DEFAULT_INSTANCE_DOMAIN'),
      bearerToken: const String.fromEnvironment('MASTODON_DEFAULT_INSTANCE_BEARER_TOKEN'),

      //! Automatic retry is available when server error or network error occurs
      //! when communicating with the API.
      retryConfig: RetryConfig(
        maxAttempts: 5,
        jitter: Jitter(
          minInSeconds: 2,
          maxInSeconds: 5,
        ),
        onExecute: (event) => print(
          'Retry after ${event.intervalInSeconds} seconds... '
          '[${event.retryCount} times]',
        ),
      ),

      //! The default timeout is 10 seconds.
      timeout: const Duration(seconds: 20),
    );

  }

  Future<HttpStatus> createAccount(String username, String email, String password) async
  {
    var response = await mastodon.v1.accounts.createAccount(
      username: username, 
      email: email, 
      password: password, 
      agreement: true, 
      locale: const Locale(lang: Language.americanEnglish, country: Country.unitedStates)
    ); 

    authToken = response.data;
    authenticated = response.status == HttpStatus.ok;
    return response.status;
  }
}