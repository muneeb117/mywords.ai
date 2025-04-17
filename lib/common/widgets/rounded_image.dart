import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mywords/utils/extensions/extended_context.dart';

class RoundedImage extends StatelessWidget {
  final String? imageUrl;
  final double borderRadius;
  final double width;
  final double height;
  final String fallbackAssetPath;
  final double borderWidth;
  final Color borderColor;

  const RoundedImage({
    super.key,
    required this.imageUrl,
    this.borderRadius = 12,
    this.width = 100,
    this.height = 100,
    this.fallbackAssetPath = 'assets/images/png/profile_placeholder.jpg',
    this.borderWidth = 2,
    this.borderColor = Colors.grey,
  });

  @override
  Widget build(BuildContext context) {
    final isNetworkImageAvailable = imageUrl != null && imageUrl!.isNotEmpty;
    return Container(
      width: 90,
      height: 90,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: context.colorScheme.primary,
          width: 1,
        ),
      ),
      child: CircleAvatar(
        backgroundColor: Colors.black,
        radius: 45,
        backgroundImage: isNetworkImageAvailable ? CachedNetworkImageProvider(imageUrl!) : AssetImage(fallbackAssetPath) as ImageProvider,
      ),
    );
  }
}
