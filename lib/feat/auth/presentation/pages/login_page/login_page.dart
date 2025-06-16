import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:katlavan24/core/enums/status_enum.dart';
import 'package:katlavan24/core/splash/splash_screen.dart';
import 'package:katlavan24/core/styles/styles.dart';
import 'package:katlavan24/core/utils/navigation.dart';
import 'package:katlavan24/core/widgets/buttons.dart';
import 'package:katlavan24/core/widgets/snackbar.dart';
import 'package:katlavan24/feat/auth/presentation/pages/login_page/cubit/login_cubit.dart';
import 'package:katlavan24/feat/auth/presentation/widgets/phone_number_row.dart';
import 'package:katlavan24/gen_l10n/app_localizations.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final phoneFormatter = MaskTextInputFormatter(
    mask: '(##) ### ## ##',
    filter: {"#": RegExp(r'[0-9]')},

    type: MaskAutoCompletionType.lazy,
  );

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent, // Ensures consistency
        statusBarIconBrightness: Brightness.dark,
      ),

      child: BlocProvider(
        create: (_) => LoginCubit(),
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            body: Builder(
              builder: (context) {
                final cubit=context.read<LoginCubit>();
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 100),
                      Text(AppLocalizations.of(context)!.login, style: AppStyles.s32w600),
                      SizedBox(height: 24),
                      BlocBuilder<LoginCubit, LoginState>(
                        builder: (context, state) {
                          return PhoneNumberRow(
                            controller: context.read<LoginCubit>().controller,
                            phoneFormatter: phoneFormatter,
                            filled: state.isEnabled,
                          );
                        },
                      ),
                      const Spacer(),
                      BlocBuilder<LoginCubit, LoginState>(
                        builder: (context, state) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 54),

                            child: PrimaryButton(
                              AppLocalizations.of(context)!.login,
                              isEnabled: state.isEnabled,
                              isLoading: state.status.isLoading,
                              onTap: () {
                                context.read<LoginCubit>().sendPhone(
                                  onSuccess: () {
                                    showModalBottomSheet(
                                      context: context,
                                      backgroundColor: Colors.white,
                                      isDismissible: false,

                                      isScrollControlled: true,

                                      builder:
                                          (contextModal) => SafeArea(
                                            top: false,
                                            child: BlocProvider.value(
                                              value: cubit,
                                              child: BlocBuilder<LoginCubit,LoginState>(
                                                builder: (contextModal,state) {

                                                  return Container(
                                                    padding: EdgeInsets.symmetric(
                                                      horizontal: 20,
                                                    ).copyWith(bottom: MediaQuery.of(contextModal).viewInsets.bottom),
                                                    child: Column(
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: [
                                                        Center(
                                                          child: Container(
                                                            width: 41,
                                                            height: 4,
                                                            margin: EdgeInsets.only(top:8,bottom: 16),
                                                            decoration: BoxDecoration(color: Color(0xffe2e2e2), borderRadius: BorderRadius.circular(50)),
                                                          ),
                                                        ),
                                                        Text(AppLocalizations.of(contextModal)!.enterCode, style: AppStyles.s18w600),
                                                        SizedBox(height: 8),

                                                        Divider(height: 16),
                                                        SizedBox(height: 16),
                                                        Text(
                                                          AppLocalizations.of(contextModal)!.enterSixDigitCode,
                                                          style: AppStyles.s16w400.copyWith(height: 24 / 16),
                                                        ),
                                                        SizedBox(height: 20),
                                                        Form(
                                                          child: PinCodeTextField(
                                                            controller: TextEditingController(),
                                                            keyboardType: TextInputType.number,
                                                            appContext: context,
                                                            length: 6,

                                                            autoFocus: true,
                                                            showCursor: true,
                                                            validator: (String? s){
                                                              if(s!.length==6){
                                                              return null;
                                                              } else {return null;}
                                                            },
                                                            onChanged: (String changed){
                                                              if(changed.length==6){
                                                                contextModal.read<LoginCubit>().login(code: changed,pinTheme: PinTheme(
                                                                  shape: PinCodeFieldShape.box,
                                                                  borderRadius: BorderRadius.circular(8),
                                                                  fieldHeight: 72,
                                                                  fieldWidth: 54,
                                                                  selectedBorderWidth: 1.5,
                                                                  selectedColor: Color(0xff49B356),
                                                                  activeBorderWidth: 1.5,

                                                                  activeColor: Color(0xff49B356),
                                                                  activeFillColor: Color(0xfff4f5f6),
                                                                  inactiveFillColor: Color(0xfff4f5f6),
                                                                  inactiveBorderWidth: 1,
                                                                  activeBoxShadow: [BoxShadow(
                                                                    color: Color(0xffF4F5F6),
                                                                    spreadRadius: 0,
                                                                  )],inActiveBoxShadow: [BoxShadow(
                                                                  color: Color(0xffF4F5F6),
                                                                  spreadRadius: 0,
                                                                )],

                                                                  inactiveColor: Color(0xffe2e2e2),
                                                                  selectedFillColor: Colors.white,
                                                                ),onSuccess:(){
                                                                  navigateReplaceAll(contextModal,SplashScreen() );
                                                                },
                                                                  onError: (String errorMessage){
                                                                  showFlushbar(contextModal,errorMessage);
                                                                  }

                                                                 );
                                                              }
                                                            },
                                                            cursorColor: Color(0xff0f0f0f),
                                                            pinTheme: state.pinTheme,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                }
                                              ),
                                            ),
                                          ),
                                    );
                                  },
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
