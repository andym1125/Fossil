// ignore_for_file: avoid_print
// TODO ^

import 'package:flutter/material.dart';
import 'package:fossil/fossil_exceptions.dart';
import 'package:fossil/lib_override/lib_override.dart';
import 'package:mastodon_api/mastodon_api.dart' as m;
import 'package:mastodon_api/mastodon_api.dart';
import 'package:mastodon_oauth2/mastodon_oauth2.dart' as oauth;
import 'package:mutex/mutex.dart';

class Fossil
{
  late m.MastodonApi mastodon;
  late oauth.MastodonOAuth2Client oauth2;
  m.Token? authToken;

  //Timeline cache and cursor variables
  static const int cursorUninitialized = -2;
  static const int cursorEmptyTimeline = -1;
  final Mutex homeMutex = Mutex();
  final Mutex publicMutex = Mutex();
  int homeCursor = -2;
  int publicCursor = -2;
  List<m.Status> homeTimeline = [];
  List<m.Status> publicTimeline = [];

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

  /* ========== Authentication Methods ========== */

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

  Future<List<m.Status>> getPublicTimeline() async
  {
    if(!authenticated) {
      return List.empty();
    }
    
    late List<m.Status> statuses;
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

  /* ========== END ========== */

  /* ========== Timeline Navigation Methods ========== */

  /// Moves the home cursor back one. If the cursor is already at the beginning, it will attempt
  /// to load new posts, and if there are no new posts, it will return Null.
  /// Throws FossilUnauthorizedException if the client is not authenticated.
  /// Note: This method acquires the homeMutex, and releases it before returning.
  Future<m.Status?> getPrevHomePost() async {
    if(!authenticated) {
      throw FossilUnauthorizedException();
    }

    await homeMutex.acquire();
    try {
      //If the home timeline is unititialized, load the first posts.
      if(homeCursor == cursorUninitialized)
      {
        homeMutex.release();
        await loadNewHomePosts();
        await homeMutex.acquire();

        if(homeTimeline.isEmpty) {
          homeCursor = cursorEmptyTimeline;
          return null;
        }

        homeCursor = 0;
        return homeTimeline[homeCursor];
      }

      if(homeCursor == cursorEmptyTimeline) {
        homeMutex.release();
        await loadNewHomePosts();
        await homeMutex.acquire();

        if(homeTimeline.isEmpty) {
          return null;
        }

        homeCursor = 0;
        return homeTimeline[homeCursor];
      }

      //If the home cursor is at the beginning, load new posts.
      if(homeCursor == 0)
      {
        homeMutex.release();
        int newPosts = await loadNewHomePosts();
        await homeMutex.acquire();

        if(newPosts <= 0) {
          return null;
        }
      }

      homeCursor--;
      return homeTimeline[homeCursor];
    } catch(e) {
      //TODO: Implement
      rethrow;
    } finally {
      homeMutex.release();
    }
  }

  /// Moves the home cursor forward one. If the cursor is near the end, it will attempt
  /// to load older posts, and if there are no older posts, it will return Null.
  /// Throws FossilUnauthorizedException if the client is not authenticated.
  /// Note: This method acquires the homeMutex, and releases it before returning.
  Future<m.Status?> getNextHomePost() async {
    if(!authenticated) {
      throw FossilUnauthorizedException();
    }
    await homeMutex.acquire();
    try {

      //If the home timeline is unititialized, load the first posts.
      if(homeCursor == cursorUninitialized)
      {
        homeMutex.release();
        await loadOldHomePosts();
        await homeMutex.acquire();

        if(homeTimeline.isEmpty) {
          homeCursor = cursorEmptyTimeline;
          return null;
        }

        homeCursor = 0;
        return homeTimeline[homeCursor];
      }

      if(homeCursor == cursorEmptyTimeline) {
        homeMutex.release();
        await loadNewHomePosts();
        await homeMutex.acquire();

        if(homeTimeline.isEmpty) {
          return null;
        }

        homeCursor = 0;
        return homeTimeline[homeCursor];
      }

      //If the home cursor is at the end, load older posts.
      if(homeCursor == homeTimeline.length - 1)
      {
        homeMutex.release();
        int olderPosts = await loadOldHomePosts();
        await homeMutex.acquire();

        if(olderPosts <= 0) {
          return null;
        }
      }

      homeCursor++;
      return homeTimeline[homeCursor];
    } catch(e) {
      //TODO: Implement
      rethrow;
    } finally {
      homeMutex.release();
    }
  }

  /// First loads new posts, then jumps the home cursor to the top of the home timeline.
  /// Returns the first posts, or null if there are no posts.
  /// Throws FossilUnauthorizedException if the client is not authenticated.
  Future<m.Status?> jumpToHomeTop() async {
    if(!authenticated) {
      throw FossilUnauthorizedException();
    }

    var numPosts = await loadNewHomePosts();
    await homeMutex.acquire();
    try {
      if(homeCursor == cursorUninitialized && numPosts <= 0) {
        homeCursor = cursorEmptyTimeline;
        return null;
      }

      if(homeCursor == cursorEmptyTimeline && numPosts <= 0) {
        return null;
      }

      homeCursor = 0;
      return homeTimeline[homeCursor];
    } catch(e) {
      //TODO: Implement
      rethrow;
    } finally {
      homeMutex.release();
    }
  }

  /// Loads new posts to the home timeline cache. Returns the number of new posts loaded.
  /// Throws FossilUnauthorizedException if the client is not authenticated.
  /// Note: if the cursor is uninitialized it will stay the same. If it is newTimeline it 
  /// will become 0. Otherwise, the cursor will increment by the number of new posts.
  Future<int> loadNewHomePosts() async {
    if(!authenticated) {
      throw FossilUnauthorizedException();
    }
    await homeMutex.acquire();
    try {
      var response = await mastodon.v1.timelines.lookupHomeTimeline(
        maxStatusId: null,
        minStatusId: null,
        limit: 20, //TODO: Make this a constant
      );

      if(response.status != m.HttpStatus.ok) {
        throw FossilException(response.status, "Failed to load new home posts. ${response.data}");
      }

      var newStatuses = response.data;
      homeTimeline.insertAll(0, newStatuses);
      if(homeCursor == cursorUninitialized) {
        homeCursor = cursorUninitialized;
      } else if(homeCursor == cursorEmptyTimeline) {
        homeCursor = 0;
      } else {
        homeCursor += newStatuses.length;
      }
      return newStatuses.length;
    } catch(e) {
      //TODO: Implement
      if (e is FossilException) {
        print('Failed to load new home posts: ${e.message}');
        rethrow;
      } else {
        throw UnimplementedError();
      }
    } finally {
      homeMutex.release();
    }
  }

  /* Loads older posts to the home timeline cache. Returns the number of older posts loaded.
   * Throws FossilUnauthorizedException if the client is not authenticated.
   */
  Future<int> loadOldHomePosts() async {
    if(!authenticated) {
      throw FossilUnauthorizedException();
    }
    await homeMutex.acquire();
    try {
      var response = await mastodon.v1.timelines.lookupHomeTimeline(
        maxStatusId: null,
        minStatusId: null,
        limit: 20, //TODO: Make this a constant
      );

      if(response.status != m.HttpStatus.ok) {
        throw FossilException(response.status, "Failed to load new home posts. ${response.data}");
      }

      var newStatuses = response.data;
      homeTimeline.insertAll(homeTimeline.length, newStatuses);
      return newStatuses.length;
    } catch(e) {
      //TODO: Implement
      rethrow;
    } finally {
      homeMutex.release();
    }
  }

  /* Moves the public cursor back one. If the cursor is already at the beginning, it will attempt
   * to load new posts, and if there are no new posts, it will return Null.
   * Throws FossilUnauthorizedException if the client is not authenticated.
   */
  Future<m.Status?> getPrevPublicPost() async {
    throw UnimplementedError();
  }

  /* Moves the public cursor forward one. If the cursor is near the end, it will attempt
   * to load older posts, and if there are no older posts, it will return Null.
   * Throws FossilUnauthorizedException if the client is not authenticated.
   */
  Future<m.Status?> getNextPublicPost() async {
    throw UnimplementedError();
  }

  /* First loads new posts, then jumps the public cursor to the top of the public timeline.
   * Throws FossilUnauthorizedException if the client is not authenticated.
   */
  Future<List<m.Status>> jumpToPublicTop() async {
    throw UnimplementedError();
  }

  /* Loads new posts to the public timeline cache. Returns the number of new posts loaded.
   * Throws FossilUnauthorizedException if the client is not authenticated.
   */
  Future<int> loadNewPublicPosts() async {
    throw UnimplementedError();
  }

  /* Loads older posts to the public timeline cache. Returns the number of older posts loaded.
   * Throws FossilUnauthorizedException if the client is not authenticated.
   */
  Future<int> loadOldPublicPosts() async {
    throw UnimplementedError();
  }

  /* ========== END ========== */
}