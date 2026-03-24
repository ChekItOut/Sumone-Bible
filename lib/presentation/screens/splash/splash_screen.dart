import 'package:flutter/material.dart';

/// Phase 0 임시 스플래시/환영 화면
///
/// 프로젝트 진행 상황을 표시
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 앱 아이콘 (임시)
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.favorite,
                  size: 64,
                  color: Color(0xFFFF6B9D),
                ),
              ),

              const SizedBox(height: 32),

              // 앱 이름
              const Text(
                'Bible SumOne',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 8),

              // 부제목
              const Text(
                '크리스천 커플을 위한 성경 나눔',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
              ),

              const SizedBox(height: 64),

              // Phase 0 완료 상태
              Container(
                padding: const EdgeInsets.all(24),
                margin: const EdgeInsets.symmetric(horizontal: 32),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    const Icon(
                      Icons.check_circle,
                      size: 48,
                      color: Color(0xFF6B4DE8),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Phase 0 완료!',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '프로젝트 셋업 완료',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF666666),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // 완료 항목
                    _buildCheckItem('✅ Flutter 프로젝트 초기화'),
                    _buildCheckItem('✅ Supabase 설정 완료'),
                    _buildCheckItem('✅ 테마 & 라우팅 설정'),

                    const SizedBox(height: 16),

                    // Supabase 연결 상태
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.cloud_done,
                          size: 20,
                          color: Colors.green,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Supabase 연결됨',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.green,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // 다음 단계 안내
              const Text(
                '다음: Phase 1 인증 시스템',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCheckItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          color: Color(0xFF1A1A1A),
        ),
      ),
    );
  }
}
