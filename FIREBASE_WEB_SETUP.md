# Firebase Web Google Sign-In 설정 가이드

## 1. Firebase Console 설정

### 1.1 Authentication 활성화
1. [Firebase Console](https://console.firebase.google.com/) 접속
2. 프로젝트 선택
3. 좌측 메뉴 **Authentication** 클릭
4. **Sign-in method** 탭 클릭
5. **Google** 활성화 확인

### 1.2 승인된 도메인 확인
1. **Authentication** > **Settings** 탭
2. **승인된 도메인** 섹션에서 다음 확인:
   - `localhost` (개발용)
   - 배포할 도메인 (예: `your-app.web.app`)

## 2. Google Cloud Console 설정

### 2.1 OAuth 동의 화면
1. [Google Cloud Console](https://console.cloud.google.com/) 접속
2. Firebase와 연결된 프로젝트 선택
3. **APIs & Services** > **OAuth consent screen**
4. **User Type**: External 선택 (또는 Internal)
5. 앱 정보 입력:
   - 앱 이름: **Bible SumOne**
   - 사용자 지원 이메일
   - 개발자 연락처 정보
6. **Save and Continue**

### 2.2 OAuth 클라이언트 ID 확인
1. **APIs & Services** > **Credentials**
2. **OAuth 2.0 Client IDs** 섹션에서 **Web client (auto created by Google Service)** 찾기
3. 클라이언트 ID 클릭하여 편집
4. **승인된 JavaScript 출처** 확인:
   ```
   http://localhost:5000
   http://localhost:8080
   http://localhost:3000
   https://your-project-id.web.app
   https://your-project-id.firebaseapp.com
   ```
5. **승인된 리디렉션 URI** 확인:
   ```
   http://localhost:5000
   http://localhost:8080
   http://localhost:3000
   https://your-project-id.web.app
   https://your-project-id.firebaseapp.com
   https://your-project-id.web.app/__/auth/handler
   https://your-project-id.firebaseapp.com/__/auth/handler
   ```
6. **Save**

### 2.3 클라이언트 ID 복사
- **클라이언트 ID** 복사 (예: `512299356257-xxx.apps.googleusercontent.com`)
- `.env` 파일의 `GOOGLE_CLIENT_ID_WEB`와 일치하는지 확인
- `web/index.html`의 `meta` 태그와도 일치하는지 확인

## 3. 로컬 테스트

### 3.1 Flutter Web 실행
```bash
# Chrome에서 실행
flutter run -d chrome

# 특정 포트로 실행 (예: 8080)
flutter run -d chrome --web-port 8080
```

### 3.2 테스트 시나리오
1. 앱 실행
2. Firebase 인증 테스트 화면으로 이동
3. **Google 로그인** 버튼 클릭
4. Google 계정 선택
5. 권한 동의
6. 로그인 성공 확인

### 3.3 에러 발생 시 확인사항
- **팝업 차단**: 브라우저가 팝업을 차단했는지 확인
- **승인된 출처**: 현재 URL(예: `http://localhost:포트`)이 Google Cloud Console에 등록되어 있는지 확인
- **클라이언트 ID**: `.env`, `web/index.html`, Google Cloud Console의 클라이언트 ID가 모두 동일한지 확인
- **개발자 도구**: Chrome DevTools Console에서 에러 로그 확인

## 4. 디버깅

### 4.1 Chrome DevTools 열기
- Windows: `Ctrl + Shift + I`
- Mac: `Cmd + Option + I`

### 4.2 확인할 로그
```javascript
// 정상 로그
[GSI_LOGGER-OAUTH2_CLIENT]: Popup timer stopped.
[GSI_LOGGER-TOKEN_CLIENT]: Trying to set gapi client token.

// Firebase 로그인 성공
✅ Google 로그인 성공!
```

### 4.3 자주 발생하는 에러

#### "인증오류: unknown"
- **원인**: Google Sign-In SDK 누락 또는 클라이언트 ID 불일치
- **해결**: `web/index.html`에 `<script src="https://accounts.google.com/gsi/client" async defer></script>` 추가 확인

#### "redirect_uri_mismatch"
- **원인**: 리디렉션 URI가 승인되지 않음
- **해결**: Google Cloud Console에서 현재 URL을 승인된 리디렉션 URI에 추가

#### "idpiframe_initialization_failed"
- **원인**: 쿠키가 차단됨
- **해결**: 브라우저 설정에서 서드파티 쿠키 허용

## 5. 체크리스트

작업 완료 후 다음을 확인하세요:

- [ ] Firebase Console에서 Google 인증 활성화
- [ ] Google Cloud Console에서 OAuth 동의 화면 설정
- [ ] 승인된 JavaScript 출처에 `http://localhost:포트` 추가
- [ ] 승인된 리디렉션 URI에 `http://localhost:포트` 및 `/__/auth/handler` 추가
- [ ] `.env` 파일의 `GOOGLE_CLIENT_ID_WEB` 확인
- [ ] `web/index.html`의 `meta` 태그 클라이언트 ID 확인
- [ ] `web/index.html`에 Google Sign-In SDK 스크립트 추가
- [ ] `flutter run -d chrome`으로 테스트
- [ ] Google 로그인 성공 확인

## 6. 참고 자료

- [Firebase Authentication Web Setup](https://firebase.google.com/docs/auth/web/start)
- [Google Sign-In for Web](https://developers.google.com/identity/sign-in/web/sign-in)
- [Flutter google_sign_in Package](https://pub.dev/packages/google_sign_in)

---

**작성일**: 2026-04-07
**버전**: 1.0
