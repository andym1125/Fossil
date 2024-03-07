import 'package:mastodon_api/mastodon_api.dart';
import 'package:mockito/annotations.dart';

@GenerateNiceMocks([MockSpec<TimelinesV1Service>(), MockSpec<StatusesV1Service>()])
import 'timeline_test.mocks.dart';