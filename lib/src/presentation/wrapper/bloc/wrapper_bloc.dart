import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:raqami/src/data/models/models/user_model.dart';
import 'package:raqami/src/domain/use_case/get_user_data_use_case.dart';

part 'wrapper_event.dart';
part 'wrapper_state.dart';
part 'wrapper_bloc.freezed.dart';

class WrapperBloc extends Bloc<WrapperEvent, WrapperState> {
  WrapperBloc({required GetUserDataUseCase getUserDataUseCase})
      : _getUserDataUseCase = getUserDataUseCase,
        super(WrapperState.initial()) {
    on<_Started>(_onStarted);
    on<_LoadUserData>(_onLoadUserData);
    on<_EmitUserData>(_onEmitUserData);
  }

  final GetUserDataUseCase _getUserDataUseCase;

  void _onStarted(
    _Started event,
    Emitter<WrapperState> emit,
  ) {
    add(const WrapperEvent.loadUserData());
  }

  Future<void> _onLoadUserData(
    _LoadUserData event,
    Emitter<WrapperState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final userDataStream = _getUserDataUseCase();
      userDataStream.listen((userData) {
        add(WrapperEvent.emitUserData(userData!));
      });
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        isSuccess: false,
        error: e.toString(),
      ));
    } 
  }

  void _onEmitUserData(
    _EmitUserData event,
    Emitter<WrapperState> emit,
  ) {
    if(!isClosed) {
    emit(state.copyWith(
      isLoading: false,
        isSuccess: true,
        userData: event.userData,
      ));
    }
  }
}

