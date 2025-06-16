
import 'dart:convert';
import 'dart:developer';

import 'package:katlavan24/core/models/token_model.dart';
import 'package:katlavan24/core/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
abstract class StorageService<T> {
  final String key;

  StorageService(this.key);

  Future<T?> getItem() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? storedData = prefs.getString(key);

    if (storedData != null) {
      final data = fromRaw(storedData);
      return data;
    }
    return null;
  }


  Future<bool> setItem(T item) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String serializedData = toRaw(item);
    return prefs.setString(key, serializedData);
  }

  Future<bool> deleteItem() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.remove(key);
  }

  T fromRaw(String data);

  String toRaw(T item);
}

class UserService extends StorageService<User> {
  UserService() : super('USER');

  @override
  User fromRaw(String data) => User.fromMap(jsonDecode(data));

  @override
  String toRaw(User item) {
    log('$key $item');

    return jsonEncode(item.toMap());
  }
}

class TokenService extends StorageService<Token> {
  TokenService() : super('TOKEN');

  @override
  Token fromRaw(String data) => Token.fromMap(jsonDecode(data));

  @override
  String toRaw(Token item) {
    log('$key $item');
    return item.toString();
  }
}
