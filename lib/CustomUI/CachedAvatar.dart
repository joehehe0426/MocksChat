import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:shimmer/shimmer.dart';
import 'dart:io';

class CachedAvatar extends StatelessWidget {
  final String? imagePath;
  final String? fallbackIcon;
  final double radius;
  final bool isGroup;
  final String? name;
  final int? contactId;

  const CachedAvatar({
    Key? key,
    this.imagePath,
    this.fallbackIcon,
    this.radius = 28,
    this.isGroup = false,
    this.name,
    this.contactId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: radius * 2,
      height: radius * 2,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey[300],
      ),
      child: ClipOval(
        child: _buildImageWidget(),
      ),
    );
  }

  Widget _buildImageWidget() {
    // If it's a group, show group icon
    if (isGroup) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          color: Color(0xFF075E54),
        ),
        child: Icon(
          Icons.group,
          color: Colors.white,
          size: radius,
        ),
      );
    }

    // Try to load profile image
    if (imagePath != null && imagePath!.isNotEmpty) {
      return _buildProfileImage();
    }

    // Fallback to contact ID mapping
    String fallbackPath = _getFallbackProfileImage(contactId ?? 0);
    if (fallbackPath.isNotEmpty) {
      return _buildAssetImage(fallbackPath);
    }

    // Final fallback to icon
    return _buildFallbackIcon();
  }

  Widget _buildProfileImage() {
    if (imagePath!.startsWith('assets/')) {
      return _buildAssetImage(imagePath!);
    } else if (imagePath!.startsWith('http')) {
      return _buildNetworkImage(imagePath!);
    } else {
      return _buildFileImage(imagePath!);
    }
  }

  Widget _buildAssetImage(String path) {
    return Image.asset(
      path,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        print('❌ Error loading asset image: $path - $error');
        return _buildFallbackIcon();
      },
    );
  }

  Widget _buildNetworkImage(String url) {
    return CachedNetworkImage(
      imageUrl: url,
      fit: BoxFit.cover,
      cacheManager: DefaultCacheManager(),
      placeholder: (context, url) => _buildShimmerPlaceholder(),
      errorWidget: (context, url, error) {
        print('❌ Error loading network image: $url - $error');
        return _buildFallbackIcon();
      },
    );
  }

  Widget _buildFileImage(String path) {
    return Image.file(
      File(path),
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        print('❌ Error loading file image: $path - $error');
        return _buildFallbackIcon();
      },
    );
  }

  Widget _buildShimmerPlaceholder() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        color: Colors.white,
      ),
    );
  }

  Widget _buildFallbackIcon() {
    if (fallbackIcon != null && fallbackIcon!.isNotEmpty) {
      return SvgPicture.asset(
        "assets/$fallbackIcon",
        color: Colors.grey[600],
        width: radius,
        height: radius,
      );
    }
    
    // Show initials if name is available
    if (name != null && name!.isNotEmpty) {
      return Container(
        color: _getAvatarColor(name!),
        child: Center(
          child: Text(
            _getInitials(name!),
            style: TextStyle(
              color: Colors.white,
              fontSize: radius * 0.6,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    }
    
    // Default icon
    return Icon(
      Icons.person,
      color: Colors.grey[600],
      size: radius,
    );
  }

  String _getFallbackProfileImage(int contactId) {
    // Map contact IDs to profile pictures (16-30, since your contacts have IDs 16-30)
    if (contactId >= 16 && contactId <= 30) {
      // Map contact ID 16-30 to photo 1-6 (cycling through your 6 photos)
      int photoNumber = ((contactId - 16) % 6) + 1;
      String imagePath = 'assets/profile_pictures/$photoNumber.jpg';
      print('🖼️ Fallback image for contact $contactId: $imagePath (mapped from photo $photoNumber)');
      return imagePath;
    }
    print('❌ No fallback image for contact $contactId (ID not in range 16-30)');
    return '';
  }

  String _getInitials(String name) {
    List<String> parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    } else if (parts.length == 1) {
      return parts[0][0].toUpperCase();
    }
    return '?';
  }

  Color _getAvatarColor(String name) {
    // Generate consistent color based on name
    int hash = name.hashCode;
    return Color.fromARGB(255, 
      (hash & 0xFF0000) >> 16, 
      (hash & 0x00FF00) >> 8, 
      hash & 0x0000FF
    ).withOpacity(0.8);
  }
}
