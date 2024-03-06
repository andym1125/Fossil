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

}
 

 


  // Add more test cases for other methods as needed