# Bible SumOne - 디자인 가이드라인

> **디자인 시스템 명세서**
>
> 이 문서는 Bible SumOne 앱의 모든 UI/UX 디자인 토큰과 사용 규칙을 정의합니다.
> Phase 0.5에서 추출한 디자인 스타일을 기반으로 작성되었으며, 모든 화면 구현 시 **반드시** 준수해야 합니다.

**버전**: 1.0
**최종 업데이트**: 2026-03-26
**기반**: lib/presentation/screens/design_system/design_test_screen.dart

---

## 📋 목차

1. [개요](#1-개요)
2. [색상 팔레트](#2-색상-팔레트-color-palette)
3. [타이포그래피](#3-타이포그래피-typography)
4. [컴포넌트 스타일](#4-컴포넌트-스타일-component-styles)
5. [간격 시스템](#5-간격-시스템-spacing-system)
6. [그림자](#6-그림자-shadows)
7. [애니메이션](#7-애니메이션-animations)
8. [사용 예시](#8-사용-예시-usage-examples)
9. [다크 모드](#9-다크-모드-dark-mode)
10. [접근성](#10-접근성-accessibility)

---

## 1. 개요

### 1.1 디자인 컨셉

**핵심 키워드**:
- ✝️ **따뜻함**: 커플의 친밀감을 강조하는 따뜻한 색상
- 💑 **현대적**: Material Design 3 기반의 모던한 UI
- 🎯 **명확함**: 직관적이고 읽기 쉬운 구조
- ✨ **경쾌함**: 부드러운 애니메이션과 둥근 모서리

### 1.2 참조 UI

**기반 디자인**:
- 제공받은 UI 스크린샷 분석 결과 (2026-03-27 최종 업데이트)
- Primary Color: **#11BC78** (녹색/민트)
- 카드 중심 디자인
- 부드러운 그림자와 둥근 모서리
- 깔끔한 여백과 간격

### 1.3 적용 범위

**모든 화면에 적용**:
- ✅ 온보딩 (Onboarding)
- ✅ 인증 (Authentication)
- ✅ 홈 (Home)
- ✅ 일일 말씀 (Daily Verse)
- ✅ 답변 작성 (Response)
- ✅ 히스토리 (History)
- ✅ 설정 (Settings)

---

## 2. 색상 팔레트 (Color Palette)

### 2.1 Primary Colors (주 색상)

**용도**: 주요 액션 버튼, 강조 요소, 선택 상태

```dart
// Primary Color
static const Color primaryColor = Color(0xFF11BC78);      // 기본 (#11BC78)
static const Color primaryLight = Color(0xFF40D399);      // 밝은 톤 (#40D399)
static const Color primaryDark = Color(0xFF0D9A63);       // 어두운 톤 (#0D9A63)
```

**사용 예시**:
- 주요 버튼 배경색 (Primary Button)
- 선택된 탭 밑줄
- 체크박스 선택 상태
- 원형 프로그레스바
- 중요한 아이콘

**사용 금지**:
- ❌ 넓은 배경색 (눈이 피로함)
- ❌ 본문 텍스트 색상
- ❌ 카드 배경색

---

### 2.2 Background Colors (배경 색상)

```dart
// Background
static const Color backgroundColor = Color(0xFFF1F5F9); // 앱 전체 배경 (#F1F5F9)
static const Color surfaceColor = Color(0xFFFFFFFF);    // 카드 배경 (#FFFFFF)
```

**backgroundColor** (연한 청회색):
- 앱 전체 배경색
- Scaffold background
- 카드 외부 공간

**surfaceColor** (완전 흰색):
- 카드 배경
- 다이얼로그 배경
- 바텀시트 배경

---

### 2.3 Text Colors (텍스트 색상)

```dart
// Text
static const Color textPrimary = Color(0xFF1A1A1A);     // 주요 텍스트 (#1A1A1A)
static const Color textSecondary = Color(0xFF666666);   // 보조 텍스트 (#666666)
static const Color textTertiary = Color(0xFF999999);    // 세부 텍스트 (#999999)
```

**textPrimary** (거의 검정):
- 제목 (Headline)
- 본문 (Body)
- 버튼 레이블 (흰 배경 위)

**textSecondary** (중간 회색):
- 설명 (Description)
- 캡션 (Caption)
- 플레이스홀더

**textTertiary** (연한 회색):
- 비활성 텍스트
- 보조 정보
- 타임스탬프

---

### 2.4 Border & Divider Colors (테두리 및 구분선)

```dart
// Border & Divider
static const Color borderColor = Color(0xFFE0E0E0);     // 테두리 (#E0E0E0)
static const Color dividerColor = Color(0xFFF5F5F5);    // 구분선 (#F5F5F5)
```

**borderColor**:
- 입력 필드 테두리
- 카드 외곽선 (옵션)
- 체크박스 미선택 상태

**dividerColor**:
- 리스트 구분선
- 섹션 구분선
- 보조 버튼 배경색

---

### 2.5 Status Colors (상태 색상)

```dart
// Status
static const Color successColor = Color(0xFF6BCF8E);    // 성공 (#6BCF8E)
static const Color warningColor = Color(0xFFFFB84D);    // 경고 (#FFB84D)
static const Color errorColor = Color(0xFFFF6B6B);      // 오류 (#FF6B6B)
static const Color infoColor = Color(0xFF4D9FFF);       // 정보 (#4D9FFF)
```

**사용 예시**:
- **successColor**: 성공 메시지, 완료 아이콘
- **warningColor**: 경고 메시지, 주의 아이콘
- **errorColor**: 오류 메시지, 유효성 검사 실패
- **infoColor**: 정보 박스, 도움말 아이콘

---

### 2.6 Disabled Colors (비활성 색상)

```dart
// Disabled
static const Color disabledBackground = Color(0xFFFFF0ED); // 배경 (#FFF0ED)
static const Color disabledText = Color(0xFFCCCCCC);       // 텍스트 (#CCCCCC)
```

**사용 예시**:
- 비활성 버튼 배경
- 비활성 텍스트
- 로딩 중 요소

---

### 2.7 색상 사용 규칙

#### DO (권장)

```dart
// ✅ 명확한 계층 구조
Container(
  color: surfaceColor,  // 카드 배경 (흰색)
  child: Column(
    children: [
      Text(
        '제목',
        style: TextStyle(color: textPrimary),  // 주요 텍스트
      ),
      Text(
        '설명',
        style: TextStyle(color: textSecondary),  // 보조 텍스트
      ),
    ],
  ),
)
```

#### DON'T (금지)

```dart
// ❌ 대비가 낮은 조합
Text(
  '중요한 정보',
  style: TextStyle(color: textTertiary),  // 너무 연함!
)

// ❌ Primary 색상 남용
Container(
  color: primaryColor,  // 넓은 배경에는 부적합
  height: 500,
  width: double.infinity,
)
```

---

## 3. 타이포그래피 (Typography)

### 3.1 폰트 패밀리

**사용 폰트**: Pretendard (기본), Noto Serif KR (성경 구절 전용)

```yaml
# pubspec.yaml
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

**사용 규칙**:
- ✅ **Pretendard**: 모든 UI 텍스트 (제목, 본문, 버튼 등)
- ✅ **Noto Serif KR**: 성경 구절만 (가독성 + 경건함)

---

### 3.2 텍스트 스타일 정의

#### Headline (제목)

```dart
// Headline 1 - 24px Bold
TextStyle(
  fontFamily: 'Pretendard',
  fontSize: 24,
  fontWeight: FontWeight.bold,  // 700
  color: textPrimary,
)
// 용도: 화면 제목, 주요 헤딩

// Headline 2 - 20px Bold
TextStyle(
  fontFamily: 'Pretendard',
  fontSize: 20,
  fontWeight: FontWeight.bold,
  color: textPrimary,
)
// 용도: 섹션 제목, 카드 제목

// Headline 3 - 18px SemiBold
TextStyle(
  fontFamily: 'Pretendard',
  fontSize: 18,
  fontWeight: FontWeight.w600,  // SemiBold
  color: textPrimary,
)
// 용도: 서브 제목, 강조 텍스트
```

---

#### Body (본문)

```dart
// Body 1 - 16px Regular
TextStyle(
  fontFamily: 'Pretendard',
  fontSize: 16,
  fontWeight: FontWeight.normal,  // 400
  color: textPrimary,
)
// 용도: 주요 본문 텍스트

// Body 2 - 14px Regular
TextStyle(
  fontFamily: 'Pretendard',
  fontSize: 14,
  fontWeight: FontWeight.normal,
  color: textPrimary,
)
// 용도: 보조 본문, 설명 텍스트
```

---

#### Caption (캡션)

```dart
// Caption 1 - 12px Regular
TextStyle(
  fontFamily: 'Pretendard',
  fontSize: 12,
  fontWeight: FontWeight.normal,
  color: textSecondary,
)
// 용도: 캡션, 라벨, 보조 정보

// Caption 2 - 10px Regular
TextStyle(
  fontFamily: 'Pretendard',
  fontSize: 10,
  fontWeight: FontWeight.normal,
  color: textSecondary,
)
// 용도: 매우 작은 텍스트, 타임스탬프
```

---

#### Special: Bible Verse (성경 구절 전용)

```dart
// Verse Text - 18px, Noto Serif KR, line height 1.8
TextStyle(
  fontFamily: 'Noto Serif KR',
  fontSize: 18,
  fontWeight: FontWeight.w500,  // Medium
  height: 1.8,  // 줄 간격 (가독성)
  color: textPrimary,
)
// 용도: 성경 구절 표시 ONLY
```

---

### 3.3 타이포그래피 사용 규칙

#### DO (권장)

```dart
// ✅ 명확한 계층 구조
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Text(
      '오늘의 말씀',
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,  // Headline 1
      ),
    ),
    SizedBox(height: 8),
    Text(
      '고린도전서 13:4-7',
      style: TextStyle(
        fontSize: 14,
        color: textSecondary,  // Body 2
      ),
    ),
    SizedBox(height: 16),
    Text(
      '사랑은 오래 참고 사랑은 온유하며...',
      style: TextStyle(
        fontFamily: 'Noto Serif KR',  // 성경 구절
        fontSize: 18,
        height: 1.8,
      ),
    ),
  ],
)
```

#### DON'T (금지)

```dart
// ❌ 폰트 크기 일관성 없음
Text('제목', style: TextStyle(fontSize: 23))  // 24px 사용!
Text('본문', style: TextStyle(fontSize: 15))  // 16px or 14px 사용!

// ❌ 성경 구절에 Pretendard 사용
Text(
  '사랑은 오래 참고...',
  style: TextStyle(fontFamily: 'Pretendard'),  // Noto Serif KR 사용!
)

// ❌ 줄 간격 없음
Text(
  '긴 성경 구절...',
  style: TextStyle(fontFamily: 'Noto Serif KR'),
  // height: 1.8 누락!
)
```

---

### 3.4 타이포그래피 스케일 요약표

| 스타일 | 크기 | 두께 | 색상 | 용도 |
|--------|------|------|------|------|
| **Headline 1** | 24px | Bold (700) | textPrimary | 화면 제목 |
| **Headline 2** | 20px | Bold (700) | textPrimary | 섹션 제목 |
| **Headline 3** | 18px | SemiBold (600) | textPrimary | 서브 제목 |
| **Body 1** | 16px | Regular (400) | textPrimary | 주요 본문 |
| **Body 2** | 14px | Regular (400) | textPrimary | 보조 본문 |
| **Caption 1** | 12px | Regular (400) | textSecondary | 캡션, 라벨 |
| **Caption 2** | 10px | Regular (400) | textSecondary | 타임스탬프 |
| **Verse Text** | 18px | Medium (500) | textPrimary | 성경 구절 (Noto Serif KR) |

---

## 4. 컴포넌트 스타일 (Component Styles)

### 4.1 버튼 (Buttons)

#### Primary Button (주요 버튼)

```dart
ElevatedButton(
  onPressed: () {},
  style: ElevatedButton.styleFrom(
    backgroundColor: primaryColor,       // #11BC78
    foregroundColor: Colors.white,       // 흰색 텍스트
    padding: EdgeInsets.symmetric(
      vertical: 16,
      horizontal: 24,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),  // 12px 둥근 모서리
    ),
    elevation: 0,  // 그림자 없음 (Material 3)
  ),
  child: Text(
    '버튼 텍스트',
    style: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,  // SemiBold
    ),
  ),
)
```

**특징**:
- 배경색: Primary Color (#11BC78)
- 텍스트: 흰색, 16px, SemiBold
- 둥근 모서리: 12px
- 그림자: 없음 (elevation 0)
- 패딩: 상하 16px, 좌우 24px

**용도**:
- 주요 액션 (로그인, 제출, 확인 등)
- 하단 고정 버튼

---

#### Secondary Button (보조 버튼)

```dart
ElevatedButton(
  onPressed: () {},
  style: ElevatedButton.styleFrom(
    backgroundColor: dividerColor,       // #F5F5F5
    foregroundColor: textSecondary,      // #666666
    padding: EdgeInsets.symmetric(
      vertical: 16,
      horizontal: 24,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    elevation: 0,
  ),
  child: Text(
    '버튼 텍스트',
    style: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
    ),
  ),
)
```

**특징**:
- 배경색: Divider Color (연한 회색)
- 텍스트: Text Secondary (중간 회색)
- 나머지는 Primary Button과 동일

**용도**:
- 취소, 닫기
- 다이얼로그에서 부정 액션

---

#### Disabled Button (비활성 버튼)

```dart
ElevatedButton(
  onPressed: null,  // null → 비활성
  style: ElevatedButton.styleFrom(
    backgroundColor: disabledBackground,  // #FFF0ED
    foregroundColor: disabledText,        // #CCCCCC
    padding: EdgeInsets.symmetric(
      vertical: 16,
      horizontal: 24,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    elevation: 0,
    disabledBackgroundColor: disabledBackground,
    disabledForegroundColor: disabledText,
  ),
  child: Text(
    '비활성 버튼',
    style: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
    ),
  ),
)
```

---

### 4.2 카드 (Cards)

#### Basic Card (기본 카드)

```dart
Card(
  elevation: 2,  // 부드러운 그림자
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(16),  // 16px 둥근 모서리
  ),
  color: surfaceColor,  // 흰색 배경
  child: Padding(
    padding: EdgeInsets.all(20),  // 내부 패딩 20px
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 카드 내용
      ],
    ),
  ),
)
```

**특징**:
- 배경색: Surface Color (흰색)
- 둥근 모서리: 16px
- Elevation: 2 (부드러운 그림자)
- 내부 패딩: 20px

**용도**:
- 일반 컨텐츠 카드
- 리스트 아이템

---

#### Elevated Card (강조 카드)

```dart
Card(
  elevation: 4,  // 더 강한 그림자
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(20),  // 20px 둥근 모서리
  ),
  color: surfaceColor,
  child: Padding(
    padding: EdgeInsets.all(20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 카드 내용
      ],
    ),
  ),
)
```

**특징**:
- 둥근 모서리: 20px (더 둥글게)
- Elevation: 4 (더 강한 그림자)
- 나머지는 Basic Card와 동일

**용도**:
- 중요한 정보 (오늘의 말씀 카드)
- 강조가 필요한 카드

---

### 4.3 입력 필드 (Text Fields)

#### 기본 입력 필드

```dart
TextField(
  decoration: InputDecoration(
    filled: true,
    fillColor: Colors.grey.shade100,  // 연한 회색 배경
    hintText: '플레이스홀더',
    hintStyle: TextStyle(color: textSecondary),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),  // 12px 둥근 모서리
      borderSide: BorderSide.none,  // 테두리 없음
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(
        color: primaryColor,  // 포커스 시 Primary Color
        width: 2,
      ),
    ),
    contentPadding: EdgeInsets.symmetric(
      vertical: 16,
      horizontal: 16,
    ),
  ),
  style: TextStyle(
    fontSize: 16,
    color: textPrimary,
  ),
)
```

**특징**:
- 배경: 연한 회색
- 기본 테두리: 없음
- 포커스 테두리: Primary Color, 2px
- 둥근 모서리: 12px
- 내부 패딩: 16px

---

### 4.4 체크박스 (Checkboxes)

#### 원형 체크박스 (커스텀)

```dart
Container(
  width: 24,
  height: 24,
  decoration: BoxDecoration(
    shape: BoxShape.circle,  // 원형
    color: isChecked ? primaryColor : Colors.transparent,
    border: Border.all(
      color: isChecked ? primaryColor : borderColor,
      width: 2,
    ),
  ),
  child: isChecked
      ? Icon(
          Icons.check,
          size: 16,
          color: Colors.white,
        )
      : null,
)
```

**특징**:
- 크기: 24x24px
- 모양: 원형 (Circle)
- 선택됨: Primary Color 배경 + 흰색 체크 아이콘
- 선택 안 됨: 투명 배경 + Border Color 테두리

**용도**:
- 리스트 선택 (제공받은 UI 스타일)

---

### 4.5 탭 (Tabs)

```dart
GestureDetector(
  onTap: () => setState(() => selectedTab = index),
  child: Container(
    padding: EdgeInsets.symmetric(vertical: 12),
    decoration: BoxDecoration(
      border: Border(
        bottom: BorderSide(
          color: isSelected ? primaryColor : Colors.transparent,
          width: 2,  // 하단 2px 밑줄
        ),
      ),
    ),
    child: Text(
      '탭 이름',
      style: TextStyle(
        fontSize: 14,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        color: isSelected ? primaryColor : textTertiary,
      ),
    ),
  ),
)
```

**특징**:
- 선택됨: Primary Color 하단 밑줄 (2px) + Bold + Primary Color 텍스트
- 선택 안 됨: 밑줄 없음 + Regular + Tertiary Color 텍스트

---

### 4.6 프로그레스 (Progress Indicators)

#### 원형 프로그레스

```dart
SizedBox(
  width: 120,
  height: 120,
  child: CircularProgressIndicator(
    value: 0.76,  // 76%
    strokeWidth: 10,  // 두께
    backgroundColor: dividerColor,
    valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
  ),
)
```

**특징**:
- 두께: 10px
- 배경: Divider Color
- 진행색: Primary Color

---

#### 선형 프로그레스

```dart
ClipRRect(
  borderRadius: BorderRadius.circular(8),  // 8px 둥근 모서리
  child: LinearProgressIndicator(
    value: 0.65,  // 65%
    minHeight: 8,  // 높이
    backgroundColor: dividerColor,
    valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
  ),
)
```

**특징**:
- 높이: 8px
- 둥근 모서리: 8px
- 배경: Divider Color
- 진행색: Primary Color

---

### 4.7 다이얼로그 (Dialogs)

```dart
Dialog(
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(20),  // 20px 둥근 모서리
  ),
  child: Padding(
    padding: EdgeInsets.all(24),  // 내부 패딩 24px
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '다이얼로그 제목',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 12),
        Text(
          '다이얼로그 내용',
          style: TextStyle(
            fontSize: 14,
            color: textSecondary,
          ),
        ),
        SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: SecondaryButton('취소'),
            ),
            SizedBox(width: 12),
            Expanded(
              child: PrimaryButton('확인'),
            ),
          ],
        ),
      ],
    ),
  ),
)
```

**특징**:
- 둥근 모서리: 20px
- 내부 패딩: 24px
- 버튼: 좌우 배치, 12px 간격

---

### 4.8 리스트 아이템 (List Items)

```dart
InkWell(
  onTap: onTap,
  child: Padding(
    padding: EdgeInsets.all(16),
    child: Row(
      children: [
        // 아이콘 또는 이미지 (60x60px)
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: dividerColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(Icons.medication_outlined, size: 32),
        ),
        SizedBox(width: 12),

        // 텍스트
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '브랜드',
                style: TextStyle(fontSize: 12, color: textSecondary),
              ),
              SizedBox(height: 4),
              Text(
                '제품명',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
        SizedBox(width: 12),

        // 체크박스 또는 액션
        CircularCheckbox(isChecked),
      ],
    ),
  ),
)
```

**특징**:
- 패딩: 16px
- 이미지/아이콘: 60x60px, 8px 둥근 모서리
- 간격: 12px
- 구분선: Divider Color, 1px

---

## 5. 간격 시스템 (Spacing System)

### 5.1 8px Grid 기반

**기본 간격**:
```dart
// 8px 배수로 간격 설정
static const double spacing4 = 4.0;
static const double spacing8 = 8.0;
static const double spacing12 = 12.0;
static const double spacing16 = 16.0;
static const double spacing20 = 20.0;
static const double spacing24 = 24.0;
static const double spacing32 = 32.0;
static const double spacing40 = 40.0;
static const double spacing48 = 48.0;
```

### 5.2 사용 가이드

| 간격 | 용도 |
|------|------|
| **4px** | 매우 작은 간격 (텍스트 줄 간격) |
| **8px** | 작은 간격 (버튼 내부 요소) |
| **12px** | 중간 간격 (카드 내부 요소) |
| **16px** | 기본 간격 (카드 패딩, 섹션 간) |
| **20px** | 넉넉한 간격 (카드 내부 패딩) |
| **24px** | 큰 간격 (섹션 간, 다이얼로그 패딩) |
| **32px** | 매우 큰 간격 (화면 섹션 간) |
| **48px** | 특별한 간격 (화면 상하단 여백) |

### 5.3 예시

```dart
// ✅ 8px 배수 사용
Column(
  children: [
    Text('제목'),
    SizedBox(height: 8),   // 제목-설명 간격
    Text('설명'),
    SizedBox(height: 24),  // 섹션 간격
    Card(
      margin: EdgeInsets.all(16),  // 카드 외부 여백
      child: Padding(
        padding: EdgeInsets.all(20),  // 카드 내부 패딩
        child: ...,
      ),
    ),
  ],
)

// ❌ 불규칙한 간격
SizedBox(height: 15)  // 16 사용!
SizedBox(height: 23)  // 24 사용!
```

---

## 6. 그림자 (Shadows)

### 6.1 Elevation 사용

**Material Design 3 기준**:
```dart
// Elevation 0 (그림자 없음)
elevation: 0  // 버튼, 입력 필드

// Elevation 2 (부드러운 그림자)
elevation: 2  // 기본 카드

// Elevation 4 (강한 그림자)
elevation: 4  // 강조 카드, 다이얼로그
```

### 6.2 커스텀 그림자 (옵션)

```dart
BoxDecoration(
  color: surfaceColor,
  borderRadius: BorderRadius.circular(16),
  boxShadow: [
    BoxShadow(
      color: Colors.black.withOpacity(0.08),  // 8% 투명도
      blurRadius: 8,
      offset: Offset(0, 2),  // 하단으로 2px
    ),
  ],
)
```

---

## 7. 애니메이션 (Animations)

### 7.1 기본 애니메이션 Duration

```dart
// 빠른 애니메이션 (버튼 피드백, 색상 변경)
static const Duration fastDuration = Duration(milliseconds: 200);

// 중간 애니메이션 (화면 전환, 카드 이동)
static const Duration mediumDuration = Duration(milliseconds: 400);

// 느린 애니메이션 (복잡한 애니메이션, Dual Reveal)
static const Duration slowDuration = Duration(milliseconds: 800);
```

### 7.2 Curve (애니메이션 곡선)

```dart
// 부드러운 시작-끝
Curves.easeInOut

// 부드러운 시작
Curves.easeOut

// 튕기는 효과
Curves.bounceOut

// 탄성 효과
Curves.elasticOut
```

### 7.3 예시

```dart
// ✅ 버튼 탭 애니메이션
AnimatedContainer(
  duration: Duration(milliseconds: 200),
  curve: Curves.easeOut,
  color: isPressed ? primaryDark : primaryColor,
  child: ...,
)

// ✅ 카드 나타나기
AnimatedOpacity(
  duration: Duration(milliseconds: 400),
  curve: Curves.easeInOut,
  opacity: isVisible ? 1.0 : 0.0,
  child: Card(...),
)
```

---

## 8. 사용 예시 (Usage Examples)

### 8.1 화면 레이아웃 기본 구조

```dart
Scaffold(
  backgroundColor: backgroundColor,  // 앱 배경색
  appBar: AppBar(
    backgroundColor: backgroundColor,
    foregroundColor: textPrimary,
    elevation: 0,
    title: Text('화면 제목'),
  ),
  body: SingleChildScrollView(
    padding: EdgeInsets.all(16),  // 기본 패딩
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 섹션 1
        Text(
          '섹션 제목',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 12),

        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: EdgeInsets.all(20),
            child: ...,
          ),
        ),

        SizedBox(height: 24),  // 섹션 간 간격

        // 섹션 2
        ...,
      ],
    ),
  ),
)
```

### 8.2 버튼 그룹

```dart
Row(
  children: [
    Expanded(
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: dividerColor,
          foregroundColor: textSecondary,
          padding: EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: Text('취소'),
      ),
    ),
    SizedBox(width: 12),
    Expanded(
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: Text('확인'),
      ),
    ),
  ],
)
```

### 8.3 정보 박스 (Info Card)

```dart
Container(
  padding: EdgeInsets.all(16),
  decoration: BoxDecoration(
    color: infoColor.withOpacity(0.1),  // 10% 투명도
    borderRadius: BorderRadius.circular(12),
    border: Border.all(
      color: infoColor.withOpacity(0.3),
      width: 1,
    ),
  ),
  child: Row(
    children: [
      Icon(Icons.info_outline, color: infoColor, size: 20),
      SizedBox(width: 8),
      Expanded(
        child: Text(
          '정보 메시지',
          style: TextStyle(fontSize: 14, color: textPrimary),
        ),
      ),
    ],
  ),
)
```

---

## 9. 다크 모드 (Dark Mode)

**현재 상태**: 추후 구현 예정

**계획**:
- Light Mode: 위 정의된 색상 사용
- Dark Mode: 별도 색상 팔레트 정의 필요

**TODO**:
- [ ] Dark Mode 색상 팔레트 정의
- [ ] Theme 분기 로직 구현
- [ ] 컴포넌트별 Dark Mode 스타일 정의

---

## 10. 접근성 (Accessibility)

### 10.1 색상 대비 (Color Contrast)

**WCAG 2.1 AA 기준 준수**:
- ✅ **textPrimary (#1A1A1A) on surfaceColor (#FFFFFF)**: 17.5:1 (충분)
- ✅ **textSecondary (#666666) on surfaceColor (#FFFFFF)**: 5.7:1 (충분)
- ✅ **primaryColor (#F93D17) vs white text**: 3.6:1 (AA 기준 충족)

### 10.2 터치 영역 (Touch Target)

**최소 터치 영역**: 48x48 dp

```dart
// ✅ 충분한 터치 영역
InkWell(
  onTap: () {},
  child: Container(
    height: 48,  // 최소 48dp
    padding: EdgeInsets.symmetric(horizontal: 16),
    child: Text('탭 가능한 영역'),
  ),
)
```

### 10.3 시맨틱 레이블 (Semantic Labels)

```dart
// ✅ 아이콘 버튼에 의미 제공
IconButton(
  icon: Icon(Icons.close),
  tooltip: '닫기',
  onPressed: () {},
)

// ✅ 이미지에 설명 제공
Image.asset(
  'assets/logo.png',
  semanticLabel: 'Bible SumOne 로고',
)
```

---

## 11. Quick Reference (빠른 참조)

### 11.1 색상 치트시트

```dart
// Primary
primaryColor       = #11BC78
primaryLight       = #40D399
primaryDark        = #0D9A63

// Background
backgroundColor    = #F1F5F9
surfaceColor       = #FFFFFF

// Text
textPrimary        = #1A1A1A
textSecondary      = #666666
textTertiary       = #999999

// Border
borderColor        = #E0E0E0
dividerColor       = #F5F5F5

// Status
successColor       = #6BCF8E
warningColor       = #FFB84D
errorColor         = #FF6B6B
infoColor          = #4D9FFF
```

### 11.2 간격 치트시트

```dart
4px   - 매우 작은 간격
8px   - 작은 간격
12px  - 중간 간격
16px  - 기본 간격 (카드 패딩)
20px  - 넉넉한 간격 (카드 내부)
24px  - 큰 간격 (섹션 간)
32px  - 매우 큰 간격
```

### 11.3 둥근 모서리 치트시트

```dart
8px   - 작은 요소 (이미지, 프로그레스)
12px  - 버튼, 입력 필드
16px  - 기본 카드
20px  - 강조 카드, 다이얼로그
```

---

## 12. 변경 히스토리

**v1.0 (2026-03-26)**:
- 초안 작성
- design_test_screen.dart 분석 기반
- 색상, 타이포그래피, 컴포넌트 스타일 정의

**v1.1 (2026-03-27)**:
- 색상 팔레트 업데이트
- Primary: #F93D17 → #11BC78 (녹색/민트)
- Background: #F8F5F5 → #F1F5F9 (연한 청회색)

**향후 계획**:
- Dark Mode 색상 팔레트 추가
- 애니메이션 가이드 확장
- 실제 화면 구현 사례 추가

---

## 🎯 Remember

```
"일관성이 창의성보다 중요하다"
"사용자는 디자인 토큰을 보지 않지만, 느낀다"
"모든 픽셀에는 의미가 있어야 한다"
```

**이 가이드를 지키면**:
- ✅ 일관된 사용자 경험
- ✅ 빠른 개발 속도 (재사용 가능한 스타일)
- ✅ 쉬운 유지보수
- ✅ 아름다운 UI

**Let's Design with Consistency! 🎨✨**

---

**문서 작성자**: Claude Code (UI/UX Analysis)
**검토자**: Design Team
**승인**: Product Team
