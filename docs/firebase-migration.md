# Supabase → Firebase 마이그레이션 계획서

**버전**: 1.0
**작성일**: 2026-04-07
**최종 업데이트**: 2026-04-07
**상태**: In Progress - Phase 0 완료 ✅

---

## 📋 목차

1. [개요](#1-개요)
2. [마이그레이션 범위](#2-마이그레이션-범위)
3. [Firebase 구조 설계](#3-firebase-구조-설계)
4. [Phase별 작업 계획](#4-phase별-작업-계획)
5. [데이터 마이그레이션 전략](#5-데이터-마이그레이션-전략)
6. [테스트 계획](#6-테스트-계획)
7. [롤백 계획](#7-롤백-계획)

---

## 1. 개요

### 1.1 마이그레이션 이유

Supabase에서 Firebase로 전환하는 이유:
- ✅ Firebase의 더 나은 생태계 (Google Cloud 통합)
- ✅ 더 성숙한 모바일 SDK 및 문서
- ✅ 무료 티어의 관대한 한도
- ✅ Firestore의 강력한 쿼리 및 실시간 기능
- ✅ Cloud Functions의 안정성

### 1.2 주요 변경 사항

| 항목 | Supabase | Firebase |
|------|----------|----------|
| 인증 | Supabase Auth | Firebase Authentication |
| 데이터베이스 | PostgreSQL (Supabase Database) | Cloud Firestore |
| 보안 규칙 | Row Level Security (RLS) | Firestore Security Rules |
| 서버리스 함수 | Edge Functions (Deno) | Cloud Functions (Node.js) |
| 실시간 동기화 | Supabase Realtime | Firestore Snapshots |
| 파일 저장소 | Supabase Storage | Firebase Storage |
| 푸시 알림 | 별도 구현 | Firebase Cloud Messaging (FCM) |

---

## 2. 마이그레이션 범위

### 2.1 현재 Supabase 구성 요소

#### 인증 (Authentication)
- [x] Email/Password 로그인
- [x] Google OAuth 로그인
- [x] 사용자 메타데이터 (name, relationship_stage)
- [x] Auth State Changes 리스너

#### 데이터베이스 (Database)
**8개 테이블**:
1. `users` - 사용자 프로필 (Auth 확장)
2. `couples` - 커플 정보
3. `daily_verses` - 일일 말씀
4. `responses` - 사용자 답변
5. `daily_progress` - 진행 상황
6. `streaks` - 스트릭
7. `bible_cache` - 성경 캐시
8. `invite_links` - 초대 링크

#### Row Level Security (RLS)
- [x] users: 본인만 조회/수정
- [x] couples: 본인과 파트너만 조회
- [x] responses: 본인과 파트너만 조회
- [x] daily_progress: 본인 커플만 조회
- [x] streaks: 본인 커플만 조회
- [x] invite_links: 본인 것만 조회

#### Edge Functions
- [x] `generate-daily-verse`: 매일 자정 실행 (Cron Job)
  - Gemini API 호출
  - daily_verses 생성
  - daily_progress 초기화

#### DataSources
- [x] `SupabaseAuthDataSource`: 인증 처리
- [x] `SupabaseCoupleDataSource`: 커플 관리

---

## 3. Firebase 구조 설계

### 3.1 Firebase 프로젝트 구조

```
firebase-project/
├── firestore/                  # Firestore 데이터베이스
│   ├── users/                  # 컬렉션
│   ├── couples/
│   ├── dailyVerses/
│   ├── responses/
│   ├── dailyProgress/
│   ├── streaks/
│   ├── bibleCache/
│   └── inviteLinks/
│
├── functions/                  # Cloud Functions
│   ├── src/
│   │   ├── index.ts            # 진입점
│   │   ├── generateDailyVerse.ts
│   │   ├── onUserCreated.ts
│   │   └── onCoupleCreated.ts
│   ├── package.json
│   └── tsconfig.json
│
├── storage/                    # Firebase Storage
│   └── profile-images/
│
└── firestore.rules             # Security Rules
```

### 3.2 Firestore 컬렉션 설계

#### 1. users 컬렉션
```typescript
/users/{userId}
{
  name: string;
  email: string;
  profileImageUrl?: string;
  relationshipStage?: 'dating' | 'engaged' | 'married';
  coupleId?: string;              // couples 컬렉션 참조
  notificationTime: string;       // "09:00:00"
  notificationEnabled: boolean;
  bibleTranslation: string;       // "KRV"
  theme: string;                  // "light" | "dark"
  createdAt: Timestamp;
  updatedAt: Timestamp;
}
```

#### 2. couples 컬렉션
```typescript
/couples/{coupleId}
{
  user1Id: string;                // users 참조
  user2Id: string;                // users 참조
  relationshipStage: string;
  dailyVersePlan?: {
    currentBook: string;
    currentChapter: number;
    currentVerse: number;
    dailyAmountType: 'verse' | 'chapter';
    dailyAmount: number;
  };
  createdAt: Timestamp;
}
```

#### 3. dailyVerses 컬렉ション
```typescript
/dailyVerses/{verseId}
{
  date: string;                   // "YYYY-MM-DD"
  bibleBook: string;
  chapter: number;
  verseStart: number;
  verseEnd?: number;
  textKorean: string;
  textEnglish?: string;
  questionKorean: string;
  questionEnglish?: string;
  topic?: string;
  createdAt: Timestamp;
}
```

#### 4. responses 컬렉션
```typescript
/responses/{responseId}
{
  verseId: string;                // dailyVerses 참조
  userId: string;                 // users 참조
  coupleId: string;               // couples 참조
  content: string;
  isSubmitted: boolean;
  createdAt: Timestamp;
  updatedAt: Timestamp;
}
```

#### 5. dailyProgress 컬렉션
```typescript
/dailyProgress/{progressId}
{
  coupleId: string;
  verseId: string;
  date: string;                   // "YYYY-MM-DD"
  user1Submitted: boolean;
  user2Submitted: boolean;
  bothCompletedAt?: Timestamp;
}
```

#### 6. streaks 컬렉션
```typescript
/streaks/{coupleId}
{
  currentStreak: number;
  longestStreak: number;
  lastCompletedDate?: string;     // "YYYY-MM-DD"
  updatedAt: Timestamp;
}
```

#### 7. bibleCache 컬렉션
```typescript
/bibleCache/{cacheId}
{
  reference: string;              // "요한복음 3:16"
  translation: string;            // "KRV"
  text: string;
  cachedAt: Timestamp;
}
```

#### 8. inviteLinks 컬렉션
```typescript
/inviteLinks/{inviteId}
{
  inviterId: string;              // users 참조
  token: string;                  // 32자 랜덤 토큰
  isUsed: boolean;
  createdAt: Timestamp;
  expiresAt: Timestamp;           // createdAt + 7일
}
```

### 3.3 Firestore Security Rules

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {

    // Helper functions
    function isAuthenticated() {
      return request.auth != null;
    }

    function isOwner(userId) {
      return isAuthenticated() && request.auth.uid == userId;
    }

    function getCoupleId(userId) {
      return get(/databases/$(database)/documents/users/$(userId)).data.coupleId;
    }

    function isPartner(userId) {
      let coupleId = getCoupleId(request.auth.uid);
      let partnerCoupleId = getCoupleId(userId);
      return coupleId != null && coupleId == partnerCoupleId;
    }

    // users 컬렉션
    match /users/{userId} {
      allow read: if isOwner(userId) || isPartner(userId);
      allow create: if isOwner(userId);
      allow update: if isOwner(userId);
      allow delete: if false; // 삭제 금지
    }

    // couples 컬렉션
    match /couples/{coupleId} {
      allow read: if isAuthenticated() &&
        (resource.data.user1Id == request.auth.uid ||
         resource.data.user2Id == request.auth.uid);
      allow create: if isAuthenticated();
      allow update: if isAuthenticated() &&
        (resource.data.user1Id == request.auth.uid ||
         resource.data.user2Id == request.auth.uid);
      allow delete: if isAuthenticated() &&
        (resource.data.user1Id == request.auth.uid ||
         resource.data.user2Id == request.auth.uid);
    }

    // dailyVerses 컬렉션 (읽기 전용)
    match /dailyVerses/{verseId} {
      allow read: if isAuthenticated();
      allow write: if false; // Cloud Function에서만 쓰기
    }

    // responses 컬렉션
    match /responses/{responseId} {
      allow read: if isAuthenticated() &&
        (resource.data.userId == request.auth.uid ||
         isPartner(resource.data.userId));
      allow create: if isAuthenticated() &&
        request.resource.data.userId == request.auth.uid;
      allow update: if isAuthenticated() &&
        resource.data.userId == request.auth.uid;
      allow delete: if isAuthenticated() &&
        resource.data.userId == request.auth.uid;
    }

    // dailyProgress 컬렉션
    match /dailyProgress/{progressId} {
      allow read: if isAuthenticated() &&
        getCoupleId(request.auth.uid) == resource.data.coupleId;
      allow write: if isAuthenticated() &&
        getCoupleId(request.auth.uid) == request.resource.data.coupleId;
    }

    // streaks 컬렉션
    match /streaks/{coupleId} {
      allow read: if isAuthenticated() &&
        getCoupleId(request.auth.uid) == coupleId;
      allow write: if isAuthenticated() &&
        getCoupleId(request.auth.uid) == coupleId;
    }

    // bibleCache 컬렉션 (읽기 전용)
    match /bibleCache/{cacheId} {
      allow read: if isAuthenticated();
      allow write: if false; // Cloud Function에서만 쓰기
    }

    // inviteLinks 컬렉션
    match /inviteLinks/{inviteId} {
      allow read: if isAuthenticated() &&
        (resource.data.inviterId == request.auth.uid ||
         request.query.token == resource.data.token);
      allow create: if isAuthenticated() &&
        request.resource.data.inviterId == request.auth.uid;
      allow update: if isAuthenticated(); // 초대 수락 시 누구나
      allow delete: if false;
    }
  }
}
```

---

## 4. Phase별 작업 계획

### Phase 0: 사전 준비 (Day 1) ✅

#### Task 0.1: Firebase 프로젝트 생성 ✅
- [✅] Firebase Console에서 새 프로젝트 생성 (gen-lang-client-0675158330)
- [ ] Google Analytics 연동 (선택)
- [✅] Firebase CLI 설치
  ```bash
  npm install -g firebase-tools  # v15.13.0 설치 완료
  firebase login  # 완료
  # firebase init  # 필요시 나중에 실행
  ```

#### Task 0.2: Flutter 프로젝트에 Firebase 추가 ✅
- [✅] FlutterFire CLI 설치
  ```bash
  dart pub global activate flutterfire_cli  # v1.3.2 설치 완료
  ```
- [✅] Firebase 앱 등록
  ```bash
  flutterfire configure  # 완료 - firebase_options.dart 생성됨
  # 지원 플랫폼: Web, iOS, macOS, Windows
  # Android는 추후 추가 필요
  ```
- [✅] pubspec.yaml 업데이트
  ```yaml
  dependencies:
    # Firebase
    firebase_core: ^3.6.0
    firebase_auth: ^5.3.1
    cloud_firestore: ^5.4.4
    cloud_functions: ^5.1.3
    firebase_storage: ^12.3.2
    firebase_messaging: ^15.1.3

    # 기존 Supabase (병행 운영)
    supabase_flutter: ^2.5.0
  ```

#### Task 0.3: 환경 변수 설정 ✅
- [✅] .env 파일 업데이트
  ```env
  # Firebase (Phase 0 - 마이그레이션 진행 중)
  FIREBASE_PROJECT_ID=
  FIREBASE_WEB_API_KEY=
  FIREBASE_MESSAGING_SENDER_ID=
  FIREBASE_APP_ID=

  # Gemini API (그대로 유지)
  GEMINI_API_KEY=your-gemini-key

  # Supabase (병행 운영)
  SUPABASE_URL=your-supabase-url
  SUPABASE_ANON_KEY=your-supabase-anon-key
  ```

#### Task 0.4: main.dart 초기화 코드 추가 ✅
- [✅] Firebase 초기화 코드 준비
  ```dart
  import 'package:firebase_core/firebase_core.dart';
  import 'firebase_options.dart';

  if (AppConfig.useFirebase) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    logger.i('✅ Firebase 초기화 완료');
  }
  ```
- [✅] AppConfig.useFirebase = false (현재는 Supabase 사용)

**Phase 0 완료일**: 2026-04-07
**상태**: ✅ 완료 - Firebase 설정 완료, 초기화 코드 준비됨

---

### Phase 1: 인증 시스템 마이그레이션 (Day 2-3)

#### Task 1.1: Firebase Authentication 설정
- [ ] Firebase Console에서 인증 방법 활성화
  - Email/Password
  - Google OAuth
- [ ] Google OAuth 클라이언트 ID 설정
  - Web
  - Android (SHA-1 추가)
  - iOS

#### Task 1.2: FirebaseAuthDataSource 구현
- [ ] 파일 생성: `lib/data/datasources/firebase_auth_datasource.dart`
- [ ] 구현 내용:
  ```dart
  class FirebaseAuthDataSource {
    Future<UserModel> getCurrentUser();
    Future<UserModel> signInWithEmail({required String email, required String password});
    Future<UserModel> signInWithGoogle();
    Future<UserModel> signUpWithEmail({required String email, required String password});
    Future<void> signOut();
    Stream<UserModel?> authStateChanges();
    Future<UserModel> updateUserMetadata(Map<String, dynamic> metadata);
    Future<void> updateUserProfile(Map<String, dynamic> profileData);
  }
  ```

#### Task 1.3: AuthRepository 수정
- [ ] 파일 수정: `lib/data/repositories/auth_repository_impl.dart`
- [ ] Supabase/Firebase 병행 사용 (Feature Flag 패턴)
  ```dart
  class AuthRepositoryImpl implements AuthRepository {
    final FirebaseAuthDataSource _firebaseDataSource;
    final SupabaseAuthDataSource _supabaseDataSource;
    final bool _useFirebase = true; // Feature Flag

    @override
    Future<Either<Failure, User>> signIn(...) async {
      if (_useFirebase) {
        return _firebaseDataSource.signInWithEmail(...);
      } else {
        return _supabaseDataSource.signInWithEmail(...);
      }
    }
  }
  ```

#### Task 1.4: 테스트
- [ ] 이메일 로그인 테스트
- [ ] Google 로그인 테스트
- [ ] 로그아웃 테스트
- [ ] Auth State Changes 테스트

---

### Phase 2: 데이터베이스 마이그레이션 (Day 4-7)

#### Task 2.1: Firestore 컬렉션 생성
- [ ] Firebase Console에서 컬렉션 수동 생성
  - users
  - couples
  - dailyVerses
  - responses
  - dailyProgress
  - streaks
  - bibleCache
  - inviteLinks

#### Task 2.2: Firestore Security Rules 배포
- [ ] `firestore.rules` 파일 생성
- [ ] 위에서 정의한 Security Rules 복사
- [ ] 배포:
  ```bash
  firebase deploy --only firestore:rules
  ```

#### Task 2.3: FirebaseCoupleDataSource 구현
- [ ] 파일 생성: `lib/data/datasources/firebase_couple_datasource.dart`
- [ ] 구현 내용:
  ```dart
  class FirebaseCoupleDataSource {
    Future<InviteLinkModel> createInviteLink(String userId);
    Future<CoupleModel> acceptInvite({required String token, required String accepterId});
    Future<CoupleModel> getCouple(String userId);
    Future<void> disconnectCouple({required String coupleId, required String userId});
    Future<CoupleModel> updateDailyVersePlan({required String coupleId, required DailyVersePlanModel plan});
  }
  ```

#### Task 2.4: FirebaseVerseDataSource 구현
- [ ] 파일 생성: `lib/data/datasources/firebase_verse_datasource.dart`
- [ ] 구현 내용:
  ```dart
  class FirebaseVerseDataSource {
    Future<DailyVerseModel> getTodayVerse();
    Future<List<DailyVerseModel>> getVerseHistory(String coupleId, int limit);
    Future<void> submitResponse({required String verseId, required String userId, required String content});
    Stream<List<ResponseModel>> watchResponses(String verseId, String coupleId);
  }
  ```

#### Task 2.5: Repository 수정
- [ ] `CoupleRepositoryImpl` 수정 (Feature Flag 추가)
- [ ] `VerseRepositoryImpl` 생성 및 구현

#### Task 2.6: Provider 수정
- [ ] `CoupleProvider` 수정
- [ ] `VerseProvider` 수정
- [ ] `QuestionGenerationProvider` 수정

#### Task 2.7: 테스트
- [ ] 커플 생성/조회 테스트
- [ ] 초대 링크 테스트
- [ ] 말씀 조회 테스트
- [ ] 답변 작성 테스트

---

### Phase 3: Cloud Functions 마이그레이션 (Day 8-10)

#### Task 3.1: Cloud Functions 프로젝트 초기화
- [ ] Firebase Functions 초기화
  ```bash
  firebase init functions
  # TypeScript 선택
  ```

#### Task 3.2: generateDailyVerse 함수 구현
- [ ] 파일 생성: `functions/src/generateDailyVerse.ts`
- [ ] Supabase Edge Function 로직을 Node.js로 변환
- [ ] Gemini API 호출 로직 이식
- [ ] Firestore CRUD 작업으로 변경

**함수 구조**:
```typescript
// functions/src/generateDailyVerse.ts
import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
import { GoogleGenerativeAI } from '@google/generative-ai';

export const generateDailyVerse = functions
  .region('asia-northeast3') // 서울 리전
  .pubsub
  .schedule('0 15 * * *') // 매일 UTC 15:00 (KST 00:00)
  .timeZone('UTC')
  .onRun(async (context) => {
    const db = admin.firestore();
    const today = new Date().toISOString().split('T')[0];

    // 1. 이미 생성되었는지 확인
    const existingVerse = await db.collection('dailyVerses')
      .where('date', '==', today)
      .limit(1)
      .get();

    if (!existingVerse.empty) {
      console.log('Already generated for today');
      return null;
    }

    // 2. 플랜이 있는 커플 조회
    const couplesSnapshot = await db.collection('couples')
      .where('dailyVersePlan', '!=', null)
      .get();

    // 3. 각 커플별 말씀 생성
    for (const coupleDoc of couplesSnapshot.docs) {
      const couple = coupleDoc.data();
      const plan = couple.dailyVersePlan;

      // Bible 구절 로드
      const verseText = await loadVerse(plan);

      // Gemini API로 질문 생성
      const question = await generateQuestion(verseText, couple.relationshipStage);

      // dailyVerses 저장
      const verseRef = await db.collection('dailyVerses').add({
        date: today,
        bibleBook: plan.currentBook,
        chapter: plan.currentChapter,
        verseStart: plan.currentVerse,
        textKorean: verseText,
        questionKorean: question,
        createdAt: admin.firestore.FieldValue.serverTimestamp(),
      });

      // dailyProgress 초기화
      await db.collection('dailyProgress').add({
        coupleId: coupleDoc.id,
        verseId: verseRef.id,
        date: today,
        user1Submitted: false,
        user2Submitted: false,
      });

      // 플랜 업데이트 (다음 날 위치)
      const nextPosition = calculateNextPosition(plan);
      await coupleDoc.ref.update({
        'dailyVersePlan': nextPosition,
      });
    }

    return null;
  });
```

#### Task 3.3: 배포 및 테스트
- [ ] 함수 배포
  ```bash
  firebase deploy --only functions
  ```
- [ ] Cloud Scheduler 확인 (Firebase Console)
- [ ] 수동 실행 테스트
  ```bash
  firebase functions:shell
  > generateDailyVerse()
  ```

---

### Phase 4: 실시간 동기화 마이그레이션 (Day 11-12)

#### Task 4.1: Firestore Snapshots로 변경
- [ ] Supabase Realtime → Firestore `snapshots()` 변경
- [ ] Provider에서 `Stream` 사용

**예시**:
```dart
// Before (Supabase)
supabase
  .from('responses')
  .stream(primaryKey: ['response_id'])
  .eq('verse_id', verseId)
  .listen((data) { ... });

// After (Firestore)
FirebaseFirestore.instance
  .collection('responses')
  .where('verseId', isEqualTo: verseId)
  .snapshots()
  .listen((snapshot) {
    final responses = snapshot.docs.map((doc) =>
      ResponseModel.fromFirestore(doc)
    ).toList();
  });
```

#### Task 4.2: 테스트
- [ ] 답변 작성 시 실시간 업데이트 확인
- [ ] 파트너 답변 실시간 수신 확인

---

### Phase 5: 데이터 마이그레이션 (Day 13-14)

#### Task 5.1: 기존 사용자 데이터 추출
- [ ] Supabase에서 데이터 Export (SQL 또는 CSV)
  ```sql
  -- users
  COPY (SELECT * FROM users) TO '/tmp/users.csv' CSV HEADER;

  -- couples
  COPY (SELECT * FROM couples) TO '/tmp/couples.csv' CSV HEADER;

  -- daily_verses
  COPY (SELECT * FROM daily_verses) TO '/tmp/daily_verses.csv' CSV HEADER;

  -- responses
  COPY (SELECT * FROM responses) TO '/tmp/responses.csv' CSV HEADER;

  -- daily_progress
  COPY (SELECT * FROM daily_progress) TO '/tmp/daily_progress.csv' CSV HEADER;

  -- streaks
  COPY (SELECT * FROM streaks) TO '/tmp/streaks.csv' CSV HEADER;
  ```

#### Task 5.2: 데이터 변환 스크립트 작성
- [ ] Node.js 스크립트 작성: `scripts/migrate-data.js`
- [ ] CSV → Firestore 변환
- [ ] UUID → Firestore Document ID 매핑

**예시**:
```javascript
// scripts/migrate-data.js
const admin = require('firebase-admin');
const csv = require('csv-parser');
const fs = require('fs');

admin.initializeApp();
const db = admin.firestore();

async function migrateUsers() {
  const users = [];

  fs.createReadStream('data/users.csv')
    .pipe(csv())
    .on('data', (row) => {
      users.push({
        id: row.user_id,
        name: row.name,
        email: row.email,
        coupleId: row.couple_id,
        relationshipStage: row.relationship_stage,
        createdAt: admin.firestore.Timestamp.fromDate(new Date(row.created_at)),
      });
    })
    .on('end', async () => {
      const batch = db.batch();
      users.forEach((user) => {
        const ref = db.collection('users').doc(user.id);
        batch.set(ref, user);
      });
      await batch.commit();
      console.log('Users migrated:', users.length);
    });
}

migrateUsers();
```

#### Task 5.3: 데이터 검증
- [ ] 마이그레이션된 데이터 개수 확인
- [ ] 관계 무결성 확인 (coupleId, userId 참조)
- [ ] 샘플 데이터 조회 테스트

---

### Phase 6: 최종 전환 (Day 15)

#### Task 6.1: Feature Flag 전환
- [ ] `lib/core/constants/app_config.dart` 생성
  ```dart
  class AppConfig {
    static const bool useFirebase = true; // true로 변경!
  }
  ```
- [ ] 모든 Repository에서 Feature Flag 확인

#### Task 6.2: Supabase 제거 (신중하게!)
- [ ] pubspec.yaml에서 `supabase_flutter` 제거
- [ ] Supabase 관련 파일 삭제
  - `lib/core/constants/supabase_client.dart`
  - `lib/data/datasources/supabase_*`
- [ ] Import 정리

#### Task 6.3: 최종 테스트
- [ ] 전체 플로우 테스트 (회원가입 → 커플 연결 → 말씀 읽기 → 답변 작성)
- [ ] 실시간 동기화 테스트
- [ ] Cloud Function 실행 테스트

---

## 5. 데이터 마이그레이션 전략

### 5.1 Zero-Downtime 전략

**병행 운영 기간 (2주)**:
1. Week 1: Firebase 구축 + Supabase 병행
2. Week 2: 데이터 마이그레이션 + 검증
3. Day 15: 완전 전환

**Feature Flag 패턴**:
```dart
final authRepository = AppConfig.useFirebase
  ? FirebaseAuthRepository()
  : SupabaseAuthRepository();
```

### 5.2 데이터 일관성 보장

**전략**:
1. **Read-Only Mode**: 마이그레이션 시작 전 Supabase를 읽기 전용으로 전환
2. **Batch Migration**: 대량 데이터는 배치로 마이그레이션
3. **Incremental Sync**: 실시간 데이터는 점진적으로 동기화

---

## 6. 테스트 계획

### 6.1 단위 테스트
- [ ] FirebaseAuthDataSource 테스트
- [ ] FirebaseCoupleDataSource 테스트
- [ ] FirebaseVerseDataSource 테스트

### 6.2 통합 테스트
- [ ] 인증 플로우 E2E 테스트
- [ ] 커플 생성 플로우 테스트
- [ ] 말씀 조회 및 답변 작성 테스트

### 6.3 성능 테스트
- [ ] Firestore 쿼리 성능 측정
- [ ] Cloud Functions 실행 시간 측정
- [ ] 실시간 동기화 지연 시간 측정

---

## 7. 롤백 계획

### 7.1 롤백 조건
- Firebase 서비스 장애
- 데이터 손실 발생
- 성능 저하 (3초 이상 응답 시간)

### 7.2 롤백 절차
1. Feature Flag를 `false`로 전환 (Supabase로 복귀)
2. 앱 재배포 (Hot Reload 불가)
3. Supabase 데이터 검증
4. 사용자 공지

### 7.3 Supabase 보관 기간
- **최소 1개월**: Firebase 안정화 확인 후 제거
- 매일 백업 유지

---

## 8. 체크리스트

### 사전 준비
- [ ] Firebase 프로젝트 생성
- [ ] Firebase CLI 설치
- [ ] FlutterFire 설정
- [ ] 환경 변수 설정

### Phase 1: 인증
- [ ] Firebase Authentication 활성화
- [ ] FirebaseAuthDataSource 구현
- [ ] AuthRepository 수정
- [ ] 테스트 완료

### Phase 2: 데이터베이스
- [ ] Firestore 컬렉션 생성
- [ ] Security Rules 배포
- [ ] DataSource 구현
- [ ] Repository 수정
- [ ] 테스트 완료

### Phase 3: Cloud Functions
- [ ] generateDailyVerse 구현
- [ ] 배포 및 테스트

### Phase 4: 실시간 동기화
- [ ] Firestore Snapshots 적용
- [ ] 테스트 완료

### Phase 5: 데이터 마이그레이션
- [ ] 데이터 추출
- [ ] 변환 스크립트 작성
- [ ] 마이그레이션 실행
- [ ] 검증 완료

### Phase 6: 최종 전환
- [ ] Feature Flag 전환
- [ ] Supabase 제거
- [ ] 최종 테스트
- [ ] 프로덕션 배포

---

## 9. 참고 자료

### Firebase 문서
- [FlutterFire 공식 문서](https://firebase.flutter.dev/)
- [Firestore 보안 규칙](https://firebase.google.com/docs/firestore/security/get-started)
- [Cloud Functions 가이드](https://firebase.google.com/docs/functions)

### 마이그레이션 도구
- [Firestore Data Import/Export](https://firebase.google.com/docs/firestore/manage-data/export-import)
- [Firebase Admin SDK](https://firebase.google.com/docs/admin/setup)

---

**작성자**: Development Team
**승인자**: Product Team
**다음 단계**: Phase 0 시작 → Firebase 프로젝트 생성

**Let's Migrate to Firebase! 🚀🔥**
