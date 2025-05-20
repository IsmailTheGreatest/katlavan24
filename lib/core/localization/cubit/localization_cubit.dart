import 'dart:convert';
import 'dart:ui';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalizationCubit extends Cubit<Locale> {
  LocalizationCubit() : super(Locale.fromSubtags(languageCode: 'uz', scriptCode: 'Latn')) {
    getStoredPreference();
  }

  Future<void> changeLocale(String langCode, String? subTag) async {
    final locale = Locale.fromSubtags(languageCode: langCode, scriptCode: subTag);
    emit(locale);
    final shared = await SharedPreferences.getInstance();
    shared.setString('locale', locale.toText);
  }

  void getStoredPreference() async {
    final shared = await SharedPreferences.getInstance();
    final storedLocale = shared.getString('locale');
    if (storedLocale != null ) {
      emit(storedLocale.toShared);
    }
  }
}

extension Localex on Locale {
  String get toText => jsonEncode({'languageCode': languageCode, 'subTag': scriptCode});
}

extension LocaleY on String {
  Locale get toShared {
    final map = jsonDecode(this);

    return Locale.fromSubtags(languageCode: map['languageCode'], scriptCode: map['subTag']);
  }
}
