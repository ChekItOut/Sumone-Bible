import 'package:flutter/material.dart';
import 'widgets/holy_fire_widget.dart';

/// 성령의 불 캐릭터 애니메이션 테스트 화면
///
/// 정적 이미지 1개 + 투명 배경으로 구현된 애니메이션:
/// - Float (둥실둥실 움직임)
/// - Pulse (크기 맥동)
/// - Glow (테두리 빛남 - 진한 주황색)
/// - Shake (흔들림) - 캐릭터를 탭하면 실행됨
/// - Drag (드래그로 위치 이동, 2초 후 자동 복귀)
class HolyFireTestScreen extends StatelessWidget {
  const HolyFireTestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🔥 성령의 불 캐릭터 테스트'),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.purple.shade50,
              Colors.blue.shade50,
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 제목
                Text(
                  '성령의 불 캐릭터',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                ),
                const SizedBox(height: 8),

                // 설명
                Text(
                  '정적 이미지 1개 + Flutter 애니메이션',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey.shade700,
                      ),
                ),
                const SizedBox(height: 40),

                // 애니메이션 캐릭터
                const HolyFireWidget(
                  imagePath: 'assets/_test/holy_fire_sample.png',
                  size: 200,
                ),
                const SizedBox(height: 40),

                // 안내 메시지
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 32),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '🎨 적용된 애니메이션',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 12),
                      _buildAnimationItem('Float', '위아래로 둥실둥실 움직임'),
                      _buildAnimationItem('Pulse', '크기가 커졌다 작아지는 맥동'),
                      _buildAnimationItem('Glow', '테두리가 진한 주황색으로 반짝임'),
                      _buildAnimationItem('Shake', '캐릭터를 탭하면 흔들림!', highlight: true),
                      _buildAnimationItem('Drag', '드래그로 이동, 2초 후 자동 복귀!', highlight: true),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // 추가 설명
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Text(
                    '💡 이 모든 효과는 정적 이미지 1개만으로 구현되었습니다.',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey.shade600,
                          fontStyle: FontStyle.italic,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnimationItem(String name, String description, {bool highlight = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '• ',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: highlight ? Colors.deepPurple : Colors.grey.shade700,
            ),
          ),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade800,
                ),
                children: [
                  TextSpan(
                    text: '$name: ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: highlight ? Colors.deepPurple : Colors.grey.shade800,
                    ),
                  ),
                  TextSpan(text: description),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
