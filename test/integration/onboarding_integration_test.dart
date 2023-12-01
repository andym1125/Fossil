import 'package:flutter_test/flutter_test.dart';
import 'package:fossil/fossil.dart';
import 'package:mastodon_api/mastodon_api.dart';

void main() {
  if(const String.fromEnvironment("TEST_INTEGRATION").toLowerCase() != "true") {
    return;
  }

  test('Create an account', () async {
    var fossil = Fossil();
    expect(await fossil.createAccount("aaaa10", "aaaa10@andymcdowall.com", "!1Asdfgh4jkl"), HttpStatus.ok);
  });

  // test('Login to an account', () async {
  //   var fossil = Fossil();
  //   expect(await fossil.login(
  // })
} 