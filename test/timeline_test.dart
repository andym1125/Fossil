import 'package:flutter_test/flutter_test.dart';
import 'package:fossil/fossil.dart';
import 'package:fossil/fossil_exceptions.dart';
import 'package:mastodon_api/mastodon_api.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'mock/MockMastodonApi.dart';
import 'util.dart';


@GenerateNiceMocks([MockSpec<TimelinesV1Service>(), MockSpec<StatusesV1Service>()])
import 'timeline_test.mocks.dart';

void main() {

//LoadNewHomePosts
 test("Not autheticated Unauthroized exception load new home posts" , () async {

  var timelinesApi = MockTimelinesV1Service();
  when(timelinesApi.lookupHomeTimeline(
        maxStatusId: anyNamed('maxStatusId'),
        minStatusId: anyNamed('minStatusId'),
        limit: anyNamed('limit')))
      .thenAnswer((_) async => futureMastodonResponse(
          data: List<Status>.generate(5, (index) => (dummyStatus),
          )));

      var mastodon = makeMockMastodonApi(timelines: timelinesApi);
      var fossil = Fossil(replaceApi: mastodon);
      fossil.authenticated = false;
      
      expect(() async => await fossil.loadNewHomePosts(), throwsA(isA<FossilUnauthorizedException>()));
  
});

 test("Unimplmeneted error new hometimeline" , () async {

  var timelinesApi = MockTimelinesV1Service();
  when(timelinesApi.lookupHomeTimeline(
        maxStatusId: anyNamed('maxStatusId'),
        minStatusId: anyNamed('minStatusId'),
        limit: anyNamed('limit')))
      .thenThrow(Exception('Unexpected error'));

      var mastodon = makeMockMastodonApi(timelines: timelinesApi);
      var fossil = Fossil(replaceApi: mastodon);
      fossil.authenticated = true;
      
     expect(() async => await fossil.loadNewHomePosts(),throwsA(isA<UnimplementedError>()));

});

 test("If status is not ok new hometimeline" , () async {

  var timelinesApi = MockTimelinesV1Service();
  when(timelinesApi.lookupHomeTimeline(
        maxStatusId: null,
        minStatusId: null,
        limit: 20))
      .thenAnswer((_) async => futureMastodonResponse(
          status: HttpStatus.badRequest,
          data: List<Status>.generate(5, (index) => (dummyStatus)),
          ));
          

      var mastodon = makeMockMastodonApi(timelines: timelinesApi);
      var fossil = Fossil(replaceApi: mastodon);
      fossil.authenticated = true;
      
     expect(() async => await fossil.loadNewHomePosts(),throwsA(isA<FossilException>()));

});

test("If status is ok new home timeline" , () async {
  var timelinesApi = MockTimelinesV1Service();
  when(timelinesApi.lookupHomeTimeline(
        maxStatusId: null,
        minStatusId: null,
        limit: 20))
      .thenAnswer((_) async => futureMastodonResponse(
          status: HttpStatus.ok,
          data: List<Status>.generate(5, (index) => (dummyStatus)),
          ));
          
  var mastodon = makeMockMastodonApi(timelines: timelinesApi);
  var fossil = Fossil(replaceApi: mastodon);
  fossil.authenticated = true;
  
  var response = await fossil.loadNewHomePosts();
  
  expect(response, 5); // assuming that 5 new posts are returned
});

test("homeCursor is updated correctly when timeline is empty", () async {
  // Set up your mock and Fossil instance as before
  var timelinesApi = MockTimelinesV1Service();
  when(timelinesApi.lookupHomeTimeline(
        maxStatusId: null,
        minStatusId: null,
        limit: 20))
      .thenAnswer((_) async => futureMastodonResponse(
          status: HttpStatus.ok,
          data: [], // Empty list to simulate an empty timeline
          ));

  var mastodon = makeMockMastodonApi(timelines: timelinesApi);
  var fossil = Fossil(replaceApi: mastodon);
  fossil.authenticated = true;
  fossil.homeCursor = Fossil.cursorEmptyTimeline; // Set homeCursor to cursorEmptyTimeline

  await fossil.loadNewHomePosts();

  expect(fossil.homeCursor, 0); // Expect homeCursor to be 0
});

test("homeCursor is updated correctly when timeline is not empty", () async {
  // Set up your mock and Fossil instance as before
  var timelinesApi = MockTimelinesV1Service();
  when(timelinesApi.lookupHomeTimeline(
        maxStatusId: null,
        minStatusId: null,
        limit: 20))
      .thenAnswer((_) async => futureMastodonResponse(
          status: HttpStatus.ok,
          data: List<Status>.generate(5, (index) => (dummyStatus)), // Non-empty list to simulate a non-empty timeline
          ));

  var mastodon = makeMockMastodonApi(timelines: timelinesApi);
  var fossil = Fossil(replaceApi: mastodon);
  fossil.authenticated = true;
  fossil.homeCursor = 0; // Set homeCursor to a value that's not cursorEmptyTimeline

  await fossil.loadNewHomePosts();

  expect(fossil.homeCursor, 5); // Expect homeCursor to be incremented by the number of new statuses
});

//LoadOldHomePosts
test("Not authenticated Unauthroized exception load old home posts" , () async {

  var timelinesApi = MockTimelinesV1Service();
  when(timelinesApi.lookupHomeTimeline(
        maxStatusId: anyNamed('maxStatusId'),
        minStatusId: anyNamed('minStatusId'),
        limit: anyNamed('limit')))
      .thenAnswer((_) async => futureMastodonResponse(
          data: List<Status>.generate(5, (index) => (dummyStatus),
          )));

      var mastodon = makeMockMastodonApi(timelines: timelinesApi);
      var fossil = Fossil(replaceApi: mastodon);
      fossil.authenticated = false;
      
      expect(() async => await fossil.loadOldHomePosts(), throwsA(isA<FossilUnauthorizedException>()));
  
});

test("Not Ok status for new timeline" , () async {

  var timelinesApi = MockTimelinesV1Service();
  when(timelinesApi.lookupHomeTimeline(
        maxStatusId: anyNamed('maxStatusId'),
        minStatusId: anyNamed('minStatusId'),
        limit: anyNamed('limit')))
      .thenAnswer((_) async => futureMastodonResponse(
          status: HttpStatus.badRequest,
          data: List<Status>.generate(5, (index) => (dummyStatus),
          )));

      var mastodon = makeMockMastodonApi(timelines: timelinesApi);
      var fossil = Fossil(replaceApi: mastodon);
      fossil.authenticated = true;
      
     expect(() async => await fossil.loadOldHomePosts(),throwsA(isA<FossilException>()));

});

test("If status is ok new home timeline" , () async {
  var timelinesApi = MockTimelinesV1Service();
  when(timelinesApi.lookupHomeTimeline(
        maxStatusId: null,
        minStatusId: null,
        limit: 20))
      .thenAnswer((_) async => futureMastodonResponse(
          status: HttpStatus.ok,
          data: List<Status>.generate(5, (index) => (dummyStatus)),
          ));
          
  var mastodon = makeMockMastodonApi(timelines: timelinesApi);
  var fossil = Fossil(replaceApi: mastodon);
  fossil.authenticated = true;
  
  var response = await fossil.loadOldHomePosts();
  
  expect(response, 5); // assuming that 5 new posts are returned
});

//getPrevHomePosts
 test("Not autheticated Unauthroized exception load new home posts" , () async {

  var timelinesApi = MockTimelinesV1Service();
  when(timelinesApi.lookupHomeTimeline(
        maxStatusId: anyNamed('maxStatusId'),
        minStatusId: anyNamed('minStatusId'),
        limit: anyNamed('limit')))
      .thenAnswer((_) async => futureMastodonResponse(
          data: List<Status>.generate(5, (index) => (dummyStatus),
          )));

      var mastodon = makeMockMastodonApi(timelines: timelinesApi);
      var fossil = Fossil(replaceApi: mastodon);
      fossil.authenticated = false;
      
      expect(() async => await fossil.getPrevHomePost(), throwsA(isA<FossilUnauthorizedException>()));
  
});

test("getPrevHomePost returns null when home timeline is uninitialized", () async {
  // Set up your mock and Fossil instance as before
  var timelinesApi = MockTimelinesV1Service();
  when(timelinesApi.lookupHomeTimeline(
        maxStatusId: null,
        minStatusId: null,
        limit: 20))
      .thenAnswer((_) async => futureMastodonResponse(
          status: HttpStatus.ok,
          data: [], // Empty list to simulate an empty timeline
          ));

  var mastodon = makeMockMastodonApi(timelines: timelinesApi);
  var fossil = Fossil(replaceApi: mastodon);
  fossil.authenticated = true;
  fossil.homeCursor = Fossil.cursorUninitialized; // Set homeCursor to cursorUninitialized

  var response = await fossil.getPrevHomePost();

  expect(response, null); // Expect null because the timeline is empty
});

test("getPrevHomePost returns the previous post when home timeline is not empty", () async {
  // Set up your mock and Fossil instance as before
  var timelinesApi = MockTimelinesV1Service();
  when(timelinesApi.lookupHomeTimeline(
        maxStatusId: null,
        minStatusId: null,
        limit: 20))
      .thenAnswer((_) async => futureMastodonResponse(
          status: HttpStatus.ok,
          data: List<Status>.generate(5, (index) => (dummyStatus)), // Non-empty list to simulate a non-empty timeline
          ));

  var mastodon = makeMockMastodonApi(timelines: timelinesApi);
  var fossil = Fossil(replaceApi: mastodon);
  fossil.authenticated = true;

  // First, load new home posts
  await fossil.loadNewHomePosts();

  // Set homeCursor to a value that's not cursorUninitialized or cursorEmptyTimeline
  fossil.homeCursor = 1; 

  // Call getPrevHomePost and expect it to return the previous post
  var response = await fossil.getPrevHomePost();

  expect(response, equals(dummyStatus)); // Expect the previous post
});

test("getPrevHomePost returns null when home timeline is empty after loading new posts", () async {
  // Set up your mock and Fossil instance as before
  var timelinesApi = MockTimelinesV1Service();
  when(timelinesApi.lookupHomeTimeline(
        maxStatusId: null,
        minStatusId: null,
        limit: 20))
      .thenAnswer((_) async => futureMastodonResponse(
          status: HttpStatus.ok,
          data: [], // Empty list to simulate an empty timeline
          ));

  var mastodon = makeMockMastodonApi(timelines: timelinesApi);
  var fossil = Fossil(replaceApi: mastodon);
  fossil.authenticated = true;
  fossil.homeCursor = Fossil.cursorUninitialized; // Set homeCursor to cursorUninitialized

  var response = await fossil.getPrevHomePost();

  expect(response, null); // Expect null because the timeline is empty after loading new posts
});

test("getPrevHomePost returns null when no new posts are loaded", () async {
  // Set up your mock and Fossil instance as before
  var timelinesApi = MockTimelinesV1Service();
  when(timelinesApi.lookupHomeTimeline(
        maxStatusId: null,
        minStatusId: null,
        limit: 20))
      .thenAnswer((_) async => futureMastodonResponse(
          status: HttpStatus.ok,
          data: [], // Empty list to simulate no new posts
          ));

  var mastodon = makeMockMastodonApi(timelines: timelinesApi);
  var fossil = Fossil(replaceApi: mastodon);
  fossil.authenticated = true;
  fossil.homeCursor = 0; // Set homeCursor to 0

  var response = await fossil.getPrevHomePost();

  expect(response, null); // Expect null because no new posts are loaded
});

test("getPrevHomePost returns the first post when home cursor is at cursorEmptyTimeline", () async {
  // Set up your mock and Fossil instance as before
  var timelinesApi = MockTimelinesV1Service();
  when(timelinesApi.lookupHomeTimeline(
        maxStatusId: null,
        minStatusId: null,
        limit: 20))
      .thenAnswer((_) async => futureMastodonResponse(
          status: HttpStatus.ok,
          data: List<Status>.generate(5, (index) => (dummyStatus)), // Non-empty list to simulate a non-empty timeline
          ));

  var mastodon = makeMockMastodonApi(timelines: timelinesApi);
  var fossil = Fossil(replaceApi: mastodon);
  fossil.authenticated = true;
  fossil.homeCursor = Fossil.cursorEmptyTimeline; // Set homeCursor to cursorEmptyTimeline

  var response = await fossil.getPrevHomePost();

  expect(response, equals(dummyStatus)); // Expect the first post
});

test("getPrevHomePost returns null when home cursor is at cursorEmptyTimeline and home timeline is empty", () async {
  // Set up your mock and Fossil instance as before
  var timelinesApi = MockTimelinesV1Service();
  when(timelinesApi.lookupHomeTimeline(
        maxStatusId: null,
        minStatusId: null,
        limit: 20))
      .thenAnswer((_) async => futureMastodonResponse(
          status: HttpStatus.ok,
          data: [], // Empty list to simulate an empty timeline
          ));

  var mastodon = makeMockMastodonApi(timelines: timelinesApi);
  var fossil = Fossil(replaceApi: mastodon);
  fossil.authenticated = true;
  fossil.homeCursor = Fossil.cursorEmptyTimeline; // Set homeCursor to cursorEmptyTimeline

  var response = await fossil.getPrevHomePost();

  expect(response, null); // Expect null because the timeline is empty
});

test("getPrevHomePost sets homeCursor to 0 and returns the first post when home cursor is uninitialized and home timeline is not empty", () async {
  // Set up your mock and Fossil instance as before
  var timelinesApi = MockTimelinesV1Service();
  when(timelinesApi.lookupHomeTimeline(
        maxStatusId: null,
        minStatusId: null,
        limit: 20))
      .thenAnswer((_) async => futureMastodonResponse(
          status: HttpStatus.ok,
          data: List<Status>.generate(5, (index) => (dummyStatus)), // Non-empty list to simulate a non-empty timeline
          ));

  var mastodon = makeMockMastodonApi(timelines: timelinesApi);
  var fossil = Fossil(replaceApi: mastodon);
  fossil.authenticated = true;
  fossil.homeCursor = Fossil.cursorUninitialized; // Set homeCursor to cursorUninitialized

  var response = await fossil.getPrevHomePost();

  expect(fossil.homeCursor, 0); // Expect homeCursor to be 0
  expect(response, equals(dummyStatus)); // Expect the first post
});

//getNextHomeposts
 test("Not autheticated Unauthroized exception load new home posts" , () async {

  var timelinesApi = MockTimelinesV1Service();
  when(timelinesApi.lookupHomeTimeline(
        maxStatusId: anyNamed('maxStatusId'),
        minStatusId: anyNamed('minStatusId'),
        limit: anyNamed('limit')))
      .thenAnswer((_) async => futureMastodonResponse(
          data: List<Status>.generate(5, (index) => (dummyStatus),
          )));

      var mastodon = makeMockMastodonApi(timelines: timelinesApi);
      var fossil = Fossil(replaceApi: mastodon);
      fossil.authenticated = false;
      
      expect(() async => await fossil.getNextHomePost(), throwsA(isA<FossilUnauthorizedException>()));
  
});
test("getNextHomePost returns the first post when home cursor is uninitialized and home timeline is not empty", () async {
  // Set up your mock and Fossil instance as before
  var timelinesApi = MockTimelinesV1Service();
  when(timelinesApi.lookupHomeTimeline(
        maxStatusId: null,
        minStatusId: null,
        limit: 20))
      .thenAnswer((_) async => futureMastodonResponse(
          status: HttpStatus.ok,
          data: List<Status>.generate(5, (index) => (dummyStatus)), // Non-empty list to simulate a non-empty timeline
          ));

  var mastodon = makeMockMastodonApi(timelines: timelinesApi);
  var fossil = Fossil(replaceApi: mastodon);
  fossil.authenticated = true;
  fossil.homeCursor = Fossil.cursorUninitialized; // Set homeCursor to cursorUninitialized

  var response = await fossil.getNextHomePost();

  expect(fossil.homeCursor, 0); // Expect homeCursor to be 0
  expect(response, equals(dummyStatus)); // Expect the first post
});

test("getNextHomePost returns null when home cursor is at the end of home timeline and no older posts are loaded", () async {
  // Set up your mock and Fossil instance as before
  var timelinesApi = MockTimelinesV1Service();
  when(timelinesApi.lookupHomeTimeline(
        maxStatusId: null,
        minStatusId: null,
        limit: 20))
      .thenAnswer((_) async => futureMastodonResponse(
          status: HttpStatus.ok,
          data: [], // Empty list to simulate no older posts
          ));

  var mastodon = makeMockMastodonApi(timelines: timelinesApi);
  var fossil = Fossil(replaceApi: mastodon);
  fossil.authenticated = true;
  fossil.homeTimeline = List<Status>.generate(5, (index) => (dummyStatus)); // Set homeTimeline to a non-empty list
  fossil.homeCursor = fossil.homeTimeline.length - 1; // Set homeCursor to the end of homeTimeline

  var response = await fossil.getNextHomePost();

  expect(response, null); // Expect null because no older posts are loaded
});

test("getNextHomePost sets homeCursor to cursorEmptyTimeline when home timeline is empty after loading new posts", () async {
  // Set up your mock and Fossil instance as before
  var timelinesApi = MockTimelinesV1Service();
  when(timelinesApi.lookupHomeTimeline(
        maxStatusId: null,
        minStatusId: null,
        limit: 20))
      .thenAnswer((_) async => futureMastodonResponse(
          status: HttpStatus.ok,
          data: [], // Empty list to simulate an empty timeline
          ));

  var mastodon = makeMockMastodonApi(timelines: timelinesApi);
  var fossil = Fossil(replaceApi: mastodon);
  fossil.authenticated = true;
  fossil.homeCursor = Fossil.cursorUninitialized; // Set homeCursor to cursorUninitialized

  var response = await fossil.getNextHomePost();

  expect(fossil.homeCursor, equals(Fossil.cursorEmptyTimeline)); // Expect homeCursor to be cursorEmptyTimeline
  expect(response, null); // Expect null because the timeline is empty
});

test("getNextHomePost sets homeCursor to 0 and returns the first post when home cursor is at cursorEmptyTimeline and home timeline is not empty after loading new posts", () async {
  // Set up your mock and Fossil instance as before
  var timelinesApi = MockTimelinesV1Service();
  when(timelinesApi.lookupHomeTimeline(
        maxStatusId: null,
        minStatusId: null,
        limit: 20))
      .thenAnswer((_) async => futureMastodonResponse(
          status: HttpStatus.ok,
          data: List<Status>.generate(5, (index) => (dummyStatus)), // Non-empty list to simulate a non-empty timeline
          ));

  var mastodon = makeMockMastodonApi(timelines: timelinesApi);
  var fossil = Fossil(replaceApi: mastodon);
  fossil.authenticated = true;
  fossil.homeCursor = Fossil.cursorEmptyTimeline; // Set homeCursor to cursorEmptyTimeline

  var response = await fossil.getNextHomePost();

  expect(fossil.homeCursor, 0); // Expect homeCursor to be 0
  expect(response, equals(dummyStatus)); // Expect the first post
});

test("getNextHomePost increments homeCursor and returns the next post when home cursor is not at the end of home timeline", () async {
  // Set up your mock and Fossil instance as before
  var timelinesApi = MockTimelinesV1Service();
  when(timelinesApi.lookupHomeTimeline(
        maxStatusId: null,
        minStatusId: null,
        limit: 20))
      .thenAnswer((_) async => futureMastodonResponse(
          status: HttpStatus.ok,
          data: List<Status>.generate(5, (index) => (dummyStatus)), // Non-empty list to simulate a non-empty timeline
          ));

  var mastodon = makeMockMastodonApi(timelines: timelinesApi);
  var fossil = Fossil(replaceApi: mastodon);
  fossil.authenticated = true;
  fossil.homeTimeline = List<Status>.generate(5, (index) => (dummyStatus)); // Set homeTimeline to a non-empty list
  fossil.homeCursor = 0; // Set homeCursor to the start of homeTimeline

  var response = await fossil.getNextHomePost();

  expect(fossil.homeCursor, 1); // Expect homeCursor to be incremented
  expect(response, equals(dummyStatus)); // Expect the next post
});

//JumpToHomePost
 test("Not autheticated Unauthroized exception load new home posts" , () async {

  var timelinesApi = MockTimelinesV1Service();
  when(timelinesApi.lookupHomeTimeline(
        maxStatusId: anyNamed('maxStatusId'),
        minStatusId: anyNamed('minStatusId'),
        limit: anyNamed('limit')))
      .thenAnswer((_) async => futureMastodonResponse(
          data: List<Status>.generate(5, (index) => (dummyStatus),
          )));

      var mastodon = makeMockMastodonApi(timelines: timelinesApi);
      var fossil = Fossil(replaceApi: mastodon);
      fossil.authenticated = false;
      
      expect(() async => await fossil.jumpToHomeTop(), throwsA(isA<FossilUnauthorizedException>()));
  
});

test("jumpToHomeTop sets homeCursor to cursorEmptyTimeline and returns null when home cursor is uninitialized and no new posts are loaded", () async {
  // Set up your mock and Fossil instance as before
  var timelinesApi = MockTimelinesV1Service();
  when(timelinesApi.lookupHomeTimeline(
        maxStatusId: null,
        minStatusId: null,
        limit: 20))
      .thenAnswer((_) async => futureMastodonResponse(
          status: HttpStatus.ok,
          data: [], // Empty list to simulate no new posts
          ));

  var mastodon = makeMockMastodonApi(timelines: timelinesApi);
  var fossil = Fossil(replaceApi: mastodon);
  fossil.authenticated = true;
  fossil.homeCursor = Fossil.cursorUninitialized; // Set homeCursor to cursorUninitialized

  var response = await fossil.jumpToHomeTop();

  expect(fossil.homeCursor, equals(Fossil.cursorEmptyTimeline)); // Expect homeCursor to be cursorEmptyTimeline
  expect(response, null); // Expect null because no new posts are loaded
});

test("jumpToHomeTop sets homeCursor to 0 and returns the first post when home cursor is uninitialized and new posts are loaded", () async {
  // Set up your mock and Fossil instance as before
  var timelinesApi = MockTimelinesV1Service();
  when(timelinesApi.lookupHomeTimeline(
        maxStatusId: null,
        minStatusId: null,
        limit: 20))
      .thenAnswer((_) async => futureMastodonResponse(
          status: HttpStatus.ok,
          data: List<Status>.generate(5, (index) => (dummyStatus)), // Non-empty list to simulate new posts
          ));

  var mastodon = makeMockMastodonApi(timelines: timelinesApi);
  var fossil = Fossil(replaceApi: mastodon);
  fossil.authenticated = true;
  fossil.homeCursor = Fossil.cursorUninitialized; // Set homeCursor to cursorUninitialized

  var response = await fossil.jumpToHomeTop();

  expect(fossil.homeCursor, 0); // Expect homeCursor to be 0
  expect(response, equals(dummyStatus)); // Expect the first post
});



//Public timelines
group('Public timelines', () {
  
  test("Not authenticated Unauthorized exception load old public posts", () async {
    var timelinesApi = MockTimelinesV1Service();
    when(timelinesApi.lookupPublicTimeline(
          maxStatusId: anyNamed('maxStatusId'),
          minStatusId: anyNamed('minStatusId'),
          limit: anyNamed('limit')))
        .thenAnswer((_) async => futureMastodonResponse(
            data: List<Status>.generate(5, (index) => (dummyStatus),
            )));

    var mastodon = makeMockMastodonApi(timelines: timelinesApi);
    var fossil = Fossil(replaceApi: mastodon);
    fossil.authenticated = false;
        
    expect(() async => await fossil.loadOldPublicPosts(), throwsA(isA<FossilUnauthorizedException>()));
  });

  test("If status is not ok new oldpublicimeline" , () async {

  var timelinesApi = MockTimelinesV1Service();
  when(timelinesApi.lookupPublicTimeline(
        maxStatusId: null,
        minStatusId: null,
        limit: 20))
      .thenAnswer((_) async => futureMastodonResponse(
          status: HttpStatus.badRequest,
          data: List<Status>.generate(5, (index) => (dummyStatus)),
          ));
          

      var mastodon = makeMockMastodonApi(timelines: timelinesApi);
      var fossil = Fossil(replaceApi: mastodon);
      fossil.authenticated = true;
      
     expect(() async => await fossil.loadOldPublicPosts(),throwsA(isA<FossilException>()));

});

  test("loadOldPublicPosts updates publicTimeline and returns correct number of statuses", () async {
    var timelinesApi = MockTimelinesV1Service();
    when(timelinesApi.lookupPublicTimeline(
          maxStatusId: anyNamed('maxStatusId'),
          minStatusId: anyNamed('minStatusId'),
          limit: anyNamed('limit')))
        .thenAnswer((_) async => futureMastodonResponse(
            data: List<Status>.generate(5, (index) => (dummyStatus),
            )));

    var mastodon = makeMockMastodonApi(timelines: timelinesApi);
    var fossil = Fossil(replaceApi: mastodon);
    fossil.authenticated = true;
        
    var result = await fossil.loadOldPublicPosts();
    expect(result, 5);
    expect(fossil.publicTimeline.length, 5);
  });

  //New Public Timeline
  test("Not authenticated Unauthorized exception load new public posts", () async {
    var timelinesApi = MockTimelinesV1Service();
    when(timelinesApi.lookupPublicTimeline(
          maxStatusId: anyNamed('maxStatusId'),
          minStatusId: anyNamed('minStatusId'),
          limit: anyNamed('limit')))
        .thenAnswer((_) async => futureMastodonResponse(
            data: List<Status>.generate(5, (index) => (dummyStatus),
            )));

    var mastodon = makeMockMastodonApi(timelines: timelinesApi);
    var fossil = Fossil(replaceApi: mastodon);
    fossil.authenticated = false;
        
    expect(() async => await fossil.loadNewPublicPosts(), throwsA(isA<FossilUnauthorizedException>()));
  });

   test("If status is not ok new newpublicimeline" , () async {

  var timelinesApi = MockTimelinesV1Service();
  when(timelinesApi.lookupPublicTimeline(
        maxStatusId: null,
        minStatusId: null,
        limit: 20))
      .thenAnswer((_) async => futureMastodonResponse(
          status: HttpStatus.badRequest,
          data: List<Status>.generate(5, (index) => (dummyStatus)),
          ));
          

      var mastodon = makeMockMastodonApi(timelines: timelinesApi);
      var fossil = Fossil(replaceApi: mastodon);
      fossil.authenticated = true;
      
     expect(() async => await fossil.loadNewPublicPosts(),throwsA(isA<FossilException>()));

  });

  test("If status is ok new public timeline" , () async {
  var timelinesApi = MockTimelinesV1Service();
  when(timelinesApi.lookupPublicTimeline(
        maxStatusId: null,
        minStatusId: null,
        limit: 20))
      .thenAnswer((_) async => futureMastodonResponse(
          status: HttpStatus.ok,
          data: List<Status>.generate(5, (index) => (dummyStatus)),
          ));
          
  var mastodon = makeMockMastodonApi(timelines: timelinesApi);
  var fossil = Fossil(replaceApi: mastodon);
  fossil.authenticated = true;
  
  var response = await fossil.loadNewPublicPosts();
  
  expect(response, 5); // assuming that 5 new posts are returned
});


test("publicCursor is updated correctly when timeline is empty", () async {
  var timelinesApi = MockTimelinesV1Service();
  when(timelinesApi.lookupPublicTimeline(
        maxStatusId: null,
        minStatusId: null,
        limit: 20))
      .thenAnswer((_) async => futureMastodonResponse(
          status: HttpStatus.ok,
          data: [], // Empty list to simulate an empty timeline
          ));

  var mastodon = makeMockMastodonApi(timelines: timelinesApi);
  var fossil = Fossil(replaceApi: mastodon);
  fossil.authenticated = true;
  fossil.publicCursor = Fossil.cursorEmptyTimeline; // Set publicCursor to cursorEmptyTimeline

  await fossil.loadNewPublicPosts();

  expect(fossil.publicCursor, 0); // Expect publicCursor to be 0
});

test("publicCursor is updated correctly when timeline is not empty", () async {
  var timelinesApi = MockTimelinesV1Service();
  when(timelinesApi.lookupPublicTimeline(
        maxStatusId: null,
        minStatusId: null,
        limit: 20))
      .thenAnswer((_) async => futureMastodonResponse(
          status: HttpStatus.ok,
          data: List<Status>.generate(5, (index) => (dummyStatus)), // Non-empty list to simulate a non-empty timeline
          ));

  var mastodon = makeMockMastodonApi(timelines: timelinesApi);
  var fossil = Fossil(replaceApi: mastodon);
  fossil.authenticated = true;
  fossil.publicCursor = 0; // Set publicCursor to a value that's not cursorEmptyTimeline

  await fossil.loadNewPublicPosts();

  expect(fossil.publicCursor, 5); // Expect publicCursor to be incremented by the number of new statuses
});

//getPrevPublicPosts

test("Not authenticated Unauthorized exception load new public posts", () async {
  var timelinesApi = MockTimelinesV1Service();
  when(timelinesApi.lookupPublicTimeline(
        maxStatusId: anyNamed('maxStatusId'),
        minStatusId: anyNamed('minStatusId'),
        limit: anyNamed('limit')))
      .thenAnswer((_) async => futureMastodonResponse(
          data: List<Status>.generate(5, (index) => (dummyStatus),
          )));

  var mastodon = makeMockMastodonApi(timelines: timelinesApi);
  var fossil = Fossil(replaceApi: mastodon);
  fossil.authenticated = false;
      
  expect(() async => await fossil.getPrevPublicPost(), throwsA(isA<FossilUnauthorizedException>()));
});
test("getPrevPublicPost returns the previous post when public timeline is not empty", () async {
  var timelinesApi = MockTimelinesV1Service();
  when(timelinesApi.lookupPublicTimeline(
        maxStatusId: null,
        minStatusId: null,
        limit: 20))
      .thenAnswer((_) async => futureMastodonResponse(
          status: HttpStatus.ok,
          data: List<Status>.generate(5, (index) => (dummyStatus)), // Non-empty list to simulate a non-empty timeline
          ));

  var mastodon = makeMockMastodonApi(timelines: timelinesApi);
  var fossil = Fossil(replaceApi: mastodon);
  fossil.authenticated = true;

  // First, load new public posts
  await fossil.loadNewPublicPosts();

  // Set publicCursor to a value that's not cursorUninitialized or cursorEmptyTimeline
  fossil.publicCursor = 1; 

  // Call getPrevPublicPost and expect it to return the previous post
  var response = await fossil.getPrevPublicPost();

  expect(response, equals(dummyStatus)); // Expect the previous post
});

test("getPrevPublicPost returns null when no new posts are loaded", () async {
  var timelinesApi = MockTimelinesV1Service();
  when(timelinesApi.lookupPublicTimeline(
        maxStatusId: null,
        minStatusId: null,
        limit: 20))
      .thenAnswer((_) async => futureMastodonResponse(
          status: HttpStatus.ok,
          data: [], // Empty list to simulate no new posts
          ));

  var mastodon = makeMockMastodonApi(timelines: timelinesApi);
  var fossil = Fossil(replaceApi: mastodon);
  fossil.authenticated = true;
  fossil.publicCursor = 0; // Set publicCursor to 0

  var response = await fossil.getPrevPublicPost();

  expect(response, null); // Expect null because no new posts are loaded
});

test("getPrevPublicPost returns the first post when public cursor is at cursorEmptyTimeline", () async {
  var timelinesApi = MockTimelinesV1Service();
  when(timelinesApi.lookupPublicTimeline(
        maxStatusId: null,
        minStatusId: null,
        limit: 20))
      .thenAnswer((_) async => futureMastodonResponse(
          status: HttpStatus.ok,
          data: List<Status>.generate(5, (index) => (dummyStatus)), // Non-empty list to simulate a non-empty timeline
          ));

  var mastodon = makeMockMastodonApi(timelines: timelinesApi);
  var fossil = Fossil(replaceApi: mastodon);
  fossil.authenticated = true;
  fossil.publicCursor = Fossil.cursorEmptyTimeline; // Set publicCursor to cursorEmptyTimeline

  var response = await fossil.getPrevPublicPost();

  expect(response, equals(dummyStatus)); // Expect the first post
});

test("getPrevPublicPost returns null when public cursor is at cursorEmptyTimeline and public timeline is empty", () async {
  var timelinesApi = MockTimelinesV1Service();
  when(timelinesApi.lookupPublicTimeline(
        maxStatusId: null,
        minStatusId: null,
        limit: 20))
      .thenAnswer((_) async => futureMastodonResponse(
          status: HttpStatus.ok,
          data: [], // Empty list to simulate an empty timeline
          ));

  var mastodon = makeMockMastodonApi(timelines: timelinesApi);
  var fossil = Fossil(replaceApi: mastodon);
  fossil.authenticated = true;
  fossil.publicCursor = Fossil.cursorEmptyTimeline; // Set publicCursor to cursorEmptyTimeline

  var response = await fossil.getPrevPublicPost();

  expect(response, null); // Expect null because the timeline is empty
});

test("getPrevPublicPost returns null when public timeline is uninitialized and empty after loading new posts", () async {
  var timelinesApi = MockTimelinesV1Service();
  when(timelinesApi.lookupPublicTimeline(
        maxStatusId: null,
        minStatusId: null,
        limit: 20))
      .thenAnswer((_) async => futureMastodonResponse(
          status: HttpStatus.ok,
          data: [], // Empty list to simulate an empty timeline
          ));

  var mastodon = makeMockMastodonApi(timelines: timelinesApi);
  var fossil = Fossil(replaceApi: mastodon);
  fossil.authenticated = true;
  fossil.publicCursor = Fossil.cursorUninitialized; // Set publicCursor to cursorUninitialized

  var response = await fossil.getPrevPublicPost();

  expect(response, null); // Expect null because the timeline is empty
  expect(fossil.publicCursor, equals(Fossil.cursorEmptyTimeline)); // Expect publicCursor to be cursorEmptyTimeline
});

test("getPrevPublicPost returns the first post when public timeline is uninitialized and not empty after loading new posts", () async {
  var timelinesApi = MockTimelinesV1Service();
  when(timelinesApi.lookupPublicTimeline(
        maxStatusId: null,
        minStatusId: null,
        limit: 20))
      .thenAnswer((_) async => futureMastodonResponse(
          status: HttpStatus.ok,
          data: List<Status>.generate(5, (index) => (dummyStatus)), // Non-empty list to simulate a non-empty timeline
          ));

  var mastodon = makeMockMastodonApi(timelines: timelinesApi);
  var fossil = Fossil(replaceApi: mastodon);
  fossil.authenticated = true;
  fossil.publicCursor = Fossil.cursorUninitialized; // Set publicCursor to cursorUninitialized

  var response = await fossil.getPrevPublicPost();

  expect(response, equals(dummyStatus)); // Expect the first post
  expect(fossil.publicCursor, equals(0)); // Expect publicCursor to be 0
});

//GetNextPublicPost
test("getNextPublicPost throws FossilUnauthorizedException when not authenticated", () async {
  var fossil = Fossil();
  fossil.authenticated = false;

  expect(() async => await fossil.getNextPublicPost(), throwsA(isA<FossilUnauthorizedException>()));
});

test("getNextPublicPost returns null and sets publicCursor to cursorEmptyTimeline when public timeline is uninitialized and empty after loading old posts", () async {
  var timelinesApi = MockTimelinesV1Service();
  when(timelinesApi.lookupPublicTimeline(
        maxStatusId: null,
        minStatusId: null,
        limit: 20))
      .thenAnswer((_) async => futureMastodonResponse(
          status: HttpStatus.ok,
          data: [], // Empty list to simulate an empty timeline
          ));

  var mastodon = makeMockMastodonApi(timelines: timelinesApi);
  var fossil = Fossil(replaceApi: mastodon);
  fossil.authenticated = true;
  fossil.publicCursor = Fossil.cursorUninitialized; // Set publicCursor to cursorUninitialized

  var response = await fossil.getNextPublicPost();

  expect(response, null); // Expect null because the timeline is empty
  expect(fossil.publicCursor, equals(Fossil.cursorEmptyTimeline)); // Expect publicCursor to be cursorEmptyTimeline
});

test("getNextPublicPost returns the first post and sets publicCursor to 0 when public timeline is uninitialized and not empty after loading old posts", () async {
  var timelinesApi = MockTimelinesV1Service();
  when(timelinesApi.lookupPublicTimeline(
        maxStatusId: null,
        minStatusId: null,
        limit: 20))
      .thenAnswer((_) async => futureMastodonResponse(
          status: HttpStatus.ok,
          data: List<Status>.generate(5, (index) => (dummyStatus)), // Non-empty list to simulate a non-empty timeline
          ));

  var mastodon = makeMockMastodonApi(timelines: timelinesApi);
  var fossil = Fossil(replaceApi: mastodon);
  fossil.authenticated = true;
  fossil.publicCursor = Fossil.cursorUninitialized; // Set publicCursor to cursorUninitialized

  var response = await fossil.getNextPublicPost();

  expect(response, equals(dummyStatus)); // Expect the first post
  expect(fossil.publicCursor, equals(0)); // Expect publicCursor to be 0
});

test("getNextPublicPost returns null when public timeline is empty and publicCursor is cursorEmptyTimeline after loading new posts", () async {
  var timelinesApi = MockTimelinesV1Service();
  when(timelinesApi.lookupPublicTimeline(
        maxStatusId: null,
        minStatusId: null,
        limit: 20))
      .thenAnswer((_) async => futureMastodonResponse(
          status: HttpStatus.ok,
          data: [], // Empty list to simulate an empty timeline
          ));

  var mastodon = makeMockMastodonApi(timelines: timelinesApi);
  var fossil = Fossil(replaceApi: mastodon);
  fossil.authenticated = true;
  fossil.publicCursor = Fossil.cursorEmptyTimeline; // Set publicCursor to cursorEmptyTimeline

  var response = await fossil.getNextPublicPost();

  expect(response, null); // Expect null because the timeline is empty
});

test("getNextPublicPost returns the first post and sets publicCursor to 0 when public timeline is not empty and publicCursor is cursorEmptyTimeline after loading new posts", () async {
  var timelinesApi = MockTimelinesV1Service();
  when(timelinesApi.lookupPublicTimeline(
        maxStatusId: null,
        minStatusId: null,
        limit: 20))
      .thenAnswer((_) async => futureMastodonResponse(
          status: HttpStatus.ok,
          data: List<Status>.generate(5, (index) => (dummyStatus)), // Non-empty list to simulate a non-empty timeline
          ));

  var mastodon = makeMockMastodonApi(timelines: timelinesApi);
  var fossil = Fossil(replaceApi: mastodon);
  fossil.authenticated = true;
  fossil.publicCursor = Fossil.cursorEmptyTimeline; // Set publicCursor to cursorEmptyTimeline

  var response = await fossil.getNextPublicPost();

  expect(response, equals(dummyStatus)); // Expect the first post
  expect(fossil.publicCursor, equals(0)); // Expect publicCursor to be 0
});

test("getNextPublicPost returns the next post and increments publicCursor when publicCursor is not at the end of publicTimeline", () async {
  var mastodon = makeMockMastodonApi();
  var fossil = Fossil(replaceApi: mastodon);
  fossil.authenticated = true;
  fossil.publicTimeline = List<Status>.generate(5, (index) => (dummyStatus)); // Non-empty publicTimeline
  fossil.publicCursor = 0; // Set publicCursor to the start of publicTimeline

  var response = await fossil.getNextPublicPost();

  expect(response, equals(dummyStatus)); // Expect the next post
  expect(fossil.publicCursor, equals(1)); // Expect publicCursor to be incremented
});

test("getNextPublicPost returns null when publicCursor is at the end of publicTimeline and no older posts are loaded", () async {
  var timelinesApi = MockTimelinesV1Service();
  when(timelinesApi.lookupPublicTimeline(
        maxStatusId: null,
        minStatusId: null,
        limit: 20))
      .thenAnswer((_) async => futureMastodonResponse(
          status: HttpStatus.ok,
          data: [], // Empty list to simulate no older posts
          ));

  var mastodon = makeMockMastodonApi(timelines: timelinesApi);
  var fossil = Fossil(replaceApi: mastodon);
  fossil.authenticated = true;
  fossil.publicTimeline = List<Status>.generate(5, (index) => (dummyStatus)); // Non-empty publicTimeline
  fossil.publicCursor = fossil.publicTimeline.length - 1; // Set publicCursor to the end of publicTimeline

  var response = await fossil.getNextPublicPost();

  expect(response, null); // Expect null because no older posts are loaded
});

//JumpToPublicPost
test("jumpToPublicTop throws FossilUnauthorizedException when not authenticated", () async {
  var fossil = Fossil();
  fossil.authenticated = false;

  expect(() async => await fossil.jumpToPublicTop(), throwsA(isA<FossilUnauthorizedException>()));
});

test("jumpToPublicTop returns an empty list and sets publicCursor to cursorEmptyTimeline when publicCursor is cursorUninitialized and no new posts are loaded", () async {
  var timelinesApi = MockTimelinesV1Service();
  when(timelinesApi.lookupPublicTimeline(
        maxStatusId: null,
        minStatusId: null,
        limit: 20))
      .thenAnswer((_) async => futureMastodonResponse(
          status: HttpStatus.ok,
          data: [], // Empty list to simulate no new posts
          ));

  var mastodon = makeMockMastodonApi(timelines: timelinesApi);
  var fossil = Fossil(replaceApi: mastodon);
  fossil.authenticated = true;
  fossil.publicCursor = Fossil.cursorUninitialized; // Set publicCursor to cursorUninitialized

  var response = await fossil.jumpToPublicTop();

  expect(response, isEmpty); // Expect an empty list because no new posts are loaded
  expect(fossil.publicCursor, equals(Fossil.cursorEmptyTimeline)); // Expect publicCursor to be cursorEmptyTimeline
});

test("jumpToPublicTop returns an empty list when publicCursor is cursorEmptyTimeline and no new posts are loaded", () async {
  var timelinesApi = MockTimelinesV1Service();
  when(timelinesApi.lookupPublicTimeline(
        maxStatusId: null,
        minStatusId: null,
        limit: 20))
      .thenAnswer((_) async => futureMastodonResponse(
          status: HttpStatus.ok,
          data: [], // Empty list to simulate no new posts
          ));

  var mastodon = makeMockMastodonApi(timelines: timelinesApi);

  // Create a subclass of Fossil where loadNewPublicPosts always returns 0
  var fossil = Fossil(replaceApi: mastodon);
  fossil.authenticated = true;
  fossil.publicCursor = Fossil.cursorEmptyTimeline; // Set publicCursor to cursorEmptyTimeline

  var response = await fossil.jumpToPublicTop();

  expect(response, isEmpty); // Expect an empty list because no new posts are loaded
});

test("jumpToPublicTop returns the publicTimeline and sets publicCursor to 0 when new posts are loaded", () async {
  var timelinesApi = MockTimelinesV1Service();
  when(timelinesApi.lookupPublicTimeline(
        maxStatusId: null,
        minStatusId: null,
        limit: 20))
      .thenAnswer((_) async => futureMastodonResponse(
          status: HttpStatus.ok,
          data: List<Status>.generate(5, (index) => (dummyStatus)), // Non-empty list to simulate new posts
          ));

  var mastodon = makeMockMastodonApi(timelines: timelinesApi);
  var fossil = Fossil(replaceApi: mastodon);
  fossil.authenticated = true;

  var response = await fossil.jumpToPublicTop();

  expect(response, equals(fossil.publicTimeline)); // Expect the publicTimeline because new posts are loaded
  expect(fossil.publicCursor, equals(0)); // Expect publicCursor to be 0
});


});


group('Fossil tests for Favorite', () {
  test('favorite returns the favorited status when successful', () async {
    var statusesApi = MockStatusesV1Service();
    Status favoritedStatus = dummyStatus.copyWith(isFavourited: true);

    when(statusesApi.createFavourite(statusId: "123"))
        .thenAnswer((realInvocation) async => futureMastodonResponse(
            status: HttpStatus.ok,
            data: favoritedStatus,
            ));

    var mastodon = makeMockMastodonApi(statuses: statusesApi);
    var fossil = Fossil(replaceApi: mastodon);
    fossil.authenticated = true;
    
    var status = await fossil.favorite("123");

    expect(status.isFavourited, isTrue);
  });

  test('favorite throws FossilUnauthorizedException when not authenticated', () async {
    var fossil = Fossil();
    fossil.authenticated = false;

    expect(() async => await fossil.favorite("123"), throwsA(isA<FossilUnauthorizedException>()));
  });

  test('favorite throws FossilException when status is not ok', () async {
    var statusesApi = MockStatusesV1Service();
    when(statusesApi.createFavourite(statusId: "123"))
        .thenAnswer((realInvocation) async => futureMastodonResponse(
            status: HttpStatus.badRequest,
            data: dummyStatus,
            ));

    var mastodon = makeMockMastodonApi(statuses: statusesApi);
    var fossil = Fossil(replaceApi: mastodon);
    fossil.authenticated = true;

    expect(() async => await fossil.favorite("123"), throwsA(isA<FossilException>()));
  });

  // Add more tests here
});

group('Fossil tests for unfavorite', () { 
  test('unfavorite returns the unfavorited status when successful', () async {
    var statusesApi = MockStatusesV1Service();
    Status unfavoritedStatus = dummyStatus.copyWith(isFavourited: false);

    when(statusesApi.destroyFavourite(statusId: "123"))
        .thenAnswer((realInvocation) async => futureMastodonResponse(
            status: HttpStatus.ok,
            data: unfavoritedStatus,
            ));

    var mastodon = makeMockMastodonApi(statuses: statusesApi);
    var fossil = Fossil(replaceApi: mastodon);
    fossil.authenticated = true;
    
    var status = await fossil.destroyFavorite("123");

    expect(status.isFavourited, isFalse);
  });

  test('unfavorite throws FossilUnauthorizedException when not authenticated', () async {
    var fossil = Fossil();
    fossil.authenticated = false;

    expect(() async => await fossil.destroyFavorite("123"), throwsA(isA<FossilUnauthorizedException>()));
  });

  test('unfavorite throws FossilException when status is not ok', () async {
    var statusesApi = MockStatusesV1Service();
    when(statusesApi.destroyFavourite(statusId: "123"))
        .thenAnswer((realInvocation) async => futureMastodonResponse(
            status: HttpStatus.badRequest,
            data: dummyStatus,
            ));

    var mastodon = makeMockMastodonApi(statuses: statusesApi);
    var fossil = Fossil(replaceApi: mastodon);
    fossil.authenticated = true;

    expect(() async => await fossil.destroyFavorite("123"), throwsA(isA<FossilException>()));
  });
});
group('Reblog', () { 
  test('reblog returns the reblogged status when successful', () async {
    var statusesApi = MockStatusesV1Service();
    Status rebloggedStatus = dummyStatus.copyWith(isReblogged: true);

    when(statusesApi.createReblog(statusId: "123"))
        .thenAnswer((realInvocation) async => futureMastodonResponse(
            status: HttpStatus.ok,
            data: rebloggedStatus,
            ));

    var mastodon = makeMockMastodonApi(statuses: statusesApi);
    var fossil = Fossil(replaceApi: mastodon);
    fossil.authenticated = true;
    
    var status = await fossil.createReblog("123");

    expect(status.isReblogged, isTrue);
  
  });

  test('reblog throws FossilUnauthorizedException when not authenticated', () async {
    var fossil = Fossil();
    fossil.authenticated = false;

    expect(() async => await fossil.createReblog("123"), throwsA(isA<FossilUnauthorizedException>()));
  });

  test('reblog throws FossilException when status is not ok', () async {
    var statusesApi = MockStatusesV1Service();
    when(statusesApi.createReblog(statusId: "123"))
        .thenAnswer((realInvocation) async => futureMastodonResponse(
            status: HttpStatus.badRequest,
            data: dummyStatus,
            ));

    var mastodon = makeMockMastodonApi(statuses: statusesApi);
    var fossil = Fossil(replaceApi: mastodon);
    fossil.authenticated = true;

    expect(() async => await fossil.createReblog("123"), throwsA(isA<FossilException>()));
  });

});

group('RemoveReblog', () { 
  test('removeReblog returns the unreblogged status when successful', () async {
    var statusesApi = MockStatusesV1Service();
    Status unrebloggedStatus = dummyStatus.copyWith(isReblogged: false);

    when(statusesApi.destroyReblog(statusId: "123"))
        .thenAnswer((realInvocation) async => futureMastodonResponse(
            status: HttpStatus.ok,
            data: unrebloggedStatus,
            ));

    var mastodon = makeMockMastodonApi(statuses: statusesApi);
    var fossil = Fossil(replaceApi: mastodon);
    fossil.authenticated = true;
    
    var status = await fossil.destroyReblog("123");

    expect(status.isReblogged, isFalse);
  });

  test('removeReblog throws FossilUnauthorizedException when not authenticated', () async {
    var fossil = Fossil();
    fossil.authenticated = false;

    expect(() async => await fossil.destroyReblog("123"), throwsA(isA<FossilUnauthorizedException>()));
  });

  test('removeReblog throws FossilException when status is not ok', () async {
    var statusesApi = MockStatusesV1Service();
    when(statusesApi.destroyReblog(statusId: "123"))
        .thenAnswer((realInvocation) async => futureMastodonResponse(
            status: HttpStatus.badRequest,
            data: dummyStatus,
            ));

    var mastodon = makeMockMastodonApi(statuses: statusesApi);
    var fossil = Fossil(replaceApi: mastodon);
    fossil.authenticated = true;

    expect(() async => await fossil.destroyReblog("123"), throwsA(isA<FossilException>()));
  });

});



}




 

 


  // Add more test cases for other methods as needed