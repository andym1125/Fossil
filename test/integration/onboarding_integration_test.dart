import 'package:flutter_test/flutter_test.dart';
import 'package:fossil/fossil.dart';
import 'package:mastodon_api/mastodon_api.dart';

void main() {
  test('Create an account', () async {
    var fossil = Fossil();
    expect(await fossil.createAccount("aaaa4", "aaaa4@andymcdowall.com", "!1Asdfgh4jkl"), HttpStatus.ok);
  });
} 