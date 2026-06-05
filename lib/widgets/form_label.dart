import 'package:flutter/material.dart';

import '../utils/app_theme.dart';

class FormLabel extends StatelessWidget {
  final String text;

  const FormLabel(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(text, style: AppTextStyles.label);
  }
}
