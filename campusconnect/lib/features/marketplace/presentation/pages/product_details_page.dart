import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../domain/entities/product.dart';
import '../../domain/entities/seller.dart';
import '../providers/marketplace_provider.dart';

class ProductDetailsPage extends StatelessWidget {
  const ProductDetailsPage({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MarketplaceProvider>();
    final seller = provider.getSeller(product.sellerId);

    return Scaffold(
      appBar: AppBar(title: Text(product.title)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(product.title, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 8),
          Text('\$${product.price.toStringAsFixed(2)}'),
          const SizedBox(height: 12),
          Text(product.description),
          const SizedBox(height: 12),
          Chip(label: Text(product.status)),
          const SizedBox(height: 16),
          if (seller != null)
            Card(
              child: ListTile(
                title: Text(seller.name),
                subtitle: Text('${seller.location} · ${seller.rating.toStringAsFixed(1)} stars'),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => SellerProfilePage(seller: seller),
                    ),
                  );
                },
              ),
            ),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: () async {
              await provider.toggleFavorite(product.id);
            },
            icon: Icon(product.isFavorite ? Icons.favorite : Icons.favorite_border),
            label: Text(product.isFavorite ? 'Remove favorite' : 'Add favorite'),
          ),
        ],
      ),
    );
  }
}

class SellerProfilePage extends StatelessWidget {
  const SellerProfilePage({super.key, required this.seller});

  final Seller seller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(seller.name)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(seller.name, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text(seller.location),
            const SizedBox(height: 8),
            Text('Rating: ${seller.rating.toStringAsFixed(1)}'),
            const SizedBox(height: 8),
            Text('Email: ${seller.email}'),
            const SizedBox(height: 8),
            Text('Phone: ${seller.phone}'),
          ],
        ),
      ),
    );
  }
}
