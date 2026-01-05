part of 'create_post_bloc.dart';

@freezed
sealed class CreatePostEvent with _$CreatePostEvent {
  const factory CreatePostEvent.started() = _Started;
  const factory CreatePostEvent.postTypeChanged(PostType type) = _PostTypeChanged;
  const factory CreatePostEvent.numberChanged(String number) = _NumberChanged;
  const factory CreatePostEvent.plateCodeChanged(String code) = _PlateCodeChanged;
  const factory CreatePostEvent.phoneCodeChanged(String code) = _PhoneCodeChanged;
  const factory CreatePostEvent.phoneProviderChanged(PhoneProvider provider) = _PhoneProviderChanged;
  const factory CreatePostEvent.lineTypeChanged(LineType lineType) = _LineTypeChanged;
  const factory CreatePostEvent.priceChanged(String price) = _PriceChanged;
  const factory CreatePostEvent.descriptionChanged(String description) = _DescriptionChanged;
  const factory CreatePostEvent.emirateChanged(UAEEmirate? emirate) = _EmirateChanged;
  const factory CreatePostEvent.plateTypeChanged(String? plateType) = _PlateTypeChanged;
  const factory CreatePostEvent.createPost() = _CreatePost;
  const factory CreatePostEvent.clearErrors() = _ClearErrors;
}

