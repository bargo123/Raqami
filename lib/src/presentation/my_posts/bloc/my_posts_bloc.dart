import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:raqami/src/domain/models/post_model.dart';
import 'package:raqami/src/domain/use_case/delete_post_use_case.dart';
import 'package:raqami/src/domain/use_case/get_posts_by_user_id_use_case.dart';
import 'package:raqami/src/domain/use_case/toggle_sold_post_use_case.dart';

part 'my_posts_event.dart';
part 'my_posts_state.dart';
part 'my_posts_bloc.freezed.dart';

class MyPostsBloc extends Bloc<MyPostsEvent, MyPostsState> {
  MyPostsBloc({
    required GetPostsByUserIdUseCase getPostsByUserIdUseCase,
    required ToggleSoldPostUseCase toggleSoldPostUseCase,
    required DeletePostUseCase deletePostUseCase,
  })  : _getPostsByUserIdUseCase = getPostsByUserIdUseCase,
        _toggleSoldPostUseCase = toggleSoldPostUseCase,
        _deletePostUseCase = deletePostUseCase,
        super(MyPostsState.initial()) {
    on<_LoadMyPosts>(_onLoadMyPosts);
    on<_ToggleSold>(_onToggleSold);
    on<_DeletePost>(_onDeletePost);
  }

  final GetPostsByUserIdUseCase _getPostsByUserIdUseCase;
  final ToggleSoldPostUseCase _toggleSoldPostUseCase;
  final DeletePostUseCase _deletePostUseCase;

  Future<void> _onLoadMyPosts(
    _LoadMyPosts event,
    Emitter<MyPostsState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null));

    try {
      await emit.forEach<List<PostModel>>(
        _getPostsByUserIdUseCase.call(userId: event.userId),
        onData: (posts) {
          print('MyPostsBloc: Received ${posts.length} posts');
          return state.copyWith(
            posts: posts,
            isLoading: false,
            error: null,
          );
        },
        onError: (error, stackTrace) {
          print('MyPostsBloc: Error loading posts: $error');
          return state.copyWith(
            isLoading: false,
            error: error.toString(),
          );
        },
      );
    } catch (e) {
      print('MyPostsBloc: Exception in _onLoadMyPosts: $e');
      emit(state.copyWith(
        isLoading: false,
        error: e.toString(),
      ));
    }
  }

  Future<void> _onToggleSold(
    _ToggleSold event,
    Emitter<MyPostsState> emit,
  ) async {
    try {
      // Optimistically update the UI
      final updatedPosts = state.posts.map((post) {
        if (post.id == event.postId) {
          return post.copyWith(sold: event.sold);
        }
        return post;
      }).toList();
      emit(state.copyWith(posts: updatedPosts));

      // Then update in Firebase
      await _toggleSoldPostUseCase.call(
        postId: event.postId,
        sold: event.sold,
      );
    } catch (error) {
      print('Error toggling sold status: $error');
      // Reload posts to get correct state
      add(MyPostsEvent.loadMyPosts(userId: event.userId));
    }
  }

  FutureOr<void> _onDeletePost(_DeletePost event, Emitter<MyPostsState> emit) async {
    try {
      await _deletePostUseCase.call(postId: event.postId);
      emit(state.copyWith(deleteSuccess: true));
      // Reset success flag after a short delay
      await Future.delayed(const Duration(milliseconds: 100));
      emit(state.copyWith(deleteSuccess: false));
    } catch (error) {
      print('Error deleting post: $error');
      emit(state.copyWith(error: error.toString()));
    }
  }
}




