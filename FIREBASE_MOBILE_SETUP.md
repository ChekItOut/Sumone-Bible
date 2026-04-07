# Firebase Mobile (Android/iOS) Google Sign-In 설정 가이드

> **Web에서는 이미 작동 중!** ✅
> 이 가이드는 Android/iOS 앱 출시를 위한 추가 설정입니다.

**작성일**: 2026-04-07
**Firebase 프로젝트**: gen-lang-client-0675158330

---

## 📋 목차

1. [Android 설정](#android-설정)
2. [iOS 설정](#ios-설정)
3. [코드 확인](#코드-확인)
4. [테스트](#테스트)
5. [문제 해결](#문제-해결)

---

## 🤖 Android 설정

### Step 1: Firebase Console에서 Android 앱 추가

1. [Firebase Console](https://console.firebase.google.com/project/gen-lang-client-0675158330) 접속
2. **프로젝트 설정** (⚙️) > **일반** 탭
3. 스크롤 내려서 **내 앱** 섹션 찾기
4. **Android 앱 추가** 버튼 클릭

### Step 2: 앱 정보 입력

**Android 패키지 이름:**
```
com.example.bibleSumone
```

**앱 닉네임 (선택사항):**
```
Bible SumOne Android
```

**디버그 서명 인증서 SHA-1** (필수!):

#### SHA-1 확인 방법

**방법 A: 명령어 (권장)**
```bash
cd android
./gradlew signingReport
```

출력에서 다음을 찾기:
```
Variant: debug
Config: debug
Store: C:\Users\[username]\.android\debug.keystore
Alias: AndroidDebugKey
MD5: XX:XX:XX:...
SHA1: AA:BB:CC:DD:EE:FF:00:11:22:33:44:55:66:77:88:99:AA:BB:CC:DD
SHA-256: ...
```

**SHA1** 값을 복사하여 Firebase에 입력!

**방법 B: Android Studio**
1. Android Studio 열기
2. 우측 **Gradle** 탭 클릭
3. **bible_sumone** > **android** > **Tasks** > **android** > **signingReport** 더블클릭
4. 하단 콘솔에서 SHA1 확인

### Step 3: google-services.json 다운로드

1. Firebase Console에서 **"google-services.json 다운로드"** 클릭
2. 다운로드한 파일을 다음 경로에 복사:

```
프로젝트 루트/
└── android/
    └── app/
        └── google-services.json  ← 여기!
```

### Step 4: Google Cloud Console 설정

1. [Google Cloud Console](https://console.cloud.google.com/) 접속
2. Firebase와 연결된 프로젝트 선택
3. **APIs & Services** > **Credentials**
4. **OAuth 2.0 Client IDs** 섹션 확인

**Android용 클라이언트 ID**가 자동 생성되었는지 확인:
- 이름: `Web client (auto created by Google Service for Firebase)`
- 타입: Android

없다면 생성:
1. **"+ CREATE CREDENTIALS"** 클릭
2. **OAuth client ID** 선택
3. **Application type**: Android
4. **Name**: Bible SumOne Android
5. **Package name**: `com.example.bibleSumone`
6. **SHA-1 certificate fingerprint**: (위에서 확인한 SHA-1 입력)
7. **CREATE** 클릭

### Step 5: .env 파일 업데이트

클라이언트 ID를 `.env` 파일에 추가:

```env
# Google OAuth
GOOGLE_CLIENT_ID_WEB=512299356257-scnqebahmj17m5r01607mmr509fldaf2.apps.googleusercontent.com
GOOGLE_CLIENT_ID_ANDROID=your-android-client-id.apps.googleusercontent.com
GOOGLE_CLIENT_ID_IOS=
```

### Step 6: 빌드 설정 확인

**`android/build.gradle`** (프로젝트 레벨):
```gradle
buildscript {
    dependencies {
        // Google Services 플러그인 (Firebase 사용)
        classpath 'com.google.gms:google-services:4.3.15'
    }
}
```

**`android/app/build.gradle`** (앱 레벨) 하단:
```gradle
// 파일 맨 마지막에 추가 (이미 있을 수 있음)
apply plugin: 'com.google.gms.google-services'
```

### Step 7: Android 테스트

```bash
flutter clean
flutter pub get
flutter run -d android
```

**Google 로그인 버튼 클릭 → Google 계정 선택 → 로그인 성공!** ✅

---

## 🍎 iOS 설정

### Step 1: Firebase Console에서 iOS 앱 추가

1. [Firebase Console](https://console.firebase.google.com/project/gen-lang-client-0675158330) 접속
2. **프로젝트 설정** (⚙️) > **일반** 탭
3. 스크롤 내려서 **내 앱** 섹션 찾기
4. **iOS 앱 추가** 버튼 클릭

### Step 2: 앱 정보 입력

**iOS 번들 ID:**
```
com.example.bibleSumone
```

**앱 닉네임 (선택사항):**
```
Bible SumOne iOS
```

### Step 3: GoogleService-Info.plist 다운로드

1. Firebase Console에서 **"GoogleService-Info.plist 다운로드"** 클릭
2. Xcode를 통해 프로젝트에 추가:

#### Xcode에서 추가하는 방법

```bash
# Xcode 워크스페이스 열기
open ios/Runner.xcworkspace
```

1. Xcode 좌측 **Project Navigator**에서 **Runner** 폴더 선택
2. 다운로드한 `GoogleService-Info.plist` 파일을 **Runner** 폴더로 드래그 앤 드롭
3. 대화상자에서:
   - ✅ **"Copy items if needed"** 체크
   - ✅ **"Add to targets: Runner"** 체크
   - **Finish** 클릭

**최종 경로:**
```
프로젝트 루트/
└── ios/
    └── Runner/
        └── GoogleService-Info.plist  ← 여기!
```

### Step 4: Google Cloud Console 설정

1. [Google Cloud Console](https://console.cloud.google.com/) 접속
2. Firebase와 연결된 프로젝트 선택
3. **APIs & Services** > **Credentials**
4. **OAuth 2.0 Client IDs** 섹션 확인

**iOS용 클라이언트 ID**가 자동 생성되었는지 확인:
- 이름: `com.example.bibleSumone`
- 타입: iOS

없다면 생성:
1. **"+ CREATE CREDENTIALS"** 클릭
2. **OAuth client ID** 선택
3. **Application type**: iOS
4. **Name**: Bible SumOne iOS
5. **Bundle ID**: `com.example.bibleSumone`
6. **CREATE** 클릭

클라이언트 ID 복사 (예: `123456789-abcdefg.apps.googleusercontent.com`)

### Step 5: .env 파일 업데이트

```env
# Google OAuth
GOOGLE_CLIENT_ID_WEB=512299356257-scnqebahmj17m5r01607mmr509fldaf2.apps.googleusercontent.com
GOOGLE_CLIENT_ID_ANDROID=your-android-client-id.apps.googleusercontent.com
GOOGLE_CLIENT_ID_IOS=your-ios-client-id.apps.googleusercontent.com
```

### Step 6: Info.plist 설정

`ios/Runner/Info.plist` 파일에 URL Scheme 추가:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <!-- 기존 설정들... -->

    <!-- Google Sign-In URL Scheme 추가 -->
    <key>CFBundleURLTypes</key>
    <array>
        <dict>
            <key>CFBundleTypeRole</key>
            <string>Editor</string>
            <key>CFBundleURLSchemes</key>
            <array>
                <!-- iOS 클라이언트 ID의 역순 -->
                <string>com.googleusercontent.apps.YOUR-IOS-CLIENT-ID-NUMBER</string>
            </array>
        </dict>
    </array>

    <!-- 기존 설정들... -->
</dict>
</plist>
```

**`YOUR-IOS-CLIENT-ID-NUMBER` 부분 교체:**

예시:
- 클라이언트 ID: `123456789-abcdefg.apps.googleusercontent.com`
- URL Scheme: `com.googleusercontent.apps.123456789-abcdefg`

### Step 7: iOS 테스트

```bash
flutter clean
flutter pub get
flutter run -d ios
```

**Google 로그인 버튼 클릭 → Google 계정 선택 → 로그인 성공!** ✅

---

## 🔍 코드 확인

현재 코드는 **이미 플랫폼별로 자동 분기 처리**되어 있습니다! 추가 코드 수정 불필요!

### FirebaseAuthDataSource (lib/data/datasources/firebase_auth_datasource.dart)

```dart
Future<UserModel> signInWithGoogle() async {
  if (kIsWeb) {
    // Web: Firebase Auth의 signInWithPopup 사용
    return await _signInWithGoogleWeb();
  } else {
    // Android/iOS: google_sign_in 패키지 사용
    return await _signInWithGoogleNative();
  }
}
```

✅ **Web**: `signInWithPopup()` (현재 작동 중!)
✅ **Android**: `google_sign_in` 패키지 (설정 파일만 추가하면 작동)
✅ **iOS**: `google_sign_in` 패키지 (설정 파일만 추가하면 작동)

---

## 🧪 테스트

### Android 테스트

```bash
# 에뮬레이터 실행 (Android Studio)
# 또는 실제 기기 연결

flutter clean
flutter pub get
flutter run -d android
```

### iOS 테스트

```bash
# 시뮬레이터 실행 (Xcode)
# 또는 실제 기기 연결

flutter clean
flutter pub get
flutter run -d ios
```

### 테스트 시나리오

1. Firebase 인증 테스트 화면으로 이동
2. **"Google 로그인"** 버튼 클릭
3. Google 계정 선택 화면 표시
4. 계정 선택
5. 권한 동의 (첫 로그인 시)
6. **"✅ Google 로그인 성공!"** 스낵바 표시
7. 사용자 정보 화면에 이메일, 이름 표시

---

## 🐛 문제 해결

### Android

#### 문제: "SHA-1 certificate fingerprint is required"

**원인**: SHA-1 인증서를 Firebase에 등록하지 않음

**해결**:
1. `cd android && ./gradlew signingReport`로 SHA-1 확인
2. Firebase Console > 프로젝트 설정 > Android 앱 > SHA 인증서 지문 추가

#### 문제: "google-services.json is missing"

**원인**: `google-services.json` 파일이 올바른 위치에 없음

**해결**:
- 파일 경로 확인: `android/app/google-services.json`
- Firebase Console에서 다시 다운로드

#### 문제: "SIGN_IN_FAILED"

**원인**: Google Play Services가 없거나 오래됨

**해결**:
- 에뮬레이터: **Google Play** 포함된 이미지 사용
- 실제 기기: Google Play 스토어에서 업데이트

### iOS

#### 문제: "GoogleService-Info.plist not found"

**원인**: `.plist` 파일이 올바른 위치에 없거나 타겟에 추가되지 않음

**해결**:
1. Xcode에서 `ios/Runner.xcworkspace` 열기
2. Runner 폴더에 파일이 있는지 확인
3. 파일 선택 > 우측 **Target Membership** > **Runner** 체크

#### 문제: "No application was found for..."

**원인**: URL Scheme이 올바르지 않음

**해결**:
- `Info.plist`의 URL Scheme 확인
- iOS 클라이언트 ID와 일치하는지 확인

#### 문제: "SIGN_IN_CANCELLED"

**원인**: 사용자가 로그인 취소

**해결**:
- 정상 동작 (에러 아님)
- 다시 로그인 시도

---

## 📚 참고 자료

- [Firebase Authentication - Flutter](https://firebase.google.com/docs/auth/flutter/start)
- [Google Sign-In for Flutter](https://pub.dev/packages/google_sign_in)
- [Firebase Console](https://console.firebase.google.com/)
- [Google Cloud Console](https://console.cloud.google.com/)

---

## ✅ 체크리스트

### Android
- [ ] Firebase Console에 Android 앱 추가
- [ ] SHA-1 인증서 등록
- [ ] `google-services.json` 다운로드 및 추가
- [ ] Google Cloud Console에서 Android OAuth 클라이언트 ID 확인
- [ ] `.env` 파일에 `GOOGLE_CLIENT_ID_ANDROID` 추가
- [ ] `android/build.gradle`에 Google Services 플러그인 확인
- [ ] Android 기기/에뮬레이터에서 테스트

### iOS
- [ ] Firebase Console에 iOS 앱 추가
- [ ] `GoogleService-Info.plist` 다운로드 및 Xcode에 추가
- [ ] Google Cloud Console에서 iOS OAuth 클라이언트 ID 확인
- [ ] `.env` 파일에 `GOOGLE_CLIENT_ID_IOS` 추가
- [ ] `Info.plist`에 URL Scheme 추가
- [ ] iOS 시뮬레이터/기기에서 테스트

---

**작성자**: Development Team
**마지막 업데이트**: 2026-04-07
