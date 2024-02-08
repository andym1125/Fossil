// ignore_for_file: avoid_print
// TODO ^

import 'package:flutter/material.dart';
import 'package:fossil/lib_override/lib_override.dart';
import 'package:mastodon_api/mastodon_api.dart' as m;
import 'package:mastodon_api/mastodon_api.dart';
import 'package:mastodon_oauth2/mastodon_oauth2.dart' as oauth;


class Fossil
{

  late m.MastodonApi mastodon;
  late oauth.MastodonOAuth2Client oauth2;
  m.Token? authToken;

  bool authenticated = false;
   
  // Constructs a new Fossil backend instance based on environmental configuration
  Fossil({m.MastodonApi? replaceApi, oauth.MastodonOAuth2Client? replaceOAuth2Client})
  {
    if(replaceApi != null)
    {
      mastodon = replaceApi;
      return;
    }
    else{
    mastodon = m.MastodonApi(
      instance: const String.fromEnvironment('MASTODON_DEFAULT_INSTANCE_DOMAIN'),
      bearerToken: const String.fromEnvironment('MASTODON_DEFAULT_INSTANCE_BEARER_TOKEN'),

      //! Automatic retry is available when server error or network error occurs
      //! when communicating with the API.
      retryConfig: m.RetryConfig(
        maxAttempts: 5,
        jitter: m.Jitter(
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
 
    if (replaceOAuth2Client != null){
      oauth2 = replaceOAuth2Client;
      return;
    }
    else{
      var instanceDomain = const String.fromEnvironment('MASTODON_DEFAULT_INSTANCE_DOMAIN');
      oauth2 = oauth.MastodonOAuth2Client(
        // Specify mastodon instance like "mastodon.social"
        instance: instanceDomain,
        clientId: const String.fromEnvironment('MASTODON_DEFAULT_INSTANCE_CLIENT_ID'),
        clientSecret: const String.fromEnvironment('MASTODON_DEFAULT_INSTANCE_CLIENT_SECRET'),

        // Replace redirect url as you need.
        redirectUri: 'com.example.fossil://callback',
        customUriScheme: 'com.example.fossil',
      );
      }
    
  }

  Future<m.HttpStatus> createAccount(String username, String email, String password) async
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

  Future<m.HttpStatus> authAccount() async
  {

    final response = await oauth2.executeAuthCodeFlow(
      scopes: [
        oauth.Scope.read,
        oauth.Scope.write,
      ],
    );

    authToken = m.Token(
      accessToken: response.accessToken, 
      tokenType: response.tokenType,
      scopes: [
        m.Scope.read,
        m.Scope.write,
      ],
      createdAt: response.createdAt
    );
    
    //TODO Look into how to use status
    authenticated =  response.accessToken != "";
    var status = response.accessToken != "" ? m.HttpStatus.ok : m.HttpStatus.unauthorized;
    return status;
  }

  /// verifyAccount returns:<br/>
  /// - ok if the user's email has been verified<br/>
  /// - unauthorized if the user authToken hasn't been intialized<br/>
  /// - forbidden if the user's email hasn't been verified<br/>
  /// - other messages if an error occurs, see Mastodon API<br/>
  Future<m.HttpStatus> verifyAccount() async
  {
    if(authToken == null || authToken.toString() == "")
    {
      return m.HttpStatus.forbidden;
    }
    
    late m.MastodonResponse<m.Account> response;
    try {
      response = await mastodon.v1.accounts.verifyAccountCredentials(bearerToken: authToken!.accessToken);
    } catch (e) {
      debugPrint('An error occurred: $e');
      return m.HttpStatus.unauthorized;
    }
    return response.status;
  }

  Future<List<Status>> getPublicTimeline() async
  {
    if(!authenticated)
      return List.empty();
    
    late List<Status> statuses;
    try {
      var response = await mastodon.v1.timelines.lookupPublicTimeline();

      //error handling non 200

      statuses = response.data;
    } catch (e)
    {
      //do some error handling
    }

    return statuses;
  }

  //if auth is null
  //if auth is empty string
  //if call returns a error response
  //if call returns a happy path
}