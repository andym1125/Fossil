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

```% flutter --version
Flutter 3.13.6 • channel stable • https://github.com/flutter/flutter.git
Framework • revision ead455963c (12 days ago) • 2023-09-26 18:28:17 -0700
Engine • revision a794cf2681
Tools • Dart 3.1.3 • DevTools 2.25.0
```

In particular, look for Flutter v3.13.6 and Dart v3.1.3

## Getting Started

Run the following to get the code, install dependencies, and run.

```git clone https://github.com/andym1125/Fossil
cd Fossil
flutter pub get
flutter run
```

If you've configured your emulator correctly, it should automatically open your emulator.

## Contributing

Develop on a branch named YourName/FeatureName. For example, andy/readme-update. When your branch is ready to review, submit a SQUASH COMMIT pull request. If any available testing fails, you PR will not be approved. Ensure your changes are sufficiently tested. At least one approval is necessary.

