import 'package:easy_localization/easy_localization.dart';
import 'package:intl/intl.dart' show DateFormat, NumberFormat;

extension NumberFormation on int {
  String priceFormat() {
    final format = NumberFormat("#,##0", "en_US");
    return format.format(this).replaceAll(',', ' ');
  }
}

extension StringFormat on String {
  String capitalizeFirstLetter() {
    try {
      if (isEmpty) return this;
      return this[0].toUpperCase() + substring(1);
    } catch (_) {
      return this;
    }
  }

  String getLocalizedStatus() {
    switch (toLowerCase()) {
      case 'pending':
        return "pending".tr();
      case 'confirmed':
        return "confirmed".tr();
      case 'canceled':
      case 'cancelled':
        return "cancelled".tr();
      case 'completed':
        return "completed".tr();
      default:
        return this;
    }
  }

  String getLocalizedPaymentStatus() {
    switch (toUpperCase()) {
      case 'PENDING':
        return "paymentStatusPending".tr();
      case 'PROCESSING':
        return "paymentStatusProcessing".tr();
      case 'PAID':
        return "paymentStatusPaid".tr();
      case 'FAILED':
        return "paymentStatusFailed".tr();
      case 'CANCELED':
      case 'CANCELLED':
        return "paymentStatusCanceled".tr();
      case 'REFUNDED':
        return "paymentStatusRefunded".tr();
      default:
        return this;
    }
  }

  String phoneFormat() {
    try {
      String numbers = replaceAll(RegExp(r'[^0-9+]'), '');
      if (numbers.startsWith('998') && numbers.length == 12) {
        return '+$numbers';
      } else if (numbers.startsWith('9') && numbers.length == 9) {
        return '+998$numbers';
      } else if (numbers.startsWith('+998') && numbers.length == 13) {
        return numbers;
      } else {
        return '';
      }
    } catch (e) {
      return '';
    }
  }
}

extension DateFormation on DateTime? {
  String toDDMMYYY() {
    try {
      if (this == null) return '';
      final dateTime = this!;
      final formatter = DateFormat('dd.MM.yyyy');
      return formatter.format(dateTime);
    } catch (e) {
      return "";
    }
  }

  String toHHMM() {
    try {
      if (this == null) return '';
      final dateTime = this!;
      final formatter = DateFormat('HH:mm');
      return formatter.format(dateTime);
    } catch (e) {
      return "";
    }
  }
}

extension StringChanges on String {
  String formatBirthdate() {
    try {
      final date = this;
      final d = DateTime.parse(date);
      return "${d.day.toString().padLeft(2, '0')}/"
          "${d.month.toString().padLeft(2, '0')}/"
          "${d.year}";
    } catch (e) {
      return "";
    }
  }
}



extension NumberFormatter on num {
  String formatWithSpaces() {
    return toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]} ',
    );
  }
}