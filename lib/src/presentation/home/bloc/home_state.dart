part of 'home_bloc.dart';

@freezed
sealed class HomeState with _$HomeState {
  const factory HomeState({
    @Default([]) List<PostModel> phoneNumberPosts,
    @Default([]) List<PostModel> carPlatePosts,
    @Default(true) bool isLoadingPhoneNumbers,
    @Default(true) bool isLoadingCarPlates,
    @Default(false) bool isLoadingMorePhoneNumbers,
    @Default(false) bool isLoadingMoreCarPlates,
    String? phoneNumberError,
    String? carPlateError,
    UAEEmirate? filterEmirate,
    String? filterCode,
    int? filterDigitCount,
    PhoneProvider? filterPhoneProvider,
    String? filterPhoneCode,
    @Default(false) bool hasMorePhoneNumbers,
    @Default(false) bool hasMoreCarPlates,
  }) = _HomeState;

  factory HomeState.initial() => const HomeState();
}

