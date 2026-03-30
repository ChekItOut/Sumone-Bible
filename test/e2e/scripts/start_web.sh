#!/bin/bash
# Flutter 웹을 HTML 렌더러로 실행

set -e

echo "🚀 Starting Flutter Web (HTML Renderer)..."

# 프로젝트 루트로 이동
cd "$(dirname "$0")/../../.."

# 기존 프로세스 종료
pkill -f "flutter_tools.snapshot run" || true

# Flutter 웹 실행 (백그라운드)
flutter run -d chrome --web-renderer html --web-port 8080 &

# PID 저장
echo $! > /tmp/flutter_web.pid

echo "✅ Flutter Web started at http://localhost:8080"
echo "To stop: ./test/e2e/scripts/stop_web.sh"
