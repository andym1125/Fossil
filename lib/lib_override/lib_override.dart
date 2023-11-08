import 'package:mastodon_api/mastodon_api.dart';

// TODO: Check if this is the correct way to do this
// ignore: constant_identifier_names
const Locale DEFAULT_LOCALE = MyLocale(country: Country.unitedStates, lang: Language.english);

class MyLocale extends Locale {
  const MyLocale({
    required this.lang,
    required this.country,
  }) : super(lang: lang, country: country);

  final Language lang;
  final Country country;

  @override
  String toString() => lang.code;
}