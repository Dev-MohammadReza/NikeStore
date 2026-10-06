import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ImageLoadingService extends StatelessWidget {
  final BorderRadius? borderRadius;
  final String imageUrl;
  const ImageLoadingService({
    super.key, required this.imageUrl, this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final image = CachedNetworkImage(
      imageUrl: imageUrl,
      fit: BoxFit.cover,
    );
    if(borderRadius==null){
      return image;
    }else{
      return ClipRRect(
          borderRadius: borderRadius!,
          child: image
      );
    }

  }
}
