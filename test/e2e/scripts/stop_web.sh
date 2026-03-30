#!/bin/bash
# Flutter 웹 종료

set -e

echo "🛑 Stopping Flutter Web..."

if [ -f /tmp/flutter_web.pid ]; then
  PID=$(cat /tmp/flutter_web.pid)
  kill $PID 2>/dev/null || echo "⚠️ Process $PID not found"
  rm /tmp/flutter_web.pid
  echo "✅ Flutter Web stopped"
else
  pkill -f "flutter_tools.snapshot run" || echo "No flutter processes found"
fi
