import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:toysell_app/components/small_loader.dart';
import 'package:toysell_app/constant/asset_paths.dart';

class ImageWidget extends StatelessWidget {
  final String imageUrl;
  final String? svgUrl; // New parameter for SVG URLs
  final double? height;
  final double? width;
  final BoxFit? boxfit;

  const ImageWidget({
    super.key,
    required this.imageUrl,
    this.svgUrl, // Initialize svgUrl
    this.height,
    this.width,
    this.boxfit,
  });

  @override
  Widget build(BuildContext context) {
    // Check if an SVG URL is provided
    if (svgUrl != null && svgUrl!.isNotEmpty) {
      return SvgPicture.network(
        svgUrl!,
        height: height,
        width: width,
        fit: boxfit ?? BoxFit.cover,
        placeholderBuilder: (context) => const SmallLoader(),
        // errorBuilder: (context, error, stackTrace) => Image.asset(
        //   'assets/images/default.jpg',
        //   height: height,
        //   width: width,
        //   fit: BoxFit.fill,
        // ),
      );
    }

    // Fallback to handling regular images if svgUrl is not provided
    return imageUrl.isEmpty
        ? Image.asset(
      AssetPaths.productImage,
      height: height,
      width: width,
      fit: BoxFit.fill,
    )
        : CachedNetworkImage(
      imageUrl: imageUrl,
      height: height,
      width: width,
      fit: boxfit ?? BoxFit.cover,
      placeholder: (context, url) => const SmallLoader(),
      errorWidget: (context, url, error) => Image.asset(
        'assets/images/default.jpg',
        height: height,
        width: width,
        fit: BoxFit.fill,
      ),
    );
  }
}
