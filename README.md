# Fossil

A client for the Mastodon microblogging platform.

## Set up your Environment

Ensure you have:

Flutter (v3.13.6) w Android Studio Emulator:
https://docs.flutter.dev/get-started/install
https://docs.flutter.dev/get-started/install/macos#android-setup

Dart (v3.1.3):
https://dart.dev/get-dart

Visual Studio Code w/ Flutter Extension (for editor):
https://docs.flutter.dev/get-started/editor

Troubleshooting:

After all this, you can ensure your installation is correct by running `flutter doctor`. Don't worry if Chrome isn't installed, but all the other options should have green checkmarks next to them. If Flutter has a yellow checkmark, your PATH may be misconfigured. Follow the given instructions.

You can also verify through flutter --version. It may look something like the following:

```
% flutter --version
Flutter 3.13.6 • channel stable • https://github.com/flutter/flutter.git
Framework • revision ead455963c (12 days ago) • 2023-09-26 18:28:17 -0700
Engine • revision a794cf2681
Tools • Dart 3.1.3 • DevTools 2.25.0
```

In particular, look for Flutter v3.13.6 and Dart v3.1.3

## Getting Started

Download the code locally:
```
git clone https://github.com/andym1125/Fossil
cd Fossil
```

Configure the secrets. Run the following to rename the secrets file:
 ```
 mv secrets.json.example secrets.json
 ```
Then, fill in the `MASTODON_DEFAULT_INSTANCE_BEARER_TOKEN` with your bearer token.

To install dependencies:
 ```
 flutter pub get
 ```

To run the project, first open your emulator. Then run:
 ```
 flutter run --dart-define-from-file=env.json --dart-define-from-file=secrets.json
 ```

If you've configured your emulator and environment variable properly, it should automatically open your emulator.

## Testing locally

To test locally, run:
```
flutter test --dart-define-from-file=env.json --dart-define-from-file=secrets.json
```

To run coverage, ensure lcov is installed. `brew install lcov`
```
flutter test --coverage --dart-define-from-file=env.json --dart-define-from-file=secrets.json
genhtml coverage/lcov.info -o coverage/html
```

## Explanation of repository

For the most part, this repo follows Flutter project conventions.

### env.json
This file contains public configuration details which should be included as environment variables.

### secret.json (secret.json.example as the example)
secret.json is excluded in .gitignore. This file contains secret configurations, such as bearer tokens. For how to configure secret.json, see `Getting Started`

## General Troubleshooting

### Expired Mastodon Certificate

Renew the certificate:
```
sudo systemctl stop mastodon-sidekiq
sudo systemctl stop mastodon-streaming
sudo systemctl stop mastodon-web
sudo systemctl stop nginx
sudo systemctl stop certbot //optional

sudo certbot renew

sudo systemctl stop certbot //optional
sudo systemctl stop nginx
sudo systemctl start mastodon-sidekiq
sudo systemctl start mastodon-streaming
sudo systemctl start mastodon-web
```

## Contributing

Develop on a branch named YourName/FeatureName. For example, andy/readme-update. When your branch is ready to review, submit a pull request. If any available testing fails, you PR will not be approved. Ensure your changes are sufficiently tested. At least one approval is necessary. 

To generate a Mockito mock based on something, add a line similar to:

```dart
//From time_test.dart
@GenerateNiceMocks([MockSpec<TimelinesV1Service>(), MockSpec<StatusesV1Service>()])
import 'timeline_test.mocks.dart';
```

Then execute:
```bash
dart run build_runner build
```
to generate the mock.



