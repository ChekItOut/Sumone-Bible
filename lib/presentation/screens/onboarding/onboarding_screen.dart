import 'dart:async';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme.dart';
import '../../../core/constants/supabase_client.dart';
import '../../../data/datasources/supabase_auth_datasource.dart';
import 'widgets/onboarding_page.dart';

/// 온보딩 화면
///
/// 새로운 사용자를 위한 3단계 온보딩 플로우
/// 참조: docs/prd.md 섹션 F-014
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool _isLoading = false;
  StreamSubscription? _authSubscription;

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
  void initState() {
    super.initState();

    // 웹 환경에서는 auth state changes를 리스닝하여
    // OAuth 로그인 완료를 감지
    if (kIsWeb) {
      _authSubscription = supabase.auth.onAuthStateChange.listen((data) {
        final session = data.session;
        if (session != null && mounted) {
          // 로그인 완료 → 프로필 설정으로 이동
          print('✅ [Web] OAuth 로그인 완료: ${session.user.id}');
          context.push('/profile-setup');
        }
      });
    }
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
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
      // 마지막 페이지에서 "시작하기" 버튼 클릭 → Google 로그인
      _signInWithGoogle();
    }
  }

  void _skip() {
    // 건너뛰기 → Google 로그인
    _signInWithGoogle();
  }

  /// Google 로그인 수행
  ///
  /// 웹: OAuth 페이지 리다이렉트 → authStateChanges로 완료 감지
  /// 모바일: 네이티브 Sign-In → 즉시 완료
  Future<void> _signInWithGoogle() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      print('🔐 Google 로그인 시작');
      final dataSource = SupabaseAuthDataSource();

      if (kIsWeb) {
        // 웹: OAuth 플로우 시작 (전체 페이지 리다이렉트)
        print('🌐 [Web] OAuth 플로우 시작...');
        await dataSource.signInWithGoogle();

        // NOTE: 웹에서는 페이지가 Google로 리다이렉트되므로
        // 이 코드는 실행되지 않을 가능성이 높습니다.
        // 로그인 후 앱으로 돌아오면 authStateChanges가 트리거됩니다.
        print('⏳ [Web] OAuth 리다이렉트 대기 중...');
        // 로딩 상태 유지 (페이지가 리다이렉트될 것임)
      } else {
        // 모바일: 네이티브 Sign-In (즉시 완료)
        print('📱 [Mobile] 네이티브 Google Sign-In...');
        final user = await dataSource.signInWithGoogle();

        print('✅ Google 로그인 성공: ${user.id}');

        if (mounted) {
          setState(() {
            _isLoading = false;
          });

          // 로그인 성공 → 프로필 설정으로 이동
          context.push('/profile-setup');
        }
      }
    } catch (e) {
      print('❌ Google 로그인 실패: $e');

      // 웹에서는 OAuth 플로우 시작 실패만 에러로 표시
      // (리다이렉트되면 이 코드는 실행되지 않음)
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              kIsWeb ? '로그인을 시작할 수 없습니다. 페이지를 새로고침하고 다시 시도해주세요.' : '로그인 실패: $e',
            ),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );

        setState(() {
          _isLoading = false;
        });
      }
    }
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
                      onPressed: _isLoading ? null : _nextPage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              _currentPage == _pages.length - 1
                                  ? 'Google로 시작하기'
                                  : '다음',
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
