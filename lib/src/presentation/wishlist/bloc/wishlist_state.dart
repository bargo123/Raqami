part of 'wishlist_bloc.dart';

@freezed
sealed class WishlistState with _$WishlistState {
  const factory WishlistState({
    @Default([]) List<PostModel> posts,
    @Default(false) bool isLoading,
    String? error,
  }) = _WishlistState;

  factory WishlistState.initial() => const WishlistState();
}





