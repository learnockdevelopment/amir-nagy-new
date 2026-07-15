import 'package:flutter/material.dart';
import 'package:amirnagy/utils/iconly.dart';
import 'package:amirnagy/providers/language_provider.dart';

class CourseCard extends StatelessWidget {
  final Map<String, dynamic> course;
  final bool isEnrolled;
  final bool enablePurchasing;
  final bool isFavorite;
  final VoidCallback onTap;
  final VoidCallback? onFavoriteTap;
  final LanguageProvider lang;
  final String? currency;

  const CourseCard({
    super.key,
    required this.course,
    required this.isEnrolled,
    required this.enablePurchasing,
    required this.isFavorite,
    required this.onTap,
    this.onFavoriteTap,
    required this.lang,
    this.currency,
  });

  static String _stripHtml(String? html) {
    if (html == null || html.isEmpty) return '';
    String result = html
        .replaceAll('&nbsp;', ' ')
        .replaceAll('&amp;', '&')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&quot;', '"')
        .replaceAll('&#39;', "'")
        .replaceAll('&apos;', "'");
    result = result.replaceAll(RegExp(r'<[^>]*>'), '');
    result = result.replaceAll(RegExp(r'\s+'), ' ').trim();
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final primary = theme.primaryColor;
    final onSurface = theme.colorScheme.onSurface;

    final String title = course['title'] ?? '';
    final String desc = _stripHtml(course['description']?.toString());
    final String thumb = course['thumbnail_url']?.toString() ?? course['image_url']?.toString() ?? '';
    final String cat = course['category_name']?.toString() ?? '';
    final bool hasDemo = course['demo_video_url'] != null && course['demo_video_url'].toString().isNotEmpty;

    final bool isFree = course['is_free'] == 1 || course['is_free'] == '1' || course['is_free'] == true
        || course['price'] == '0.00' || course['price'] == 0 || course['price'] == '0';
    final String priceStr = course['price']?.toString() ?? '0.00';
    final double progress = double.tryParse(course['progress']?.toString() ?? '0') ?? 0.0;

    final String lecturesCount = course['total_materials']?.toString()
        ?? course['materials_count']?.toString() ?? '0';
    final String studentsCount = course['total_students']?.toString()
        ?? course['enrollment_count']?.toString()
        ?? course['members_count']?.toString() ?? '0';

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.05)),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        padding: const EdgeInsets.all(10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // ── THUMBNAIL ─────────────────────────────────────────────────
            SizedBox(
              width: 90,
              height: 90,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    if (thumb.isNotEmpty)
                      Image.network(
                        thumb,
                        fit: BoxFit.cover,
                        errorBuilder: (c, e, s) => Container(
                          color: primary.withOpacity(0.1),
                          child: Icon(IconlyLight.image, color: primary, size: 24),
                        ),
                      )
                    else
                      Container(color: primary.withOpacity(0.1), child: Icon(IconlyLight.image, color: primary, size: 24)),
                    if (hasDemo)
                      Center(
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(color: Colors.black.withOpacity(0.5), shape: BoxShape.circle),
                          child: const Icon(IconlyBold.play, color: Colors.white, size: 14),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            // ── DETAILS COLUMN ────────────────────────────────────────────
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (cat.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            cat.toUpperCase(),
                            style: TextStyle(color: primary, fontSize: 8, fontWeight: FontWeight.w900, letterSpacing: 0.5),
                          ),
                        )
                      else
                        const SizedBox.shrink(),
                      if (onFavoriteTap != null)
                        GestureDetector(
                          onTap: onFavoriteTap,
                          child: Icon(
                            isFavorite ? IconlyBold.heart : IconlyLight.heart,
                            color: isFavorite ? Colors.redAccent : onSurface.withOpacity(0.4),
                            size: 16,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    title,
                    style: TextStyle(color: onSurface, fontSize: 13, fontWeight: FontWeight.w900, height: 1.2),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (desc.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      desc,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: onSurface.withOpacity(0.45), fontSize: 10, fontWeight: FontWeight.w500),
                    ),
                  ],
                  const SizedBox(height: 6),
                  if (isEnrolled) ...[
                    // Progress
                    Row(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: progress / 100,
                              backgroundColor: primary.withOpacity(0.1),
                              valueColor: AlwaysStoppedAnimation<Color>(primary),
                              minHeight: 3,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${progress.round()}%',
                          style: TextStyle(color: primary, fontSize: 9, fontWeight: FontWeight.w900),
                        ),
                      ],
                    ),
                  ] else ...[
                    // Stats & Price Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(IconlyLight.document, size: 10, color: onSurface.withOpacity(0.4)),
                            const SizedBox(width: 2),
                            Text(
                              '$lecturesCount',
                              style: TextStyle(color: onSurface.withOpacity(0.5), fontSize: 9, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(width: 8),
                            Icon(IconlyLight.user, size: 10, color: onSurface.withOpacity(0.4)),
                            const SizedBox(width: 2),
                            Text(
                              '$studentsCount',
                              style: TextStyle(color: onSurface.withOpacity(0.5), fontSize: 9, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        if (enablePurchasing)
                          Text(
                            isFree ? (lang.translate('free') ?? 'Free') : '$priceStr ${currency ?? ''}',
                            style: TextStyle(color: primary, fontSize: 12, fontWeight: FontWeight.w900),
                          ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
