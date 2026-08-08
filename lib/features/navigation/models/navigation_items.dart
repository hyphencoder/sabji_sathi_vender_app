import 'package:flutter/material.dart';
import 'package:vender_app/features/orders/pages/order_page.dart';
import 'package:vender_app/features/products/pages/product_page.dart';
import 'package:vender_app/features/profile/pages/profile_page.dart';

import '../../dashboard/pages/dashboard_page.dart';
import '../models/navigation_item.dart';

final List<NavigationItem> navigationItems = [
  NavigationItem(
    label: 'Dashboard',
    icon: Icons.dashboard_outlined,
    selectedIcon: Icons.dashboard,
    page: const DashboardPage(),
  ),
  NavigationItem(
    label: 'Products',
    icon: Icons.inventory_2_outlined,
    selectedIcon: Icons.inventory_2,
    page: const ProductsPage(),
  ),
  NavigationItem(
    label: 'Orders',
    icon: Icons.receipt_long_outlined,
    selectedIcon: Icons.receipt_long,
    page: const OrdersPage(),
  ),
  NavigationItem(
    label: 'Profile',
    icon: Icons.person_outline,
    selectedIcon: Icons.person,
    page: const ProfilePage(),
  ),
];
