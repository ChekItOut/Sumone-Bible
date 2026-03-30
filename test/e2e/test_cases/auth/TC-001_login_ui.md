# TC-001: 로그인 화면 UI 검증

**Feature**: 인증
**Priority**: High
**Reference**: docs/prd.md 섹션 7.1
**Date**: 2026-03-30
**Tester**: QA Agent

---

## Pre-conditions
- Flutter 웹 실행: http://localhost:8080
- 사용자 상태: 비로그인

## Test Steps

1. http://localhost:8080 접속
2. 로고 표시 확인
3. "Google로 로그인" 버튼 존재 확인
4. 버튼 클릭 가능 상태 확인
5. 접근성 트리 검사

## Expected Results

1. Bible SumOne 로고가 중앙 상단에 표시됨
2. "Google로 로그인" 버튼이 중앙에 표시됨
3. 버튼이 클릭 가능 상태
4. 버튼에 aria-label 또는 명확한 텍스트 있음

## Actual Results

(QA Agent가 자동으로 채움)

## Overall Status
⏳ **PENDING** / ✅ **PASS** / ❌ **FAIL** / ⚠️ **BLOCKED**

## Screenshots
- `test/e2e/screenshots/baseline/login_screen.png`

## Issues Found
- None

## Recommendations
- None
