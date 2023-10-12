import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Accessing public environment variables', () {
    var myEnvironmentVariable = const String.fromEnvironment('MASTODON_DEFAULT_INSTANCE_DOMAIN', defaultValue: "");
    expect(myEnvironmentVariable, isNotNull);
    expect(myEnvironmentVariable, isNotEmpty);
  });

  test('Accessing environment variable secrets', () {
    var myEnvironmentVariable = const String.fromEnvironment('MASTODON_DEFAULT_INSTANCE_BEARER_TOKEN', defaultValue: "");
    expect(myEnvironmentVariable, isNotNull);
    expect(myEnvironmentVariable, isNotEmpty);
  });

}
