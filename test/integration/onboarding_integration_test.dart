import 'package:flutter_test/flutter_test.dart';
import 'package:fossil/fossil.dart';
import 'package:mastodon_api/mastodon_api.dart';

void main() {
  test('Create an account', () async {
    var fossil = Fossil();
    expect(await fossil.createAccount("andy3952922334410", "20ia1w5tb10@duck.com", "!1Asdfgh4jkl"), HttpStatus.ok);
  });
} 