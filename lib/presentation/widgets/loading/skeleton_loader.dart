import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// Skeleton Loader - Shimmer 효과를 사용한 로딩 플레이스홀더
///
/// 데이터 로딩 중에 표시할 스켈레톤 UI를 제공합니다.
/// Shimmer 효과로 좌→우로 빛나는 애니메이션을 표시합니다.
///
/// 예시:
/// ```dart
/// SkeletonLoader(width: 200, height: 20)  // 텍스트 플레이스홀더
/// SkeletonLoader(width: double.infinity, height: 150)  // 카드 플레이스홀더
/// ```
///
/// 주요 매개변수:
/// - width: 너비 (필수)
/// - height: 높이 (필수)
/// - borderRadius: 둥근 모서리 (기본값: 8)
class SkeletonLoader extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;

  const SkeletonLoader({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = 8,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}

/// Skeleton Card - 카드 로딩 플레이스홀더
///
/// 카드 형태의 스켈레톤 UI를 제공합니다.
/// 제목, 부제목, 본문을 가진 카드 레이아웃을 모방합니다.
///
/// 예시:
/// ```dart
/// SkeletonCard()  // 기본 카드 스켈레톤
/// ```
class SkeletonCard extends StatelessWidget {
  const SkeletonCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 제목
          SkeletonLoader(width: 150, height: 20, borderRadius: 4),
          SizedBox(height: 12),

          // 부제목
          SkeletonLoader(width: 100, height: 16, borderRadius: 4),
          SizedBox(height: 16),

          // 본문 (3줄)
          SkeletonLoader(width: double.infinity, height: 14, borderRadius: 4),
          SizedBox(height: 8),
          SkeletonLoader(width: double.infinity, height: 14, borderRadius: 4),
          SizedBox(height: 8),
          SkeletonLoader(width: 200, height: 14, borderRadius: 4),
        ],
      ),
    );
  }
}

/// Skeleton List - 리스트 로딩 플레이스홀더
///
/// 여러 개의 리스트 아이템 스켈레톤을 표시합니다.
///
/// 예시:
/// ```dart
/// SkeletonList(itemCount: 5)  // 5개 아이템 표시
/// ```
class SkeletonList extends StatelessWidget {
  final int itemCount;

  const SkeletonList({super.key, this.itemCount = 3});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Row(
            children: [
              // 이미지 플레이스홀더
              const SkeletonLoader(width: 60, height: 60, borderRadius: 8),
              const SizedBox(width: 12),

              // 텍스트 플레이스홀더
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SkeletonLoader(
                      width: double.infinity,
                      height: 16,
                      borderRadius: 4,
                    ),
                    const SizedBox(height: 8),
                    SkeletonLoader(
                      width: MediaQuery.of(context).size.width * 0.6,
                      height: 14,
                      borderRadius: 4,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
