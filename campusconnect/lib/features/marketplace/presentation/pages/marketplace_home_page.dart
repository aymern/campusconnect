import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../domain/entities/product.dart';
import '../providers/marketplace_provider.dart';
import 'create_listing_page.dart';
import 'product_details_page.dart';

class MarketplaceHomePage extends StatefulWidget {
  const MarketplaceHomePage({super.key});

  @override
  State<MarketplaceHomePage> createState() => _MarketplaceHomePageState();
}

class _MarketplaceHomePageState extends State<MarketplaceHomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MarketplaceProvider>().initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MarketplaceProvider>();
    final products = provider.visibleProducts;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Marketplace'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const CreateListingPage()),
              );
            },
            icon: const Icon(Icons.add_circle_outline),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Search listings',
                border: OutlineInputBorder(),
              ),
              onChanged: provider.setSearchQuery,
            ),
          ),
          SizedBox(
            height: 56,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: provider.categories.length + 1,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                if (index == 0) {
                  return FilterChip(
                    label: const Text('All'),
                    selected: provider.selectedCategory == 'all',
                    onSelected: (_) => provider.setCategory('all'),
                  );
                }
                final category = provider.categories[index - 1];
                return FilterChip(
                  label: Text(category.name),
                  selected: provider.selectedCategory == category.id,
                  onSelected: (_) => provider.setCategory(category.id),
                );
              },
            ),
          ),
          Expanded(
            child: provider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : products.isEmpty
                    ? const Center(child: Text('No listings found.'))
                    : ListView.builder(
                        itemCount: products.length,
                        itemBuilder: (context, index) {
                          final product = products[index];
                          return _ProductTile(product: product);
                        },
                      ),
          ),
        ],
      ),
    );
  }
}

class _ProductTile extends StatelessWidget {
  const _ProductTile({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MarketplaceProvider>();
    final seller = provider.getSeller(product.sellerId);
    return Card(
      child: ListTile(
        leading: const Icon(Icons.shopping_bag),
        title: Text(product.title),
        subtitle: Text('${seller?.name ?? 'Unknown'} · \$${product.price.toStringAsFixed(2)}'),
        trailing: IconButton(
          icon: Icon(product.isFavorite ? Icons.favorite : Icons.favorite_border),
          onPressed: () async {
            await provider.toggleFavorite(product.id);
          },
        ),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => ProductDetailsPage(product: product)),
          );
        },
      ),
    );
  }
}
