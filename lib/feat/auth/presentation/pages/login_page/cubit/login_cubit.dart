import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:katlavan24/core/enums/status_enum.dart';
import 'package:katlavan24/core/services/cache_service.dart';
import 'package:katlavan24/feat/auth/data/auth_datasource.dart';
import 'package:katlavan24/feat/auth/domain/auth_repo.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final controller = TextEditingController();
  final repo = AuthRepositoryImpl(AuthDataSourceImpl());

  LoginCubit()
    : super(
        LoginState(
          pinTheme: PinTheme(
            shape: PinCodeFieldShape.box,
            borderRadius: BorderRadius.circular(8),
            fieldHeight: 72,
            fieldWidth: 54,
            selectedBorderWidth: 1.5,
            selectedColor: Color(0xff0f0f0f),
            activeBorderWidth: 1.5,

            activeColor: Color(0xff0f0f0f),
            activeFillColor: Colors.white,
            inactiveFillColor: Colors.white,
            inactiveBorderWidth: 1,

            activeBoxShadow: const [
              BoxShadow(blurRadius: 0, spreadRadius: 2, color: Color(0xffe2e2e2)),
              BoxShadow(blurRadius: 0, color: Colors.white),
            ],
            inActiveBoxShadow: const [
              BoxShadow(blurRadius: 0, spreadRadius: 2, color: Color(0xffe2e2e2)),
              BoxShadow(blurRadius: 0, color: Colors.white),
            ],

            inactiveColor: Color(0xffe2e2e2),
            selectedFillColor: Colors.white,
          ),
        ),
      ) {
    controller.addListener(isEnabled);
  }

  Future<void> submit() async {}

  void isEnabled() {
    emit(
      state.copyWith(
        isEnabled: controller.text.trim().replaceAll(' ', '').replaceAll('(', '').replaceAll(')', '').length == 9,
      ),
    );
  }

  void checkPinController(String text) {
    if (text.length == 6) {}
  }

  void sendPhone({required Function() onSuccess}) async {
    emit(state.copyWith(status: Status.loading));
    try {
      await repo.getOtp(controller.text.replaceAll(RegExp(r'\D'), '').trim());
      onSuccess();
      emit(state.copyWith(status: Status.init));
    } catch (e) {
      emit(state.copyWith(status: Status.error));
      emit(state.copyWith(status: Status.init));
    }
  }

  void login({
    required Function() onSuccess,
    required PinTheme pinTheme,
    required String code,
    required Function(String message) onError,
  }) async {
    try {
      final token = await repo.verifyOtp(controller.text.replaceAll(RegExp(r'\D'), '').trim(), code.trim());
      emit(state.copyWith(pinTheme: pinTheme));
      TokenService().setItem(token);
      await Future.delayed(Duration(seconds: 1));
      onSuccess();
    } catch (e) {
      if (e is Response) {
        onError(r"Eskirgan yoki noto'g'ri kod");
      } else {
        onError(e.toString());
      }
      log(e.toString());
    }
  }
}
