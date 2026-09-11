import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

void main() => runApp(const BubbleButtonApp());

class BubbleButtonApp extends StatelessWidget {
  const BubbleButtonApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Definitely Safe',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(useMaterial3: true),
        home: const ButtonPage(),
      );
}

class ButtonPage extends StatefulWidget {
  const ButtonPage({super.key});

  @override
  State<ButtonPage> createState() => _ButtonPageState();
}

class _ButtonPageState extends State<ButtonPage> {
  static const _navy = Color(0xFF071A3D);
  static const _pink = Color(0xFFFF70B8);
  Timer? _timer;
  var _isHovering = false;
  var _countdown = -1;
  var _isSike = false;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _pressButton() {
    if (_countdown >= 0) return;
    setState(() {
      _isSike = false;
      _countdown = 5;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdown == 0) {
        timer.cancel();
        setState(() {
          _countdown = -1;
          _isSike = true;
        });
      } else {
        setState(() => _countdown--);
      }
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: _navy,
        body: Stack(
          fit: StackFit.expand,
          children: [
            if (_isSike) const Positioned.fill(child: ConfettiBurst()),
            Center(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 350),
                child: _isSike
                    ? const _SikeMessage(key: ValueKey('sike'))
                    : _countdown >= 0
                        ? _Countdown(
                            number: _countdown,
                            key: const ValueKey('countdown'),
                          )
                        : MouseRegion(
                            key: const ValueKey('button'),
                            cursor: SystemMouseCursors.click,
                            onEnter: (_) => setState(() => _isHovering = true),
                            onExit: (_) => setState(() => _isHovering = false),
                            child: GestureDetector(
                              onTap: _pressButton,
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 180),
                                curve: Curves.easeOut,
                                width: 176,
                                height: 176,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: _pink,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: _pink.withValues(
                                        alpha: _isHovering ? .92 : .38,
                                      ),
                                      blurRadius: _isHovering ? 38 : 12,
                                      spreadRadius: _isHovering ? 10 : 0,
                                    ),
                                  ],
                                ),
                                child: const Text('press me',
                                    style: TextStyle(
                                        color: _navy,
                                        fontSize: 25,
                                        fontWeight: FontWeight.w800)),
                              ),
                            ),
                          ),
              ),
            ),
          ],
        ),
      );
}

class _Countdown extends StatelessWidget {
  const _Countdown({required this.number, super.key});
  final int number;
  @override
  Widget build(BuildContext context) =>
      Column(mainAxisSize: MainAxisSize.min, children: [
        const Text('this webpage is gonna give you a virus in',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w600)),
        const SizedBox(height: 18),
        Text('$number',
            style: const TextStyle(
                color: Color(0xFFFF70B8),
                fontSize: 112,
                fontWeight: FontWeight.w900,
                height: .9)),
      ]);
}

class _SikeMessage extends StatelessWidget {
  const _SikeMessage({super.key});
  @override
  Widget build(BuildContext context) =>
      const Column(mainAxisSize: MainAxisSize.min, children: [
        Text('SIKE!',
            style: TextStyle(
                color: Color(0xFFFF70B8),
                fontSize: 76,
                fontWeight: FontWeight.w900)),
        SizedBox(height: 6),
        Text('i was kidding.',
            style: TextStyle(
                color: Colors.white,
                fontSize: 25,
                fontWeight: FontWeight.w700)),
      ]);
}

class ConfettiBurst extends StatefulWidget {
  const ConfettiBurst({super.key});
  @override
  State<ConfettiBurst> createState() => _ConfettiBurstState();
}

class _ConfettiBurstState extends State<ConfettiBurst>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 2))
          ..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => IgnorePointer(
      child: AnimatedBuilder(
          animation: _controller,
          builder: (_, __) =>
              CustomPaint(painter: _ConfettiPainter(_controller.value))));
}

class _ConfettiPainter extends CustomPainter {
  _ConfettiPainter(this.progress);
  final double progress;
  static const colors = [
    Color(0xFFFF70B8),
    Color(0xFF57E1D4),
    Color(0xFFFFD45C),
    Colors.white
  ];
  @override
  void paint(Canvas canvas, Size size) {
    final random = Random(12);
    for (var i = 0; i < 120; i++) {
      final x = size.width * (.3 + random.nextDouble() * .4) +
          (random.nextDouble() - .5) * size.width * progress * 1.7;
      final y = size.height * .45 +
          random.nextDouble() * size.height * progress * 1.25;
      final paint = Paint()
        ..color =
            colors[i % colors.length].withValues(alpha: 1 - (progress * .25));
      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(random.nextDouble() * pi * progress * 6);
      canvas.drawRect(
          Rect.fromCenter(center: Offset.zero, width: 9, height: 16),
          paint);
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _ConfettiPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
