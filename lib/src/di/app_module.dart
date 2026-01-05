import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import 'package:raqami/src/domain/use_case/like_post_use_case.dart';
import 'package:raqami/src/domain/use_case/report_post_use_case.dart';
import 'package:raqami/src/presentation/create_account/bloc/create_account_bloc.dart';
import 'package:raqami/src/presentation/login/bloc/login_bloc.dart';
import 'package:raqami/src/presentation/email_verification/bloc/email_verification_bloc.dart' show EmailVerificationBloc;
import 'package:raqami/src/presentation/edit_profile/bloc/edit_profile_bloc.dart';
import 'package:raqami/src/presentation/profile/bloc/profile_bloc.dart';
import 'package:raqami/src/presentation/home/bloc/home_bloc.dart';
import 'package:raqami/src/presentation/wishlist/bloc/wishlist_bloc.dart';
import 'package:raqami/src/presentation/my_posts/bloc/my_posts_bloc.dart';
import 'package:raqami/src/presentation/post_detail/bloc/post_detail_bloc.dart';
import 'package:raqami/src/presentation/post_info/bloc/post_info_bloc.dart';
import 'package:raqami/src/domain/models/post_model.dart';
import 'package:raqami/src/domain/use_case/sign_in_with_email_use_case.dart';
import 'package:raqami/src/core/utils/language_preference_manager.dart';
import 'package:raqami/src/domain/use_case/sign_up_with_email_use_case.dart';
import 'package:raqami/src/domain/use_case/complete_sign_up_use_case.dart';
import 'package:raqami/src/domain/use_case/get_user_data_use_case.dart';
import 'package:raqami/src/domain/use_case/update_user_profile_use_case.dart';
import 'package:raqami/src/domain/use_case/sign_out_use_case.dart';
import 'package:raqami/src/domain/use_case/create_post_use_case.dart';
import 'package:raqami/src/domain/use_case/toggle_like_post_use_case.dart';
import 'package:raqami/src/domain/use_case/get_posts_by_type_use_case.dart';
import 'package:raqami/src/domain/use_case/get_posts_liked_by_user_use_case.dart';
import 'package:raqami/src/domain/use_case/get_posts_by_user_id_use_case.dart';
import 'package:raqami/src/domain/use_case/toggle_sold_post_use_case.dart';
import 'package:raqami/src/domain/use_case/update_post_use_case.dart';
import 'package:raqami/src/domain/use_case/delete_post_use_case.dart';
import 'package:raqami/src/domain/repositories/auth_repository.dart';
import 'package:raqami/src/domain/repositories/user_repositotry.dart';
import 'package:raqami/src/domain/repositories/post_repository.dart';
import 'package:raqami/src/presentation/wrapper/bloc/wrapper_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

@module  
abstract class RegisterModule {  
  @singleton
  FirebaseAuth get firebaseAuth => FirebaseAuth.instance;

  @singleton
  FirebaseFirestore get firestore => FirebaseFirestore.instance;

  @preResolve
  @singleton
  Future<SharedPreferences> get sharedPreferences async => await SharedPreferences.getInstance();

  // BLoCs
  @injectable
  LoginBloc loginBloc(SignInWithEmailUseCase signInWithEmailUseCase) => 
      LoginBloc(signInWithEmailUseCase: signInWithEmailUseCase);

  @injectable
  EmailVerificationBloc emailVerificationBloc(CompleteSignUpUseCase completeSignUpUseCase) => 
      EmailVerificationBloc(completeSignUpUseCase: completeSignUpUseCase);
  
  @injectable
  CreateAccountBloc createAccountBloc(SignUpWithEmailUseCase signUpWithEmailUseCase) => 
      CreateAccountBloc(signUpWithEmailUseCase: signUpWithEmailUseCase);

  @injectable
  WrapperBloc wrapperBloc(GetUserDataUseCase getUserDataUseCase) => 
      WrapperBloc(getUserDataUseCase: getUserDataUseCase);

  @injectable
  EditProfileBloc editProfileBloc(
    GetUserDataUseCase getUserDataUseCase,
    UpdateUserProfileUseCase updateUserProfileUseCase,
  ) => EditProfileBloc(
    updateUserProfileUseCase: updateUserProfileUseCase,
  );

  @injectable
  ProfileBloc profileBloc(
    SignOutUseCase signOutUseCase,
    GetPostsByUserIdUseCase getPostsByUserIdUseCase,
    GetPostsLikedByUserUseCase getPostsLikedByUserUseCase,
  ) => ProfileBloc(
    signOutUseCase: signOutUseCase,
    getPostsByUserIdUseCase: getPostsByUserIdUseCase,
    getPostsLikedByUserUseCase: getPostsLikedByUserUseCase,
  );

  @injectable
  HomeBloc homeBloc(GetPostsByTypeUseCase getPostsByTypeUseCase, LikePostUseCase likePostUseCase) => 
      HomeBloc(getPostsByTypeUseCase: getPostsByTypeUseCase, likePostUseCase: likePostUseCase);

  @injectable
  WishlistBloc wishlistBloc(
    GetPostsLikedByUserUseCase getPostsLikedByUserUseCase,
    LikePostUseCase likePostUseCase,
  ) => WishlistBloc(
    getPostsLikedByUserUseCase: getPostsLikedByUserUseCase,
    likePostUseCase: likePostUseCase,
  );

  @injectable
  MyPostsBloc myPostsBloc(
    GetPostsByUserIdUseCase getPostsByUserIdUseCase,
    ToggleSoldPostUseCase toggleSoldPostUseCase,
    DeletePostUseCase deletePostUseCase,
  ) => MyPostsBloc(
    getPostsByUserIdUseCase: getPostsByUserIdUseCase,
    toggleSoldPostUseCase: toggleSoldPostUseCase,
    deletePostUseCase: deletePostUseCase,
  );

  @injectable
  PostDetailBloc postDetailBloc(
    UpdatePostUseCase updatePostUseCase,
    DeletePostUseCase deletePostUseCase,
  ) => PostDetailBloc(
    updatePostUseCase: updatePostUseCase,
    deletePostUseCase: deletePostUseCase,
  );

  @injectable
  PostInfoBloc postInfoBloc(
    LikePostUseCase likePostUseCase,
    ReportPostUseCase reportPostUseCase,
    @factoryParam PostModel initialPost,
  ) => PostInfoBloc(
    likePostUseCase: likePostUseCase,
    reportPostUseCase: reportPostUseCase,
    initialPost: initialPost,
  );

  @injectable
  LanguagePreferenceManager languagePreferenceManager(
    SharedPreferences sharedPreferences,
  ) => LanguagePreferenceManager(sharedPreferences);

  // Repositories - Register before use cases that depend on them
  @injectable
  AuthRepository authRepository(FirebaseAuth firebaseAuth, FirebaseFirestore firestore) => 
      AuthRepository(firebaseAuth: firebaseAuth);

  @injectable
  UserRepository userRepository(
    FirebaseFirestore firestore,
    SharedPreferences sharedPreferences,
  ) => UserRepository(
    firestore: firestore,
  );

  @injectable
  PostRepository postRepository(
    FirebaseFirestore firestore,
  ) => PostRepository(
    firestore: firestore,
  );

  // Use cases
  @injectable
  SignInWithEmailUseCase signInWithEmailUseCase(AuthRepository authRepository, UserRepository userRepository) => 
      SignInWithEmailUseCase(authRepository: authRepository, userRepository: userRepository);

  @injectable
  SignUpWithEmailUseCase signUpWithEmailUseCase(AuthRepository authRepository, UserRepository userRepository) => 
      SignUpWithEmailUseCase(authRepository: authRepository, userRepository: userRepository);

  @injectable
  CompleteSignUpUseCase completeSignUpUseCase(AuthRepository authRepository, UserRepository userRepository) => 
      CompleteSignUpUseCase(authRepository: authRepository, userRepository: userRepository);

  @injectable
  GetUserDataUseCase getUserDataUseCase(
    AuthRepository authRepository,
    UserRepository userRepository,
  ) => GetUserDataUseCase(
    authRepository: authRepository,
    userRepository: userRepository,
  );

  @injectable
  UpdateUserProfileUseCase updateUserProfileUseCase(
    AuthRepository authRepository,
    UserRepository userRepository,
  ) => UpdateUserProfileUseCase(
    authRepository: authRepository,
    userRepository: userRepository,
  );

  @injectable
  SignOutUseCase signOutUseCase(
    AuthRepository authRepository,
  ) => SignOutUseCase(
    authRepository: authRepository,
  );


  // Post Use Cases
  @injectable
  CreatePostUseCase createPostUseCase(
    PostRepository postRepository,
    AuthRepository authRepository,
    UserRepository userRepository,
  ) => CreatePostUseCase(
    postRepository: postRepository,
    authRepository: authRepository,
    userRepository: userRepository,
  );

  @injectable
  ToggleLikePostUseCase toggleLikePostUseCase(
    PostRepository postRepository,
    AuthRepository authRepository,
  ) => ToggleLikePostUseCase(
    postRepository: postRepository,
    authRepository: authRepository,
  );

  @injectable
  GetPostsByTypeUseCase getPostsByTypeUseCase(
    PostRepository postRepository,
  ) => GetPostsByTypeUseCase(
    postRepository: postRepository,
  );

  @injectable
  GetPostsLikedByUserUseCase getPostsLikedByUserUseCase(
    PostRepository postRepository,
    AuthRepository authRepository,
  ) => GetPostsLikedByUserUseCase(
    postRepository: postRepository,
  );

  @injectable
  LikePostUseCase likePostUseCase(
    PostRepository postRepository,
  ) => LikePostUseCase(
    postRepository: postRepository,
  );

  @injectable
  ReportPostUseCase reportPostUseCase(
    PostRepository postRepository,
  ) => ReportPostUseCase(
    postRepository: postRepository,
  );

  @injectable
  GetPostsByUserIdUseCase getPostsByUserIdUseCase(
    PostRepository postRepository,
  ) => GetPostsByUserIdUseCase(
    postRepository: postRepository,
  );

  @injectable
  ToggleSoldPostUseCase toggleSoldPostUseCase(
    PostRepository postRepository,
  ) => ToggleSoldPostUseCase(
    postRepository: postRepository,
  );

  @injectable
  UpdatePostUseCase updatePostUseCase(
    PostRepository postRepository,
  ) => UpdatePostUseCase(
    postRepository: postRepository,
  );

  @injectable
  DeletePostUseCase deletePostUseCase(
    PostRepository postRepository,
  ) => DeletePostUseCase(
    postRepository: postRepository,
  );

}  