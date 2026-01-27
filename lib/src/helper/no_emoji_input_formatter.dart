import 'package:flutter/services.dart';

/// TextInputFormatter that blocks emoji, stickers and variation selectors
/// from being entered in text fields.
class NoEmojiInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) return newValue;
    final buffer = StringBuffer();
    for (final r in newValue.text.runes) {
      if (!_isEmojiOrSticker(r)) {
        buffer.write(String.fromCharCodes(_codePointToUtf16(r)));
      }
    }
    final filtered = buffer.toString();
    if (filtered == newValue.text) return newValue;
    return TextEditingValue(
      text: filtered,
      selection: TextSelection.collapsed(offset: filtered.length),
    );
  }

  static List<int> _codePointToUtf16(int codePoint) {
    if (codePoint <= 0xFFFF) return [codePoint];
    final n = codePoint - 0x10000;
    return [
      0xD800 + (n >> 10),
      0xDC00 + (n & 0x3FF),
    ];
  }

  static bool _isEmojiOrSticker(int code) {
    return
        (code >= 0x1F300 && code <= 0x1F5FF) || // Misc Symbols and Pictographs
        (code >= 0x1F600 && code <= 0x1F64F) || // Emoticons
        (code >= 0x1F680 && code <= 0x1F6FF) || // Transport and Map
        (code >= 0x1F900 && code <= 0x1F9FF) || // Supplemental Symbols, stickers
        (code >= 0x2600 && code <= 0x26FF) ||   // Misc symbols
        (code >= 0x2700 && code <= 0x27BF) ||   // Dingbats
        (code >= 0x1F1E0 && code <= 0x1F1FF) || // Flags
        (code == 0xFE0F) ||                     // Variation selector (emoji style)
        (code == 0x200D);                       // Zero-width joiner (emoji sequences)
  }
}
