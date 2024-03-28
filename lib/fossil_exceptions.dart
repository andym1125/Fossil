import 'package:mastodon_api/mastodon_api.dart';

class FossilException implements Exception {
  final String message;
  final HttpStatus status;
  FossilException(this.status, this.message);
}

class FossilUnauthorizedException extends FossilException {
  FossilUnauthorizedException({String? message, Token? token}) : 
    super(HttpStatus.unauthorized, "The Fossil client is unauthenticated. Message: $message Token: ${token?.accessToken ?? "Token is null"}");
}