import 'package:flutter/material.dart';
import 'package:katlavan24/core/styles/styles.dart';
import 'package:katlavan24/core/utils/navigation.dart';
import 'package:katlavan24/core/widgets/buttons.dart';
import 'package:katlavan24/feat/auth/presentation/pages/login_or_signup_page.dart';
import 'package:katlavan24/feat/auth/presentation/widgets/intro_bottom_container.dart';
import 'package:katlavan24/gen_l10n/app_localizations.dart';
class IntroPage extends StatelessWidget {
  const IntroPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/auth/welcome_image.png'),
            fit: BoxFit.fitHeight,
            colorFilter: ColorFilter.mode(Colors.black45, BlendMode.darken),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(child: Image.asset('assets/auth/logo.png', width: 180, height: 35)),
            IntroBottomContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.welcomeMessage,

                    style: AppStyles.s32w700,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    AppLocalizations.of(context)!.startJourney,
                    style: AppStyles.s16w400.copyWith(color: Color(0xff777777)),
                  ),
                  SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: PrimaryButton(
                      AppLocalizations.of(context)!.getStarted,

                      onTap: () {
                        navigate(context, LoginOrSignupPage());
                      },
                    ),
                  ),
                ],
              ),

            ),
          ],
        ),
      ),
    );
  }
}

