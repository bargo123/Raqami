import 'package:flutter/material.dart';
import 'package:raqami/src/domain/models/post_model.dart';
import 'package:raqami/src/presentation/widgets/phone_preview.dart';

/// Widget for displaying phone preview in home list (uses PostModel)
class PhonePreviewCard extends StatelessWidget {
  final PostModel post;
  final Size? size;

  const PhonePreviewCard({
    super.key,
    required this.post,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    return PhonePreview.fromPost(
      post: post,
      showContainer: false,
      size: size,
    );
  }
}


