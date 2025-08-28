import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:sizer/sizer.dart';

class RecipeHeaderWidget extends StatelessWidget {
  final String imageUrl;
  final bool isVisible;
  final bool isSaved;
  final VoidCallback onBack;
  final VoidCallback onSave;
  final VoidCallback onShare;

  const RecipeHeaderWidget({
    super.key,
    required this.imageUrl,
    required this.isVisible,
    required this.isSaved,
    required this.onBack,
    required this.onSave,
    required this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 50.h,
      floating: false,
      pinned: true,
      backgroundColor: Colors.black.withAlpha(179),
      automaticallyImplyLeading: false,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                color: Colors.grey[300],
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
              errorWidget: (context, url, error) => Container(
                color: Colors.grey[300],
                child: const Icon(
                  Icons.restaurant,
                  size: 50,
                  color: Colors.grey,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withAlpha(102),
                    Colors.transparent,
                    Colors.black.withAlpha(179),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        Container(
          margin: EdgeInsets.only(right: 2.w, top: 2.h),
          child: Row(
            children: [
              _buildHeaderButton(
                icon: Icons.share,
                onPressed: onShare,
              ),
              SizedBox(width: 2.w),
              _buildHeaderButton(
                icon: isSaved ? Icons.favorite : Icons.favorite_border,
                onPressed: onSave,
                color: isSaved ? Colors.red : null,
              ),
            ],
          ),
        ),
      ],
      leading: Container(
        margin: EdgeInsets.only(left: 2.w, top: 2.h),
        child: _buildHeaderButton(
          icon: Icons.arrow_back,
          onPressed: onBack,
        ),
      ),
    );
  }

  Widget _buildHeaderButton({
    required IconData icon,
    required VoidCallback onPressed,
    Color? color,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withAlpha(128),
        borderRadius: BorderRadius.circular(20),
      ),
      child: IconButton(
        icon: Icon(
          icon,
          color: color ?? Colors.white,
          size: 24,
        ),
        onPressed: onPressed,
      ),
    );
  }
}
