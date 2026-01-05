import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:raqami/src/di/di_container.dart' show di, configureDependencies;
import 'package:raqami/src/domain/use_case/get_posts_by_user_id_use_case.dart';
import 'package:raqami/src/domain/use_case/get_posts_liked_by_user_use_case.dart';
import 'package:raqami/src/domain/use_case/sign_out_use_case.dart';

part 'profile_event.dart';
part 'profile_state.dart';
part 'profile_bloc.freezed.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc({
    required SignOutUseCase signOutUseCase,
    required GetPostsByUserIdUseCase getPostsByUserIdUseCase,
    required GetPostsLikedByUserUseCase getPostsLikedByUserUseCase,
  })  : _signOutUseCase = signOutUseCase,
        _getPostsByUserIdUseCase = getPostsByUserIdUseCase,
        _getPostsLikedByUserUseCase = getPostsLikedByUserUseCase,
        super(ProfileState.initial()) {
    on<_SignOut>(_onSignOut);
    on<_LoadMyPostsCount>(_onLoadMyPostsCount);
    on<_LoadWishlistCount>(_onLoadWishlistCount);
  }

  final SignOutUseCase _signOutUseCase;
  final GetPostsByUserIdUseCase _getPostsByUserIdUseCase;
  final GetPostsLikedByUserUseCase _getPostsLikedByUserUseCase;


  Future<void> _onSignOut(
    _SignOut event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null));

    try {
      await _signOutUseCase();
      await di.reset();
      await configureDependencies();
      emit(state.copyWith(
        isLoading: false,
        isSuccess: true,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        isSuccess: false,
        error: e.toString(),
      ));
    }
  }

  Future<void> _onLoadMyPostsCount(
    _LoadMyPostsCount event,
    Emitter<ProfileState> emit,
  ) async {
    await emit.forEach(
      _getPostsByUserIdUseCase(userId: event.userId),
      onData: (posts) {
        emit(state.copyWith(myPostsCount: posts.length));
        return state.copyWith(myPostsCount: posts.length);
      },
      onError: (error, stackTrace) {
        print('ProfileBloc: Error loading my posts: $error');
        return state.copyWith(error: error.toString());
      },
    );
  }

  Future<void> _onLoadWishlistCount(
    _LoadWishlistCount event,
    Emitter<ProfileState> emit,
  ) async {
    await emit.forEach(
      _getPostsLikedByUserUseCase(userId: event.userId),
      onData: (posts) {
        print('ProfileBloc: Received ${posts.length} wishlist');
        emit(state.copyWith(wishlistCount: posts.length));
        return state.copyWith(wishlistCount: posts.length);
      },
      onError: (error, stackTrace) {
        print('ProfileBloc: Error loading wishlist: $error');
        return state.copyWith(error: error.toString());
      },
    );
  }

  @override
  Future<void> close() {
    return super.close();
  }
}

