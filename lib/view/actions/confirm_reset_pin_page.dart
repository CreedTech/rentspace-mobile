import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ConfirmResetPinPage extends ConsumerStatefulWidget {
  const ConfirmResetPinPage({super.key, required this.pin});
  final String pin;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ConfirmResetPinPageState();
}

class _ConfirmResetPinPageState extends ConsumerState<ConfirmResetPinPage> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
