import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_config.dart';
import '../../providers/auth_provider.dart';
import '../../providers/auth_state.dart';

/// Firebase 인증 테스트 화면
///
/// Phase 1 Task 1.4: 인증 테스트
/// - 이메일 로그인/회원가입
/// - Google 로그인
/// - 로그아웃
/// - Auth State Changes
class FirebaseAuthTestScreen extends ConsumerStatefulWidget {
  const FirebaseAuthTestScreen({super.key});

  @override
  ConsumerState<FirebaseAuthTestScreen> createState() =>
      _FirebaseAuthTestScreenState();
}

class _FirebaseAuthTestScreenState
    extends ConsumerState<FirebaseAuthTestScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('🔥 Firebase 인증 테스트'),
        backgroundColor: Colors.orange,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 현재 상태 표시
            _buildStatusCard(authState),

            const SizedBox(height: 24),

            // Feature Flag 상태
            _buildFeatureFlagCard(),

            const SizedBox(height: 24),

            // 이메일/비밀번호 입력
            _buildEmailPasswordForm(),

            const SizedBox(height: 24),

            // 액션 버튼들
            _buildActionButtons(authState),
          ],
        ),
      ),
    );
  }

  /// 현재 인증 상태 카드
  Widget _buildStatusCard(AuthState authState) {
    final isAuthenticated = authState.user != null;
    final statusColor = isAuthenticated ? Colors.green : Colors.grey;
    final statusIcon = isAuthenticated ? Icons.check_circle : Icons.cancel;
    final statusText = isAuthenticated ? '로그인 상태' : '로그아웃 상태';

    return Card(
      color: statusColor.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(statusIcon, size: 48, color: statusColor),
            const SizedBox(height: 8),
            Text(
              statusText,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: statusColor,
              ),
            ),
            if (authState.user != null) ...[
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 8),
              _buildUserInfo(authState.user!),
            ],
            if (authState.error != null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error, color: Colors.red),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        authState.error!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// 사용자 정보 표시
  Widget _buildUserInfo(user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoRow('ID', user.id),
        _buildInfoRow('이메일', user.email),
        _buildInfoRow('이름', user.name ?? '(없음)'),
        _buildInfoRow('생성일', user.createdAt.toString().split('.')[0]),
        _buildInfoRow('이메일 인증', user.emailVerified ? '✅ 인증됨' : '❌ 미인증'),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 14))),
        ],
      ),
    );
  }

  /// Feature Flag 상태 카드
  Widget _buildFeatureFlagCard() {
    final useFirebase = AppConfig.useFirebase;
    final backendName = useFirebase ? 'Firebase 🔥' : 'Supabase 🟢';
    final backendColor = useFirebase ? Colors.orange : Colors.green;

    return Card(
      color: backendColor.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(Icons.settings, color: backendColor),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '현재 백엔드',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    backendName,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: backendColor,
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

  /// 이메일/비밀번호 입력 폼
  Widget _buildEmailPasswordForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '이메일/비밀번호 인증',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              labelText: '이메일',
              hintText: 'test@example.com',
              prefixIcon: Icon(Icons.email),
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '이메일을 입력하세요';
              }
              if (!value.contains('@')) {
                return '유효한 이메일을 입력하세요';
              }
              return null;
            },
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _passwordController,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: '비밀번호',
              hintText: '최소 6자',
              prefixIcon: Icon(Icons.lock),
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '비밀번호를 입력하세요';
              }
              if (value.length < 6) {
                return '비밀번호는 최소 6자 이상이어야 합니다';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  /// 액션 버튼들
  Widget _buildActionButtons(AuthState authState) {
    final isLoading = authState.isLoading;
    final isAuthenticated = authState.user != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 이메일 로그인
        ElevatedButton.icon(
          onPressed: isLoading || isAuthenticated ? null : _handleEmailSignIn,
          icon: const Icon(Icons.login),
          label: const Text('이메일 로그인'),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
          ),
        ),

        const SizedBox(height: 12),

        // 이메일 회원가입
        ElevatedButton.icon(
          onPressed: isLoading || isAuthenticated ? null : _handleEmailSignUp,
          icon: const Icon(Icons.person_add),
          label: const Text('이메일 회원가입'),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
          ),
        ),

        const SizedBox(height: 12),

        // Google 로그인
        ElevatedButton.icon(
          onPressed: isLoading || isAuthenticated ? null : _handleGoogleSignIn,
          icon: Image.asset(
            'assets/images/google_logo.png',
            height: 24,
            width: 24,
            errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.g_mobiledata),
          ),
          label: const Text('Google 로그인'),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            side: const BorderSide(color: Colors.grey),
          ),
        ),

        const SizedBox(height: 24),

        // 로그아웃
        if (isAuthenticated)
          OutlinedButton.icon(
            onPressed: isLoading ? null : _handleSignOut,
            icon: const Icon(Icons.logout),
            label: const Text('로그아웃'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              foregroundColor: Colors.red,
              side: const BorderSide(color: Colors.red),
            ),
          ),

        const SizedBox(height: 24),

        // 에러 초기화
        if (authState.error != null)
          TextButton(
            onPressed: () {
              ref.read(authProvider.notifier).clearError();
            },
            child: const Text('에러 메시지 지우기'),
          ),
      ],
    );
  }

  /// 이메일 로그인 처리
  Future<void> _handleEmailSignIn() async {
    if (!_formKey.currentState!.validate()) return;

    final email = _emailController.text.trim();
    final password = _passwordController.text;

    await ref
        .read(authProvider.notifier)
        .signInWithEmail(email: email, password: password);

    if (mounted) {
      final authState = ref.read(authProvider);
      if (authState.user != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ 로그인 성공!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }

  /// 이메일 회원가입 처리
  Future<void> _handleEmailSignUp() async {
    if (!_formKey.currentState!.validate()) return;

    final email = _emailController.text.trim();
    final password = _passwordController.text;

    await ref
        .read(authProvider.notifier)
        .signUpWithEmail(email: email, password: password);

    if (mounted) {
      final authState = ref.read(authProvider);
      if (authState.user != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ 회원가입 성공!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }

  /// Google 로그인 처리
  Future<void> _handleGoogleSignIn() async {
    await ref.read(authProvider.notifier).signInWithGoogle();

    if (mounted) {
      final authState = ref.read(authProvider);
      if (authState.user != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Google 로그인 성공!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }

  /// 로그아웃 처리
  Future<void> _handleSignOut() async {
    await ref.read(authProvider.notifier).signOut();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ 로그아웃 완료'),
          backgroundColor: Colors.grey,
        ),
      );
    }
  }
}
