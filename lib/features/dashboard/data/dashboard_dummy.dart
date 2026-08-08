import '../models/low_stock_model.dart';
import '../models/order_model.dart';

const recentOrders = [
  OrderModel(
    id: '#1001',
    customerName: 'Rahul Sharma',
    amount: 420,
    status: 'Pending',
  ),
  OrderModel(
    id: '#1002',
    customerName: 'Amit Singh',
    amount: 285,
    status: 'Delivered',
  ),
  OrderModel(
    id: '#1003',
    customerName: 'Priya Verma',
    amount: 610,
    status: 'Processing',
  ),
];

const lowStockProducts = [
  LowStockModel(name: 'Tomato', stock: 2, unit: 'Kg', image: ''),
  LowStockModel(name: 'Potato', stock: 5, unit: 'Kg', image: ''),
  LowStockModel(name: 'Onion', stock: 3, unit: 'Kg', image: ''),
];
