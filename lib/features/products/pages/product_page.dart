import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vender_app/core/routes/app_routes.dart';
import 'package:vender_app/features/products/data/dummy_products.dart';

import '../../dashboard/widgets/dashboard_header.dart';
import '../widgets/product_card.dart';
import '../widgets/product_filter_chip.dart';
import '../widgets/product_search_bar.dart';

class ProductsPage extends StatelessWidget {
  const ProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.push(AppRoutes.addProducts);
        },
        icon: const Icon(Icons.add),
        label: const Text("Add Product"),
      ),

      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            /// Header
            const SliverToBoxAdapter(
              child: DashboardHeader(shopName: "Green Grocer"),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 16)),

            /// Search
            const SliverToBoxAdapter(child: ProductSearchBar()),

            const SliverToBoxAdapter(child: SizedBox(height: 16)),

            /// Categories
            SliverToBoxAdapter(
              child: SizedBox(
                height: 42,
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  scrollDirection: Axis.horizontal,
                  children: [
                    ProductFilterChip(
                      title: "All",
                      isSelected: true,
                      onTap: () {},
                    ),

                    ProductFilterChip(
                      title: "Vegetables",
                      isSelected: false,
                      onTap: () {},
                    ),

                    ProductFilterChip(
                      title: "Leafy",
                      isSelected: false,
                      onTap: () {},
                    ),

                    ProductFilterChip(
                      title: "Root",
                      isSelected: false,
                      onTap: () {},
                    ),

                    ProductFilterChip(
                      title: "Fruits",
                      isSelected: false,
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 16)),

            /// Product List
            SliverList.builder(
              itemCount: DummyProducts.products.length,
              itemBuilder: (context, index) {
                final product = DummyProducts.products[index];

                return ProductCard(
                  name: product.name,
                  category: product.category,
                  price: product.price,
                  stock: product.stock,
                  imageUrl: product.image,
                  status: product.status,
                  onTap: () {},
                  onEdit: () {},
                  onDelete: () {},
                );
              },
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),
    );
  }
}
