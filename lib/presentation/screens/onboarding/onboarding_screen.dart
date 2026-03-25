import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme.dart';
import 'widgets/onboarding_page.dart';

/// 온보딩 화면
///
/// 새로운 사용자를 위한 3단계 온보딩 플로우
/// 참조: docs/prd.md 섹션 F-014
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // 온보딩 페이지 데이터
  final List<Map<String, dynamic>> _pages = [
    {
      'icon': Icons.favorite,
      'title': '두 사람의 신앙 여정을\n함께 시작해요 ✨',
      'description': 'Bible SumOne과 함께\n매일 말씀으로 서로를 알아가세요',
    },
    {
      'icon': Icons.auto_stories,
      'title': '매일 짧은 말씀과 질문으로\n서로를 더 깊이 알아가요',
      'description': '3-5분이면 충분해요\n부담 없이 꾸준히 나눌 수 있어요',
    },
    {
      'icon': Icons.connect_without_contact,
      'title': '파트너를 초대하고\n첫 말씀을 나눠보세요',
      'description': '함께하면 더 재미있어요\n지금 바로 시작해볼까요?',
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // 마지막 페이지에서 "시작하기" 버튼 클릭
      context.push('/profile-setup');
    }
  }

  void _skip() {
    // 바로 프로필 설정으로 이동
    context.push('/profile-setup');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      body: SafeArea(
        child: Column(
          children: [
            // 상단 스킵 버튼
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: _skip,
                  child: const Text(
                    '건너뛰기',
                    style: TextStyle(
                      color: AppTheme.textOnBackgroundLight,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),

            // 페이지뷰
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  final page = _pages[index];
                  return OnboardingPage(
                    icon: page['icon'] as IconData,
                    title: page['title'] as String,
                    description: page['description'] as String,
                  );
                },
              ),
            ),

            // 하단 인디케이터 & 버튼
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  // 페이지 인디케이터
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _pages.length,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: _currentPage == index ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _currentPage == index
                              ? AppTheme.primaryColor
                              : AppTheme.textOnBackgroundLight.withValues(
                                  alpha: 0.3,
                                ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // 다음/시작하기 버튼
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _nextPage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        _currentPage == _pages.length - 1 ? '시작하기' : '다음',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
