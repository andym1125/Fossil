import 'package:fossil/lib_override/lib_override.dart';
import 'package:mastodon_api/mastodon_api.dart';

class Fossil
{
  late MastodonApi mastodon;
  Token? authToken;

  bool authenticated = false;

  // Constructs a new Fossil backend instance based on environmental configuration
  Fossil([MastodonApi? replaceApi])
  {
    if(replaceApi != null)
    {
      mastodon = replaceApi;
      return;
    }

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
      locale: DEFAULT_LOCALE
    ); 

    authToken = response.data;
    return response.status;
  }

  // Future<HttpStatus> authAccount(String email, String password) async
  // {

  //   mastodon.v1.apps.
  //   var response = await mastodon.v1.accounts.(
  //     username: email, 
  //     password: password, 
  //     locale: DEFAULT_LOCALE
  //   );

  //   authToken = response.data;
  //   return response.status;
  // }

  /// verifyAccount returns:<br/>
  /// - ok if the user's email has been verified<br/>
  /// - unauthorized if the user authToken hasn't been intialized<br/>
  /// - forbidden if the user's email hasn't been verified<br/>
  /// - other messages if an error occurs, see Mastodon API<br/>
  Future<HttpStatus> verifyAccount() async
  {
    if(authToken == null)
    {
      return HttpStatus.unauthorized;
    }

    late MastodonResponse<Account> response;
    try {
      response = await mastodon.v1.accounts.verifyAccountCredentials(bearerToken: authToken!.toString());
    } catch (e) {
      if (e.toString().contains('email needs to be confirmed')) {
        // ignore: avoid_print
        //TODO
        print('Email is not verified');
        return HttpStatus.forbidden;
      } else {
        print('An error occurred: $e');
        return response.status;
      }
    }

    authenticated = response.status == HttpStatus.ok;
    return response.status;
  }
}