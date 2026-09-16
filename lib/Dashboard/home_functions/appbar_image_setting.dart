import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ProfileImageHelper {
  static Widget buildProfileImage({
    required File? selectedImageFile,
    required String profileImagePath,
    required Widget placeholderAvatar,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: selectedImageFile != null && !kIsWeb
          ? Image.file(
              selectedImageFile,
              width: 56,
              height: 56,
              fit: BoxFit.cover,
            )
          : profileImagePath.startsWith('http') || profileImagePath.startsWith('blob:')
              ? Image.network(
                  profileImagePath,
                  width: 56,
                  height: 56,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => placeholderAvatar,
                )
              : profileImagePath.isEmpty || profileImagePath == 'null'
                  ? placeholderAvatar
                  : !kIsWeb && File(profileImagePath).existsSync()
                      ? Image.file(
                          File(profileImagePath),
                          width: 56,
                          height: 56,
                          fit: BoxFit.cover,
                        )
                      : Image.asset(
                          profileImagePath,
                          width: 56,
                          height: 56,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => placeholderAvatar,
                        ),
    );
  }
}
