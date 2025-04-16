import 'package:bloc/bloc.dart';
import 'package:mywords/modules/authentication/repository/forgot_password_repository.dart';
import 'package:mywords/utils/extensions/either_extension.dart';

part 'forgot_password_state.dart';

/// We use 'step' to track the user's current position in the forgot password flow.

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  final ForgotPasswordRepository _forgotPasswordRepository;

  ForgotPasswordCubit({required ForgotPasswordRepository forgotPasswordRepository})
      : _forgotPasswordRepository = forgotPasswordRepository,
        super(ForgotPasswordState.initial());

  void submitEmail(String email) async {
    emit(state.copyWith(status: ForgotPasswordStatus.loading, step: ForgotPasswordStep.emailInput));

    final result = await _forgotPasswordRepository.submitEmail(email);

    result.handle(
      onSuccess: (String result) async {
        emit(state.copyWith(email: email, status: ForgotPasswordStatus.success));
      },
      onError: (error) {
        emit(state.copyWith(status: ForgotPasswordStatus.failure, errorMessage: error.errorMsg));
      },
    );
  }

  void verifyOtp(String otp) async {
    emit(state.copyWith(status: ForgotPasswordStatus.loading,step: ForgotPasswordStep.otpInput));

    final result = await _forgotPasswordRepository.verifyOtp(state.email, otp);

    result.handle(
      onSuccess: (String result) async {
        emit(state.copyWith(otp: otp,  status: ForgotPasswordStatus.success));
      },
      onError: (error) {
        emit(state.copyWith(status: ForgotPasswordStatus.failure, errorMessage: error.errorMsg));
      },
    );
  }

  void submitNewPassword(String newPassword) async {
    emit(state.copyWith(status: ForgotPasswordStatus.loading,step: ForgotPasswordStep.newPassword));

    final result = await _forgotPasswordRepository.resetPassword(state.email, state.otp, newPassword);

    result.handle(
      onSuccess: (String result) async {
        emit(state.copyWith(newPassword: newPassword, status: ForgotPasswordStatus.success));
      },
      onError: (error) {
        emit(state.copyWith(status: ForgotPasswordStatus.failure, errorMessage: error.errorMsg));
      },
    );
  }

  void resetState() {
    emit(ForgotPasswordState.initial());
  }
}
