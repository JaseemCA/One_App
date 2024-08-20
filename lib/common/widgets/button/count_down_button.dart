import 'dart:async';

import 'package:flutter/material.dart';
import 'package:oneappcounter/services/counter_setting_service.dart';

class CountDownButton extends StatefulWidget {
  const CountDownButton({
    super.key,
    required this.onPressed,
  });

  final void Function()? onPressed;

  @override
  State<CountDownButton> createState() => _CountDownButtonState();
}

class _CountDownButtonState extends State<CountDownButton> {
  late Timer _timer;
  String label =
      'Continue(${CounterSettingService.counterSettings?.alertTime ?? 10})';
  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      int max = CounterSettingService.counterSettings?.alertTime ?? 10;
      if (timer.tick == max) {
        widget.onPressed!();
      } else if (timer.tick <= max) {
        setState(() {
          label = 'Continue(${max - timer.tick})';
        });
      }
    });
  }

  @override
  void dispose() {
    try {
      _timer.cancel();
    } catch (_) {}
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: widget.onPressed,
      child: Text(label),
    );
  }
}
