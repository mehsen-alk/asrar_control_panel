import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/app/di.dart';
import '../../../employees_manager/domain/entities/employee.dart';
import '../../data/models/requests.dart';
import '../../domain/repository/repository.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final Repository _repository = instance<Repository>();

  AuthenticationBloc() : super(AuthenticationInitial()) {
    // login
    on<LoginButtonPressed>((event, emit) async {
      emit(AuthenticationInProgress());

      (await _repository.login(event.loginRequest)).fold(
        (failure) {
          emit(AuthenticationFailed(failure.message));
        },
        (employee) {
          emit(AuthenticationSuccess(employee: employee));
        },
      );
    });
  }
}
