import 'package:flutter/material.dart';
import 'dart:async';

class TypingTextAnimation extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final Duration typingDuration;
  final Duration pauseDuration;
  final bool loop;

  const TypingTextAnimation({
    super.key,
    required this.text,
    this.style,
    this.typingDuration = const Duration(milliseconds: 150),
    this.pauseDuration = const Duration(seconds: 1),
    this.loop = true,
  });

  @override
  State<TypingTextAnimation> createState() => _TypingTextAnimationState();
}

class _TypingTextAnimationState extends State<TypingTextAnimation> {
  String _displayedText = '';
  int _currentIndex = 0;
  Timer? _typingTimer;
  Timer? _pauseTimer;

  @override
  void initState() {
    super.initState();
    _startTyping();
  }

  void _startTyping() {
    _typingTimer?.cancel();
    _pauseTimer?.cancel();

    _displayedText = '';
    _currentIndex = 0;

    _typingTimer = Timer.periodic(widget.typingDuration, (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (_currentIndex < widget.text.length) {
        setState(() {
          _displayedText = widget.text.substring(0, _currentIndex + 1);
          _currentIndex++;
        });
      } else {
        timer.cancel();
        if (widget.loop) {
          _startPauseTimer();
        }
      }
    });
  }

  void _startPauseTimer() {
    _pauseTimer = Timer(widget.pauseDuration, () {
      if (!mounted) return;
      _startTyping();
    });
  }

  @override
  void dispose() {
    _typingTimer?.cancel();
    _pauseTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(_displayedText, style: widget.style);
  }
}
