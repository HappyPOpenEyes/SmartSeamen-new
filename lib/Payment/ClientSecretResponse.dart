// To parse this JSON data, do
//
//     final clientSecretResponse = clientSecretResponseFromJson(jsonString);

import 'dart:convert';

ClientSecretResponse clientSecretResponseFromJson(String str) =>
    ClientSecretResponse.fromJson(json.decode(str));

String clientSecretResponseToJson(ClientSecretResponse data) =>
    json.encode(data.toJson());

class ClientSecretResponse {
  ClientSecretResponse({
    required this.code,
    required this.message,
    required this.count,
    required this.data,
  });

  int code;
  String message;
  String count;
  Data data;

  factory ClientSecretResponse.fromJson(Map<String, dynamic> json) =>
      ClientSecretResponse(
        code: json["code"],
        message: json["message"],
        count: json["count"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "count": count,
        "data": data.toJson(),
      };
}

class Data {
  Data({
    required this.id,
    required this.object,
    required this.amount,
    required this.amountCapturable,
    required this.amountDetails,
    required this.amountReceived,
    this.application,
    this.applicationFeeAmount,
    this.automaticPaymentMethods,
    this.canceledAt,
    this.cancellationReason,
    required this.captureMethod,
    required this.charges,
    required this.clientSecret,
    required this.confirmationMethod,
    required this.created,
    required this.currency,
    required this.customer,
    this.description,
    this.invoice,
    this.lastPaymentError,
    required this.livemode,
    required this.metadata,
    this.nextAction,
    this.onBehalfOf,
    this.paymentMethod,
    required this.paymentMethodOptions,
    required this.paymentMethodTypes,
    this.processing,
    this.receiptEmail,
    this.review,
    required this.setupFutureUsage,
    this.shipping,
    this.source,
    this.statementDescriptor,
    this.statementDescriptorSuffix,
    required this.status,
    this.transferData,
    this.transferGroup,
  });

  String id;
  String object;
  int amount;
  int amountCapturable;
  AmountDetails amountDetails;
  int amountReceived;
  dynamic application;
  dynamic applicationFeeAmount;
  dynamic automaticPaymentMethods;
  dynamic canceledAt;
  dynamic cancellationReason;
  String captureMethod;
  Charges charges;
  String clientSecret;
  String confirmationMethod;
  int created;
  String currency;
  String customer;
  dynamic description;
  dynamic invoice;
  dynamic lastPaymentError;
  bool livemode;
  List<dynamic> metadata;
  dynamic nextAction;
  dynamic onBehalfOf;
  dynamic paymentMethod;
  PaymentMethodOptions paymentMethodOptions;
  List<String> paymentMethodTypes;
  dynamic processing;
  dynamic receiptEmail;
  dynamic review;
  String setupFutureUsage;
  dynamic shipping;
  dynamic source;
  dynamic statementDescriptor;
  dynamic statementDescriptorSuffix;
  String status;
  dynamic transferData;
  dynamic transferGroup;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        object: json["object"],
        amount: json["amount"],
        amountCapturable: json["amount_capturable"],
        amountDetails: AmountDetails.fromJson(json["amount_details"]),
        amountReceived: json["amount_received"],
        application: json["application"],
        applicationFeeAmount: json["application_fee_amount"],
        automaticPaymentMethods: json["automatic_payment_methods"],
        canceledAt: json["canceled_at"],
        cancellationReason: json["cancellation_reason"],
        captureMethod: json["capture_method"],
        charges: Charges.fromJson(json["charges"]),
        clientSecret: json["client_secret"],
        confirmationMethod: json["confirmation_method"],
        created: json["created"],
        currency: json["currency"],
        customer: json["customer"],
        description: json["description"],
        invoice: json["invoice"],
        lastPaymentError: json["last_payment_error"],
        livemode: json["livemode"],
        metadata: List<dynamic>.from(json["metadata"].map((x) => x)),
        nextAction: json["next_action"],
        onBehalfOf: json["on_behalf_of"],
        paymentMethod: json["payment_method"],
        paymentMethodOptions:
            PaymentMethodOptions.fromJson(json["payment_method_options"]),
        paymentMethodTypes:
            List<String>.from(json["payment_method_types"].map((x) => x)),
        processing: json["processing"],
        receiptEmail: json["receipt_email"],
        review: json["review"],
        setupFutureUsage: json["setup_future_usage"],
        shipping: json["shipping"],
        source: json["source"],
        statementDescriptor: json["statement_descriptor"],
        statementDescriptorSuffix: json["statement_descriptor_suffix"],
        status: json["status"],
        transferData: json["transfer_data"],
        transferGroup: json["transfer_group"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "object": object,
        "amount": amount,
        "amount_capturable": amountCapturable,
        "amount_details": amountDetails.toJson(),
        "amount_received": amountReceived,
        "application": application,
        "application_fee_amount": applicationFeeAmount,
        "automatic_payment_methods": automaticPaymentMethods,
        "canceled_at": canceledAt,
        "cancellation_reason": cancellationReason,
        "capture_method": captureMethod,
        "charges": charges.toJson(),
        "client_secret": clientSecret,
        "confirmation_method": confirmationMethod,
        "created": created,
        "currency": currency,
        "customer": customer,
        "description": description,
        "invoice": invoice,
        "last_payment_error": lastPaymentError,
        "livemode": livemode,
        "metadata": List<dynamic>.from(metadata.map((x) => x)),
        "next_action": nextAction,
        "on_behalf_of": onBehalfOf,
        "payment_method": paymentMethod,
        "payment_method_options": paymentMethodOptions.toJson(),
        "payment_method_types":
            List<dynamic>.from(paymentMethodTypes.map((x) => x)),
        "processing": processing,
        "receipt_email": receiptEmail,
        "review": review,
        "setup_future_usage": setupFutureUsage,
        "shipping": shipping,
        "source": source,
        "statement_descriptor": statementDescriptor,
        "statement_descriptor_suffix": statementDescriptorSuffix,
        "status": status,
        "transfer_data": transferData,
        "transfer_group": transferGroup,
      };
}

class AmountDetails {
  AmountDetails({
    required this.tip,
  });

  List<dynamic> tip;

  factory AmountDetails.fromJson(Map<String, dynamic> json) => AmountDetails(
        tip: List<dynamic>.from(json["tip"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "tip": List<dynamic>.from(tip.map((x) => x)),
      };
}

class Charges {
  Charges({
    required this.object,
    required this.data,
    required this.hasMore,
    required this.totalCount,
    required this.url,
  });

  String object;
  List<dynamic> data;
  bool hasMore;
  int totalCount;
  String url;

  factory Charges.fromJson(Map<String, dynamic> json) => Charges(
        object: json["object"],
        data: List<dynamic>.from(json["data"].map((x) => x)),
        hasMore: json["has_more"],
        totalCount: json["total_count"],
        url: json["url"],
      );

  Map<String, dynamic> toJson() => {
        "object": object,
        "data": List<dynamic>.from(data.map((x) => x)),
        "has_more": hasMore,
        "total_count": totalCount,
        "url": url,
      };
}

class PaymentMethodOptions {
  PaymentMethodOptions({
    required this.card,
  });

  Card card;

  factory PaymentMethodOptions.fromJson(Map<String, dynamic> json) =>
      PaymentMethodOptions(
        card: Card.fromJson(json["card"]),
      );

  Map<String, dynamic> toJson() => {
        "card": card.toJson(),
      };
}

class Card {
  Card({
    this.installments,
    this.mandateOptions,
    this.network,
    required this.requestThreeDSecure,
  });

  dynamic installments;
  dynamic mandateOptions;
  dynamic network;
  String requestThreeDSecure;

  factory Card.fromJson(Map<String, dynamic> json) => Card(
        installments: json["installments"],
        mandateOptions: json["mandate_options"],
        network: json["network"],
        requestThreeDSecure: json["request_three_d_secure"],
      );

  Map<String, dynamic> toJson() => {
        "installments": installments,
        "mandate_options": mandateOptions,
        "network": network,
        "request_three_d_secure": requestThreeDSecure,
      };
}
