import 'dart:convert';

class Token {
  String accessToken;
  String refreshToken;

  Token({required this.accessToken, required this.refreshToken});

  static Token fromMap(Map data) => Token(accessToken: data['access_token'], refreshToken: data['refresh_token']);

  static Token fromString(String data) => Token.fromMap(jsonDecode(data));

  Token copyWith({String? accessToken, String? refreshToken}) => Token(
        accessToken: accessToken ?? this.accessToken,
        refreshToken: refreshToken ?? this.refreshToken,
      );

  @override
  String toString() => jsonEncode({"access_token": accessToken, "refresh_token": refreshToken});
}
