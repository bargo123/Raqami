part of 'create_post_bloc.dart';

@freezed
sealed class CreatePostState with _$CreatePostState {
  const factory CreatePostState({
    @Default(PostType.phoneNumber) PostType postType,
    @Default('') String number,
    @Default('') String plateCode,
    @Default('') String phoneCode,
    @Default('') String phonePrice,
    @Default('') String platePrice,
    @Default('') String description,
    UAEEmirate? emirate,
    String? plateType,
    @Default(PhoneProvider.du) PhoneProvider phoneProvider,
    @Default(LineType.prepaid) LineType lineType,
    @Default(false) bool isLoading,
    @Default(false) bool isSuccess,
    String? numberError,
    String? plateCodeError,
    String? phoneCodeError,
    String? priceError,
    String? emirateError,
    String? generalError,
  }) = _CreatePostState;

  factory CreatePostState.initial() => const CreatePostState();
}

