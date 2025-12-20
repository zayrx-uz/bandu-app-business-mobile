import 'dart:convert';

import 'package:flutter/material.dart';

class BaseImageWidget extends StatelessWidget {
  final String img;
  const BaseImageWidget({super.key, required this.img});

  @override
  Widget build(BuildContext context) {
    final base64String = img.split(',').last;
    final bytes = base64Decode(base64String);
    return Image.memory(bytes);
  }
}
