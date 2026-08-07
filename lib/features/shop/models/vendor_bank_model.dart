class VendorBankModel {
  final String? id;
  final String vendorId;

  final String accountHolder;
  final String bankName;
  final String accountNumber;
  final String ifscCode;

  final bool isPrimary;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  const VendorBankModel({
    this.id,
    required this.vendorId,
    required this.accountHolder,
    required this.bankName,
    required this.accountNumber,
    required this.ifscCode,
    this.isPrimary = true,
    this.createdAt,
    this.updatedAt,
  });

  factory VendorBankModel.fromJson(Map<String, dynamic> json) {
    return VendorBankModel(
      id: json['id'] as String?,
      vendorId: json['vendor_id'] as String,
      accountHolder: json['account_holder'] as String,
      bankName: json['bank_name'] as String,
      accountNumber: json['account_number'] as String,
      ifscCode: json['ifsc_code'] as String,
      isPrimary: json['is_primary'] ?? true,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'vendor_id': vendorId,
      'account_holder': accountHolder,
      'bank_name': bankName,
      'account_number': accountNumber,
      'ifsc_code': ifscCode,
      'is_primary': isPrimary,
    };

    if (id != null) {
      json['id'] = id;
    }

    if (createdAt != null) {
      json['created_at'] = createdAt!.toIso8601String();
    }

    if (updatedAt != null) {
      json['updated_at'] = updatedAt!.toIso8601String();
    }

    return json;
  }

  VendorBankModel copyWith({
    String? id,
    String? vendorId,
    String? accountHolder,
    String? bankName,
    String? accountNumber,
    String? ifscCode,
    bool? isPrimary,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return VendorBankModel(
      id: id ?? this.id,
      vendorId: vendorId ?? this.vendorId,
      accountHolder: accountHolder ?? this.accountHolder,
      bankName: bankName ?? this.bankName,
      accountNumber: accountNumber ?? this.accountNumber,
      ifscCode: ifscCode ?? this.ifscCode,
      isPrimary: isPrimary ?? this.isPrimary,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
