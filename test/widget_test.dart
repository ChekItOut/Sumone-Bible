import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bible_sumone/app/app.dart';

/// Bible SumOne 기본 위젯 테스트
///
/// NOTE: Phase 7에서 본격적인 테스트 작성 예정
void main() {
  testWidgets('App should load without crashing', (WidgetTester tester) async {
    // ProviderScope로 감싸서 앱 빌드
    await tester.pumpWidget(
      const ProviderScope(
        child: BibleSumOneApp(),
      ),
    );

    // 앱이 정상적으로 로드되는지 확인
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
