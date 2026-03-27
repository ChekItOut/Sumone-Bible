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

### 4.9 공통 위젯: 버튼 (Common Widgets: Buttons)

#### 4.9.1 PrimaryButton

**파일 경로**: `lib/presentation/widgets/buttons/primary_button.dart`

**용도**: 주요 액션 (로그인, 제출, 확인, 시작 등)

**Props**:
- `text` (String, required): 버튼 텍스트
- `onPressed` (VoidCallback?, required): 탭 이벤트 핸들러 (null이면 비활성)
- `isLoading` (bool, optional): 로딩 상태 (기본값: false)
- `fullWidth` (bool, optional): 전체 너비 사용 (기본값: false)
- `height` (double?, optional): 버튼 높이 (기본값: 48)
- `padding` (EdgeInsetsGeometry?, optional): 내부 패딩 (기본값: 16px 수직, 24px 수평)

**코드 예시**:
```dart
// ✅ 기본 사용법
PrimaryButton(
  text: '확인',
  onPressed: () {
    print('버튼 클릭');
  },
)

// ✅ 전체 너비 버튼
PrimaryButton(
  text: '로그인',
  fullWidth: true,
  onPressed: () => handleLogin(),
)

// ✅ 로딩 상태
PrimaryButton(
  text: '제출 중...',
  onPressed: _handleSubmit,
  isLoading: true, // 로딩 인디케이터 표시
)

// ✅ 비활성 상태
PrimaryButton(
  text: '제출하기',
  onPressed: null, // onPressed가 null이면 자동 비활성
)

// ❌ 잘못된 사용 (안티 패턴)
PrimaryButton(
  text: '', // 빈 텍스트 금지
  onPressed: () {},
)
```

**사용 시나리오**:
- 로그인/회원가입 제출 버튼
- 답변 제출 버튼
- 설정 저장 버튼
- 확인 다이얼로그의 확인 버튼

**디자인 스펙**:
- 배경색: Primary Color (#11BC78)
- 텍스트 색: 흰색 (#FFFFFF)
- 비활성 배경색: 연한 초록색 (primaryColor 20% 투명도)
- 비활성 텍스트 색: 중간 톤 초록 (primaryColor 50% 투명도)
- 둥근 모서리: 12px
- Elevation: 0 (Material Design 3)
- 폰트: 16px, SemiBold (w600)

---

#### 4.9.2 SecondaryButton

**파일 경로**: `lib/presentation/widgets/buttons/secondary_button.dart`

**용도**: 보조 액션 (취소, 돌아가기, 건너뛰기 등)

**Props**:
- `text` (String, required): 버튼 텍스트
- `onPressed` (VoidCallback?, required): 탭 이벤트 핸들러
- `isLoading` (bool, optional): 로딩 상태 (기본값: false)
- `fullWidth` (bool, optional): 전체 너비 사용 (기본값: false)
- `height` (double?, optional): 버튼 높이 (기본값: 48)
- `padding` (EdgeInsetsGeometry?, optional): 내부 패딩

**코드 예시**:
```dart
// ✅ 기본 사용법 (취소 버튼)
SecondaryButton(
  text: '취소',
  onPressed: () => Navigator.pop(context),
)

// ✅ 다이얼로그에서 사용
Row(
  children: [
    Expanded(
      child: SecondaryButton(
        text: '취소',
        onPressed: () => Navigator.pop(context),
      ),
    ),
    SizedBox(width: 12),
    Expanded(
      child: PrimaryButton(
        text: '확인',
        onPressed: () => handleConfirm(),
      ),
    ),
  ],
)

// ✅ 로딩 상태
SecondaryButton(
  text: '처리 중...',
  isLoading: true,
  onPressed: null,
)
```

**사용 시나리오**:
- 다이얼로그 취소 버튼
- 스텝 이동 (이전 단계)
- 선택적 액션

**디자인 스펙**:
- 배경색: Divider Color (#F5F5F5)
- 텍스트 색: Text Secondary (#666666)
- 비활성 배경색: #FFF0ED
- 비활성 텍스트 색: #CCCCCC
- 둥근 모서리: 12px
- Elevation: 0

---

#### 4.9.3 TextButtonCustom

**파일 경로**: `lib/presentation/widgets/buttons/text_button_custom.dart`

**용도**: 배경 없는 텍스트 링크 버튼 (회원가입, 비밀번호 찾기 등)

**Props**:
- `text` (String, required): 버튼 텍스트
- `onPressed` (VoidCallback?, required): 탭 이벤트 핸들러
- `isLoading` (bool, optional): 로딩 상태 (기본값: false)
- `padding` (EdgeInsetsGeometry?, optional): 내부 패딩 (기본값: 8px 수직, 16px 수평)

**코드 예시**:
```dart
// ✅ 기본 사용법 (링크 스타일)
TextButtonCustom(
  text: '회원가입',
  onPressed: () => context.push('/signup'),
)

// ✅ 비밀번호 찾기
TextButtonCustom(
  text: '비밀번호를 잊으셨나요?',
  onPressed: () => showResetPasswordDialog(),
)

// ✅ 건너뛰기 버튼
TextButtonCustom(
  text: '건너뛰기',
  onPressed: () => Navigator.pushReplacementNamed(context, '/home'),
)
```

**사용 시나리오**:
- 회원가입 링크
- 비밀번호 찾기 링크
- 건너뛰기 버튼
- 약관 보기 링크

**디자인 스펙**:
- 배경색: 없음 (투명)
- 텍스트 색: Primary Color (#11BC78)
- 비활성 텍스트 색: #CCCCCC
- 둥근 모서리: 8px
- 폰트: 14px, SemiBold (w600)

---

### 4.10 공통 위젯: 카드 (Common Widgets: Cards)

#### 4.10.1 BaseCard

**파일 경로**: `lib/presentation/widgets/cards/base_card.dart`

**용도**: 표준 카드 스타일 (일반 정보 표시)

**Props**:
- `child` (Widget, required): 카드 내부에 표시할 위젯
- `padding` (EdgeInsetsGeometry?, optional): 카드 내부 패딩 (기본값: 20px)
- `margin` (EdgeInsetsGeometry?, optional): 카드 외부 여백 (기본값: null)
- `onTap` (VoidCallback?, optional): 카드 클릭 이벤트 (null이면 탭 불가)
- `backgroundColor` (Color?, optional): 카드 배경색 (기본값: surfaceColor #FFFFFF)

**코드 예시**:
```dart
// ✅ 기본 사용법
BaseCard(
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        '제목',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      SizedBox(height: 8),
      Text(
        '내용',
        style: TextStyle(fontSize: 14, color: AppTheme.textSecondary),
      ),
    ],
  ),
)

// ✅ 탭 가능한 카드
BaseCard(
  onTap: () {
    print('카드 클릭됨');
  },
  child: ListTile(
    leading: Icon(Icons.person),
    title: Text('사용자 프로필'),
  ),
)

// ✅ 커스텀 배경색 및 패딩
BaseCard(
  backgroundColor: Colors.blue.shade50,
  padding: EdgeInsets.all(16),
  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
  child: Text('정보 메시지'),
)
```

**사용 시나리오**:
- 사용자 정보 카드
- 설정 항목 카드
- 리스트 아이템 래퍼

**디자인 스펙**:
- Elevation: 2 (부드러운 그림자)
- 둥근 모서리: 16px
- 배경색: Surface Color (#FFFFFF)
- 그림자 색: Black 8% 투명도
- 기본 패딩: 20px

---

#### 4.10.2 ElevatedCard

**파일 경로**: `lib/presentation/widgets/cards/elevated_card.dart`

**용도**: 강조 카드 스타일 (중요한 정보, 오늘의 말씀 카드 등)

**Props**:
- `child` (Widget, required): 카드 내부에 표시할 위젯
- `padding` (EdgeInsetsGeometry?, optional): 카드 내부 패딩 (기본값: 20px)
- `margin` (EdgeInsetsGeometry?, optional): 카드 외부 여백
- `onTap` (VoidCallback?, optional): 카드 클릭 이벤트
- `backgroundColor` (Color?, optional): 카드 배경색

**코드 예시**:
```dart
// ✅ 오늘의 말씀 카드
ElevatedCard(
  child: Column(
    children: [
      Text(
        '오늘의 말씀',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      SizedBox(height: 12),
      Text(
        '사랑은 오래 참고 사랑은 온유하며...',
        style: TextStyle(fontSize: 16, height: 1.8),
        textAlign: TextAlign.center,
      ),
      SizedBox(height: 8),
      Text(
        '고린도전서 13:4',
        style: TextStyle(fontSize: 12, color: AppTheme.textSecondary),
      ),
    ],
  ),
)

// ✅ 마일스톤 카드
ElevatedCard(
  backgroundColor: AppTheme.primaryLight.withValues(alpha: 0.1),
  onTap: () => showMilestoneDetails(),
  child: Row(
    children: [
      Icon(Icons.celebration, size: 48, color: AppTheme.primaryColor),
      SizedBox(width: 16),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('7일 연속 달성!', style: TextStyle(fontWeight: FontWeight.bold)),
            Text('계속해서 좋은 습관을 유지해보세요.'),
          ],
        ),
      ),
    ],
  ),
)
```

**사용 시나리오**:
- 오늘의 말씀 카드
- 마일스톤 축하 카드
- 프로모션 배너

**디자인 스펙**:
- Elevation: 4 (더 강한 그림자)
- 둥근 모서리: 20px (BaseCard보다 더 둥글게)
- 배경색: Surface Color (#FFFFFF)
- 그림자 색: Black 8% 투명도
- 기본 패딩: 20px

---

### 4.11 공통 위젯: 입력 (Common Widgets: Inputs)

#### 4.11.1 TextFieldCustom

**파일 경로**: `lib/presentation/widgets/inputs/text_field_custom.dart`

**용도**: 한 줄 입력 필드 (이메일, 비밀번호, 이름 등)

**Props**:
- `labelText` (String?, optional): 입력 필드 라벨
- `hintText` (String?, optional): 플레이스홀더 텍스트
- `controller` (TextEditingController?, optional): 텍스트 컨트롤러
- `errorText` (String?, optional): 에러 메시지 (표시 시 빨간 테두리)
- `obscureText` (bool, optional): 비밀번호 입력 여부 (기본값: false)
- `keyboardType` (TextInputType, optional): 키보드 타입 (기본값: text)
- `enabled` (bool, optional): 활성화 여부 (기본값: true)
- `prefixIcon` (Widget?, optional): 좌측 아이콘
- `suffixIcon` (Widget?, optional): 우측 아이콘
- `maxLines` (int?, optional): 최대 줄 수 (기본값: 1)
- `onChanged` (ValueChanged<String>?, optional): 입력 변경 시 콜백
- `validator` (String? Function(String?)?, optional): 유효성 검사 함수
- `textInputAction` (TextInputAction, optional): 키보드 액션 버튼 (기본값: done)

**코드 예시**:
```dart
// ✅ 기본 사용법 (이메일 입력)
TextFieldCustom(
  labelText: '이메일',
  hintText: 'example@email.com',
  keyboardType: TextInputType.emailAddress,
  controller: _emailController,
)

// ✅ 비밀번호 입력
TextFieldCustom(
  labelText: '비밀번호',
  hintText: '비밀번호를 입력하세요',
  obscureText: true,
  controller: _passwordController,
  suffixIcon: Icon(Icons.visibility_off),
)

// ✅ 에러 상태
TextFieldCustom(
  labelText: '이메일',
  hintText: 'example@email.com',
  controller: _emailController,
  errorText: '올바른 이메일 형식이 아닙니다',
)

// ✅ 아이콘 포함
TextFieldCustom(
  hintText: '검색',
  prefixIcon: Icon(Icons.search),
  onChanged: (value) => handleSearch(value),
)

// ✅ Form 유효성 검사
TextFormField(
  controller: _emailController,
  validator: (value) {
    if (value == null || value.isEmpty) {
      return '이메일을 입력해주세요';
    }
    if (!value.contains('@')) {
      return '올바른 이메일 형식이 아닙니다';
    }
    return null;
  },
)
```

**사용 시나리오**:
- 로그인 이메일/비밀번호 입력
- 회원가입 폼
- 프로필 수정
- 검색 입력

**디자인 스펙**:
- 배경색: Colors.grey.shade100 (연한 회색)
- 비활성 배경색: #FFF0ED
- 둥근 모서리: 12px
- 테두리: 기본적으로 없음 (BorderSide.none)
- 포커스 테두리: Primary Color (#11BC78), 2px
- 에러 테두리: Error Color (#FF6B6B), 2px
- 내부 패딩: 16px
- 폰트: 16px

---

#### 4.11.2 TextAreaCustom

**파일 경로**: `lib/presentation/widgets/inputs/text_area_custom.dart`

**용도**: 여러 줄 입력 필드 (답변 작성, 긴 텍스트 입력)

**Props**:
- `labelText` (String?, optional): 입력 필드 라벨
- `hintText` (String?, optional): 플레이스홀더 텍스트
- `controller` (TextEditingController?, optional): 텍스트 컨트롤러
- `errorText` (String?, optional): 에러 메시지
- `enabled` (bool, optional): 활성화 여부 (기본값: true)
- `maxLines` (int?, optional): 최대 줄 수 (기본값: 5)
- `onChanged` (ValueChanged<String>?, optional): 입력 변경 시 콜백

**코드 예시**:
```dart
// ✅ 기본 사용법 (답변 작성)
TextAreaCustom(
  labelText: '답변 작성',
  hintText: '오늘 말씀을 읽고 느낀 점을 자유롭게 작성해주세요.',
  controller: _responseController,
  maxLines: 5,
)

// ✅ 긴 텍스트 입력
TextAreaCustom(
  labelText: '자기소개',
  hintText: '자신을 소개해주세요.',
  controller: _bioController,
  maxLines: 8,
  onChanged: (value) {
    setState(() {
      _charCount = value.length;
    });
  },
)

// ✅ 에러 상태
TextAreaCustom(
  labelText: '답변',
  hintText: '답변을 입력하세요',
  controller: _answerController,
  errorText: '답변은 최소 10자 이상이어야 합니다',
)
```

**사용 시나리오**:
- 일일 말씀 답변 작성
- 커플 메모 작성
- 자기소개 입력
- 피드백 작성

**디자인 스펙**:
- TextFieldCustom과 동일한 스타일
- 기본 줄 수: 5줄
- 키보드 타입: TextInputType.multiline

---

### 4.12 공통 위젯: 로딩 (Common Widgets: Loading)

#### 4.12.1 LoadingIndicator

**파일 경로**: `lib/presentation/widgets/loading/loading_indicator.dart`

**용도**: 원형 로딩 인디케이터 (작업 진행 중)

**Props**:
- `size` (double, optional): 인디케이터 크기 (기본값: 40)
- `color` (Color?, optional): 인디케이터 색상 (기본값: primaryColor)
- `strokeWidth` (double, optional): 선 두께 (기본값: 4)
- `semanticLabel` (String?, optional): 접근성 레이블 (기본값: "로딩 중")

**추가 위젯**:
- `FullScreenLoading`: 전체 화면 로딩 (message 파라미터 지원)

**코드 예시**:
```dart
// ✅ 기본 사용법
LoadingIndicator()

// ✅ 작은 크기
LoadingIndicator(size: 24, strokeWidth: 2)

// ✅ 흰색 인디케이터 (다크 배경에서)
LoadingIndicator(color: Colors.white)

// ✅ 전체 화면 로딩
Scaffold(
  body: FullScreenLoading(
    message: '데이터를 불러오는 중...',
  ),
)

// ✅ 버튼 내부 로딩
ElevatedButton(
  onPressed: isLoading ? null : () {},
  child: isLoading
    ? LoadingIndicator(size: 20, color: Colors.white)
    : Text('제출하기'),
)
```

**사용 시나리오**:
- API 호출 중
- 데이터 로딩 중
- 버튼 클릭 후 처리 중
- 화면 초기화 중

**디자인 스펙**:
- 기본 크기: 40px
- 선 두께: 4px
- 색상: Primary Color (#11BC78)
- 접근성 레이블: "로딩 중"

---

#### 4.12.2 SkeletonLoader

**파일 경로**: `lib/presentation/widgets/loading/skeleton_loader.dart`

**용도**: Shimmer 효과를 사용한 로딩 플레이스홀더

**Props**:
- `width` (double, required): 너비
- `height` (double, required): 높이
- `borderRadius` (double, optional): 둥근 모서리 (기본값: 8)

**추가 위젯**:
- `SkeletonCard`: 카드 형태의 스켈레톤 UI
- `SkeletonList`: 리스트 형태의 스켈레톤 UI (itemCount 파라미터)

**코드 예시**:
```dart
// ✅ 텍스트 플레이스홀더
SkeletonLoader(width: 200, height: 20)

// ✅ 이미지 플레이스홀더
SkeletonLoader(
  width: double.infinity,
  height: 150,
  borderRadius: 12,
)

// ✅ 카드 스켈레톤
SkeletonCard()

// ✅ 리스트 스켈레톤
SkeletonList(itemCount: 5)

// ✅ 실제 사용 예시
isLoading
  ? Column(
      children: [
        SkeletonLoader(width: 200, height: 24, borderRadius: 4),
        SizedBox(height: 12),
        SkeletonLoader(width: 150, height: 16, borderRadius: 4),
        SizedBox(height: 16),
        SkeletonLoader(width: double.infinity, height: 100, borderRadius: 12),
      ],
    )
  : ActualContentWidget()
```

**사용 시나리오**:
- 말씀 카드 로딩 중
- 리스트 데이터 로딩 중
- 프로필 정보 로딩 중
- 이미지 로딩 중

**디자인 스펙**:
- Base Color: Colors.grey.shade300
- Highlight Color: Colors.grey.shade100
- 기본 둥근 모서리: 8px
- Shimmer 방향: 좌 → 우

---

### 4.13 공통 위젯: 다이얼로그 (Common Widgets: Dialogs)

#### 4.13.1 ConfirmDialog

**파일 경로**: `lib/presentation/widgets/dialogs/confirm_dialog.dart`

**용도**: 확인/취소 다이얼로그 (사용자 확인 필요한 액션)

**Props**:
- `title` (String, required): 다이얼로그 제목
- `message` (String, required): 다이얼로그 내용
- `confirmText` (String, optional): 확인 버튼 텍스트 (기본값: "확인")
- `cancelText` (String, optional): 취소 버튼 텍스트 (기본값: "취소")

**Helper 메서드**:
- `ConfirmDialog.show()`: 다이얼로그 표시 (반환값: true/false/null)

**코드 예시**:
```dart
// ✅ 기본 사용법
final result = await ConfirmDialog.show(
  context,
  title: '삭제 확인',
  message: '정말 삭제하시겠습니까?',
);

if (result == true) {
  // 확인 버튼 클릭
  deleteItem();
} else {
  // 취소 버튼 클릭 또는 외부 클릭
  print('취소됨');
}

// ✅ 커스텀 버튼 텍스트
final result = await ConfirmDialog.show(
  context,
  title: '로그아웃',
  message: '로그아웃 하시겠습니까?',
  confirmText: '로그아웃',
  cancelText: '머무르기',
);

// ✅ 위험한 액션 경고
final result = await ConfirmDialog.show(
  context,
  title: '⚠️ 경고',
  message: '이 작업은 되돌릴 수 없습니다. 계속하시겠습니까?',
  confirmText: '삭제',
  cancelText: '취소',
);
```

**사용 시나리오**:
- 데이터 삭제 확인
- 로그아웃 확인
- 변경사항 저장 확인
- 위험한 액션 경고

**디자인 스펙**:
- 둥근 모서리: 20px
- 내부 패딩: 24px
- 제목 폰트: 18px, Bold
- 내용 폰트: 14px, Text Secondary
- 버튼: Secondary (취소) + Primary (확인)
- 버튼 간격: 12px

---

#### 4.13.2 ErrorDialog

**파일 경로**: `lib/presentation/widgets/dialogs/error_dialog.dart`

**용도**: 에러 메시지 다이얼로그 (사용자에게 오류 알림)

**Props**:
- `title` (String, optional): 다이얼로그 제목 (기본값: "오류")
- `message` (String, required): 에러 메시지
- `buttonText` (String, optional): 버튼 텍스트 (기본값: "확인")

**Helper 메서드**:
- `ErrorDialog.show()`: 다이얼로그 표시

**코드 예시**:
```dart
// ✅ 기본 사용법
await ErrorDialog.show(
  context,
  message: '네트워크 연결을 확인해주세요.',
);

// ✅ 커스텀 제목
await ErrorDialog.show(
  context,
  title: '로그인 실패',
  message: '이메일 또는 비밀번호가 올바르지 않습니다.',
);

// ✅ try-catch에서 사용
try {
  await loginUser(email, password);
} catch (e) {
  await ErrorDialog.show(
    context,
    message: '로그인 중 오류가 발생했습니다: ${e.toString()}',
  );
}

// ✅ API 에러 처리
final response = await apiCall();
if (!response.success) {
  await ErrorDialog.show(
    context,
    title: '오류 발생',
    message: response.errorMessage ?? '알 수 없는 오류가 발생했습니다.',
    buttonText: '다시 시도',
  );
}
```

**사용 시나리오**:
- API 호출 실패
- 네트워크 오류
- 유효성 검사 실패
- 권한 오류

**디자인 스펙**:
- 둥근 모서리: 20px
- 내부 패딩: 24px
- 에러 아이콘: Icons.error_outline, Error Color (#FF6B6B), 48px
- 제목 폰트: 18px, Bold
- 내용 폰트: 14px, Text Secondary
- 버튼: Primary Button (전체 너비)
- barrierDismissible: false (외부 클릭으로 닫을 수 없음)

---

### 4.14 공통 위젯: AppBar (Common Widgets: AppBar)

#### 4.14.1 CustomAppBar

**파일 경로**: `lib/presentation/widgets/app_bar/custom_app_bar.dart`

**용도**: 일관된 스타일의 앱바 (모든 화면에서 사용)

**Props**:
- `title` (String, required): 앱바 제목
- `showBackButton` (bool, optional): 뒤로가기 버튼 표시 (기본값: true)
- `actions` (List<Widget>?, optional): 우측 액션 버튼 리스트
- `elevation` (double, optional): 앱바 그림자 (기본값: 0)
- `centerTitle` (bool, optional): 제목 중앙 정렬 (기본값: true)
- `backgroundColor` (Color?, optional): 배경색 (기본값: backgroundColor)

**코드 예시**:
```dart
// ✅ 기본 사용법
Scaffold(
  appBar: CustomAppBar(
    title: '홈',
  ),
  body: ...,
)

// ✅ 뒤로가기 버튼 없는 앱바
Scaffold(
  appBar: CustomAppBar(
    title: '메인',
    showBackButton: false,
  ),
)

// ✅ 액션 버튼 포함
Scaffold(
  appBar: CustomAppBar(
    title: '설정',
    actions: [
      IconButton(
        icon: Icon(Icons.save),
        onPressed: () => handleSave(),
        tooltip: '저장',
      ),
      IconButton(
        icon: Icon(Icons.more_vert),
        onPressed: () => showMenu(),
        tooltip: '메뉴',
      ),
    ],
  ),
)

// ✅ 커스텀 배경색 및 elevation
Scaffold(
  appBar: CustomAppBar(
    title: '프로필',
    backgroundColor: AppTheme.primaryColor,
    elevation: 2,
    centerTitle: false,
  ),
)
```

**사용 시나리오**:
- 모든 화면의 상단 앱바
- 설정 화면
- 프로필 화면
- 서브 페이지

**디자인 스펙**:
- 배경색: Background Color (#F1F5F9)
- 텍스트 색: Text Primary (#1A1A1A)
- Elevation: 0 (Material Design 3, 그림자 없음)
- 제목 폰트: 20px, Bold
- 중앙 정렬: true
- 높이: kToolbarHeight (56px)

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

**✅ UPDATE (2026-03-28)**: Phase 0.5에서 다크 모드 테마 완료

### 9.1 다크 모드 색상 팔레트

**Primary Colors**:
- Light: `#11BC78` (녹색/민트) → Dark: `#40D399` (밝은 민트, 가시성 향상)
- Light: `#40D399` (밝은 민트) → Dark: `#6BE0B0` (더 밝은 민트)

**Background Colors**:
- Light: `#F1F5F9` (연한 청회색) → Dark: `#121212` (거의 검정)
- Light: `#FFFFFF` (흰색 카드) → Dark: `#1E1E1E` (어두운 회색 카드)

**Text Colors**:
- Light: `#1A1A1A` (어두운 회색) → Dark: `#FFFFFF` (흰색)
- Light: `#666666` (중간 회색) → Dark: `#B0B0B0` (밝은 회색)

**Why These Colors?**
- Primary는 다크 배경에서 가시성을 위해 더 밝은 톤 사용 (#11BC78 → #40D399)
- Background는 순수 검정 (#000000)이 아닌 #121212 사용 (눈의 피로 감소, Material Design 권장)
- Text는 충분한 대비율 확보 (WCAG AA 기준)

---

### 9.2 테마 전환 방법

#### 방법 1: Theme.of(context) 사용

```dart
Widget build(BuildContext context) {
  final brightness = Theme.of(context).brightness;

  Color getButtonColor() {
    return brightness == Brightness.dark
      ? AppTheme.primaryLight  // 다크 모드에서는 밝은 톤
      : AppTheme.primaryColor; // 라이트 모드에서는 기본 톤
  }

  return ElevatedButton(
    style: ElevatedButton.styleFrom(
      backgroundColor: getButtonColor(),
    ),
    child: Text('버튼'),
  );
}
```

#### 방법 2: 조건부 색상 직접 사용

```dart
Container(
  color: brightness == Brightness.dark
    ? Color(0xFF1E1E1E)  // Dark: surfaceDark
    : Color(0xFFFFFFFF), // Light: surfaceColor
  child: Text(
    '텍스트',
    style: TextStyle(
      color: brightness == Brightness.dark
        ? Color(0xFFFFFFFF)  // Dark: textPrimaryDark
        : Color(0xFF1A1A1A), // Light: textPrimary
    ),
  ),
)
```

#### 방법 3: MaterialApp에서 테마 설정

```dart
MaterialApp(
  theme: AppTheme.lightTheme,        // 라이트 테마
  darkTheme: AppTheme.darkTheme,     // 다크 테마
  themeMode: ThemeMode.system,       // 시스템 설정 따름
  // themeMode: ThemeMode.light,     // 강제 라이트 모드
  // themeMode: ThemeMode.dark,      // 강제 다크 모드
)
```

---

### 9.3 다크 모드 디자인 원칙

#### 1. WCAG 대비율 준수

**최소 대비율**:
- 텍스트: 4.5:1 (AA 기준)
- UI 요소: 3:1 (AA 기준)

**예시**:
```dart
// ✅ 충분한 대비율
Text(
  '텍스트',
  style: TextStyle(
    color: brightness == Brightness.dark
      ? Colors.white     // 대비율: 높음
      : Colors.black,
  ),
)

// ❌ 낮은 대비율 (피하기)
Text(
  '텍스트',
  style: TextStyle(
    color: brightness == Brightness.dark
      ? Colors.grey.shade700  // 대비율: 낮음
      : Colors.grey.shade300,
  ),
)
```

#### 2. 순수 검정 피하기

**이유**: 순수 검정 (#000000)은 OLED 화면에서 번아웃 문제를 일으키고, 눈의 피로를 증가시킵니다.

**권장**: Material Design 기본값 #121212 사용

```dart
// ✅ 권장
scaffoldBackgroundColor: Color(0xFF121212)  // Material Design 다크

// ❌ 비권장
scaffoldBackgroundColor: Color(0xFF000000)  // 순수 검정
```

#### 3. 색상 강도 조정

다크 모드에서는 Primary 색상을 더 밝게 조정하여 가시성 확보:

```dart
// ✅ Light Mode
primaryColor: Color(0xFF11BC78)  // 원래 톤

// ✅ Dark Mode
primaryColor: Color(0xFF40D399)  // 더 밝은 톤 (가시성 향상)
```

#### 4. 그림자 제거 또는 감소

다크 배경에서는 그림자가 잘 보이지 않으므로 elevation을 줄이거나 제거:

```dart
Card(
  elevation: brightness == Brightness.dark
    ? 0  // 다크 모드: 그림자 없음
    : 2, // 라이트 모드: 부드러운 그림자
)
```

---

### 9.4 다크 모드 테스트

**lib/app/theme.dart**에 정의된 `darkTheme`을 사용합니다.

**테스트 방법**:
1. **시스템 설정 변경**: 디바이스의 다크 모드 On/Off
2. **강제 테마 설정**: MaterialApp의 `themeMode` 파라미터 변경
3. **에뮬레이터**: Settings → Display → Dark theme 토글

**테스트 체크리스트**:
- [ ] 모든 텍스트가 읽기 쉬운가?
- [ ] 버튼이 명확하게 구분되는가?
- [ ] 카드가 배경과 구분되는가?
- [ ] 입력 필드가 사용 가능해 보이는가?
- [ ] 아이콘이 명확하게 보이는가?

**예시 스크린샷 비교** (권장):
```
[라이트 모드]                    [다크 모드]
- 배경: #F1F5F9                  - 배경: #121212
- 카드: #FFFFFF                  - 카드: #1E1E1E
- 텍스트: #1A1A1A                - 텍스트: #FFFFFF
- Primary: #11BC78               - Primary: #40D399
```

---

### 9.5 다크 모드 FAQ

**Q: 왜 다크 모드에서 Primary 색상을 더 밝게 했나요?**
A: 어두운 배경에서는 원래 Primary 색상(#11BC78)이 너무 어두워 보이기 때문에, 더 밝은 톤(#40D399)을 사용하여 가시성을 확보했습니다.

**Q: 왜 배경을 #000000이 아닌 #121212를 사용하나요?**
A: OLED 화면에서 번아웃 문제를 방지하고, 눈의 피로를 줄이기 위해 Material Design 권장 색상인 #121212를 사용합니다.

**Q: 다크 모드를 강제로 켜거나 끌 수 있나요?**
A: 네! MaterialApp의 `themeMode`를 `ThemeMode.dark` 또는 `ThemeMode.light`로 설정하면 됩니다. 현재는 `ThemeMode.system`으로 시스템 설정을 따릅니다.

**Q: 사용자가 앱 내에서 테마를 변경할 수 있나요?**
A: 현재는 시스템 설정을 따르지만, 향후 Settings 화면에서 테마 선택 기능을 추가할 수 있습니다.

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

### 11.4 공통 위젯 치트시트

**버튼**:
```dart
// 주요 액션
PrimaryButton(
  text: '확인',
  onPressed: () {},
  fullWidth: true,
)

// 보조 액션
SecondaryButton(
  text: '취소',
  onPressed: () {},
)

// 텍스트 버튼
TextButtonCustom(
  text: '건너뛰기',
  onPressed: () {},
)
```

**카드**:
```dart
// 기본 카드 (Elevation 2)
BaseCard(
  child: Text('내용'),
)

// 강조 카드 (Elevation 4)
ElevatedCard(
  onTap: () {},
  child: Text('중요한 내용'),
)
```

**입력**:
```dart
// 한 줄 입력
TextFieldCustom(
  labelText: '이메일',
  hintText: 'example@email.com',
  controller: _controller,
)

// 여러 줄 입력 (답변 작성)
TextAreaCustom(
  labelText: '답변',
  hintText: '답변을 입력하세요',
  maxLines: 5,
)
```

**로딩**:
```dart
// 로딩 인디케이터
LoadingIndicator(size: 40)

// 전체 화면 로딩
FullScreenLoading(message: '로딩 중...')

// 스켈레톤 로더
SkeletonLoader(height: 100, width: double.infinity)

// 카드 스켈레톤
SkeletonCard()

// 리스트 스켈레톤
SkeletonList(itemCount: 5)
```

**다이얼로그**:
```dart
// 확인 다이얼로그
final result = await ConfirmDialog.show(
  context,
  title: '삭제하시겠어요?',
  message: '이 작업은 되돌릴 수 없습니다.',
);

// 에러 다이얼로그
await ErrorDialog.show(
  context,
  message: '오류가 발생했습니다',
)
```

**AppBar**:
```dart
// 커스텀 AppBar
Scaffold(
  appBar: CustomAppBar(
    title: '홈',
    showBackButton: true,
    actions: [
      IconButton(icon: Icon(Icons.settings), onPressed: () {}),
    ],
  ),
)
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
