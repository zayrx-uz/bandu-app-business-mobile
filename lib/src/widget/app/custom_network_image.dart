import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CustomNetworkImage extends StatelessWidget {
  final double? height, width, borderRadius;
  final String? imageUrl;
  final BoxFit? fit;

  const CustomNetworkImage({
    super.key,
    this.height,
    this.width,
    this.borderRadius,
    this.imageUrl,
    this.fit,
  });

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null || imageUrl!.isEmpty) {
      return Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius ?? 0),
          color: Colors.grey[300],
        ),
        child: Icon(
          Icons.person,
          size: (height != null && width != null)
              ? (height! < width! ? height! / 2 : width! / 2)
              : 24,
        ),
      );
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius ?? 0),
      child: CachedNetworkImage(
        imageUrl: imageUrl!,
        height: height,
        width: width,
        fit: fit ?? BoxFit.cover,
        errorWidget: (context, error, stackTrace) {
          return Container(
            height: height,
            width: width,
            color: Colors.grey[300],
            child: Icon(
              Icons.broken_image,
              size: (height != null && width != null)
                  ? (height! < width! ? height! / 2 : width! / 2)
                  : 24,
            ),
          );
        },
      ),
    );
  }
}
