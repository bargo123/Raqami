import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:raqami/src/domain/constants/firestore_constants.dart';
import 'package:raqami/src/domain/models/post_model.dart';
import 'package:raqami/src/domain/models/phone_provider.dart';
import 'package:raqami/src/domain/models/post_type.dart';
import 'package:raqami/src/domain/models/uae_emirate.dart';
import 'package:raqami/src/domain/use_case/get_posts_by_type_use_case.dart';
import 'package:raqami/src/domain/use_case/like_post_use_case.dart';

part 'home_event.dart';
part 'home_state.dart';
part 'home_bloc.freezed.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc({
    required GetPostsByTypeUseCase getPostsByTypeUseCase,
    required LikePostUseCase likePostUseCase,
  })  : _getPostsByTypeUseCase = getPostsByTypeUseCase,
        _likePostUseCase = likePostUseCase,
        super(HomeState.initial()) {
    on<_Started>(_onStarted);
    on<_LoadPhoneNumbers>(_onLoadPhoneNumbers);
    on<_LoadCarPlates>(_onLoadCarPlates);
    on<_LikePost>(_onLikePost);
    on<_FilterCarPlates>(_onFilterCarPlates);
    on<_FilterPhoneNumbers>(_onFilterPhoneNumbers);
  }

  final GetPostsByTypeUseCase _getPostsByTypeUseCase;
  final LikePostUseCase _likePostUseCase;
  DocumentSnapshot? _lastPhoneNumberDocument;
  DocumentSnapshot? _lastCarPlateDocument;

  void _onStarted(
    _Started event,
    Emitter<HomeState> emit,
  ) {
   add(const HomeEvent.loadPhoneNumbers(
      countryCode: FirestoreConstants.countryCodeUAE,
    ));
    add(const HomeEvent.loadCarPlates(
      countryCode: FirestoreConstants.countryCodeUAE,
    ));
  }

  Future<void> _onLoadPhoneNumbers(
    _LoadPhoneNumbers event,
    Emitter<HomeState> emit,
  ) async {
    try {
      if (event.loadMore) {
        emit(state.copyWith(isLoadingMorePhoneNumbers: true));
      } else {
        emit(state.copyWith(
          isLoadingPhoneNumbers: true,
          phoneNumberError: null,
        ));
        _lastPhoneNumberDocument = null; // Reset pagination
      }

      final result = await _getPostsByTypeUseCase(
        countryCode: event.countryCode,
        postType: PostType.phoneNumber,
        phoneProvider: state.filterPhoneProvider,
        phoneCode: state.filterPhoneCode,
        lastDocument: event.loadMore ? _lastPhoneNumberDocument : null,
        limit: 10,
      );

      // Update last document for pagination
      _lastPhoneNumberDocument = result.lastDocument;

      final updatedPosts = event.loadMore
          ? [...state.phoneNumberPosts, ...result.posts]
          : result.posts;

      emit(state.copyWith(
        phoneNumberPosts: updatedPosts,
        isLoadingPhoneNumbers: false,
        isLoadingMorePhoneNumbers: false,
        phoneNumberError: null,
        hasMorePhoneNumbers: result.hasMore,
      ));
    } catch (error) {
      emit(state.copyWith(
        isLoadingPhoneNumbers: false,
        isLoadingMorePhoneNumbers: false,
        phoneNumberError: error.toString(),
      ));
    }
  }

 

  Future<void> _onLoadCarPlates(
    _LoadCarPlates event,
    Emitter<HomeState> emit,
  ) async {
    try {
      if (event.loadMore) {
        emit(state.copyWith(isLoadingMoreCarPlates: true));
      } else {
        emit(state.copyWith(
          isLoadingCarPlates: true,
          carPlateError: null,
        ));
        _lastCarPlateDocument = null; // Reset pagination
      }

      final result = await _getPostsByTypeUseCase(
        countryCode: event.countryCode,
        postType: PostType.carPlate,
        emirate: state.filterEmirate,
        plateCode: state.filterCode?.isEmpty == true ? null : state.filterCode,
        digitCount: state.filterDigitCount,
        lastDocument: event.loadMore ? _lastCarPlateDocument : null,
        limit: 10,
      );

      // Update last document for pagination
      _lastCarPlateDocument = result.lastDocument;

      final updatedPosts = event.loadMore
          ? [...state.carPlatePosts, ...result.posts]
          : result.posts;

      emit(state.copyWith(
        carPlatePosts: updatedPosts,
        isLoadingCarPlates: false,
        isLoadingMoreCarPlates: false,
        carPlateError: null,
        hasMoreCarPlates: result.hasMore,
      ));
    } catch (error) {
      emit(state.copyWith(
        isLoadingCarPlates: false,
        isLoadingMoreCarPlates: false,
        carPlateError: error.toString(),
      ));
    }
  }

  Future<void> _onLikePost(
    _LikePost event,
    Emitter<HomeState> emit,
  ) async {
    try {
      // Optimistically update the UI
      final updatedPhonePosts = state.phoneNumberPosts.map((post) {
        if (post.id == event.postId) {
          final likedBy = List<String>.from(post.likedBy);
          final isLiked = likedBy.contains(event.userId);
          if (isLiked) {
            likedBy.remove(event.userId);
          } else {
            likedBy.add(event.userId);
          }
          return post.copyWith(likedBy: likedBy);
        }
        return post;
      }).toList();

      final updatedCarPosts = state.carPlatePosts.map((post) {
        if (post.id == event.postId) {
          final likedBy = List<String>.from(post.likedBy);
          final isLiked = likedBy.contains(event.userId);
          if (isLiked) {
            likedBy.remove(event.userId);
          } else {
            likedBy.add(event.userId);
          }
          return post.copyWith(likedBy: likedBy);
        }
        return post;
      }).toList();

      // Update state optimistically
      emit(state.copyWith(
        phoneNumberPosts: updatedPhonePosts,
        carPlatePosts: updatedCarPosts,
      ));

      // Then update in Firebase
      await _likePostUseCase(postId: event.postId, userId: event.userId);
    } catch (error) {
      print('Error toggling like: $error');
      // Revert optimistic update on error
      // For now, just reload the posts to get the correct state
      add(HomeEvent.loadCarPlates(
        countryCode: FirestoreConstants.countryCodeUAE,
      ));
      add(HomeEvent.loadPhoneNumbers(
        countryCode: FirestoreConstants.countryCodeUAE,
      ));
    }
  }

  Future<void> _onFilterCarPlates(
    _FilterCarPlates event,
    Emitter<HomeState> emit,
  ) async {
    // Update filters
    emit(state.copyWith(
      filterEmirate: event.emirate,
      filterCode: event.code,
      filterDigitCount: event.digitCount,
      isLoadingCarPlates: true,
      carPlateError: null,
    ));

    // Reset pagination and reload
    _lastCarPlateDocument = null;

    try {
      final result = await _getPostsByTypeUseCase(
        countryCode: FirestoreConstants.countryCodeUAE,
        postType: PostType.carPlate,
        emirate: event.emirate,
        plateCode: event.code?.isEmpty == true ? null : event.code,
        digitCount: event.digitCount,
        limit: 10,
      );

      _lastCarPlateDocument = result.lastDocument;

      emit(state.copyWith(
        carPlatePosts: result.posts,
        isLoadingCarPlates: false,
        hasMoreCarPlates: result.hasMore,
        carPlateError: null,
      ));
    } catch (error, stackTrace) {
      print('Error filtering car plates: $error');
      print('Stack trace: $stackTrace');
      emit(state.copyWith(
        isLoadingCarPlates: false,
        carPlateError: error.toString(),
      ));
    }
  }

  Future<void> _onFilterPhoneNumbers(
    _FilterPhoneNumbers event,
    Emitter<HomeState> emit,
  ) async {
    // Update filters
    emit(state.copyWith(
      filterPhoneProvider: event.provider,
      filterPhoneCode: event.code,
      isLoadingPhoneNumbers: true,
      phoneNumberError: null,
    ));

    // Reset pagination and reload
    _lastPhoneNumberDocument = null;

    try {
      final result = await _getPostsByTypeUseCase(
        countryCode: FirestoreConstants.countryCodeUAE,
        postType: PostType.phoneNumber,
        phoneProvider: event.provider,
        phoneCode: event.code?.isEmpty == true ? null : event.code,
        limit: 10,
      );

      _lastPhoneNumberDocument = result.lastDocument;

      emit(state.copyWith(
        phoneNumberPosts: result.posts,
        isLoadingPhoneNumbers: false,
        hasMorePhoneNumbers: result.hasMore,
        phoneNumberError: null,
      ));
    } catch (error, stackTrace) {
      print('Error filtering phone numbers: $error');
      print('Stack trace: $stackTrace');
      emit(state.copyWith(
        isLoadingPhoneNumbers: false,
        phoneNumberError: error.toString(),
      ));
    }
  }
}

