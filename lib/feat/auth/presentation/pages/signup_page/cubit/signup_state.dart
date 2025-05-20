part of 'signup_cubit.dart';

class SignupState extends Equatable {
  const SignupState({this.isEnabled = false, this.textFieldEnabled = false});

  final bool textFieldEnabled;

  final bool isEnabled;

  SignupState copyWith({bool? isEnabled, bool? textFieldEnabled}) =>
      SignupState(textFieldEnabled: textFieldEnabled ?? this.textFieldEnabled, isEnabled: isEnabled ?? this.isEnabled);

  @override
  List<Object?> get props => [isEnabled, textFieldEnabled];
}
