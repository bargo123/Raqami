import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:raqami/src/domain/models/post_model.dart';
import 'package:raqami/src/domain/use_case/like_post_use_case.dart';
import 'package:raqami/src/domain/use_case/report_post_use_case.dart';

part 'post_info_event.dart';
part 'post_info_state.dart';
part 'post_info_bloc.freezed.dart';

class PostInfoBloc extends Bloc<PostInfoEvent, PostInfoState> {
  PostInfoBloc({
    required LikePostUseCase likePostUseCase,
    required ReportPostUseCase reportPostUseCase,
    required PostModel initialPost,
  })  : _likePostUseCase = likePostUseCase,
        _reportPostUseCase = reportPostUseCase,
        super(PostInfoState.initial(initialPost)) {
    on<_Initialize>(_onInitialize);
    on<_LikePost>(_onLikePost);
    on<_ReportPost>(_onReportPost);
  }

  final LikePostUseCase _likePostUseCase;
  final ReportPostUseCase _reportPostUseCase;

  void _onInitialize(
    _Initialize event,
    Emitter<PostInfoState> emit,
  ) {
    emit(PostInfoState.initial(event.post));
  }

  Future<void> _onLikePost(
    _LikePost event,
    Emitter<PostInfoState> emit,
  ) async {
    final currentPost = state.post;
    final isLiked = currentPost.likedBy.contains(event.userId);
    
    // Optimistically update the UI
    final updatedLikedBy = List<String>.from(currentPost.likedBy);
    if (isLiked) {
      updatedLikedBy.remove(event.userId);
    } else {
      updatedLikedBy.add(event.userId);
    }
    
    final updatedPost = currentPost.copyWith(likedBy: updatedLikedBy);
    
    emit(state.copyWith(
      post: updatedPost,
      isLiking: true,
      error: null,
    ));
    
    try {
      await _likePostUseCase(postId: currentPost.id, userId: event.userId);
      emit(state.copyWith(isLiking: false));
    } catch (error) {
      // Revert optimistic update on error
      emit(state.copyWith(
        post: currentPost,
        isLiking: false,
        error: error.toString(),
      ));
    }
  }

  Future<void> _onReportPost(
    _ReportPost event,
    Emitter<PostInfoState> emit,
  ) async {
    emit(state.copyWith(
      isReporting: true,
      error: null,
      reportSuccess: false,
    ));

    try {
      await _reportPostUseCase(
        postId: event.postId,
        reporterId: event.reporterId,
        reason: event.reason,
        additionalDetails: event.additionalDetails,
      );
      emit(state.copyWith(
        isReporting: false,
        reportSuccess: true,
      ));
    } catch (error) {
      emit(state.copyWith(
        isReporting: false,
        reportSuccess: false,
        error: error.toString(),
      ));
    }
  }
}

