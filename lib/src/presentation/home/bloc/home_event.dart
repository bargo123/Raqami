part of 'home_bloc.dart';

@freezed
sealed class HomeEvent with _$HomeEvent {
  const factory HomeEvent.started() = _Started;
  const factory HomeEvent.loadPhoneNumbers({
    required String countryCode,
    @Default(false) bool loadMore,
  }) = _LoadPhoneNumbers;
  const factory HomeEvent.loadCarPlates({
    required String countryCode,
    @Default(false) bool loadMore,
  }) = _LoadCarPlates;
  const factory HomeEvent.likePost({
    required String postId,
    required String userId,
  }) = _LikePost;
  const factory HomeEvent.filterCarPlates({
    UAEEmirate? emirate,
    String? code,
    int? digitCount,
  }) = _FilterCarPlates;
  const factory HomeEvent.filterPhoneNumbers({
    PhoneProvider? provider,
    String? code,
  }) = _FilterPhoneNumbers;
}

