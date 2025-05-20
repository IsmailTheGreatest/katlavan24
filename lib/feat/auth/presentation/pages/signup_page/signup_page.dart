import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:katlavan24/core/styles/styles.dart';
import 'package:katlavan24/core/widgets/buttons.dart';
import 'package:katlavan24/feat/auth/presentation/pages/signup_page/cubit/signup_cubit.dart';
import 'package:katlavan24/feat/auth/presentation/widgets/custom_text_field.dart';
import 'package:katlavan24/feat/auth/presentation/widgets/phone_number_row.dart';
import 'package:katlavan24/gen_l10n/app_localizations.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class SignupPage extends StatelessWidget {
   SignupPage({super.key});
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
        create: (_) => SignupCubit(),
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            body: Builder(
              builder: (context) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 100),
                      Text(AppLocalizations.of(context)!.signUp, style: AppStyles.s32w600),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Text(AppLocalizations.of(context)!.haveAccount, style: AppStyles.s16w400),
                          SizedBox(width: 5),
                          InkWell(
                            onTap: () {},
                            child: Text(
                              AppLocalizations.of(context)!.login,
                              style: AppStyles.s16w400.copyWith(
                                decoration: TextDecoration.underline,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 24),
                      BlocBuilder<SignupCubit, SignupState>(
                        builder: (context, state) {
                          return Column(
                            children: [
                              CustomTextField(controller: context.read<SignupCubit>().nameController, filled: state.textFieldEnabled, labelText: AppLocalizations.of(context)!.fullName,),
                              const SizedBox(height: 24,),
                              PhoneNumberRow(
                                phoneFormatter: phoneFormatter,
                                controller: context.read<SignupCubit>().controller,
                                filled: state.isEnabled,
                              ),
                            ],
                          );
                        },
                      ),
                      const Spacer(),
                      BlocBuilder<SignupCubit, SignupState>(
                        builder: (context, state) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 54),

                            child: PrimaryButton(AppLocalizations.of(context)!.signUp, isEnabled: state.isEnabled&&state.textFieldEnabled),
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
