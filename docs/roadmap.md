# Bible SumOne - Flutter 개발 로드맵

**버전**: 1.0
**작성일**: 2026-03-24
**목적**: Flutter 기반 앱 개발을 위한 상세 가이드 및 구현 순서

---

## 📋 목차

1. [프로젝트 구조 설계](#1-프로젝트-구조-설계)
2. [UI 디자인 시스템](#2-ui-디자인-시스템)
3. [필수 라이브러리 및 패키지](#3-필수-라이브러리-및-패키지)
4. [Supabase 연동 계획](#4-supabase-연동-계획)
5. [성경 API 통합](#5-성경-api-통합)
6. [AI 기능 통합](#6-ai-기능-통합)
7. [기능 구현 순서](#7-기능-구현-순서)
8. [에이전트 활용 계획](#8-에이전트-활용-계획)
9. [테스트 전략](#9-테스트-전략)
10. [배포 계획](#10-배포-계획)

---

## 1. 프로젝트 구조 설계

### 1.1 폴더 구조 (Clean Architecture + Feature-First)

```
lib/
├── main.dart                      # 앱 진입점
├── app/
│   ├── app.dart                   # MaterialApp 설정
│   ├── routes.dart                # 라우팅 설정
│   └── theme.dart                 # 테마 설정
│
├── core/                          # 공통 핵심 기능
│   ├── constants/
│   │   ├── api_constants.dart     # API URL, 엔드포인트
│   │   ├── app_constants.dart     # 앱 상수 (색상, 폰트)
│   │   └── storage_keys.dart      # 로컬 저장소 키
│   │
│   ├── utils/
│   │   ├── logger.dart            # 로깅 유틸
│   │   ├── date_utils.dart        # 날짜 포맷팅
│   │   └── validators.dart        # 입력 검증
│   │
│   ├── network/
│   │   ├── dio_client.dart        # HTTP 클라이언트
│   │   └── api_interceptor.dart   # 요청/응답 인터셉터
│   │
│   └── error/
│       ├── failures.dart          # 에러 타입 정의
│       └── exceptions.dart        # 예외 처리
│
├── data/                          # 데이터 레이어
│   ├── models/                    # 데이터 모델 (JSON ↔ Dart)
│   │   ├── user_model.dart
│   │   ├── couple_model.dart
│   │   ├── daily_verse_model.dart
│   │   ├── response_model.dart
│   │   └── streak_model.dart
│   │
│   ├── repositories/              # 데이터 소스 추상화
│   │   ├── auth_repository.dart
│   │   ├── couple_repository.dart
│   │   ├── verse_repository.dart
│   │   └── response_repository.dart
│   │
│   ├── datasources/               # 실제 데이터 소스
│   │   ├── supabase_datasource.dart
│   │   ├── bible_api_datasource.dart
│   │   ├── gemini_api_datasource.dart
│   │   └── local_storage_datasource.dart
│   │
│   └── services/                  # 비즈니스 로직 서비스
│       ├── notification_service.dart
│       └── analytics_service.dart
│
├── domain/                        # 도메인 레이어 (비즈니스 로직)
│   ├── entities/                  # 엔티티 (순수 비즈니스 객체)
│   │   ├── user.dart
│   │   ├── couple.dart
│   │   ├── daily_verse.dart
│   │   └── streak.dart
│   │
│   └── usecases/                  # 유즈케이스 (단일 책임)
│       ├── auth/
│       │   ├── sign_up_usecase.dart
│       │   ├── sign_in_usecase.dart
│       │   └── sign_out_usecase.dart
│       │
│       ├── couple/
│       │   ├── invite_partner_usecase.dart
│       │   └── connect_couple_usecase.dart
│       │
│       ├── verse/
│       │   ├── get_daily_verse_usecase.dart
│       │   └── get_verse_history_usecase.dart
│       │
│       └── response/
│           ├── submit_response_usecase.dart
│           └── get_partner_response_usecase.dart
│
├── presentation/                  # UI 레이어
│   ├── providers/                 # Riverpod 상태 관리
│   │   ├── auth_provider.dart
│   │   ├── couple_provider.dart
│   │   ├── verse_provider.dart
│   │   ├── response_provider.dart
│   │   └── streak_provider.dart
│   │
│   ├── screens/                   # Feature-First 화면
│   │   ├── splash/
│   │   │   └── splash_screen.dart
│   │   │
│   │   ├── auth/
│   │   │   ├── login_screen.dart
│   │   │   ├── signup_screen.dart
│   │   │   └── widgets/
│   │   │       └── auth_button.dart
│   │   │
│   │   ├── onboarding/
│   │   │   ├── onboarding_screen.dart
│   │   │   └── widgets/
│   │   │       └── onboarding_page.dart
│   │   │
│   │   ├── couple/
│   │   │   ├── invite_partner_screen.dart
│   │   │   └── connect_couple_screen.dart
│   │   │
│   │   ├── home/
│   │   │   ├── home_screen.dart
│   │   │   └── widgets/
│   │   │       ├── daily_verse_card.dart
│   │   │       ├── streak_widget.dart
│   │   │       └── quick_actions.dart
│   │   │
│   │   ├── verse/
│   │   │   ├── daily_verse_screen.dart
│   │   │   ├── verse_detail_screen.dart
│   │   │   └── widgets/
│   │   │       ├── verse_text.dart
│   │   │       ├── question_card.dart
│   │   │       └── response_input.dart
│   │   │
│   │   ├── response/
│   │   │   ├── response_screen.dart
│   │   │   ├── dual_reveal_screen.dart
│   │   │   └── widgets/
│   │   │       ├── my_response_card.dart
│   │   │       ├── partner_response_card.dart
│   │   │       └── flip_animation.dart
│   │   │
│   │   ├── history/
│   │   │   ├── history_screen.dart
│   │   │   └── widgets/
│   │   │       └── history_item.dart
│   │   │
│   │   └── settings/
│   │       ├── settings_screen.dart
│   │       ├── profile_screen.dart
│   │       └── widgets/
│   │           └── settings_item.dart
│   │
│   └── widgets/                   # 공통 위젯
│       ├── app_bar.dart
│       ├── buttons/
│       │   ├── primary_button.dart
│       │   └── secondary_button.dart
│       │
│       ├── cards/
│       │   └── base_card.dart
│       │
│       ├── loading/
│       │   ├── loading_indicator.dart
│       │   └── skeleton_loader.dart
│       │
│       └── dialogs/
│           ├── confirm_dialog.dart
│           └── error_dialog.dart
│
└── generated/                     # 자동 생성 파일
    ├── intl/                      # 다국어 (추후)
    └── assets.gen.dart            # 에셋 자동 생성
```

### 1.2 설계 원칙

#### Clean Architecture
- **Separation of Concerns**: 각 레이어는 독립적
- **Dependency Rule**: 외부 → 내부로만 의존 (domain은 data 모름)
- **Testability**: 각 레이어 독립 테스트 가능

#### Feature-First Approach
- 기능별로 폴더 구분 (auth, verse, response 등)
- 각 기능은 자체 위젯 포함
- 재사용 가능한 위젯은 공통 widgets/에 배치

#### 확장성 & 유지보수
- **모듈화**: 각 기능은 독립적으로 수정 가능
- **코드 재사용**: 공통 로직은 core/에 배치
- **명확한 네이밍**: 파일명, 클래스명이 역할을 명시

---

## 2. UI 디자인 시스템

### 2.1 테마 설정 (`app/theme.dart`)

**디자인 컨셉**: 모던한 도서 앱 UI 참조
- 부드러운 slate blue 배경 (#78909C)
- 큰 카드 중심 디자인 (24px 둥근 모서리)
- 넉넉한 여백과 부드러운 그림자

```dart
import 'package:flutter/material.dart';

class AppTheme {
  // 컬러 팔레트 (Updated 2026-03-24)
  static const Color primaryColor = Color(0xFF6B4DE8); // 보라색 (영적)
  static const Color secondaryColor = Color(0xFFFFC857); // 노란색 (빛, 별)
  static const Color accentColor = Color(0xFFFF6B9D); // 핑크 (하트)

  static const Color backgroundLight = Color(0xFF78909C); // Slate blue
  static const Color backgroundDark = Color(0xFF121212);

  static const Color surfaceLight = Color(0xFFFFFFFF); // 카드 배경
  static const Color surfaceDark = Color(0xFF1E1E1E);

  static const Color textPrimaryLight = Color(0xFF1A1A1A); // 카드 위 텍스트
  static const Color textSecondaryLight = Color(0xFF666666);
  static const Color textOnBackgroundLight = Color(0xFFFFFFFF); // 배경 위 텍스트

  static const Color textPrimaryDark = Color(0xFFFFFFFF);
  static const Color textSecondaryDark = Color(0xFFB0B0B0);

  // 라이트 테마
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.light(
      primary: primaryColor,
      secondary: secondaryColor,
      surface: backgroundLight,
      background: backgroundLight,
      error: Colors.red.shade400,
    ),

    // 텍스트 테마
    textTheme: TextTheme(
      // Headline (제목)
      headlineLarge: TextStyle(
        fontFamily: 'Pretendard',
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: textPrimaryLight,
      ),

      // Body (본문)
      bodyLarge: TextStyle(
        fontFamily: 'Pretendard',
        fontSize: 16,
        color: textPrimaryLight,
      ),

      bodyMedium: TextStyle(
        fontFamily: 'Pretendard',
        fontSize: 14,
        color: textSecondaryLight,
      ),

      // 성경 구절 전용 (세리프)
      displayLarge: TextStyle(
        fontFamily: 'Noto Serif KR',
        fontSize: 18,
        height: 1.8, // 줄 간격
        fontWeight: FontWeight.w500,
        color: textPrimaryLight,
      ),
    ),

    // 버튼 테마 (더 둥근 모서리)
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 2,
      ),
    ),

    // 카드 테마 (큰 둥근 모서리 + 부드러운 그림자)
    cardTheme: CardTheme(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24), // 24px!
      ),
      color: surfaceLight,
      shadowColor: Colors.black.withOpacity(0.08),
    ),

    // 입력 필드 테마
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.grey.shade100,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: primaryColor, width: 2),
      ),
    ),
  );

  // 다크 테마
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.dark(
      primary: Color(0xFF8B6EF7),
      secondary: secondaryColor,
      surface: Color(0xFF1E1E1E),
      background: backgroundDark,
      error: Colors.red.shade300,
    ),

    textTheme: TextTheme(
      headlineLarge: TextStyle(
        fontFamily: 'Pretendard',
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: textPrimaryDark,
      ),

      bodyLarge: TextStyle(
        fontFamily: 'Pretendard',
        fontSize: 16,
        color: textPrimaryDark,
      ),

      bodyMedium: TextStyle(
        fontFamily: 'Pretendard',
        fontSize: 14,
        color: textSecondaryDark,
      ),

      displayLarge: TextStyle(
        fontFamily: 'Noto Serif KR',
        fontSize: 18,
        height: 1.8,
        fontWeight: FontWeight.w500,
        color: textPrimaryDark,
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF8B6EF7),
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),

    cardTheme: CardTheme(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: Color(0xFF1E1E1E),
    ),
  );
}
```

### 2.2 폰트 설정

#### pubspec.yaml
```yaml
fonts:
  - family: Pretendard
    fonts:
      - asset: fonts/Pretendard-Regular.ttf
      - asset: fonts/Pretendard-Medium.ttf
        weight: 500
      - asset: fonts/Pretendard-Bold.ttf
        weight: 700

  - family: Noto Serif KR
    fonts:
      - asset: fonts/NotoSerifKR-Regular.ttf
      - asset: fonts/NotoSerifKR-Medium.ttf
        weight: 500
```

#### 디자인 가이드라인 (스크린샷 참조)

**핵심 원칙**:
1. **Card-First Design**: 모든 주요 컨텐츠는 카드로 감싸기
2. **Generous Spacing**: 넉넉한 여백 (16-24px padding)
3. **Soft Shadows**: 부드러운 그림자 (elevation 2-4)
4. **Rounded Corners**: 큰 둥근 모서리 (24px)
5. **Color Contrast**: 배경(slate blue) vs 카드(흰색) 명확한 대비

**컴포넌트별 가이드**:
- **카드**: borderRadius 24px, elevation 4, white background
- **버튼**: borderRadius 16px, height 48-56px
- **아이콘**: 20-24px (일반), 32-48px (강조)
- **여백**: 카드 내부 16-24px, 카드 간 16px, 섹션 간 24-32px

### 2.3 애니메이션 가이드

#### Dual Reveal 애니메이션
```dart
// lib/presentation/screens/response/widgets/flip_animation.dart
class FlipAnimation extends StatefulWidget {
  final Widget frontCard;
  final Widget backCard;

  @override
  _FlipAnimationState createState() => _FlipAnimationState();
}

class _FlipAnimationState extends State<FlipAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _flipAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );

    _flipAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    // 자동 시작
    Future.delayed(Duration(milliseconds: 500), () {
      _controller.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _flipAnimation,
      builder: (context, child) {
        final angle = _flipAnimation.value * 3.14159; // 180도
        final isFlipped = _flipAnimation.value > 0.5;

        return Transform(
          transform: Matrix4.rotationY(angle),
          alignment: Alignment.center,
          child: isFlipped ? widget.backCard : widget.frontCard,
        );
      },
    );
  }
}
```

---

## 3. 필수 라이브러리 및 패키지

### 3.1 pubspec.yaml 전체

```yaml
name: bible_sumone
description: 크리스천 커플을 위한 성경 나눔 앱
publish_to: 'none'
version: 1.0.0+1

environment:
  sdk: ^3.11.1

dependencies:
  flutter:
    sdk: flutter

  # 상태 관리
  flutter_riverpod: ^2.5.1
  riverpod_annotation: ^2.3.5

  # 라우팅
  go_router: ^14.0.0

  # Backend (Supabase)
  supabase_flutter: ^2.5.0

  # HTTP 클라이언트
  dio: ^5.4.0
  pretty_dio_logger: ^1.3.1

  # 로컬 저장소
  shared_preferences: ^2.2.2
  hive: ^2.2.3
  hive_flutter: ^1.1.0

  # 로컬 알림
  flutter_local_notifications: ^16.3.0
  timezone: ^0.9.2  # 로컬 알림 스케줄링용

  # UI/UX
  flutter_svg: ^2.0.9
  cached_network_image: ^3.3.1
  shimmer: ^3.0.0
  lottie: ^3.0.0
  confetti: ^0.7.0  # 마일스톤 축하 애니메이션

  # 유틸리티
  intl: ^0.19.0  # 날짜 포맷팅
  url_launcher: ^6.2.2  # 외부 링크
  share_plus: ^7.2.1  # 공유 기능
  image_picker: ^1.0.7  # 프로필 사진

  # 로깅 & 디버깅
  logger: ^2.0.2

  # 환경 변수
  flutter_dotenv: ^5.1.0

  # 아이콘
  cupertino_icons: ^1.0.8

dev_dependencies:
  flutter_test:
    sdk: flutter

  # 린트
  flutter_lints: ^6.0.0

  # 코드 생성
  build_runner: ^2.4.7
  riverpod_generator: ^2.3.11
  hive_generator: ^2.0.1

  # 테스트
  mockito: ^5.4.4

  # 에셋 자동 생성
  flutter_gen_runner: ^5.4.0

flutter:
  uses-material-design: true

  assets:
    - assets/images/
    - assets/icons/
    - assets/animations/
    - .env

  fonts:
    - family: Pretendard
      fonts:
        - asset: fonts/Pretendard-Regular.ttf
        - asset: fonts/Pretendard-Medium.ttf
          weight: 500
        - asset: fonts/Pretendard-Bold.ttf
          weight: 700

    - family: Noto Serif KR
      fonts:
        - asset: fonts/NotoSerifKR-Regular.ttf
        - asset: fonts/NotoSerifKR-Medium.ttf
          weight: 500
```

### 3.2 환경 변수 (.env)

```.env
# Supabase
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_ANON_KEY=your-anon-key

# Bible API
BIBLE_API_URL=https://bible.helloao.org/api

# Gemini API
GEMINI_API_KEY=your-gemini-api-key
GEMINI_API_URL=https://generativelanguage.googleapis.com/v1beta

# GPT API (프리미엄 기능 - 추후)
GPT_API_KEY=your-gpt-api-key
```

---

## 4. Supabase 연동 계획

### 4.1 Supabase 초기화

```dart
// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 환경 변수 로드
  await dotenv.load(fileName: ".env");

  // Supabase 초기화
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );

  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}
```

### 4.2 Supabase 클라이언트

```dart
// lib/core/constants/supabase_client.dart
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;
```

### 4.3 데이터베이스 테이블 생성 (SQL)

```sql
-- Supabase Dashboard에서 실행

-- 1. users 테이블 (Auth 자동 생성 활용)
-- Supabase Auth의 auth.users를 확장하는 public.users 테이블
CREATE TABLE public.users (
  user_id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  name VARCHAR(100) NOT NULL,
  profile_image_url TEXT,
  relationship_stage VARCHAR(20) CHECK (relationship_stage IN ('dating', 'engaged', 'married')),
  notification_time TIME DEFAULT '09:00:00',
  notification_enabled BOOLEAN DEFAULT true,
  bible_translation VARCHAR(20) DEFAULT 'KRV',
  theme VARCHAR(10) DEFAULT 'light',
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

-- 2. couples 테이블
CREATE TABLE couples (
  couple_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user1_id UUID REFERENCES public.users(user_id) ON DELETE CASCADE,
  user2_id UUID REFERENCES public.users(user_id) ON DELETE CASCADE,
  relationship_stage VARCHAR(20),
  created_at TIMESTAMP DEFAULT NOW(),
  UNIQUE(user1_id, user2_id)
);

-- 3. daily_verses 테이블
CREATE TABLE daily_verses (
  verse_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  date DATE UNIQUE NOT NULL,
  bible_book VARCHAR(50) NOT NULL,
  chapter INT NOT NULL,
  verse_start INT NOT NULL,
  verse_end INT,
  text_korean TEXT NOT NULL,
  text_english TEXT,
  question_korean TEXT NOT NULL,
  question_english TEXT,
  topic VARCHAR(50),
  created_at TIMESTAMP DEFAULT NOW()
);

-- 4. responses 테이블
CREATE TABLE responses (
  response_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  verse_id UUID REFERENCES daily_verses(verse_id) ON DELETE CASCADE,
  user_id UUID REFERENCES public.users(user_id) ON DELETE CASCADE,
  couple_id UUID REFERENCES couples(couple_id) ON DELETE CASCADE,
  content TEXT NOT NULL,
  is_submitted BOOLEAN DEFAULT false,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW(),
  UNIQUE(verse_id, user_id)
);

-- 5. daily_progress 테이블
CREATE TABLE daily_progress (
  progress_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  couple_id UUID REFERENCES couples(couple_id) ON DELETE CASCADE,
  verse_id UUID REFERENCES daily_verses(verse_id) ON DELETE CASCADE,
  date DATE NOT NULL,
  user1_submitted BOOLEAN DEFAULT false,
  user2_submitted BOOLEAN DEFAULT false,
  both_completed_at TIMESTAMP,
  UNIQUE(couple_id, date)
);

-- 6. streaks 테이블
CREATE TABLE streaks (
  couple_id UUID PRIMARY KEY REFERENCES couples(couple_id) ON DELETE CASCADE,
  current_streak INT DEFAULT 0,
  longest_streak INT DEFAULT 0,
  last_completed_date DATE,
  updated_at TIMESTAMP DEFAULT NOW()
);

-- 7. bible_cache 테이블
CREATE TABLE bible_cache (
  cache_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  reference VARCHAR(100) NOT NULL,
  translation VARCHAR(20) NOT NULL,
  text TEXT NOT NULL,
  cached_at TIMESTAMP DEFAULT NOW(),
  UNIQUE(reference, translation)
);

-- 8. invite_links 테이블 (파트너 초대)
CREATE TABLE invite_links (
  invite_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  inviter_id UUID REFERENCES public.users(user_id) ON DELETE CASCADE,
  token VARCHAR(50) UNIQUE NOT NULL,
  is_used BOOLEAN DEFAULT false,
  created_at TIMESTAMP DEFAULT NOW(),
  expires_at TIMESTAMP DEFAULT NOW() + INTERVAL '7 days'
);
```

### 4.4 Row Level Security (RLS) 정책

```sql
-- RLS 활성화
ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;
ALTER TABLE couples ENABLE ROW LEVEL SECURITY;
ALTER TABLE responses ENABLE ROW LEVEL SECURITY;
ALTER TABLE daily_progress ENABLE ROW LEVEL SECURITY;
ALTER TABLE streaks ENABLE ROW LEVEL SECURITY;

-- users: 자신의 정보만 읽기/수정
CREATE POLICY "Users can view own profile"
ON public.users FOR SELECT
USING (auth.uid() = user_id);

CREATE POLICY "Users can update own profile"
ON public.users FOR UPDATE
USING (auth.uid() = user_id);

-- responses: 자신과 파트너의 답변만 조회
CREATE POLICY "Users can view own and partner responses"
ON responses FOR SELECT
USING (
  user_id = auth.uid()
  OR user_id IN (
    SELECT user1_id FROM couples WHERE user2_id = auth.uid()
    UNION
    SELECT user2_id FROM couples WHERE user1_id = auth.uid()
  )
);

-- responses: 자신의 답변만 작성/수정
CREATE POLICY "Users can insert own responses"
ON responses FOR INSERT
WITH CHECK (user_id = auth.uid());

CREATE POLICY "Users can update own responses"
ON responses FOR UPDATE
USING (user_id = auth.uid());
```

### 4.5 Supabase Edge Functions (Cron Job)

#### 일일 말씀 생성 함수

```typescript
// supabase/functions/generate-daily-verse/index.ts
import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

serve(async (req) => {
  try {
    const supabaseClient = createClient(
      Deno.env.get('SUPABASE_URL') ?? '',
      Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? ''
    )

    // 1. 오늘 날짜 확인
    const today = new Date().toISOString().split('T')[0]

    // 2. 이미 생성되었는지 확인
    const { data: existing } = await supabaseClient
      .from('daily_verses')
      .select('*')
      .eq('date', today)
      .single()

    if (existing) {
      return new Response(JSON.stringify({ message: 'Already generated' }), {
        headers: { 'Content-Type': 'application/json' },
      })
    }

    // 3. 주제 선택 (로테이션)
    const topics = ['love', 'forgiveness', 'gratitude', 'communication', 'faith']
    const topic = topics[new Date().getDay() % topics.length]

    // 4. 성경 구절 가져오기 (Bible API)
    const bibleVerses = {
      love: { book: '고린도전서', chapter: 13, start: 4, end: 7 },
      forgiveness: { book: '에베소서', chapter: 4, start: 32, end: 32 },
      // ... 더 많은 매핑
    }

    const verseRef = bibleVerses[topic]
    const bibleResponse = await fetch(
      `https://bible.helloao.org/api/KRV/${verseRef.book}/${verseRef.chapter}:${verseRef.start}-${verseRef.end}`
    )
    const bibleData = await bibleResponse.json()

    // 5. Gemini API로 질문 생성
    const geminiResponse = await fetch(
      `https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=${Deno.env.get('GEMINI_API_KEY')}`,
      {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          contents: [{
            parts: [{
              text: `당신은 크리스천 커플을 위한 성경 공부 가이드입니다.

성경 구절: ${bibleData.text}

위 말씀을 읽은 커플이 서로 나눌 수 있는 대화 질문 1개를 생성하세요.
요구사항:
1. 커플의 관계에 적용 가능
2. 자연스러운 대화 유도
3. 50자 이내

출력: [질문만]`
            }]
          }]
        })
      }
    )

    const geminiData = await geminiResponse.json()
    const question = geminiData.candidates[0].content.parts[0].text

    // 6. DB에 저장
    const { error } = await supabaseClient
      .from('daily_verses')
      .insert({
        date: today,
        bible_book: verseRef.book,
        chapter: verseRef.chapter,
        verse_start: verseRef.start,
        verse_end: verseRef.end,
        text_korean: bibleData.text,
        question_korean: question,
        topic: topic
      })

    if (error) throw error

    return new Response(JSON.stringify({ message: 'Success' }), {
      headers: { 'Content-Type': 'application/json' },
    })

  } catch (error) {
    return new Response(JSON.stringify({ error: error.message }), {
      status: 500,
      headers: { 'Content-Type': 'application/json' },
    })
  }
})
```

#### Cron Job 설정 (매일 자정 실행)
```sql
-- Supabase Dashboard > Database > Cron Jobs
SELECT cron.schedule(
  'generate-daily-verse',
  '0 0 * * *', -- 매일 자정
  $$
  SELECT net.http_post(
    url := 'https://your-project.supabase.co/functions/v1/generate-daily-verse',
    headers := '{"Content-Type": "application/json", "Authorization": "Bearer YOUR_SERVICE_ROLE_KEY"}'::jsonb
  );
  $$
);
```

---

## 5. 성경 API 통합

### 5.1 Bible API Datasource

```dart
// lib/data/datasources/bible_api_datasource.dart
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class BibleApiDatasource {
  final Dio _dio;
  final String baseUrl = dotenv.env['BIBLE_API_URL'] ?? '';

  BibleApiDatasource(this._dio);

  /// 성경 구절 조회
  /// [translation]: 번역본 (KRV, NIV 등)
  /// [book]: 책 이름 (예: 요한복음)
  /// [chapter]: 장
  /// [verseStart]: 시작 절
  /// [verseEnd]: 끝 절 (선택)
  Future<Map<String, dynamic>> getVerse({
    required String translation,
    required String book,
    required int chapter,
    required int verseStart,
    int? verseEnd,
  }) async {
    try {
      final verseRange = verseEnd != null
        ? '$verseStart-$verseEnd'
        : '$verseStart';

      final url = '$baseUrl/$translation/$book/$chapter:$verseRange';

      final response = await _dio.get(url);

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to load verse');
      }
    } catch (e) {
      throw Exception('Bible API Error: $e');
    }
  }

  /// 로컬 캐시에서 먼저 조회, 없으면 API 호출
  Future<String> getVerseWithCache({
    required String reference, // "요한복음 3:16"
    required String translation,
  }) async {
    // 1. Supabase bible_cache에서 조회
    final cachedVerse = await _getCachedVerse(reference, translation);

    if (cachedVerse != null) {
      return cachedVerse;
    }

    // 2. 캐시 없으면 API 호출
    final parts = _parseReference(reference);
    final verseData = await getVerse(
      translation: translation,
      book: parts['book']!,
      chapter: int.parse(parts['chapter']!),
      verseStart: int.parse(parts['verseStart']!),
      verseEnd: parts['verseEnd'] != null ? int.parse(parts['verseEnd']!) : null,
    );

    // 3. 캐시에 저장
    await _cacheVerse(reference, translation, verseData['text']);

    return verseData['text'];
  }

  Future<String?> _getCachedVerse(String reference, String translation) async {
    // Supabase에서 조회 구현
    return null; // TODO: 구현
  }

  Future<void> _cacheVerse(String reference, String translation, String text) async {
    // Supabase에 저장 구현
    // TODO: 구현
  }

  Map<String, String> _parseReference(String reference) {
    // "요한복음 3:16-17" → { book: "요한복음", chapter: "3", verseStart: "16", verseEnd: "17" }
    final regex = RegExp(r'(.+)\s(\d+):(\d+)(?:-(\d+))?');
    final match = regex.firstMatch(reference);

    return {
      'book': match!.group(1)!,
      'chapter': match.group(2)!,
      'verseStart': match.group(3)!,
      'verseEnd': match.group(4),
    };
  }
}
```

---

## 6. AI 기능 통합

### 6.1 Gemini API Datasource

```dart
// lib/data/datasources/gemini_api_datasource.dart
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GeminiApiDatasource {
  final Dio _dio;
  final String apiKey = dotenv.env['GEMINI_API_KEY'] ?? '';
  final String baseUrl = dotenv.env['GEMINI_API_URL'] ?? '';

  GeminiApiDatasource(this._dio);

  /// 성경 구절 기반 질문 생성
  Future<String> generateQuestion({
    required String verseText,
    required String relationshipStage, // 'dating', 'engaged', 'married'
  }) async {
    try {
      final prompt = _buildPrompt(verseText, relationshipStage);

      final url = '$baseUrl/models/gemini-1.5-flash:generateContent?key=$apiKey';

      final response = await _dio.post(
        url,
        data: {
          'contents': [{
            'parts': [{'text': prompt}]
          }]
        },
      );

      if (response.statusCode == 200) {
        final question = response.data['candidates'][0]['content']['parts'][0]['text'];
        return _cleanQuestion(question);
      } else {
        throw Exception('Failed to generate question');
      }
    } catch (e) {
      throw Exception('Gemini API Error: $e');
    }
  }

  String _buildPrompt(String verseText, String relationshipStage) {
    final stageContext = {
      'dating': '연애 중인',
      'engaged': '약혼한',
      'married': '신혼',
    };

    return '''
당신은 크리스천 커플을 위한 성경 공부 가이드입니다.

성경 구절:
$verseText

커플 상태: ${stageContext[relationshipStage]}

위 말씀을 읽은 커플이 서로 나눌 수 있는 대화 질문 1개를 생성하세요.

요구사항:
1. 커플의 관계에 직접 적용 가능해야 함
2. 너무 무겁지 않고 자연스러운 대화 유도
3. "서로" 나눌 수 있는 질문 (한 사람만 답하는 것 X)
4. 50자 이내

출력 형식:
[질문 내용만 출력, 추가 설명 없이]
''';
  }

  String _cleanQuestion(String rawQuestion) {
    // 불필요한 마크다운, 따옴표 제거
    return rawQuestion
        .replaceAll('"', '')
        .replaceAll('*', '')
        .trim();
  }
}
```

### 6.2 GPT API (프리미엄 기능 - 추후)

```dart
// lib/data/datasources/gpt_api_datasource.dart (프리미엄 기능)
class GptApiDatasource {
  // 두 사람의 답변 분석 및 인사이트 생성
  Future<String> generateInsight({
    required String question,
    required String response1,
    required String response2,
  }) async {
    // GPT-4o API 호출 구현
    // TODO: 추후 구현
  }
}
```

---

## 7. 기능 구현 순서

### Phase 0: 프로젝트 셋업 (Week 1)

#### Task 0.1: 프로젝트 초기화 ✅
- [✅] Flutter 프로젝트 생성 완료 (이미 완료)
- [✅] pubspec.yaml에 모든 패키지 추가
- [✅] 폴더 구조 생성
- [✅] 테마 설정 (theme.dart)
- [✅] 라우팅 설정 (routes.dart)

#### Task 0.2: Supabase 설정 ✅
- [✅] Supabase 프로젝트 생성
- [✅] 데이터베이스 테이블 생성 (SQL 실행)
- [✅] RLS 정책 설정
- [✅] Supabase Flutter SDK 초기화
- [✅] .env 파일 설정

#### Task 0.3: 외부 API 준비 ✅
- [✅] Bible API URL 설정 (https://bible.helloao.org/api)
- [✅] Gemini API 키 발급 (https://aistudio.google.com/apikey)
- [✅] .env 파일에 API 키 추가
- [✅] Firebase 제거 (Supabase + 로컬 알림으로 통일)

---

### Phase 1: 인증 및 온보딩 (Week 2)

#### Task 1.1: 인증 시스템
- [ ] Supabase Auth 통합
- [ ] Google 로그인 (OAuth) - 메인 로그인 방식
- [ ] 로그인 상태 관리 (Riverpod)

#### Task 1.2: 온보딩 플로우
- [ ] 스플래시 화면
- [ ] 온보딩 3단계 화면 (Swiper)
- [ ] 프로필 설정 (이름, 관계 단계)
- [ ] 상태 저장 (Supabase users 테이블)

#### Task 1.3: 커플 매칭
- [ ] 파트너 초대 링크 생성
- [ ] 초대 링크 공유 (share_plus)
- [ ] 초대 수락 플로우
- [ ] 커플 연결 (couples 테이블)

---

### Phase 2: 일일 말씀 시스템 (Week 3-4)

#### Task 2.1: 성경 API 통합
- [ ] BibleApiDatasource 구현
- [ ] 성경 구절 조회 기능
- [ ] 로컬 캐싱 (Supabase bible_cache)
- [ ] 에러 핸들링

#### Task 2.2: AI 질문 생성
- [ ] GeminiApiDatasource 구현
- [ ] 질문 생성 프롬프트 최적화
- [ ] 질문 품질 필터링
- [ ] 베타 테스트용 목회자 검토 시스템

#### Task 2.3: Supabase Edge Function
- [ ] generate-daily-verse 함수 작성
- [ ] Cron Job 설정 (매일 자정)
- [ ] 테스트 및 배포

#### Task 2.4: UI 구현
- [ ] 홈 화면 (daily_verse_card)
- [ ] 오늘의 말씀 상세 화면
- [ ] 성경 구절 표시 (Noto Serif KR)
- [ ] 질문 카드 UI

---

### Phase 3: 답변 & Dual Reveal (Week 5-6)

#### Task 3.1: 답변 작성
- [ ] 텍스트 입력 UI
- [ ] 글자 수 카운터 (500자 제한)
- [ ] 임시 저장 기능
- [ ] 답변 제출 (responses 테이블)
- [ ] 상태 관리 (ResponseProvider)

#### Task 3.2: Dual Reveal 애니메이션
- [ ] 카드 뒤집기 애니메이션 (flip_animation.dart)
- [ ] 대기 화면 ("파트너 대기 중")
- [ ] 동시 공개 로직
- [ ] 서로 답변 보기 UI
- [ ] 좋아요/하트 반응 기능

#### Task 3.3: 실시간 동기화
- [ ] Supabase Realtime Subscriptions
- [ ] 파트너 답변 완료 시 실시간 알림
- [ ] 상태 자동 갱신

---

### Phase 4: 스트릭 & 마일스톤 (Week 7)

#### Task 4.1: 스트릭 시스템
- [ ] 스트릭 계산 로직
- [ ] streaks 테이블 업데이트
- [ ] 현재 스트릭 표시 UI
- [ ] 최고 스트릭 기록

#### Task 4.2: 마일스톤 축하
- [ ] 7일, 30일, 100일, 365일 감지
- [ ] 축하 애니메이션 (Confetti)
- [ ] 축하 메시지 표시
- [ ] 인스타/카톡 공유 기능

---

### Phase 5: 알림 시스템 (Week 8)

**NOTE**: Firebase 제거 - Supabase + 로컬 알림으로 통일

#### Task 5.1: 로컬 알림 구현
- [ ] flutter_local_notifications 설정
- [ ] timezone 패키지 초기화
- [ ] 알림 권한 요청 (iOS, Android)
- [ ] 매일 오전 9시 알림 스케줄링
- [ ] 알림 클릭 시 앱 열기 (딥링크)
- [ ] 앱 시작 시 자동 재스케줄링

#### Task 5.2: 알림 설정 UI
- [ ] 알림 ON/OFF 토글
- [ ] 알림 시간 선택 (TimePicker)
- [ ] 설정 변경 시 스케줄 업데이트
- [ ] Supabase에 사용자 알림 설정 저장

---

### Phase 6: 부가 기능 (Week 9)

#### Task 6.1: 과거 대화 보기
- [ ] 타임라인 UI
- [ ] 날짜별 필터링
- [ ] 무료: 7일, 프리미엄: 전체
- [ ] 상세 보기 화면

#### Task 6.2: 설정
- [ ] 프로필 수정 (이름, 사진)
- [ ] 알림 설정
- [ ] 성경 번역본 선택
- [ ] 테마 (라이트/다크)
- [ ] 계정 관리 (로그아웃, 탈퇴)

---

### Phase 7: 테스트 & 최적화 (Week 10)

#### Task 7.1: 테스트
- [ ] 단위 테스트 (주요 비즈니스 로직)
- [ ] 통합 테스트 (API 호출)
- [ ] E2E 테스트 (주요 플로우)

#### Task 7.2: 성능 최적화
- [ ] 이미지 최적화 (cached_network_image)
- [ ] 로딩 스켈레톤 (Shimmer)
- [ ] 에러 핸들링 개선

#### Task 7.3: 베타 테스트
- [ ] TestFlight (iOS) / Google Play Console 내부 테스트 (Android)
- [ ] 20-30 커플 초대
- [ ] 피드백 수집
- [ ] 버그 수정

---

### Phase 8: 출시 준비 (Week 11-12)

#### Task 8.1: 앱스토어 준비
- [ ] 앱 아이콘 디자인
- [ ] 스크린샷 준비
- [ ] 앱 설명 작성 (한국어/영어)
- [ ] 개인정보 처리 방침
- [ ] 서비스 이용약관

#### Task 8.2: 출시
- [ ] iOS App Store 등록
- [ ] Android Google Play 등록
- [ ] 심사 대응
- [ ] 정식 출시 🎉

---

## 8. 에이전트 활용 계획

### 8.1 개발 에이전트 (능동적 생성)

#### Agent 1: UI/UX Implementation Agent
**역할**: 화면별 UI 구현
**태스크**:
- 홈 화면 UI 구현
- 답변 작성 화면 UI 구현
- Dual Reveal 애니메이션 구현
- 설정 화면 UI 구현

**생성 시점**: Phase 2.4, 3.2, 6.2

#### Agent 2: Backend Integration Agent
**역할**: Supabase, API 통합
**태스크**:
- Supabase 클라이언트 설정
- Auth 통합
- 데이터 CRUD 구현
- Realtime 구독

**생성 시점**: Phase 0.2, 1.1, 3.3

#### Agent 3: Bible API Agent
**역할**: 성경 API 통합
**태스크**:
- BibleApiDatasource 구현
- 캐싱 로직
- 에러 핸들링

**생성 시점**: Phase 2.1

#### Agent 4: AI Integration Agent
**역할**: Gemini API 통합
**태스크**:
- GeminiApiDatasource 구현
- 프롬프트 최적화
- 질문 품질 필터링

**생성 시점**: Phase 2.2

#### Agent 5: Notification Agent
**역할**: 로컬 알림 구현
**태스크**:
- flutter_local_notifications 설정
- 로컬 알림 스케줄링
- 알림 설정 UI

**생성 시점**: Phase 5.1, 5.2

#### Agent 6: Animation Agent
**역할**: 애니메이션 구현
**태스크**:
- Flip 애니메이션
- 마일스톤 Confetti
- 로딩 애니메이션

**생성 시점**: Phase 3.2, 4.2

#### Agent 7: Testing Agent
**역할**: 테스트 작성
**태스크**:
- 단위 테스트
- 통합 테스트
- E2E 테스트

**생성 시점**: Phase 7.1

### 8.2 에이전트 사용 예시

```bash
# 예시: UI 구현 에이전트 생성
"홈 화면 UI를 구현해줘. docs/prd.md와 docs/roadmap.md의 디자인 가이드를 참고하여
daily_verse_card와 streak_widget을 포함한 home_screen.dart를 작성해."

# 예시: Backend 통합 에이전트 생성
"Supabase Auth를 통합해줘. Google OAuth를 구현하고
AuthProvider로 상태를 관리해."

# 예시: AI 통합 에이전트 생성
"Gemini API를 사용하여 성경 구절 기반 질문을 생성하는 GeminiApiDatasource를
구현해줘. docs/prd.md의 프롬프트 예시를 참고해."
```

---

## 9. 테스트 전략

### 9.1 단위 테스트

```dart
// test/domain/usecases/auth/sign_in_usecase_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

void main() {
  group('SignInUseCase', () {
    test('should return user when login succeeds', () async {
      // Arrange
      final repository = MockAuthRepository();
      final usecase = SignInUseCase(repository);

      when(repository.signIn(any, any))
          .thenAnswer((_) async => Right(mockUser));

      // Act
      final result = await usecase.call(
        email: 'test@example.com',
        password: 'password123',
      );

      // Assert
      expect(result, Right(mockUser));
      verify(repository.signIn('test@example.com', 'password123'));
    });
  });
}
```

### 9.2 Widget 테스트

```dart
// test/presentation/screens/home/home_screen_test.dart
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('HomeScreen displays daily verse card', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: HomeScreen(),
        ),
      ),
    );

    expect(find.byType(DailyVerseCard), findsOneWidget);
    expect(find.byType(StreakWidget), findsOneWidget);
  });
}
```

### 9.3 통합 테스트

```dart
// integration_test/app_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Complete flow: Login → Daily Verse → Response', (tester) async {
    await tester.pumpWidget(MyApp());

    // 1. 로그인
    await tester.enterText(find.byKey(Key('email_field')), 'test@example.com');
    await tester.enterText(find.byKey(Key('password_field')), 'password123');
    await tester.tap(find.byKey(Key('login_button')));
    await tester.pumpAndSettle();

    // 2. 홈 화면 확인
    expect(find.byType(HomeScreen), findsOneWidget);

    // 3. 오늘의 말씀 클릭
    await tester.tap(find.byKey(Key('daily_verse_card')));
    await tester.pumpAndSettle();

    // 4. 답변 작성
    await tester.enterText(find.byKey(Key('response_input')), '테스트 답변');
    await tester.tap(find.byKey(Key('submit_button')));
    await tester.pumpAndSettle();

    // 5. 대기 화면 확인
    expect(find.text('파트너 대기 중'), findsOneWidget);
  });
}
```

---

## 10. 배포 계획

### 10.1 환경 구분

#### 개발 (Development)
- Supabase: 개발 프로젝트
- API: 테스트 키

#### 스테이징 (Staging)
- Supabase: 스테이징 프로젝트
- API: 실제 키 (제한된 할당량)

#### 프로덕션 (Production)
- Supabase: 프로덕션 프로젝트
- API: 실제 키

### 10.2 배포 체크리스트

#### iOS (App Store)
- [ ] Apple Developer 계정 ($99/year)
- [ ] 앱 아이콘 (1024x1024)
- [ ] 스크린샷 (6.5", 5.5" iPhone)
- [ ] 앱 설명 (한국어, 영어)
- [ ] 개인정보 처리 방침 URL
- [ ] 지원 URL
- [ ] TestFlight 베타 테스트
- [ ] App Store Connect 등록
- [ ] 심사 제출

#### Android (Google Play)
- [ ] Google Play 계정 ($25 일회성)
- [ ] 앱 아이콘 (512x512)
- [ ] 스크린샷
- [ ] 앱 설명 (한국어, 영어)
- [ ] 개인정보 처리 방침
- [ ] Internal Testing
- [ ] Closed Testing
- [ ] Open Testing (선택)
- [ ] Production 배포

### 10.3 CI/CD (추후)

#### GitHub Actions
```yaml
# .github/workflows/build.yml
name: Build and Test

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.11.1'
      - run: flutter pub get
      - run: flutter analyze
      - run: flutter test

  build:
    needs: test
    runs-on: macos-latest
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
      - run: flutter build ios --release
      - run: flutter build apk --release
```

---

## 11. 다음 단계: 개발 시작!

### 11.1 즉시 실행할 작업

1. **패키지 설치**
```bash
flutter pub get
```

2. **폴더 구조 생성**
```bash
mkdir -p lib/{app,core,data,domain,presentation}
mkdir -p lib/core/{constants,utils,network,error}
mkdir -p lib/data/{models,repositories,datasources,services}
mkdir -p lib/domain/{entities,usecases}
mkdir -p lib/presentation/{providers,screens,widgets}
```

3. **Supabase 프로젝트 생성**
- https://supabase.com 접속
- 새 프로젝트 생성
- SQL 에디터에서 테이블 생성 스크립트 실행

4. **환경 변수 설정**
```bash
# .env 파일 생성
echo "SUPABASE_URL=your_url" > .env
echo "SUPABASE_ANON_KEY=your_key" >> .env
```

5. **에이전트 시작!**
"프로젝트 셋업부터 시작해줘. Phase 0의 모든 태스크를 순서대로 진행하자."

---

## 12. 요약

### ✅ 준비 완료
- 제품 전략, 페르소나, PRD
- Flutter 프로젝트 구조 설계
- Supabase DB 스키마
- 성경 API & AI API 계획
- 상세한 기능 구현 순서

### 🚀 다음 12주 일정
- Week 1: 프로젝트 셋업
- Week 2: 인증 & 온보딩
- Week 3-4: 일일 말씀 시스템
- Week 5-6: 답변 & Dual Reveal
- Week 7: 스트릭 & 마일스톤
- Week 8: 알림 시스템
- Week 9: 부가 기능
- Week 10: 테스트 & 최적화
- Week 11-12: 출시 준비

### 🎯 MVP 목표
- 500 커플 가입
- 7일 리텐션 60%
- 30일 리텐션 40%
- NPS 50+

---

**Let's Build! 🚀✝️**

**다음 명령어**: "Phase 0부터 시작하자. 프로젝트 셋업을 도와줘!"

---

**문서 버전**: v1.0
**최종 업데이트**: 2026-03-24
**작성자**: Product & Dev Team
