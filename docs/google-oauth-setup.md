# Google OAuth 설정 가이드

Bible SumOne 앱에서 Google 로그인을 사용하기 위한 설정 가이드입니다.

## 📋 목차
1. [Google Cloud Console 설정](#1-google-cloud-console-설정)
2. [Android 설정](#2-android-설정)
3. [iOS 설정](#3-ios-설정)
4. [환경 변수 설정](#4-환경-변수-설정)
5. [테스트](#5-테스트)
6. [문제 해결](#6-문제-해결)

---

## 1. Google Cloud Console 설정

### 1.1 프로젝트 생성

1. [Google Cloud Console](https://console.cloud.google.com/) 접속
2. 새 프로젝트 생성 또는 기존 프로젝트 선택
3. 프로젝트 이름: `Bible SumOne`

### 1.2 OAuth 동의 화면 설정

1. **탐색 메뉴** > **API 및 서비스** > **OAuth 동의 화면**
2. **사용자 유형**: 외부 선택
3. **앱 정보**:
   - 앱 이름: `Bible SumOne`
   - 사용자 지원 이메일: (개발자 이메일)
   - 앱 로고: (선택 사항)
4. **범위**:
   - `email`
   - `profile`
   - `openid`
5. **테스트 사용자**: 개발/테스트용 이메일 추가

### 1.3 OAuth 2.0 클라이언트 ID 생성

1. **API 및 서비스** > **사용자 인증 정보**
2. **+ 사용자 인증 정보 만들기** > **OAuth 2.0 클라이언트 ID**

---

## 2. Android 설정

### 2.1 SHA-1 인증서 지문 가져오기

개발용 (Debug):
```bash
# Windows (Git Bash)
keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android

# macOS/Linux
keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
```

출력 예시:
```
Certificate fingerprints:
SHA1: 1A:2B:3C:4D:5E:6F:7A:8B:9C:0D:1E:2F:3A:4B:5C:6D:7E:8F:9A:0B
SHA256: ...
```

**SHA-1 값을 복사하세요!**

배포용 (Release):
```bash
keytool -list -v -keystore /path/to/your/release.keystore -alias your-key-alias
```

### 2.2 OAuth 클라이언트 ID 생성 (Android)

1. **애플리케이션 유형**: Android
2. **이름**: `Bible SumOne (Android)`
3. **패키지 이름**: `com.example.bible_sumone` (실제 앱 패키지명)
4. **SHA-1 인증서 지문**: 위에서 복사한 SHA-1 값 붙여넣기
5. **만들기** 클릭

### 2.3 Android 앱 설정

`android/app/build.gradle`에 다음 추가:

```gradle
android {
    defaultConfig {
        // ...
        manifestPlaceholders = [
            'appAuthRedirectScheme': 'com.example.bible_sumone'
        ]
    }
}
```

### 2.4 Android Client ID 복사

생성된 클라이언트 ID를 `.env` 파일에 추가:
```
GOOGLE_CLIENT_ID_ANDROID=YOUR_ANDROID_CLIENT_ID.apps.googleusercontent.com
```

---

## 3. iOS 설정

### 3.1 OAuth 클라이언트 ID 생성 (iOS)

1. **애플리케이션 유형**: iOS
2. **이름**: `Bible SumOne (iOS)`
3. **번들 ID**: `com.example.bibleSumone` (Xcode 프로젝트의 Bundle Identifier)
4. **만들기** 클릭

### 3.2 iOS 앱 설정

#### Info.plist 수정

`ios/Runner/Info.plist`에 다음 추가:

```xml
<!-- Google Sign In URL Scheme -->
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleTypeRole</key>
        <string>Editor</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <!-- Reversed Client ID from GoogleService-Info.plist -->
            <string>com.googleusercontent.apps.YOUR_REVERSED_CLIENT_ID</string>
        </array>
    </dict>
</array>
```

**YOUR_REVERSED_CLIENT_ID**는 iOS Client ID를 역순으로:
```
Client ID: 123456789012-abcdefghijklmnop.apps.googleusercontent.com
Reversed: com.googleusercontent.apps.123456789012-abcdefghijklmnop
```

### 3.3 iOS Client ID 복사

생성된 클라이언트 ID를 `.env` 파일에 추가:
```
GOOGLE_CLIENT_ID_IOS=YOUR_IOS_CLIENT_ID.apps.googleusercontent.com
```

---

## 4. 환경 변수 설정

`.env` 파일 예시:

```env
# Supabase
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_ANON_KEY=your-anon-key

# Google OAuth
GOOGLE_CLIENT_ID_ANDROID=123456789012-android_client_id.apps.googleusercontent.com
GOOGLE_CLIENT_ID_IOS=123456789012-ios_client_id.apps.googleusercontent.com

# Gemini API (추후)
GEMINI_API_KEY=your-gemini-api-key
```

**중요**: `.env` 파일은 `.gitignore`에 포함되어 있어야 합니다!

---

## 5. 테스트

### 5.1 Android 테스트

```bash
flutter run -d android
```

1. 로그인 화면에서 "Google로 로그인" 버튼 클릭
2. Google 계정 선택 화면 확인
3. 계정 선택 후 권한 동의
4. 로그인 성공 확인

### 5.2 iOS 테스트

```bash
flutter run -d ios
```

(동일한 절차)

### 5.3 디버그 로그 확인

로그에 다음과 같은 메시지가 있는지 확인:

```
✅ Google Sign In Success: user@example.com
✅ Supabase Auth Success: user_id
```

---

## 6. 문제 해결

### 6.1 "Sign in failed" 에러

**원인**: SHA-1 지문이 일치하지 않음

**해결**:
1. 현재 SHA-1 재확인:
   ```bash
   keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey
   ```
2. Google Cloud Console에서 SHA-1 업데이트
3. 앱 재빌드: `flutter clean && flutter run`

### 6.2 "PlatformException(sign_in_failed)" 에러

**원인**: Client ID 불일치

**해결**:
1. `.env` 파일의 `GOOGLE_CLIENT_ID_ANDROID` 확인
2. Google Cloud Console의 Android Client ID와 일치하는지 확인
3. 앱 재시작

### 6.3 iOS에서 "Invalid client" 에러

**원인**: Bundle ID 또는 Reversed Client ID 오류

**해결**:
1. Xcode에서 Bundle Identifier 확인
2. `Info.plist`의 Reversed Client ID 확인
3. Google Cloud Console의 iOS Client ID 재확인

### 6.4 "Network error" 에러

**원인**: 인터넷 연결 문제 또는 Google API 비활성화

**해결**:
1. 인터넷 연결 확인
2. Google Cloud Console에서 **Google Sign-In API** 활성화 확인
3. 방화벽/VPN 설정 확인

---

## 7. 추가 참고 자료

- [Google Sign-In for Flutter](https://pub.dev/packages/google_sign_in)
- [Google OAuth 2.0 문서](https://developers.google.com/identity/protocols/oauth2)
- [Supabase Auth with Google](https://supabase.com/docs/guides/auth/social-login/auth-google)

---

## 8. 체크리스트

설정 완료 후 확인:

- [ ] Google Cloud Console 프로젝트 생성
- [ ] OAuth 동의 화면 설정
- [ ] Android OAuth Client ID 생성
- [ ] iOS OAuth Client ID 생성
- [ ] SHA-1 지문 등록 (Android)
- [ ] Reversed Client ID 설정 (iOS)
- [ ] `.env` 파일에 Client ID 추가
- [ ] Android 테스트 성공
- [ ] iOS 테스트 성공
- [ ] Supabase와 연동 확인

---

**작성일**: 2026-03-25
**작성자**: Backend Integration Agent
