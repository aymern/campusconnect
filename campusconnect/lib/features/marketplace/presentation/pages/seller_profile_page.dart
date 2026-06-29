import 'package:flutter/material.dart';
import '../../domain/entities/seller.dart';

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
            Text('Location: ${seller.location}'),
            const SizedBox(height: 8),
            Text('Phone: ${seller.phone}'),
            const SizedBox(height: 8),
            Text('Email: ${seller.email}'),
            const SizedBox(height: 8),
            Text('Rating: ${seller.rating.toStringAsFixed(1)} / 5'),
          ],
        ),
      ),
    );
  }
}
