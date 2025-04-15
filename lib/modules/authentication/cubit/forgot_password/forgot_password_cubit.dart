import 'package:bloc/bloc.dart';
import 'package:mywords/modules/authentication/repository/forgot_password_repository.dart';
import 'package:mywords/utils/extensions/either_extension.dart';

part 'forgot_password_state.dart';

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  final ForgotPasswordRepository _forgotPasswordRepository;

  ForgotPasswordCubit({required ForgotPasswordRepository forgotPasswordRepository})
      : _forgotPasswordRepository = forgotPasswordRepository,
        super(ForgotPasswordState.initial());

  void submitEmail(String email) async {
    emit(state.copyWith(status: ForgotPasswordStatus.loading));

    final result = await _forgotPasswordRepository.submitEmail(email);

    result.handle(
      onSuccess: (String token) async {
        emit(state.copyWith(email: email, step: ForgotPasswordStep.emailInput, status: ForgotPasswordStatus.success));
      },
      onError: (error) {
        emit(state.copyWith(status: ForgotPasswordStatus.failure, errorMessage: error.errorMsg));
      },
    );
  }

  void verifyOtp(String otp) async {
    emit(state.copyWith(status: ForgotPasswordStatus.loading));

    final result = await _forgotPasswordRepository.verifyOtp(state.email, otp);

    result.handle(
      onSuccess: (String token) async {
        emit(state.copyWith(otp: otp, step: ForgotPasswordStep.otpInput, status: ForgotPasswordStatus.success));
      },
      onError: (error) {
        emit(state.copyWith(status: ForgotPasswordStatus.failure, errorMessage: error.errorMsg));
      },
    );
  }

  void submitNewPassword(String newPassword) async {
    emit(state.copyWith(status: ForgotPasswordStatus.loading));

    final result = await _forgotPasswordRepository.resetPassword(state.email, state.otp, newPassword);

    result.handle(
      onSuccess: (String token) async {
        emit(state.copyWith(newPassword: newPassword, step: ForgotPasswordStep.newPassword, status: ForgotPasswordStatus.success));
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
