class AliceCheckerModel {
  final bool success;
  final String message;
  final AlicePaymentData? data;

  AliceCheckerModel({
    required this.success,
    required this.message,
    this.data,
  });

  factory AliceCheckerModel.fromJson(Map<String, dynamic> json) =>
      AliceCheckerModel(
        success: json["success"] ?? false,
        message: json["message"] ?? "",
        data: json["data"] == null
            ? null
            : AlicePaymentData.fromJson(json["data"]),
      );
}

class AlicePaymentData {
  final String transactionId;
  final String status;
  final int amount;
  final String paymentMethod;
  final DateTime? paymentDate;
  final String? cardNumber;
  final String? merchantId;

  AlicePaymentData({
    required this.transactionId,
    required this.status,
    required this.amount,
    required this.paymentMethod,
    this.paymentDate,
    this.cardNumber,
    this.merchantId,
  });

  factory AlicePaymentData.fromJson(Map<String, dynamic> json) =>
      AlicePaymentData(
        transactionId: json["transactionId"] ?? "",
        status: json["status"] ?? "",
        amount: json["amount"] ?? 0,
        paymentMethod: json["paymentMethod"] ?? "",
        paymentDate: json["paymentDate"] == null
            ? null
            : DateTime.tryParse(json["paymentDate"]),
        cardNumber: json["cardNumber"],
        merchantId: json["merchantId"],
      );
}
