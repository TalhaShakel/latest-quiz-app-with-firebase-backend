import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:quiz_app/configs/app_config.dart';

DecorationImage getUserImageforEditProfile(BuildContext context, String? imageUrl, File? imageFile, String? assetString) {
  return DecorationImage(
      fit: imageUrl != null || imageFile != null ? BoxFit.cover : BoxFit.scaleDown,
      image: imageUrl != null
          ? CachedNetworkImageProvider(imageUrl)
          : imageFile != null
              ? FileImage(imageFile) as ImageProvider<Object>
              : AssetImage(assetString ?? Config.defaultAvatarString));
}

DecorationImage getUserImage(
    BuildContext context, String? imageUrl, String? assetString) {
  return DecorationImage(
      fit: imageUrl != null ? BoxFit.cover : BoxFit.scaleDown,
      image: imageUrl != null
          ? CachedNetworkImageProvider(imageUrl)
          : AssetImage(assetString ?? Config.defaultAvatarString)
              as ImageProvider<Object>);
}
