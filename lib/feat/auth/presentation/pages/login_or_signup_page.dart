import 'package:flutter/material.dart';
import 'package:katlavan24/core/styles/styles.dart';
import 'package:katlavan24/core/utils/navigation.dart';
import 'package:katlavan24/core/widgets/buttons.dart';
import 'package:katlavan24/feat/auth/presentation/pages/login_page/login_page.dart';
import 'package:katlavan24/feat/auth/presentation/pages/signup_page/signup_page.dart';
import 'package:katlavan24/feat/auth/presentation/widgets/intro_bottom_container.dart';
import 'package:katlavan24/gen_l10n/app_localizations.dart';
class LoginOrSignupPage extends StatelessWidget {
  const LoginOrSignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(image: AssetImage('assets/auth/digging.jpg', ),fit: BoxFit.fitHeight),

          ),
          child: Column(
            children: [
              Expanded(child: SizedBox()),
              IntroBottomContainer(child: Column(
                children: [
                  Text(AppLocalizations.of(context)!.startFinding,style: AppStyles.s32w700,),
                  SizedBox(height: 6,),
                  Text(AppLocalizations.of(context)!.discoverSource,style: AppStyles.s16w400.copyWith(color: Color(0xff777777)),),
                  SizedBox(height: 24,),
                  SizedBox(height: 12,),
                  PrimaryButton(AppLocalizations.of(context)!.signUp, onTap: ()=>navigate(context,SignupPage()),),
                  SizedBox(height: 16,),
                  SecondaryButton(AppLocalizations.of(context)!.login, onTap: ()=>navigate(context,LoginPage()),),
                  SizedBox(height: 12,),
                ],
              )),
            ],
          ),
        ),
      ),
    );
  }
}
