part of 'login_cubit.dart';

class LoginState extends Equatable {
  const LoginState({this.isEnabled = false, this.status = Status.init, required this.pinTheme});

  final Status status;
  final bool isEnabled;
  final PinTheme pinTheme;

  LoginState copyWith({bool? isEnabled, Status? status, PinTheme? pinTheme}) => LoginState(
    pinTheme: pinTheme ?? this.pinTheme,
    status: status ?? this.status,
    isEnabled: isEnabled ?? this.isEnabled,
  );

  @override
  List<Object?> get props => [isEnabled, status, pinTheme];
}
