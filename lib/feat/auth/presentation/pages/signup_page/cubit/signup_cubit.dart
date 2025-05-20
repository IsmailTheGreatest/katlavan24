import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  final controller = TextEditingController();
  final nameController = TextEditingController();

  SignupCubit() : super(SignupState()) {
    controller.addListener(isEnabled);
    nameController.addListener(textFieldEnabled);
  }

  Future<void> submit() async {}
void textFieldEnabled(){
    emit(state.copyWith(textFieldEnabled: nameController.text.isNotEmpty));
}
  void isEnabled() {
    final bool isOk = controller.text.trim().replaceAll(' ', '').replaceAll('(', '').replaceAll(')', '').length == 9;
    if (state.isEnabled != isOk) {
      emit(state.copyWith(isEnabled: isOk));
    }
  }
}
