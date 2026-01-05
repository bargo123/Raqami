import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:raqami/src/domain/use_case/complete_sign_up_use_case.dart';

part 'email_verification_event.dart';
part 'email_verification_state.dart';
part 'email_verification_bloc.freezed.dart';

class EmailVerificationBloc extends Bloc<EmailVerificationEvent, EmailVerificationState> {
  EmailVerificationBloc({required CompleteSignUpUseCase completeSignUpUseCase})
      : _completeSignUpUseCase = completeSignUpUseCase,
        super(EmailVerificationState.initial()) {
    on<_Started>(_onStarted);
    on<_VerifyOtp>(_onVerifyOtp);
  }

  final CompleteSignUpUseCase _completeSignUpUseCase;

  void _onStarted(
    _Started event,
    Emitter<EmailVerificationState> emit,
  ) {
    emit(state.copyWith(
      email: event.email,
    ));
  }


  Future<void> _onVerifyOtp(
    _VerifyOtp event,
    Emitter<EmailVerificationState> emit,
  ) async {
    emit(state.copyWith(
      isLoading: true,
      generalError: null,
    ));

    // For email verification, check if email is verified
      try {
        // Complete sign up after email verification
          await _completeSignUpUseCase();
        emit(state.copyWith(
          isLoading: false,
          isSuccess: true,
        ));
      } on FirebaseAuthException catch (e) {
        String errorMessage;
        switch (e.code) {
          case 'email-not-verified':
            errorMessage = 'Email not verified. Please check your email and click the verification link.';
            break;
          default:
            errorMessage = 'Verification failed. Please try again.';
        }
        emit(state.copyWith(
          isLoading: false,
          generalError: errorMessage,
        ));
      } catch (e) {
        emit(state.copyWith(
          isLoading: false,
          generalError: 'Something unexpected happened. Please try again.',
        ));
      }
      return;
    
  }

}

