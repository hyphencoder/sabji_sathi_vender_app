class OrderModel {
  final String id;
  final String customerName;
  final double amount;
  final String status;

  const OrderModel({
    required this.id,
    required this.customerName,
    required this.amount,
    required this.status,
  });
}
