import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:raqami/src/domain/models/post_model.dart';
import 'package:raqami/src/domain/use_case/delete_post_use_case.dart';
import 'package:raqami/src/domain/use_case/update_post_use_case.dart';

part 'post_detail_event.dart';
part 'post_detail_state.dart';
part 'post_detail_bloc.freezed.dart';

class PostDetailBloc extends Bloc<PostDetailEvent, PostDetailState> {
  PostDetailBloc({
    required UpdatePostUseCase updatePostUseCase,
    required DeletePostUseCase deletePostUseCase,
  })  : _updatePostUseCase = updatePostUseCase,
        _deletePostUseCase = deletePostUseCase,
        super(PostDetailState.initial()) {
    on<_UpdatePost>(_onUpdatePost);
    on<_DeletePost>(_onDeletePost);
    on<_SetNumberError>(_onSetNumberError);
    on<_SetPlateCodeError>(_onSetPlateCodeError);
    on<_SetPhoneCodeError>(_onSetPhoneCodeError);
  }

  final UpdatePostUseCase _updatePostUseCase;
  final DeletePostUseCase _deletePostUseCase;

  Future<void> _onUpdatePost(
    _UpdatePost event,
    Emitter<PostDetailState> emit,
  ) async {
    emit(state.copyWith(isUpdating: true, error: null));

    try {
      await _updatePostUseCase.call(
        postId: event.postId,
        number: event.number,
        price: event.price,
        sold: event.sold,
        plateCode: event.plateCode,
      );

      emit(state.copyWith(
        isUpdating: false,
        isSuccess: true,
        error: null,
      ));
    } catch (e) {
      emit(state.copyWith(
        isUpdating: false,
        error: e.toString(),
      ));
    }
  }

  void _onSetNumberError(
    _SetNumberError event,
    Emitter<PostDetailState> emit,
  ) {
    emit(state.copyWith(numberError: event.error));
  }

  void _onSetPlateCodeError(
    _SetPlateCodeError event,
    Emitter<PostDetailState> emit,
  ) {
    emit(state.copyWith(plateCodeError: event.error));
  }

  void _onSetPhoneCodeError(
    _SetPhoneCodeError event,
    Emitter<PostDetailState> emit,
  ) {
    emit(state.copyWith(phoneCodeError: event.error));
  }

  Future<void> _onDeletePost(
    _DeletePost event,
    Emitter<PostDetailState> emit,
  ) async {
    emit(state.copyWith(isDeleting: true, error: null));

    try {
      await _deletePostUseCase.call(postId: event.postId);

      emit(state.copyWith(
        isDeleting: false,
        isSuccess: true,
        error: null,
      ));
    } catch (e) {
      emit(state.copyWith(
        isDeleting: false,
        error: e.toString(),
      ));
    }
  }
}

