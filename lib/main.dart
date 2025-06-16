import "dart:io";

import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:katlavan24/core/localization/cubit/localization_cubit.dart";
import "package:katlavan24/core/splash/splash_screen.dart";
import "package:katlavan24/core/styles/theme.dart";
import "package:katlavan24/gen_l10n/app_localizations.dart";


void main() async {
  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  //  init.initMapkit(
  //    locale: 'ru-RU',
  //     apiKey: '99aac6a8-30e3-4247-9fd8-d4681e76db6a'
  // );


  runApp(EntryPoint());
}

class EntryPoint extends StatelessWidget {
  const EntryPoint({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LocalizationCubit(),
      child: BlocBuilder<LocalizationCubit, Locale>(
        builder: (context, locale) {
          return SafeArea(
            top: false,
            child: MaterialApp(
              locale: locale,
              theme: theme,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              debugShowCheckedModeBanner: false,
              home: Builder(
                builder: (context) {
                  return SafeArea(
                      top: false,
                      child: SplashScreen());
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}