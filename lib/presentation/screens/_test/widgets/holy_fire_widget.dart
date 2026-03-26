import 'dart:ui';
import 'package:flutter/material.dart';

/// 테스트용 성령의 불 캐릭터 애니메이션 위젯
///
/// 구현된 기능:
/// - Float (둥실둥실 움직임)
/// - Pulse (크기 맥동)
/// - Shake (흔들림 - 탭 시, 완료 후 각도 초기화)
/// - Drag (드래그로 위치 이동, 2초 후 자동 복귀)
/// - Glow (캐릭터 테두리만 주황색으로 빛남)
class HolyFireWidget extends StatefulWidget {
  final String imagePath;
  final double size;

  const HolyFireWidget({
    super.key,
    required this.imagePath,
    this.size = 150,
  });

  @override
  State<HolyFireWidget> createState() => _HolyFireWidgetState();
}

class _HolyFireWidgetState extends State<HolyFireWidget>
    with TickerProviderStateMixin {
  late AnimationController _floatController;
  late AnimationController _pulseController;
  late AnimationController _shakeController;
  late AnimationController _glowController;
  late AnimationController _returnController;

  late Animation<double> _floatAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _shakeAnimation;
  late Animation<double> _glowAnimation;
  late Animation<Offset> _returnAnimation;

  // 드래그 관련 상태
  Offset _dragOffset = Offset.zero;
  bool _isDragging = false;

  @override
  void initState() {
    super.initState();

    // 1. Float Animation (둥실둥실)
    _floatController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);

    _floatAnimation = Tween<double>(
      begin: -10,
      end: 10,
    ).animate(CurvedAnimation(
      parent: _floatController,
      curve: Curves.easeInOut,
    ));

    // 2. Pulse Animation (맥동)
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    // 3. Shake Animation (흔들림)
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _shakeAnimation = Tween<double>(
      begin: 0,
      end: 0,
    ).animate(CurvedAnimation(
      parent: _shakeController,
      curve: Curves.elasticOut,
    ));

    // ✅ 수정 1: Shake 완료 후 각도 초기화
    _shakeController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _shakeAnimation = Tween<double>(
            begin: 0,
            end: 0,
          ).animate(_shakeController);
        });
      }
    });

    // 4. Glow Animation (빛나기)
    _glowController = AnimationController(
      duration: const Duration(milliseconds: 1800),
      vsync: this,
    )..repeat(reverse: true);

    _glowAnimation = Tween<double>(
      begin: 0.3,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _glowController,
      curve: Curves.easeInOut,
    ));

    // 5. Return Animation (제자리 복귀)
    _returnController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _returnAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _returnController,
      curve: Curves.easeOutBack,
    ));
  }

  @override
  void dispose() {
    _floatController.dispose();
    _pulseController.dispose();
    _shakeController.dispose();
    _glowController.dispose();
    _returnController.dispose();
    super.dispose();
  }

  /// Shake 애니메이션 트리거
  void _triggerShake() {
    _shakeAnimation = Tween<double>(
      begin: -15,
      end: 15,
    ).animate(CurvedAnimation(
      parent: _shakeController,
      curve: Curves.elasticOut,
    ));

    _shakeController
      ..reset()
      ..forward();
  }

  /// ✅ 수정 2: 드래그 시작
  void _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      _isDragging = true;
      _dragOffset += details.delta;
    });
  }

  /// ✅ 수정 2: 드래그 종료 후 2초 뒤 제자리 복귀
  void _onPanEnd(DragEndDetails details) {
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;

      _returnAnimation = Tween<Offset>(
        begin: _dragOffset,
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: _returnController,
        curve: Curves.easeOutBack,
      ));

      _returnController.reset();
      _returnController.forward().then((_) {
        if (!mounted) return;
        setState(() {
          _isDragging = false;
          _dragOffset = Offset.zero;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _triggerShake,
      onPanUpdate: _onPanUpdate,
      onPanEnd: _onPanEnd,
      child: AnimatedBuilder(
        animation: Listenable.merge([
          _floatController,
          _pulseController,
          _shakeController,
          _glowController,
          _returnController,
        ]),
        builder: (context, child) {
          // 드래그 중이면 드래그 오프셋, 복귀 중이면 복귀 애니메이션
          final currentOffset = _isDragging
              ? _dragOffset
              : (_returnController.isAnimating
                  ? _returnAnimation.value
                  : Offset.zero);

          return Transform.translate(
            // 드래그 오프셋
            offset: currentOffset,
            child: Transform.translate(
              // Float: 위아래로 둥실둥실
              offset: Offset(0, _floatAnimation.value),
              child: Transform.rotate(
                // Shake: 좌우로 흔들기
                angle: _shakeAnimation.value * 0.05,
                child: Transform.scale(
                  // Pulse: 크기 맥동
                  scale: _pulseAnimation.value,
                  child: _buildGlowingImage(),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /// ✅ 수정 3: 캐릭터 테두리만 빛나는 Glow 효과
  Widget _buildGlowingImage() {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Glow Layer 1: 외곽 빛 (매우 흐림)
          Opacity(
            opacity: _glowAnimation.value * 0.5,
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(
                sigmaX: 15,
                sigmaY: 15,
                tileMode: TileMode.decal,
              ),
              child: ColorFiltered(
                colorFilter: const ColorFilter.mode(
                  Color(0xFFFF6B35), // 진한 주황색
                  BlendMode.srcATop,
                ),
                child: Image.asset(
                  widget.imagePath,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),

          // Glow Layer 2: 중간 빛 (약간 흐림)
          Opacity(
            opacity: _glowAnimation.value * 0.7,
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(
                sigmaX: 8,
                sigmaY: 8,
                tileMode: TileMode.decal,
              ),
              child: ColorFiltered(
                colorFilter: const ColorFilter.mode(
                  Color(0xFFFF8C42), // 중간 주황색
                  BlendMode.srcATop,
                ),
                child: Image.asset(
                  widget.imagePath,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),

          // Glow Layer 3: 내부 빛 (살짝 흐림)
          Opacity(
            opacity: _glowAnimation.value * 0.9,
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(
                sigmaX: 3,
                sigmaY: 3,
                tileMode: TileMode.decal,
              ),
              child: ColorFiltered(
                colorFilter: const ColorFilter.mode(
                  Color(0xFFFFA500), // 밝은 주황색
                  BlendMode.srcATop,
                ),
                child: Image.asset(
                  widget.imagePath,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),

          // Original Image: 원본 이미지
          Image.asset(
            widget.imagePath,
            fit: BoxFit.contain,
          ),
        ],
      ),
    );
  }
}
