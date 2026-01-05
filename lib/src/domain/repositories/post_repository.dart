import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:raqami/src/domain/constants/firestore_constants.dart';
import 'package:raqami/src/domain/models/line_type.dart';
import 'package:raqami/src/domain/models/phone_provider.dart';
import 'package:raqami/src/domain/models/post_model.dart';
import 'package:raqami/src/domain/models/post_type.dart';
import 'package:raqami/src/domain/models/uae_emirate.dart';

class PostRepository {
  PostRepository({
    required FirebaseFirestore firestore,
  }) : _firestore = firestore;

  final FirebaseFirestore _firestore;

  /// Get the posts collection reference for a specific country
  CollectionReference _getPostsCollection(String countryCode) {
    return _firestore
        .collection(FirestoreConstants.countriesCollection)
        .doc(countryCode.toLowerCase())
        .collection(FirestoreConstants.postsCollection);
  }

  /// Create a new post
  Future<PostModel> createPost({
    required String countryCode,
    required PostType type,
    required String number,
    required double price,
    required String currency,
    required String userId,
    required String creatorPhoneNumber,
    required String creatorName,
    String? description,
    UAEEmirate? emirate,
    String? plateType,
    String? plateCode,
    PhoneProvider? phoneProvider,
    LineType? lineType,
  }) async {
    final postRef = _getPostsCollection(countryCode).doc();
    
    final postModel = PostModel(
      id: postRef.id,
      type: type,
      number: number,
      price: price,
      currency: currency,
      description: description,
      emirate: emirate,
      plateType: plateType,
      plateCode: plateCode,
      phoneProvider: phoneProvider,
      lineType: lineType,
      userId: userId,
      creatorPhoneNumber: creatorPhoneNumber,
      creatorName: creatorName,
      likedBy: [],
      sold: false,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await postRef.set(postModel.toFirestore());
    return postModel;
  }

  /// Get post by ID
  Future<PostModel?> getPostById(String countryCode, String postId) async {
    try {
      final postDoc = await _getPostsCollection(countryCode)
          .doc(postId)
          .get();
      
      if (postDoc.exists) {
        return PostModel.fromFirestore(postDoc);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Get post stream by ID
  Stream<PostModel?> getPostByIdStream(String countryCode, String postId) {
    return _getPostsCollection(countryCode)
        .doc(postId)
        .snapshots()
        .map((postDoc) {
      try {
        if (postDoc.exists) {
          return PostModel.fromFirestore(postDoc);
        }
        return null;
      } catch (e) {
        return null;
      }
    });
  }

  /// Get all posts for a country
  Stream<List<PostModel>> getAllPosts(String countryCode) {
    return _getPostsCollection(countryCode)
        .orderBy(FirestoreConstants.postFieldCreatedAt, descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => PostModel.fromFirestore(doc))
          .toList();
    });
  }

  /// Get posts by type for a country
  Stream<List<PostModel>> getPostsByType(String countryCode, PostType type) {
    return _getPostsCollection(countryCode)
        .where(FirestoreConstants.postFieldType, isEqualTo: type.name)
        .orderBy(FirestoreConstants.postFieldCreatedAt, descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => PostModel.fromFirestore(doc))
          .toList();
    });
  }

  /// Get posts by type with pagination and filtering
  /// Returns a tuple of (posts, lastDocument, hasMore)
  Future<({List<PostModel> posts, DocumentSnapshot? lastDocument, bool hasMore})> getPostsByTypePaginated({
    required String countryCode,
    required PostType type,
    UAEEmirate? emirate,
    String? plateCode,
    int? digitCount,
    PhoneProvider? phoneProvider,
    String? phoneCode,
    DocumentSnapshot? lastDocument,
    int limit = 10,
  }) async {
    try {
      Query query = _getPostsCollection(countryCode)
          .where(FirestoreConstants.postFieldType, isEqualTo: type.name);

      // Apply filters for car plates
      if (emirate != null) {
        query = query.where(FirestoreConstants.postFieldEmirate, isEqualTo: emirate.name);
      }

      if (plateCode != null && plateCode.isNotEmpty) {
        query = query.where(FirestoreConstants.postFieldPlateCode, isEqualTo: plateCode.toUpperCase());
      }

      // Apply filters for phone numbers
      if (phoneProvider != null) {
        query = query.where(FirestoreConstants.postFieldPhoneProvider, isEqualTo: phoneProvider.name);
      }

      // Order by createdAt
      query = query.orderBy(FirestoreConstants.postFieldCreatedAt, descending: true);

      // Apply pagination
      if (lastDocument != null) {
        query = query.startAfterDocument(lastDocument);
      }

      // Limit results (request one extra to check if there are more)
      query = query.limit(limit + 1);

      final snapshot = await query.get();

      // Map documents to posts
      final allPosts = snapshot.docs
          .map((doc) => (doc: doc, post: PostModel.fromFirestore(doc)))
          .toList();

      // Filter by digit count if specified (client-side as Firebase doesn't support regex)
      var filteredPosts = allPosts;
      if (digitCount != null) {
        filteredPosts = allPosts.where((item) {
          final digitsOnly = item.post.number.replaceAll(RegExp(r'[^0-9]'), '');
          return digitsOnly.length == digitCount;
        }).toList();
      }

      // Filter by phone code if specified (client-side filtering)
      if (phoneCode != null && phoneCode.isNotEmpty && type == PostType.phoneNumber) {
        filteredPosts = filteredPosts.where((item) {
          // Extract code from phone number (first 3 characters before space or first 3 chars)
          final numberParts = item.post.number.split(' ');
          final code = numberParts.isNotEmpty 
              ? numberParts[0] 
              : (item.post.number.length >= 3 ? item.post.number.substring(0, 3) : '');
          return code == phoneCode;
        }).toList();
      }

      // Check if there are more results (before filtering)
      final hasMore = snapshot.docs.length > limit;
      
      // Take only the limit amount
      final actualPosts = filteredPosts.take(limit).toList();
      
      // Get the last document from the actual posts returned
      final lastDoc = actualPosts.isNotEmpty
          ? actualPosts.last.doc
          : null;

      return (
        posts: actualPosts.map((item) => item.post).toList(),
        lastDocument: lastDoc,
        hasMore: hasMore && actualPosts.length == limit,
      );
    } catch (e) {
      // If query fails (e.g., missing composite index), fall back to simpler query
      print('Error in paginated query: $e');
      rethrow;
    }
  }

  /// Get all posts for a specific user in a country
  Stream<List<PostModel>> getPostsByUserId(String countryCode, String userId) {
    return _getPostsCollection(countryCode)
        .where(FirestoreConstants.postFieldUserId, isEqualTo: userId)
        .orderBy(FirestoreConstants.postFieldCreatedAt, descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => PostModel.fromFirestore(doc))
          .toList();
    });
  }

  /// Get posts by user ID (non-stream, one-time fetch)
  Future<List<PostModel>> getPostsByUserIdOnce(String countryCode, String userId) async {
    final snapshot = await _getPostsCollection(countryCode)
        .where(FirestoreConstants.postFieldUserId, isEqualTo: userId)
        .orderBy(FirestoreConstants.postFieldCreatedAt, descending: true)
        .get();
    
    return snapshot.docs
        .map((doc) => PostModel.fromFirestore(doc))
        .toList();
  }

  /// Toggle like on a post (searches across all countries using collection group)
  Future<void> toggleLikePost(String postId, String userId) async {
    print("Calling toggleLikePost with postId: $postId and userId: $userId");
    // Use collection group query to search across all posts in all countries
    // Note: We can't filter by documentId directly in collection group queries,
    // so we query and find the matching document
    final postsSnapshot = await _firestore
        .collectionGroup(FirestoreConstants.postsCollection)        .get();

    // Find the post with matching ID
    final postDoc = postsSnapshot.docs.firstWhere(
      (doc) => doc.id == postId,
      orElse: () => throw Exception('Post not found'),
    );

    final data = postDoc.data();
    final likedBy = List<String>.from(data[FirestoreConstants.postFieldLikedBy] ?? []);

    if (likedBy.contains(userId)) {
      likedBy.remove(userId);
    } else {
      likedBy.add(userId);
    }

    await postDoc.reference.update({
      FirestoreConstants.postFieldLikedBy: likedBy,
      FirestoreConstants.postFieldUpdatedAt: FieldValue.serverTimestamp(),
    });
  }



  /// Check if user liked a post (searches across all countries using collection group)
  Future<bool> hasUserLikedPost(String postId, String userId) async {
    try {
      // Use collection group query to search across all posts in all countries
      final postsSnapshot = await _firestore
          .collectionGroup(FirestoreConstants.postsCollection)
          .limit(1000) // Limit to prevent too many reads, adjust if needed
          .get();

      // Find the post with matching ID
      final postDoc = postsSnapshot.docs.firstWhere(
        (doc) => doc.id == postId,
        orElse: () => throw Exception('Post not found'),
      );

      final post = PostModel.fromFirestore(postDoc);
      return post.likedBy.contains(userId);
    } catch (e) {
      return false;
    }
  }

  /// Get all posts liked by a specific user (across all countries)
  Stream<List<PostModel>> getPostsLikedByUser(String userId) {
    print('PostRepository: getPostsLikedByUser called with userId: $userId');
    // Use collection group query to search across all posts collections
    // This searches in countries/{countryCode}/posts regardless of country structure
    return _firestore
        .collectionGroup(FirestoreConstants.postsCollection)
        .where(FirestoreConstants.postFieldLikedBy, arrayContains: userId)
        .orderBy(FirestoreConstants.postFieldCreatedAt, descending: true)
        .snapshots()
        .map((snapshot) {
      print('PostRepository: Found ${snapshot.docs.length} liked posts');
      final posts = snapshot.docs
          .map((doc) => PostModel.fromFirestore(doc))
          .toList();
      
      print('PostRepository: Returning ${posts.length} total liked posts');
      return posts;
    });
  }

  /// Toggle sold status on a post (searches across all countries using collection group)
  Future<void> toggleSoldPost(String postId, bool sold) async {
    print("Calling toggleSoldPost with postId: $postId and sold: $sold");
    // Use collection group query to search across all posts in all countries
    final postsSnapshot = await _firestore
        .collectionGroup(FirestoreConstants.postsCollection)
        .get();

    // Find the post with matching ID
    final postDoc = postsSnapshot.docs.firstWhere(
      (doc) => doc.id == postId,
      orElse: () => throw Exception('Post not found'),
    );

    await postDoc.reference.update({
      FirestoreConstants.postFieldSold: sold,
      FirestoreConstants.postFieldUpdatedAt: FieldValue.serverTimestamp(),
    });
  }

  /// Get all posts created by a specific user (across all countries)
  Stream<List<PostModel>> getPostsByUserIdAcrossCountries(String userId) {
    print('PostRepository: getPostsByUserIdAcrossCountries called with userId: $userId');
    // Use collection group query to search across all posts collections
    return _firestore
        .collectionGroup(FirestoreConstants.postsCollection)
        .where(FirestoreConstants.postFieldUserId, isEqualTo: userId)
        .orderBy(FirestoreConstants.postFieldCreatedAt, descending: true)
        .snapshots()
        .map((snapshot) {
      print('PostRepository: Found ${snapshot.docs.length} posts by user');
      final posts = snapshot.docs
          .map((doc) => PostModel.fromFirestore(doc))
          .toList();
      
      print('PostRepository: Returning ${posts.length} total posts by user');
      return posts;
    });
  }

  /// Update a post (searches across all countries using collection group)
  Future<void> updatePost({
    required String postId,
    String? number,
    double? price,
    bool? sold,
    String? plateCode,
  }) async {
    print("Calling updatePost with postId: $postId");
    // Use collection group query to search across all posts in all countries
    final postsSnapshot = await _firestore
        .collectionGroup(FirestoreConstants.postsCollection)
        .get();

    // Find the post with matching ID
    final postDoc = postsSnapshot.docs.firstWhere(
      (doc) => doc.id == postId,
      orElse: () => throw Exception('Post not found'),
    );

    final updateData = <String, dynamic>{
      FirestoreConstants.postFieldUpdatedAt: FieldValue.serverTimestamp(),
    };

    if (number != null) {
      updateData[FirestoreConstants.postFieldNumber] = number;
    }
    if (price != null) {
      updateData[FirestoreConstants.postFieldPrice] = price;
    }
    if (sold != null) {
      updateData[FirestoreConstants.postFieldSold] = sold;
    }
    if (plateCode != null) {
      updateData[FirestoreConstants.postFieldPlateCode] = plateCode;
    }

    await postDoc.reference.update(updateData);
  }

  /// Delete a post (searches across all countries using collection group)
  Future<void> deletePost(String postId) async {
    print("Calling deletePost with postId: $postId");
    // Use collection group query to search across all posts in all countries
    final postsSnapshot = await _firestore
        .collectionGroup(FirestoreConstants.postsCollection)
        .get();

    // Find the post with matching ID
    final postDoc = postsSnapshot.docs.firstWhere(
      (doc) => doc.id == postId,
      orElse: () => throw Exception('Post not found'),
    );

    await postDoc.reference.delete();
  }

  /// Report a post
  Future<void> reportPost({
    required String postId,
    required String reporterId,
    required String reason,
    String? additionalDetails,
  }) async {
    await _firestore.collection(FirestoreConstants.reportsCollection).add({
      FirestoreConstants.reportFieldPostId: postId,
      FirestoreConstants.reportFieldReporterId: reporterId,
      FirestoreConstants.reportFieldReason: reason,
      FirestoreConstants.reportFieldAdditionalDetails: additionalDetails,
      FirestoreConstants.reportFieldCreatedAt: FieldValue.serverTimestamp(),
      FirestoreConstants.reportFieldStatus: 'pending',
    });
  }
}

