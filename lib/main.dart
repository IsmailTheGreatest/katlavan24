import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:katlavan24/core/localization/cubit/localization_cubit.dart";
import "package:katlavan24/core/styles/theme.dart";
import "package:katlavan24/feat/map/example_map/mapkit_flutter.dart";
import 'package:yandex_maps_mapkit/init.dart' as init;
import "package:katlavan24/feat/client_home/presentation/client_home_page.dart";
import "package:katlavan24/gen_l10n/app_localizations.dart";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
   init.initMapkit(
     locale: 'ru-RU',
      apiKey: '99aac6a8-30e3-4247-9fd8-d4681e76db6a'
  );


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
          return MaterialApp(
            locale: locale,
            theme: theme,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            debugShowCheckedModeBanner: false,
            home: Builder(
              builder: (context) {
                return ClientHomePage();
              },
            ),
          );
        },
      ),
    );
  }
}
