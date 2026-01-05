part of 'wrapper_bloc.dart';

@freezed
class WrapperEvent with _$WrapperEvent {
  const factory WrapperEvent.started() = _Started;
  const factory WrapperEvent.loadUserData() = _LoadUserData;
  const factory WrapperEvent.emitUserData(UserModel userData) = _EmitUserData;
}


