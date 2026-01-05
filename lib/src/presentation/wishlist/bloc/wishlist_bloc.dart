import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:raqami/src/domain/models/post_model.dart';
import 'package:raqami/src/domain/use_case/get_posts_liked_by_user_use_case.dart';
import 'package:raqami/src/domain/use_case/like_post_use_case.dart';

part 'wishlist_event.dart';
part 'wishlist_state.dart';
part 'wishlist_bloc.freezed.dart';

class WishlistBloc extends Bloc<WishlistEvent, WishlistState> {
  WishlistBloc({
    required GetPostsLikedByUserUseCase getPostsLikedByUserUseCase,
    required LikePostUseCase likePostUseCase,
  })  : _getPostsLikedByUserUseCase = getPostsLikedByUserUseCase,
        _likePostUseCase = likePostUseCase,
        super(WishlistState.initial()) {
    on<_LoadLikedPosts>(_onLoadLikedPosts);
    on<_LikePost>(_onLikePost);
  }

  final GetPostsLikedByUserUseCase _getPostsLikedByUserUseCase;
  final LikePostUseCase _likePostUseCase;

  Future<void> _onLoadLikedPosts(
    _LoadLikedPosts event,
    Emitter<WishlistState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null));

    try {
      await emit.forEach<List<PostModel>>(
        _getPostsLikedByUserUseCase.call(userId: event.userId),
        onData: (posts) {
          print('WishlistBloc: Received ${posts.length} liked posts');
          return state.copyWith(
            posts: posts,
            isLoading: false,
            error: null,
          );
        },
        onError: (error, stackTrace) {
          print('WishlistBloc: Error loading liked posts: $error');
          return state.copyWith(
            isLoading: false,
            error: error.toString(),
          );
        },
      );
    } catch (e) {
      print('WishlistBloc: Exception in _onLoadLikedPosts: $e');
      emit(state.copyWith(
        isLoading: false,
        error: e.toString(),
      ));
    }
  }

  Future<void> _onLikePost(
    _LikePost event,
    Emitter<WishlistState> emit,
  ) async {
    try {
      // Find the current post
      final currentPost = state.posts.firstWhere(
        (post) => post.id == event.postId,
        orElse: () => throw Exception('Post not found'),
      );
      final isCurrentlyLiked = currentPost.likedBy.contains(event.userId);

      // Optimistically update the UI
      if (isCurrentlyLiked) {
        // If unliking, remove the post from the wishlist immediately
        final updatedPosts = state.posts.where(
          (post) => post.id != event.postId,
        ).toList();
        emit(state.copyWith(posts: updatedPosts));
      } else {
        // If liking (shouldn't happen in wishlist, but handle it anyway)
        final updatedPosts = state.posts.map((post) {
          if (post.id == event.postId) {
            final likedBy = List<String>.from(post.likedBy);
            likedBy.add(event.userId);
            return post.copyWith(likedBy: likedBy);
          }
          return post;
        }).toList();
        emit(state.copyWith(posts: updatedPosts));
      }

      // Then update in Firebase
      await _likePostUseCase.call(postId: event.postId, userId: event.userId);
    } catch (error) {
      print('Error toggling like: $error');
      // Reload posts to get correct state
      add(WishlistEvent.loadLikedPosts(userId: event.userId));
    }
  }

}

