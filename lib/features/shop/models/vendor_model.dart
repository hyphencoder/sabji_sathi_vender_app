class VendorModel {
  final String id;

  final String shopName;
  final String ownerName;

  final String mobile;
  final String? email;

  final String? profileImage;
  final String? shopImage;

  final String address;
  final String city;
  final String state;
  final String pincode;

  final double? latitude;
  final double? longitude;

  final String? gstNumber;
  final String? panNumber;

  final String status;
  final bool shopCompleted;

  // ==========================
  // Admin Fields
  // ==========================

  final DateTime? approvedAt;
  final String? approvedBy;

  final DateTime? rejectedAt;
  final String? rejectReason;

  final DateTime? blockedAt;
  final String? blockReason;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  const VendorModel({
    required this.id,
    required this.shopName,
    required this.ownerName,
    required this.mobile,
    this.email,
    this.profileImage,
    this.shopImage,
    required this.address,
    required this.city,
    required this.state,
    required this.pincode,
    this.latitude,
    this.longitude,
    this.gstNumber,
    this.panNumber,
    required this.status,
    required this.shopCompleted,

    this.approvedAt,
    this.approvedBy,

    this.rejectedAt,
    this.rejectReason,

    this.blockedAt,
    this.blockReason,

    this.createdAt,
    this.updatedAt,
  });

  factory VendorModel.fromMap(Map<String, dynamic> map) {
    return VendorModel(
      id: map['id'],
      shopName: map['shop_name'],
      ownerName: map['owner_name'],
      mobile: map['mobile'],
      email: map['email'],
      profileImage: map['profile_image'],
      shopImage: map['shop_image'],
      address: map['address'],
      city: map['city'],
      state: map['state'],
      pincode: map['pincode'],
      latitude: map['latitude']?.toDouble(),
      longitude: map['longitude']?.toDouble(),
      gstNumber: map['gst_number'],
      panNumber: map['pan_number'],
      status: map['status'] ?? 'pending',
      shopCompleted: map['shop_completed'] ?? false,

      approvedAt: map['approved_at'] == null
          ? null
          : DateTime.parse(map['approved_at']),

      approvedBy: map['approved_by'],

      rejectedAt: map['rejected_at'] == null
          ? null
          : DateTime.parse(map['rejected_at']),

      rejectReason: map['reject_reason'],

      blockedAt: map['blocked_at'] == null
          ? null
          : DateTime.parse(map['blocked_at']),

      blockReason: map['block_reason'],

      createdAt: map['created_at'] == null
          ? null
          : DateTime.parse(map['created_at']),

      updatedAt: map['updated_at'] == null
          ? null
          : DateTime.parse(map['updated_at']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'shop_name': shopName,
      'owner_name': ownerName,
      'mobile': mobile,
      'email': email,
      'profile_image': profileImage,
      'shop_image': shopImage,
      'address': address,
      'city': city,
      'state': state,
      'pincode': pincode,
      'latitude': latitude,
      'longitude': longitude,
      'gst_number': gstNumber,
      'pan_number': panNumber,
      'status': status,
      'shop_completed': shopCompleted,

      // Admin fields intentionally NOT included
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  VendorModel copyWith({
    String? id,
    String? shopName,
    String? ownerName,
    String? mobile,
    String? email,
    String? profileImage,
    String? shopImage,
    String? address,
    String? city,
    String? state,
    String? pincode,
    double? latitude,
    double? longitude,
    String? gstNumber,
    String? panNumber,
    String? status,
    bool? shopCompleted,

    DateTime? approvedAt,
    String? approvedBy,

    DateTime? rejectedAt,
    String? rejectReason,

    DateTime? blockedAt,
    String? blockReason,

    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return VendorModel(
      id: id ?? this.id,
      shopName: shopName ?? this.shopName,
      ownerName: ownerName ?? this.ownerName,
      mobile: mobile ?? this.mobile,
      email: email ?? this.email,
      profileImage: profileImage ?? this.profileImage,
      shopImage: shopImage ?? this.shopImage,
      address: address ?? this.address,
      city: city ?? this.city,
      state: state ?? this.state,
      pincode: pincode ?? this.pincode,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      gstNumber: gstNumber ?? this.gstNumber,
      panNumber: panNumber ?? this.panNumber,
      status: status ?? this.status,
      shopCompleted: shopCompleted ?? this.shopCompleted,

      approvedAt: approvedAt ?? this.approvedAt,
      approvedBy: approvedBy ?? this.approvedBy,

      rejectedAt: rejectedAt ?? this.rejectedAt,
      rejectReason: rejectReason ?? this.rejectReason,

      blockedAt: blockedAt ?? this.blockedAt,
      blockReason: blockReason ?? this.blockReason,

      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
